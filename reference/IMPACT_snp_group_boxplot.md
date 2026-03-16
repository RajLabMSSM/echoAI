# *IMPACT* SNP group box plot

Box plot of *IMPACT* scores from each SNP group, with optional
statistical comparisons via ggpubr.

## Usage

``` r
IMPACT_snp_group_boxplot(
  TOP_IMPACT_all,
  snp_groups = c("GWAS lead", "UCS", "Consensus"),
  method = "wilcox.test",
  comparisons_filter = function(x) {
     if ("Consensus" %in% x) 
         return(x)

    },
  show_plot = TRUE,
  save_path = FALSE,
  title = "IMPACT scores",
  xlabel = NULL,
  ylabel = NULL,
  show_padj = TRUE,
  show_signif = TRUE,
  vjust_signif = 0.5,
  show_xtext = TRUE,
  shift_points = TRUE,
  height = 10,
  width = 10
)
```

## Source

[ggpubr
example](https://www.r-bloggers.com/add-p-values-and-significance-levels-to-ggplots/)

## Arguments

- TOP_IMPACT_all:

  A `data.table` with columns `SNP_group` and `mean_IMPACT`.

- snp_groups:

  Character vector of SNP groups to include.

- method:

  Statistical test method (e.g. `"wilcox.test"`, `"t.test"`).

- comparisons_filter:

  A function applied to filter pairwise comparisons. Set to `NULL` to
  include all.

- show_plot:

  Whether to display the plot.

- save_path:

  Path to save the plot, or `FALSE` to skip saving.

- title:

  Plot title.

- xlabel:

  X-axis label.

- ylabel:

  Y-axis label.

- show_padj:

  Whether to show adjusted p-values.

- show_signif:

  Whether to show significance stars.

- vjust_signif:

  Vertical justification for significance labels.

- show_xtext:

  Whether to show x-axis tick labels.

- shift_points:

  Currently unused; kept for API compatibility.

- height:

  Height of saved plot in inches.

- width:

  Width of saved plot in inches.

## Value

A `ggplot` object.

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
[`hierarchical_colors()`](https://rajlabmssm.github.io/echoAI/reference/hierarchical_colors.md),
[`prepare_mat_meta()`](https://rajlabmssm.github.io/echoAI/reference/prepare_mat_meta.md)

## Examples

``` r
if (FALSE) { # \dontrun{
bp <- IMPACT_snp_group_boxplot(TOP_IMPACT_all, method = "wilcox.test")
} # }
```
