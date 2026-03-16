# Melt deep learning annotations into long format

Aggregates deep learning annotation values by SNP group within each
locus, then melts the result into long format and parses annotation
column names into component fields (`Model`, `Tissue`, `Assay`, `Type`,
`Metric`, `SNP_group`).

## Usage

``` r
DEEPLEARNING_melt(
  ANNOT,
  model = c("Basenji", "BiClassCNN", "DeepSEA", "ChromHMM", "Roadmap", "Others"),
  aggregate_func = "mean",
  replace_NA = NA,
  replace_negInf = NA,
  save_path = FALSE,
  verbose = TRUE
)
```

## Source

<https://alkesgroup.broadinstitute.org/LDSCORE/DeepLearning/Dey_DeepLearning.tgz>

## Arguments

- ANNOT:

  A `data.table` of deep learning annotations as returned by
  [`DEEPLEARNING_query`](https://rajlabmssm.github.io/echoAI/reference/DEEPLEARNING_query.md).

- model:

  Character vector of model names used to identify annotation columns.

- aggregate_func:

  Name of the aggregation function (e.g. `"mean"`, `"median"`).

- replace_NA:

  Value to substitute for `NA` before aggregation.

- replace_negInf:

  Value to substitute for `-Inf` (currently unused but reserved for
  future use).

- save_path:

  File path to save the melted result, or `FALSE` to skip saving.

- verbose:

  Print messages.

## Value

A `data.table` in long format with columns `Locus`, `Annotation`,
`value`, `Model`, `Tissue`, `Assay`, `Type`, `Metric`, and `SNP_group`.

## See also

Other DEEPLEARNING:
[`DEEPLEARNING_plot()`](https://rajlabmssm.github.io/echoAI/reference/DEEPLEARNING_plot.md),
[`DEEPLEARNING_query()`](https://rajlabmssm.github.io/echoAI/reference/DEEPLEARNING_query.md),
[`DEEPLEARNING_query_multi_chr()`](https://rajlabmssm.github.io/echoAI/reference/DEEPLEARNING_query_multi_chr.md),
[`DEEPLEARNING_query_one_chr()`](https://rajlabmssm.github.io/echoAI/reference/DEEPLEARNING_query_one_chr.md)

## Examples

``` r
if (FALSE) { # \dontrun{
annot_melt <- DEEPLEARNING_melt(
    ANNOT = ANNOT,
    aggregate_func = "mean",
    save_path = "results/deeplearning_snp_groups_mean.csv.gz"
)
} # }
```
