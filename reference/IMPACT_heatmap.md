# Plot ComplexHeatmap of *IMPACT* scores

Creates a heatmap of mean IMPACT scores across SNP groups and loci using
ComplexHeatmap. Includes a boxplot annotation at the top and a metadata
annotation column for transcription factors.

## Usage

``` r
IMPACT_heatmap(
  ANNOT_MELT,
  snp_groups = c("GWAS lead", "UCS (-PolyFun)", "UCS", "Consensus (-PolyFun)",
    "Consensus"),
  no_no_loci = NULL,
  save_path = NULL
)
```

## Arguments

- ANNOT_MELT:

  A melted `data.table` of IMPACT annotations (as returned by
  [`IMPACT_postprocess_annotations`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_postprocess_annotations.md)).

- snp_groups:

  Character vector of SNP group names to include.

- no_no_loci:

  Character vector of locus names to exclude.

- save_path:

  Path to save the heatmap (SVG format). If `NULL`, the heatmap is drawn
  to the current device.

## Value

A `data.table` of the heatmap metadata matrix (invisibly).

## See also

Other IMPACT:
[`IMPACT_compute_enrichment()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_compute_enrichment.md),
[`IMPACT_files`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_files.md),
[`IMPACT_get_annotation_key()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_get_annotation_key.md),
[`IMPACT_get_annotations()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_get_annotations.md),
[`IMPACT_get_ldscores()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_get_ldscores.md),
[`IMPACT_get_top_annotations()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_get_top_annotations.md),
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
mat_meta <- IMPACT_heatmap(ANNOT_MELT = ANNOT_MELT)
} # }
```
