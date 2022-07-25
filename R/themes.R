# Author: Jeffrey Molendijk

# Description: Themes that are used in workflow.R
# Usage: Themes are loaded as part of workflow.R, so running this file manually is not required



# Theme for Figure 1G and Figure 2 (C,D,E,F,G,H,I,L,M,N,O,P,Q)
theme_panel <- theme(axis.text=element_text(size=8), axis.title = element_text(size = 8),
                     panel.grid.major.x = element_blank(),
                     panel.grid.minor = element_blank(),
                     legend.position = "null",
                     plot.title = element_text(size = 8, margin = margin(b = 10)),
                     plot.subtitle = element_text(size = 8, color = "darkslategrey", margin = margin(b = 25)),
                     plot.caption = element_text(size = 8, margin = margin(t = 10), color = "grey70", hjust = 0),
                     panel.background = element_blank(), axis.line.x = element_line(colour = "black"), axis.line.y = element_line(colour = "black"), axis.ticks.y = element_blank())


# Theme for Figure 1E
mhtheme <- theme(legend.position = "none", 
                 panel.grid.major = element_blank(), 
                 panel.grid.minor = element_blank(), 
                 panel.background = element_blank(), 
                 axis.line = element_line(colour = "black"))


# Theme for Supplementary Figure 3
theme_localmanhattan <- theme(axis.text=element_text(size=12), 
                               panel.grid.major.x = element_blank(),
                               panel.grid.minor = element_blank(),
                               legend.position = "null",
                               plot.title = element_text(size = 10, margin = margin(b = 10)),
                               plot.subtitle = element_text(size = 10, color = "darkslategrey", margin = margin(b = 25)),
                               plot.caption = element_text(size = 8, margin = margin(t = 10), color = "grey70", hjust = 0),
                               panel.background = element_blank(), axis.line = element_line(colour = "black"))


# Theme for Figure 2A
mytheme_phewas <- theme(legend.position = "none", 
                        panel.grid.major = element_blank(), 
                        panel.grid.minor = element_blank(), 
                        panel.background = element_blank(), 
                        axis.line = element_line(colour = "black"), 
                        axis.text.y=element_blank(), 
                        axis.ticks.y=element_blank(), 
                        plot.title = element_text(size = 8, vjust = -10), 
                        panel.border = element_rect(colour = "black", fill=NA, size=0.5))

# Theme for Figure 2A
mytheme_phewas2 <- theme(legend.position = "none", 
                         panel.grid.major = element_blank(), 
                         panel.grid.minor = element_blank(), 
                         panel.background = element_blank(), 
                         plot.title = element_text(size = 8, vjust = -10), 
                         panel.border = element_rect(colour = NA, fill=NA))
