# Prepare *IMPACT* annotations

Transform *IMPACT* annotations from wide format (one row per SNP) to
long format (multiple rows per SNP). Adds a `topConsensus` column, sorts
loci by mean IMPACT of the top consensus SNP, and creates a combined
`Cell_Type` label.

## Usage

``` r
IMPACT_postprocess_annotations(
  ANNOT_MELT,
  order_loci = TRUE,
  no_no_loci = NULL
)
```

## Arguments

- ANNOT_MELT:

  A melted `data.table` of IMPACT annotations (as returned by
  [`IMPACT_get_annotations`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_get_annotations.md)
  or
  [`IMPACT_iterate_get_annotations`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_iterate_get_annotations.md)).

- order_loci:

  Whether to reorder loci by mean IMPACT score of the top consensus SNP.

- no_no_loci:

  Character vector of locus names to exclude.

## Value

A `data.table` with postprocessed IMPACT annotations including a
`uniqueID` column.

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
[`IMPACT_iterate_get_annotations()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_iterate_get_annotations.md),
[`IMPACT_plot_enrichment()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_plot_enrichment.md),
[`IMPACT_plot_impact_score()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_plot_impact_score.md),
[`IMPACT_process()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_process.md),
[`IMPACT_query()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_query.md),
[`IMPACT_snp_group_boxplot()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_snp_group_boxplot.md),
[`hierarchical_colors()`](https://rajlabmssm.github.io/echoAI/reference/hierarchical_colors.md),
[`prepare_mat_meta()`](https://rajlabmssm.github.io/echoAI/reference/prepare_mat_meta.md)

## Examples

``` r
if (FALSE) { # \dontrun{
ANNOT_MELT <- IMPACT_postprocess_annotations(ANNOT_MELT)
} # }
```
