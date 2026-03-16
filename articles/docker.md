# Docker/Singularity Containers

## Installation

echoAI is now available via
[ghcr.io](https://ghcr.io/ghcr.io/rajlabmssm/echoai) as a containerised
environment with Rstudio and all necessary dependencies pre-installed.

### Method 1: via Docker

First, [install Docker](https://docs.docker.com/get-docker/) if you have
not already.

Create an image of the [Docker](https://www.docker.com/) container in
command line:

    docker pull ghcr.io/rajlabmssm/echoai

Once the image has been created, you can launch it with:

    docker run \
      -d \
      -e ROOT=true \
      -e PASSWORD="<your_password>" \
      -v ~/Desktop:/Desktop \
      -v /Volumes:/Volumes \
      -p 8900:8787 \
      ghcr.io/rajlabmssm/echoai

#### NOTES

- Make sure to replace `<your_password>` above with whatever you want
  your password to be.
- Change the paths supplied to the `-v` flags for your particular use
  case.
- The `-d` ensures the container will run in “detached” mode, which
  means it will persist even after you’ve closed your command line
  session.
- The username will be *“rstudio”* by default.
- Optionally, you can also install the [Docker
  Desktop](https://www.docker.com/products/docker-desktop/) to easily
  manage your containers.

### Method 2: via Singularity

If you are using a system that does not allow Docker (as is the case for
many institutional computing clusters), you can instead [install Docker
images via
Singularity](https://docs.sylabs.io/guides/2.6/user-guide/singularity_and_docker.html).

    singularity pull docker://ghcr.io/rajlabmssm/echoai

For troubleshooting, see the [Singularity
documentation](https://docs.sylabs.io/guides/latest/user-guide/singularity_and_docker.html#github-container-registry).

## Usage

Finally, launch the containerised Rstudio by entering the following URL
in any web browser: *<http://localhost:8900/>*

Login using the credentials set during the Installation steps.

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
