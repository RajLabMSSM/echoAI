# Getting Started

``` r

library(echoAI)
```

## Introduction

`echoAI` provides API access to variant-level AI/ML predictions,
currently centred on three tools:

- **IMPACT** (Inference and Modeling of Phenotype-related ACtive
  Transcription) – predicts transcription factor (TF) binding at motif
  sites by learning epigenomic profiles, primarily from
  [ENCODE](https://www.encodeproject.org/). The 707 annotations cover a
  wide range of immune and non-immune cell types, making IMPACT scores
  especially useful for prioritising causal variants in immune-mediated
  diseases. All IMPACT data are aligned to **hg19**. Tabix-indexed
  versions are hosted on Zenodo
  ([doi:10.5281/zenodo.7062238](https://doi.org/10.5281/zenodo.7062238))
  for rapid remote querying.

- **SpliceAI** – predicts the probability that a variant alters mRNA
  splicing. Results can be obtained via a local VCF/TSV or the Broad
  Institute API.

- **Deep learning annotations** (Basenji, DeepSEA) – query precomputed
  variant-level scores from deep learning models of chromatin
  accessibility and gene expression.

## IMPACT

### Query IMPACT annotations

The primary entry point is
[`IMPACT_query()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_query.md),
which queries tabix-indexed IMPACT annotation and LD-score files hosted
on Zenodo. This is the fastest way to annotate a small set of SNPs.

``` r

## Prepare example query data
query_dat <- echodata::BST1[1:50,]

## Query IMPACT annotations (European population, wide format)
annot_wide <- IMPACT_query(
    query_dat = query_dat,
    types = "annot",
    populations = "EUR",
    output_format = "wide"
)
head(annot_wide)
```

You can also retrieve results in long format, which is useful for
downstream enrichment analysis. Setting `add_metadata = TRUE` appends
tissue/cell/TF information to each row.

``` r

annot_long <- IMPACT_query(
    query_dat = query_dat,
    types = "annot",
    populations = "EUR",
    output_format = "long",
    add_metadata = TRUE
)
head(annot_long)
```

### Annotation key

The annotation key maps each of the 707 IMPACT annotation IDs to its
source study, tissue, cell type/line, and transcription factor.

``` r

annot_key <- IMPACT_get_annotation_key(save_key = FALSE)
head(annot_key)
```

### Download full annotation matrices

For larger analyses (e.g. genome-wide or multi-locus), you can download
the full per-chromosome annotation matrices directly from the IMPACT
GitHub repository with
[`IMPACT_get_annotations()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_get_annotations.md).

**Note:** These files are large. Make sure you have sufficient memory
and storage.

``` r

## Get annotations for variants in the BST1 locus
BST1 <- echodata::BST1
annot_melt <- IMPACT_get_annotations(dat = BST1)
head(annot_melt)
```

To iterate across all chromosomes in a merged fine-mapping dataset:

``` r

merged_DT <- echodata::get_Nalls2019_merged()
ANNOT_MELT <- IMPACT_iterate_get_annotations(merged_DT = merged_DT)
```

### Post-processing

[`IMPACT_postprocess_annotations()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_postprocess_annotations.md)
converts the annotation table to long format, identifies the top
consensus SNP per locus, and adds a combined cell-type label.

``` r

ANNOT_MELT <- IMPACT_postprocess_annotations(ANNOT_MELT)
```

### Enrichment analysis

Enrichment is computed as the ratio of IMPACT signal in a given SNP
group (e.g. consensus, credible set, lead GWAS) to the proportion of
SNPs in that group. This tells you whether fine-mapped SNPs are enriched
for predicted TF binding relative to the background.

``` r

## Compute enrichment for a single locus
enrich <- IMPACT_compute_enrichment(
    annot_melt = annot_melt,
    locus = "BST1"
)
head(enrich)

## Or iterate across all loci
ENRICH <- IMPACT_iterate_enrichment(ANNOT_MELT = ANNOT_MELT)
```

### Visualisation

#### SNP group box plot

Compare IMPACT score distributions across SNP groups with
[`IMPACT_snp_group_boxplot()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_snp_group_boxplot.md):

``` r

bp <- IMPACT_snp_group_boxplot(
    TOP_IMPACT_all = TOP_IMPACT_all,
    snp_groups = c("GWAS lead", "UCS", "Consensus"),
    method = "wilcox.test"
)
```

#### Enrichment plots

Visualise enrichment results with bar and violin plots:

``` r

plots <- IMPACT_plot_enrichment(ENRICH = ENRICH)
```

#### Locus plot

Create a multi-panel locus plot showing GWAS results, fine-mapping
posterior probabilities, and per-tissue IMPACT scores:

``` r

impact_plot <- IMPACT_plot_impact_score(annot_melt = annot_melt)
```

#### Heatmap

Generate a ComplexHeatmap of mean IMPACT scores across loci and SNP
groups:

``` r

mat_meta <- IMPACT_heatmap(ANNOT_MELT = ANNOT_MELT)
```

## SpliceAI

### Run SpliceAI

[`SPLICEAI_run()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_run.md)
is the main entry point. It dispatches to the appropriate backend (API,
local TSV, or VCF) depending on your input.

``` r

query_dat <- echodata::BST1[1:50,]
res <- SPLICEAI_run(query_dat = query_dat)
```

### Visualise splice probabilities

``` r

plt <- SPLICEAI_plot(query_dat = res)
```

## Deep learning annotations

### Query deep learning scores

[`DEEPLEARNING_query()`](https://rajlabmssm.github.io/echoAI/reference/DEEPLEARNING_query.md)
retrieves precomputed variant-level scores from deep learning models
(e.g. Basenji, DeepSEA) via tabix-indexed files.

``` r

query_dat <- echodata::BST1[1:50,]
dl_res <- DEEPLEARNING_query(query_dat = query_dat)
```

### Visualise scores

``` r

plt <- DEEPLEARNING_plot(dl_res)
```

## Session Info

``` r

utils::sessionInfo()
```

    ## R Under development (unstable) (2026-03-12 r89607)
    ## Platform: x86_64-pc-linux-gnu
    ## Running under: Ubuntu 24.04.4 LTS
    ## 
    ## Matrix products: default
    ## BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
    ## LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0
    ## 
    ## locale:
    ##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
    ##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
    ##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
    ##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
    ##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
    ## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
    ## 
    ## time zone: UTC
    ## tzcode source: system (glibc)
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] echoAI_0.99.0    BiocStyle_2.39.0
    ## 
    ## loaded via a namespace (and not attached):
    ##   [1] DBI_1.3.0                   piggyback_0.1.5            
    ##   [3] bitops_1.0-9                rlang_1.1.7                
    ##   [5] magrittr_2.0.4              otel_0.2.0                 
    ##   [7] matrixStats_1.5.0           compiler_4.6.0             
    ##   [9] RSQLite_2.4.6               GenomicFeatures_1.63.1     
    ##  [11] dir.expiry_1.19.0           png_0.1-8                  
    ##  [13] systemfonts_1.3.2           vctrs_0.7.1                
    ##  [15] stringr_1.6.0               pkgconfig_2.0.3            
    ##  [17] crayon_1.5.3                fastmap_1.2.0              
    ##  [19] XVector_0.51.0              Rsamtools_2.27.1           
    ##  [21] rmarkdown_2.30              tzdb_0.5.0                 
    ##  [23] UCSC.utils_1.7.1            ragg_1.5.1                 
    ##  [25] bit_4.6.0                   purrr_1.2.1                
    ##  [27] xfun_0.56                   aws.s3_0.3.22              
    ##  [29] cachem_1.1.0                downloadR_1.0.0            
    ##  [31] cigarillo_1.1.0             GenomeInfoDb_1.47.2        
    ##  [33] jsonlite_2.0.0              blob_1.3.0                 
    ##  [35] DelayedArray_0.37.0         BiocParallel_1.45.0        
    ##  [37] echoconda_1.0.0             parallel_4.6.0             
    ##  [39] R6_2.6.1                    VariantAnnotation_1.57.1   
    ##  [41] RColorBrewer_1.1-3          bslib_0.10.0               
    ##  [43] stringi_1.8.7               rtracklayer_1.71.3         
    ##  [45] reticulate_1.45.0           GenomicRanges_1.63.1       
    ##  [47] jquerylib_0.1.4             Rcpp_1.1.1                 
    ##  [49] Seqinfo_1.1.0               bookdown_0.46              
    ##  [51] SummarizedExperiment_1.41.1 knitr_1.51                 
    ##  [53] base64enc_0.1-6             R.utils_2.13.0             
    ##  [55] readr_2.2.0                 IRanges_2.45.0             
    ##  [57] Matrix_1.7-4                tidyselect_1.2.1           
    ##  [59] dichromat_2.0-0.1           abind_1.4-8                
    ##  [61] yaml_2.3.12                 codetools_0.2-20           
    ##  [63] curl_7.0.0                  lattice_0.22-9             
    ##  [65] tibble_3.3.1                S7_0.2.1                   
    ##  [67] KEGGREST_1.51.1             Biobase_2.71.0             
    ##  [69] basilisk.utils_1.23.1       evaluate_1.0.5             
    ##  [71] desc_1.4.3                  zip_2.3.3                  
    ##  [73] xml2_1.5.2                  Biostrings_2.79.5          
    ##  [75] pillar_1.11.1               BiocManager_1.30.27        
    ##  [77] filelock_1.0.3              MatrixGenerics_1.23.0      
    ##  [79] DT_0.34.0                   stats4_4.6.0               
    ##  [81] generics_0.1.4              RCurl_1.98-1.17            
    ##  [83] ggplot2_4.0.2               S4Vectors_0.49.0           
    ##  [85] hms_1.1.4                   scales_1.4.0               
    ##  [87] glue_1.8.0                  tools_4.6.0                
    ##  [89] BiocIO_1.21.0               data.table_1.18.2.1        
    ##  [91] BSgenome_1.79.1             GenomicAlignments_1.47.0   
    ##  [93] openxlsx_4.2.8.1            XML_3.99-0.22              
    ##  [95] fs_1.6.7                    grid_4.6.0                 
    ##  [97] tidyr_1.3.2                 echotabix_1.0.1            
    ##  [99] echodata_1.0.0              AnnotationDbi_1.73.0       
    ## [101] basilisk_1.23.0             restfulr_0.0.16            
    ## [103] cli_3.6.5                   textshaping_1.0.5          
    ## [105] S4Arrays_1.11.1             dplyr_1.2.0                
    ## [107] gtable_0.3.6                R.methodsS3_1.8.2          
    ## [109] sass_0.4.10                 digest_0.6.39              
    ## [111] BiocGenerics_0.57.0         SparseArray_1.11.11        
    ## [113] farver_2.1.2                rjson_0.2.23               
    ## [115] htmlwidgets_1.6.4           memoise_2.0.1              
    ## [117] htmltools_0.5.9             pkgdown_2.2.0              
    ## [119] R.oo_1.27.1                 lifecycle_1.0.5            
    ## [121] httr_1.4.8                  aws.signature_0.6.0        
    ## [123] bit64_4.6.0-1

\
