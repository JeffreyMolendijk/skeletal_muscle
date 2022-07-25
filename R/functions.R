# Author: Jeffrey Molendijk

# Description: Functions that are called in workflow.R, adapted from CoffeeProt
# Usage: Functions are loaded as part of workflow.R, so running this file manually is not required



#' Create a qtl location plot
#'
#' \code{cp_pqtl_locplot} returns a qtl location plot.
#'
#' @param qtldata A pQTL table.

#' @return A qtl location plot o
#'
#' @examples
#' cp_pqtl_locplot(qtldata)
#' 
cp_pqtl_locplot <- function(qtldata){
  
  qtlcolnames <- colnames(qtldata)
  
  x = qtldata %>% mutate(gene_loc = ((!! rlang::sym(qtlcolnames[5]) + !! rlang::sym(qtlcolnames[6])) / 2))
  snp_labs = x %>% group_by(!! rlang::sym(qtlcolnames[3])) %>% summarise(meanchr = mean(!! rlang::sym(qtlcolnames[2]))) %>% as.data.frame()
  snp_labs[,1] <- sub("chr", "", snp_labs[,1], ignore.case = TRUE)
  gene_labs = x %>% group_by(!! rlang::sym(qtlcolnames[7])) %>% summarise(meanchr = mean(gene_loc)) %>% as.data.frame()
  gene_labs[,1] <- sub("chr", "", gene_labs[,1], ignore.case = TRUE)
  snp_line = x %>% group_by(!! rlang::sym(qtlcolnames[3])) %>% summarise(max = max(!! rlang::sym(qtlcolnames[2]))) %>% as.data.frame()
  gene_line = x %>% group_by(!! rlang::sym(qtlcolnames[7])) %>% summarise(max = max(gene_loc)) %>% as.data.frame()
  
  
  p1 = ggplot(x, aes(x = !! rlang::sym(qtlcolnames[2]), y = gene_loc)) + geom_bin2d(bins = 200) + theme(axis.text=element_text(size=8), axis.title=element_text(size=8),  legend.position = "none" ,panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), plot.margin=unit(c(0,0,0,0), "mm")) + labs(x = "SNP chromosome", y = "Gene chromosome") + scale_fill_gradient(low="gray96", high="darkblue") + scale_x_continuous(breaks = snp_labs[,2], labels = snp_labs[,1], expand = c(0,0)) + scale_y_continuous(breaks = gene_labs[,2], labels = gene_labs[,1], expand = c(0,0)) + geom_vline(xintercept = snp_line[,2], alpha = 0.1) + geom_hline(yintercept = gene_line[,2], alpha = 0.1)
  
  p2 = ggplot(x, aes(x = !! rlang::sym(qtlcolnames[2]))) + stat_density(fill = "lightblue", alpha = 0.7, adjust = 0.3) + cowplot::theme_nothing() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), plot.margin=unit(c(0,0,0,0), "mm")) + labs(x = "SNP location", y = "Gene location") + scale_fill_gradient(low="gray95",high="darkblue") + scale_x_continuous(expand = c(0,0))
  
  p3 = ggplot(x, aes(y = gene_loc))+ stat_density(fill = "lightblue", alpha = 0.7, adjust = 0.3) + cowplot::theme_nothing() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), plot.margin=unit(c(0,0,0,0), "mm")) + labs(x = "SNP location", y = "Gene location") + scale_fill_gradient(low="gray95",high="darkblue")  + scale_y_continuous(expand = c(0,0))
  
  plot_qtl_snploc <- p2 + plot_spacer() + p1 + p3 + plot_layout(widths = c(8, 1), heights = c(1, 8))
  
  return(plot_qtl_snploc)
  
}


#' Create a cp_circos object
#'
#' \code{cp_circos_create} returns a circos plot.
#'
#' @param qtldata A pQTL table.
#' @param circos_select Concatenated strings containing gene names to be plotted.
#' @param significance Indicate whether the data contains p-values or LOD.
#' 
#' @return A cp_circos object, to be used in \code{cp_circos_plot}
#'
#' @examples
#' cp_circos_create(qtldata, c("gene1", "gene2","gene3"))
#' 
cp_circos_create <- function(qtldata, circos_select, significance){
  
  qtlcolnames <- colnames(qtldata)
  
  #Create a table containing the start and end of each chromosome (in the RSID and Gene columns)
  chrlocs <- rbind(qtldata[,c(1,2,3)] %>% `colnames<-`(qtlcolnames[1:3]), 
                   qtldata[,c(1,5,7)] %>% `colnames<-`(qtlcolnames[1:3]), 
                   qtldata[,c(1,6,7)] %>% `colnames<-`(qtlcolnames[1:3]) )  
  
  chrlocs <- chrlocs %>% mutate(snp_chr = !! rlang::sym(qtlcolnames[3])) %>% group_by(snp_chr) %>% mutate(chrstart = as.numeric(min(!! rlang::sym(qtlcolnames[2]))), chrend = as.numeric(max(!! rlang::sym(qtlcolnames[2])))) %>% ungroup %>% distinct(snp_chr, chrstart, chrend) %>% arrange(snp_chr) %>% mutate(snp_chr = paste0("chr", as.character(snp_chr))) %>% mutate(gene_symbol = snp_chr)
  
  #A chromosome where the start and end are the same cause problems, must be removed.
  chrlocs <- chrlocs %>% filter(chrstart != chrend) %>% arrange(chrstart)
  
  # 
  chrlocs <- mm10_chrsize %>% mutate(V2 = V2 + V3) %>% dplyr::select(V1, V3, V2, chromosome) %>% mutate(chromosome = paste("chr", chromosome, sep = "")) %>% `colnames<-`(c("snp_chr", "chrstart", "chrend", "gene_symbol")) %>% filter(snp_chr != "chrY") %>% filter(snp_chr != "chrM")
  
  #For normalizetodataframe to work a track needs to be initialized first
  circos.genomicInitialize(chrlocs, plotType = NULL)
  
  bed_genomesize <- chrlocs %>% group_by(snp_chr) %>% summarize(chr_len = max(chrend) - min(chrstart)) %>% dplyr::select(chr_len) %>% colSums() %>% as.numeric()
  
  target <- circos_select
  
  
  #Use the circlize normalizetodataframe function before making links > seems to cause errors.
  if(significance == "pval"){
    bed <- qtldata %>% filter(!! rlang::sym(qtlcolnames[4]) %in% target) %>% mutate(gene_symbol = !! rlang::sym(qtlcolnames[4]), snp_chr = paste0("chr", as.character(!! rlang::sym(qtlcolnames[3]))), gene_chr = paste0("chr", as.character(!! rlang::sym(qtlcolnames[7]))), snp_bp_abs = !! rlang::sym(qtlcolnames[2]),  snp_bp_abs_end = !! rlang::sym(qtlcolnames[2]), sign = -log10(!! rlang::sym(qtlcolnames[8])), gene_start_abs = !! rlang::sym(qtlcolnames[5]), gene_end_abs = !! rlang::sym(qtlcolnames[6])) %>% dplyr::select(snp_chr, snp_bp_abs, snp_bp_abs_end, gene_start_abs, gene_end_abs, sign, everything()) 
  } else {
    bed <- qtldata %>% filter(!! rlang::sym(qtlcolnames[4]) %in% target) %>% mutate(gene_symbol = !! rlang::sym(qtlcolnames[4]), snp_chr = paste0("chr", as.character(!! rlang::sym(qtlcolnames[3]))), gene_chr = paste0("chr", as.character(!! rlang::sym(qtlcolnames[7]))), snp_bp_abs = !! rlang::sym(qtlcolnames[2]),  snp_bp_abs_end = !! rlang::sym(qtlcolnames[2]), sign = !! rlang::sym(qtlcolnames[8]), gene_start_abs = !! rlang::sym(qtlcolnames[5]), gene_end_abs = !! rlang::sym(qtlcolnames[6])) %>% dplyr::select(snp_chr, snp_bp_abs, snp_bp_abs_end, gene_start_abs, gene_end_abs, sign, everything()) 
  }
  bed <- bed %>% mutate(snp_bp_abs_end = (snp_bp_abs_end + (bed_genomesize / 1000)))
  bed <- bed %>% mutate(gene_end_abs = case_when(gene_end_abs - gene_start_abs < (bed_genomesize / 1000) ~  (gene_start_abs + (bed_genomesize / 1000)), TRUE ~ gene_end_abs) )
  bed <- bed %>% circlize:::validate_data_frame()
  bed <- bed %>% circlize:::normalizeToDataFrame()
  bed1 <- bed %>% dplyr::select(snp_chr, snp_bp_abs, snp_bp_abs_end, sign) %>% mutate(gene_symbol = snp_chr)
  bed2 <- bed %>% dplyr::select(gene_chr, gene_start_abs, gene_end_abs, sign, gene_symbol)
  
  #Create colors for plot, if there is only 1 unique sign make the color gray, else make gradient.
  if(bed$sign %>% unique() %>% length() < 2){
    linkcolors <- paste0("gray", "80")
  } else {
    ii <- cut(bed$sign, breaks = seq(min(bed$sign), max(bed$sign), len = 100), include.lowest = TRUE)
    linkcolors <- colorRampPalette(c("gray", "darkblue"))(99)[ii]
    linkcolors <- paste0(linkcolors, "80")
  }
  
  chrlabels <- bed2 %>% dplyr::select(-sign) %>% `colnames<-`(colnames(chrlocs)) %>% distinct(snp_chr, chrstart, .keep_all = TRUE) %>% mutate(labelname = gene_symbol, labcol = "black") %>% bind_rows(chrlocs %>% mutate(chrstart = ((chrstart + chrend) / 2), chrend = chrstart, labelname = snp_chr, labcol = "darkgray"))
  
  cp_circos <- list()
  cp_circos$chrlocs <- chrlocs
  cp_circos$chrlabels <- chrlabels
  cp_circos$bed1 <- bed1
  cp_circos$bed2 <- bed2
  cp_circos$linkcolors <- linkcolors
  
  return(cp_circos)
  
}


#' Create a circos plot
#'
#' \code{cp_circos_plot} returns a circos plot.
#'
#' @param cp_circos A cp_circos object produced by \code{cp_circos_create}
#' 
#' @return A circos plot object visualizing the links between gene and SNP locations.
#'
#' @examples
#' cp_circos_plot(cp_circos)
#' 
cp_circos_plot <- function(cp_circos){
  
  circos.genomicInitialize(cp_circos$chrlocs, plotType = NULL)
  circos.genomicLabels(cp_circos$chrlabels, labels.column = 4, side = "outside", col = cp_circos$chrlabels$labcol)
  circos.track(ylim = c(0, 1), panel.fun = function(x, y) circos.genomicAxis(h ="top", labels = NULL, labels.col = "#FF000000"), bg.col = rand_color(nrow(cp_circos$chrlocs), transparency = 0.5), bg.border = NA, track.height = 0.05)
  circos.genomicLink(cp_circos$bed1, cp_circos$bed2, col = cp_circos$linkcolors, border = NA, lwd = 1)
  
}
