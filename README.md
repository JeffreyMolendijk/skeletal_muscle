## Introduction

Code repository for the manuscript: 

`Proteome-wide systems genetics analysis identifies UFMylation as a regulator of muscle function.`

<br>

## Usage

* Clone this repository to your local computer (`git clone https://github.com/JeffreyMolendijk/hmdp_skeletal_muscle.git`).
* Install the R-packages as used in the individual scripts. 
* Execute the code in the file `workflow.Rmd`.
* Inspect the output tables and images in `data/export/`.

To locate the directories and scripts of interest, please refer to the folder structure below.

<br>

## Folder structure

```
exercise_modalities
│   LICENSE
│   README.md
│
├───data
│   ├───database
│   │   │   SNP_locations_pqtl.csv    
│   │   │   SNP_locations_trait_05.csv
│   │   │   traitnames.csv
│   │   │   variant_effect_impact.csv 
│   │   │
│   │   ├───genebass
│   │   │       gene-phewas-exomes_ENSG00000143222_UFC1_2021_08_25_11_57_10.csv
│   │   │       gene-phewas-exomes_ENSG00000143819_EPHX1_2021_08_25_10_57_34.csv
│   │   │       gene-phewas-exomes_ENSG00000158716_DUSP23_2021_08_25_11_57_50.csv
│   │   │       gene-phewas-exomes_ENSG00000158793_NIT1_2021_08_25_11_58_01.csv
│   │   │       gene-phewas-exomes_ENSG00000158887_MPZ_2021_08_25_11_56_52.csv
│   │   │       gene-phewas-exomes_ENSG00000162813_BPNT1_2021_08_25_11_56_32.csv
│   │   │       gene-phewas-exomes_ENSG00000248485_PCP4L1_2021_08_25_11_57_25.csv
│   │   │
│   │   ├───hmdp_haplotype
│   │   │       hmdp_haplotype_cumulative_mm10.csv
│   │   │
│   │   └───Mm_102_GRCm38
│   │           Mus_musculus.GRCm38.102.gtf.gz
│   │           Mus_musculus.GRCm38.102.uniprot.tsv.gz
│   │
│   ├───export
│   │   └───images
│   └───input
│           181117_Lumos_BenP_HMDP_Muscle_TMT_Proteins_mapped.txt
│           AAV6_splashRNA_HMDP_pQTLs 25-2-2020_V2.xlsx
│           gentype.RDS
│           HMDP Traits List.xlsx
│           male.mm10.chrom.sizes.tsv
│           phenomeasure2022.RDS
│           pqtl_m_1.RDS
│           pqtl_m_2.RDS
│           pqtl_m_3.RDS
│           traitdata2022.RDS
│
└───R
        functions.R
        themes.R
        workflow.Rmd


```

<br>

## Input data

| filename                                                      | description                                               |
| -------------                                                 | -------------                                             |
| 181117_Lumos_BenP_HMDP_Muscle_TMT_Proteins_mapped.txt         | HMDP proteomic data                                       |
| AAV6_splashRNA_HMDP_pQTLs 25-2-2020_V2.xlsx                   | AAV design                                                |
| gentype.RDS                                                   | HMDP gentype data                                         |
| HMDP Traits List.xlsx                                         | HMDP trait information                                    |
| male.mm10.chrom.sizes.tsv                                     | Mouse chromosome sizes                                    |
| phenomeasure2022.RDS                                          | HMDP phenotype data                                       |
| pqtl_m_1.RDS                                                  | HMDP pQTL data (part 1)                                   |
| pqtl_m_2.RDS                                                  | HMDP pQTL data (part 2)                                   |
| pqtl_m_3.RDS                                                  | HMDP pQTL data (part 3)                                   |
| traitdata2022.RDS                                             | HMDP traitQTL data                                        |

> Note: QTL data has been filtered to reduce the filesize

<br>

## Analysis outputs

### `../data/export/images`

| filename | description                                    |
| ---------| -------------                                  |
| F1C.svg  | protein cv% violin plot                        |
| F1E.svg  | pqtl manhattan plot                            |
| F1F.svg  | pqtl gene-location vs variant-location plot    |
| F1G.svg  | rpl correlation and variant network            |
| F1H.svg  | genetic associations of mocs2 and atp proteins |
| F1I.svg  | intragenic variants affecting acadl abundance  |
| F1J.svg  | ephx1 variant allele boxplot                   |
| F2A.png  | protein-trait qtl heatmap                      |
| SF1.svg  | proteomics sample dendrogram                   |

> Note: The files in the `data/export/images` directory have a prefix describing the Figure they relate to. For example, F1C refers to Figure 1C, whereas SF1 refers to supplementary Figure 1. Further minor edits were made in Adobe Illustrator prior to collating the plots into figure panels.


<br>

## Citation

<cite>To be added.</cite>

<br>

## Contact
For more information, please contact Benjamin L. Parker (ben.parker@unimelb.edu.au).