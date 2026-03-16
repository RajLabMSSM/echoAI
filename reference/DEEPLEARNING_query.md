# Iteratively collect deep learning annotations

Queries deep learning annotations across all combinations of `level`,
`tissue`, `model`, `mean_max`, and `type`, then column-binds the
annotation columns onto `merged_dat`.

## Usage

``` r
DEEPLEARNING_query(
  merged_dat,
  base_url = NULL,
  level = c("Variant_Level", "Allelic_Effect"),
  tissue = c("NTS", "Blood", "Brain"),
  model = c("Basenji", "BiClassCNN", "DeepSEA", "ChromHMM", "Roadmap", "Others"),
  mean_max = c("MEAN", "MAX"),
  type = c("annot", "ldscore"),
  nThread = 1,
  verbose = TRUE
)
```

## Source

<https://console.cloud.google.com/storage/browser/broad-alkesgroup-public-requester-pays>
Original URL (now offline):
`https://alkesgroup.broadinstitute.org/LDSCORE/DeepLearning/Dey_DeepLearning.tgz`

## Arguments

- merged_dat:

  A `data.frame` or `data.table` containing at least columns `CHR` and
  `SNP`.

- base_url:

  Base directory path containing the Dey DeepLearning annotation files.
  Must be provided explicitly.

- level:

  Annotation level: `"Variant_Level"` or `"Allelic_Effect"`.

- tissue:

  Tissue type: `"NTS"`, `"Blood"`, or `"Brain"`.

- model:

  Deep learning model: `"Basenji"`, `"BiClassCNN"`, `"DeepSEA"`,
  `"ChromHMM"`, `"Roadmap"`, or `"Others"`.

- mean_max:

  Aggregation metric: `"MEAN"` or `"MAX"`.

- type:

  File type: `"annot"` or `"ldscore"`.

- nThread:

  Number of threads for
  [`data.table::fread`](https://rdrr.io/pkg/data.table/man/fread.html).

- verbose:

  Print messages.

## Value

A `data.table` with `merged_dat` columns plus all collected annotation
columns.

## See also

Other DEEPLEARNING:
[`DEEPLEARNING_melt()`](https://rajlabmssm.github.io/echoAI/reference/DEEPLEARNING_melt.md),
[`DEEPLEARNING_plot()`](https://rajlabmssm.github.io/echoAI/reference/DEEPLEARNING_plot.md),
[`DEEPLEARNING_query_multi_chr()`](https://rajlabmssm.github.io/echoAI/reference/DEEPLEARNING_query_multi_chr.md),
[`DEEPLEARNING_query_one_chr()`](https://rajlabmssm.github.io/echoAI/reference/DEEPLEARNING_query_one_chr.md)

## Examples

``` r
if (FALSE) { # \dontrun{
merged_dat <- echodata::find_consensus_snps_no_polyfun(merged_dat)

## Allelic_Effect
ANNOT_ae <- DEEPLEARNING_query(
    merged_dat = merged_dat,
    base_url = "/path/to/Dey_DeepLearning",
    level = "Allelic_Effect",
    type = "annot"
)

## Variant_Level
ANNOT_vl <- DEEPLEARNING_query(
    merged_dat = merged_dat,
    base_url = "/path/to/Dey_DeepLearning",
    level = "Variant_Level",
    type = "annot"
)
} # }
```
