# Download *IMPACT* annotations

Includes the raw annotation itself, as well as per-SNP *IMPACT* scores
for each annotation.

## Usage

``` r
IMPACT_get_annotations(
  baseURL = paste0("https://github.com/immunogenomics/IMPACT/",
    "raw/master/IMPACT707/Annotations"),
  chrom = NULL,
  dat = NULL,
  nThread = 1,
  all_snps_in_range = FALSE,
  verbose = TRUE
)
```

## Arguments

- baseURL:

  Base URL for IMPACT annotation files.

- chrom:

  Chromosome number.

- dat:

  A `data.table` with at least columns CHR, SNP, POS.

- nThread:

  Number of threads for
  [`data.table::fread`](https://rdrr.io/pkg/data.table/man/fread.html).

- all_snps_in_range:

  Whether to include all SNPs in the range (not just those in `dat`).

- verbose:

  Print messages.

## Value

A melted `data.table` of IMPACT annotations merged with annotation
metadata.

## Details

Unfortunately, you have to download the entire chromosome file at once,
because they aren't Tabix indexed. To minimize the memory load, this
function only keeps the portion of the *IMPACT* file that overlaps with
the coordinates in `dat`.

## See also

Other IMPACT:
[`IMPACT_compute_enrichment()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_compute_enrichment.md),
[`IMPACT_files`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_files.md),
[`IMPACT_get_annotation_key()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_get_annotation_key.md),
[`IMPACT_get_ldscores()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_get_ldscores.md),
[`IMPACT_get_top_annotations()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_get_top_annotations.md),
[`IMPACT_heatmap()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_heatmap.md),
[`IMPACT_iterate_enrichment()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_iterate_enrichment.md),
[`IMPACT_iterate_get_annotations()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_iterate_get_annotations.md),
[`IMPACT_plot_enrichment()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_plot_enrichment.md),
[`IMPACT_plot_impact_score()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_plot_impact_score.md),
[`IMPACT_postprocess_annotations()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_postprocess_annotations.md),
[`IMPACT_process()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_process.md),
[`IMPACT_query()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_query.md),
[`IMPACT_snp_group_boxplot()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_snp_group_boxplot.md),
[`hierarchical_colors()`](https://rajlabmssm.github.io/echoAI/reference/hierarchical_colors.md),
[`prepare_mat_meta()`](https://rajlabmssm.github.io/echoAI/reference/prepare_mat_meta.md)

## Examples

``` r
if (FALSE) { # \dontrun{
BST1 <- echodata::BST1
annot_melt <- IMPACT_get_annotations(dat = BST1)
} # }
```
