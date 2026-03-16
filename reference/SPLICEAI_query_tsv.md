# Query genome-wide *SpliceAI* results (TSV format)

Subset a genome-wide pre-computed *SpliceAI* TSV file for the region
covered by the supplied data, using tabix.

## Usage

``` r
SPLICEAI_query_tsv(
  dat,
  precomputed_path,
  merge_data = TRUE,
  drop_na = TRUE,
  filtered = TRUE
)
```

## Source

<https://github.com/Illumina/SpliceAI>
[doi:10.1016/j.cell.2018.12.015](https://doi.org/10.1016/j.cell.2018.12.015)

## Arguments

- dat:

  A `data.table` with at least columns `CHR` (chromosome) and `POS`
  (base-pair position).

- precomputed_path:

  Path to the bgzipped and tabix-indexed pre-computed SpliceAI TSV file.

- merge_data:

  Whether to merge the SpliceAI results back onto `dat`. If `FALSE`,
  returns the raw query result.

- drop_na:

  If `TRUE`, only keeps rows that match between `dat` and the SpliceAI
  results.

- filtered:

  Whether the pre-computed file is in the filtered format (with extra
  columns such as ID, QUAL, FILTER, STRAND, TYPE).

## Value

A `data.table` of SpliceAI scores, optionally merged with `dat`.

## See also

Other SPLICEAI:
[`SPLICEAI_plot()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_plot.md),
[`SPLICEAI_query_api()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_api.md),
[`SPLICEAI_query_tsv_iterate()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_tsv_iterate.md),
[`SPLICEAI_query_vcf()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_vcf.md),
[`SPLICEAI_run()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_run.md),
[`SPLICEAI_snp_probs()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_snp_probs.md)

## Examples

``` r
if (FALSE) { # \dontrun{
dat <- data.table::fread("my_sumstats.tsv.gz")
spliceai_dat <- SPLICEAI_query_tsv(
    dat = dat,
    precomputed_path = "spliceai_scores.tsv.gz"
)
} # }
```
