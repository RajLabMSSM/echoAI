# Query deep learning annotations and LD scores (single chromosome)

Query deep learning annotations and LD scores for a single chromosome,
then merge with `dat` by *SNP*.

## Usage

``` r
DEEPLEARNING_query_one_chr(
  dat,
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

- dat:

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

A `data.table` with the original columns plus one new column per
matching annotation file, named
`<model>_<tissue>_<assay>_<type>_<mean_max>`.

## See also

Other DEEPLEARNING:
[`DEEPLEARNING_melt()`](https://rajlabmssm.github.io/echoAI/reference/DEEPLEARNING_melt.md),
[`DEEPLEARNING_plot()`](https://rajlabmssm.github.io/echoAI/reference/DEEPLEARNING_plot.md),
[`DEEPLEARNING_query()`](https://rajlabmssm.github.io/echoAI/reference/DEEPLEARNING_query.md),
[`DEEPLEARNING_query_multi_chr()`](https://rajlabmssm.github.io/echoAI/reference/DEEPLEARNING_query_multi_chr.md)

## Examples

``` r
if (FALSE) { # \dontrun{
BST1 <- echodata::BST1
annot_dat <- DEEPLEARNING_query_one_chr(
    dat = BST1,
    base_url = "/path/to/Dey_DeepLearning",
    tissue = "NTS",
    model = "Basenji",
    type = "annot"
)
} # }
```
