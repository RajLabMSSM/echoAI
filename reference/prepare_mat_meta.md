# Prepare data matrix and metadata for ComplexHeatmap

Prepare data matrix and metadata for ComplexHeatmap

## Usage

``` r
prepare_mat_meta(
  TOP_IMPACT,
  snp.group = "Consensus",
  value.var = "mean_IMPACT",
  fill_na = 0
)
```

## Arguments

- TOP_IMPACT:

  A `data.table` of top IMPACT annotations.

- snp.group:

  Name of the SNP group to use for metadata merge.

- value.var:

  Name of the value column to use in the cast.

- fill_na:

  Value to use for filling NA entries.

## Value

A `data.frame` with loci as rows and SNP groups as columns, plus
metadata columns.

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
[`IMPACT_postprocess_annotations()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_postprocess_annotations.md),
[`IMPACT_process()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_process.md),
[`IMPACT_query()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_query.md),
[`IMPACT_snp_group_boxplot()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_snp_group_boxplot.md),
[`hierarchical_colors()`](https://rajlabmssm.github.io/echoAI/reference/hierarchical_colors.md)
