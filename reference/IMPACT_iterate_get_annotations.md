# Gather all *IMPACT* annotations that overlap with your query

Iterates over each unique locus. ***WARNING!*** These files are quite
large and you need to make sure you have ample memory and storage on
your computer for best results.

## Usage

``` r
IMPACT_iterate_get_annotations(
  merged_DT,
  IMPACT_score_thresh = 0.1,
  baseURL = paste0("https://github.com/immunogenomics/IMPACT/",
    "raw/master/IMPACT707/Annotations"),
  all_snps_in_range = TRUE,
  top_annotations = FALSE,
  force_one_annot_per_locus = FALSE,
  snp.filter = "!is.na(SNP)",
  nThread = 1,
  verbose = TRUE
)
```

## Arguments

- merged_DT:

  A merged `data.table` containing fine-mapping results across multiple
  loci with at least columns CHR and Locus.

- IMPACT_score_thresh:

  Minimum IMPACT score threshold for filtering.

- baseURL:

  Base URL for IMPACT annotation files.

- all_snps_in_range:

  Whether to include all SNPs in range.

- top_annotations:

  Number of top annotations to keep, or `FALSE` to keep all.

- force_one_annot_per_locus:

  Whether to force one annotation per locus.

- snp.filter:

  An expression (as character) used to filter SNPs for top annotation
  selection.

- nThread:

  Number of threads for data.table operations.

- verbose:

  Print messages.

## Value

A `data.table` of IMPACT annotations across all chromosomes.

## See also

Other IMPACT:
[`IMPACT_compute_enrichment()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_compute_enrichment.md),
[`IMPACT_files`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_files.md),
[`IMPACT_get_annotation_key()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_get_annotation_key.md),
[`IMPACT_get_annotations()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_get_annotations.md),
[`IMPACT_get_ldscores()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_get_ldscores.md),
[`IMPACT_get_top_annotations()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_get_top_annotations.md),
[`IMPACT_heatmap()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_heatmap.md),
[`IMPACT_iterate_enrichment()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_iterate_enrichment.md),
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
data("merged_DT")
ANNOT_MELT <- IMPACT_iterate_get_annotations(merged_DT = merged_DT)
} # }
```
