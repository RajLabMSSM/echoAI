# Plot deep learning predictions

Violin/box plot of deep learning annotation values across SNP groups,
with optional pairwise statistical comparisons via ggpubr. Outliers are
optionally removed before plotting.

## Usage

``` r
DEEPLEARNING_plot(
  annot_melt,
  snp_groups = c("GWAS lead", "UCS", "Consensus (-POLYFUN)", "Consensus"),
  comparisons_filter = function(x) {
     if ("Consensus" %in% x) 
         return(x)

    },
  model_metric = c("MAX"),
  facet_formula = ". ~ Model",
  remove_outliers = TRUE,
  show_padj = TRUE,
  show_signif = TRUE,
  vjust_signif = 0,
  show_plot = TRUE,
  save_path = FALSE,
  height = 6,
  width = 8
)
```

## Source

<https://alkesgroup.broadinstitute.org/LDSCORE/DeepLearning/Dey_DeepLearning.tgz>

## Arguments

- annot_melt:

  A `data.table` in long format as returned by
  [`DEEPLEARNING_melt`](https://rajlabmssm.github.io/echoAI/reference/DEEPLEARNING_melt.md),
  with columns including `Metric`, `SNP_group`, and `value`.

- snp_groups:

  Character vector of SNP groups to include in the plot.

- comparisons_filter:

  A function applied to each pairwise combination of SNP groups. Return
  the pair to keep it; return `NULL` to drop. Set to `NULL` to include
  all pairwise comparisons.

- model_metric:

  Character vector of metric values to include (e.g. `"MAX"`).

- facet_formula:

  Facet formula passed to
  [`facet_grid`](https://ggplot2.tidyverse.org/reference/facet_grid.html).

- remove_outliers:

  Logical; if `TRUE`, outliers identified by
  [`boxplot`](https://rdrr.io/r/graphics/boxplot.html) are removed
  before plotting.

- show_padj:

  Whether to show adjusted p-values (requires ggpubr).

- show_signif:

  Whether to show significance stars (requires ggpubr).

- vjust_signif:

  Vertical justification for significance labels.

- show_plot:

  Whether to display the plot.

- save_path:

  File path to save the plot, or `FALSE` to skip.

- height:

  Height of saved plot in inches.

- width:

  Width of saved plot in inches.

## Value

A `ggplot` object.

## See also

Other DEEPLEARNING:
[`DEEPLEARNING_melt()`](https://rajlabmssm.github.io/echoAI/reference/DEEPLEARNING_melt.md),
[`DEEPLEARNING_query()`](https://rajlabmssm.github.io/echoAI/reference/DEEPLEARNING_query.md),
[`DEEPLEARNING_query_multi_chr()`](https://rajlabmssm.github.io/echoAI/reference/DEEPLEARNING_query_multi_chr.md),
[`DEEPLEARNING_query_one_chr()`](https://rajlabmssm.github.io/echoAI/reference/DEEPLEARNING_query_one_chr.md)

## Examples

``` r
if (FALSE) { # \dontrun{
gp <- DEEPLEARNING_plot(
    annot_melt = annot_melt,
    facet_formula = "Tissue ~ Model",
    comparisons_filter = NULL,
    save_path = "results/deeplearning_plot.png"
)
} # }
```
