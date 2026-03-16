# Iterate *SpliceAI* TSV queries across multiple loci

Make multiple queries to a genome-wide pre-computed *SpliceAI* results
file (TSV format), one per summary-statistics file. Results are
optionally merged and saved.

## Usage

``` r
SPLICEAI_query_tsv_iterate(
  sumstats_paths,
  precomputed_path,
  nThread = 1,
  merge_data = TRUE,
  drop_na = TRUE,
  filtered = FALSE,
  save_path = "./spliceAI_subset.tsv.gz"
)
```

## Source

<https://github.com/Illumina/SpliceAI>
[doi:10.1016/j.cell.2018.12.015](https://doi.org/10.1016/j.cell.2018.12.015)

## Arguments

- sumstats_paths:

  Character vector of paths to per-locus summary-statistics files (TSV /
  TSV.GZ).

- precomputed_path:

  Path to the bgzipped and tabix-indexed pre-computed SpliceAI TSV file.

- nThread:

  Number of threads for
  [`mclapply`](https://rdrr.io/r/parallel/mclapply.html) and
  [`fwrite`](https://rdrr.io/pkg/data.table/man/fwrite.html).

- merge_data:

  Passed to
  [`SPLICEAI_query_tsv`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_tsv.md).

- drop_na:

  Passed to
  [`SPLICEAI_query_tsv`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_tsv.md).

- filtered:

  Passed to
  [`SPLICEAI_query_tsv`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_tsv.md).

- save_path:

  Path to save the combined results, or `FALSE` to skip saving.

## Value

A `data.table` of combined SpliceAI results across all loci.

## See also

Other SPLICEAI:
[`SPLICEAI_plot()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_plot.md),
[`SPLICEAI_query_api()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_api.md),
[`SPLICEAI_query_tsv()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_tsv.md),
[`SPLICEAI_query_vcf()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_vcf.md),
[`SPLICEAI_run()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_run.md),
[`SPLICEAI_snp_probs()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_snp_probs.md)

## Examples

``` r
if (FALSE) { # \dontrun{
sumstats_paths <- list.files(
    "path/to/sumstats",
    pattern = "*.tsv.gz",
    recursive = TRUE, full.names = TRUE
)
DAT <- SPLICEAI_query_tsv_iterate(
    sumstats_paths = sumstats_paths,
    precomputed_path = "spliceai_scores.tsv.gz"
)
} # }
```
