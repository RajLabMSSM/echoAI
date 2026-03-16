# Query SpliceAI Lookup API

Query the public [SpliceAI
Lookup](https://spliceailookup.broadinstitute.org/) web API hosted by
the Broad Institute. This service runs the SpliceAI model on-the-fly for
individual variants without requiring local installation or precomputed
files.

## Usage

``` r
SPLICEAI_query_api(
  variants,
  genome = c("37", "38"),
  distance = 50,
  mask = 0,
  verbose = TRUE
)
```

## Source

<https://spliceailookup.broadinstitute.org/>
[doi:10.1016/j.cell.2018.12.015](https://doi.org/10.1016/j.cell.2018.12.015)

## Arguments

- variants:

  Character vector of variants in `"chrom-pos-ref-alt"` format (e.g.
  `"2-179415988-C-CA"`).

- genome:

  Genome build: `"37"` (GRCh37/hg19) or `"38"` (GRCh38/hg38).

- distance:

  Maximum distance between the variant and gained/lost splice site
  (default 50, max 10000).

- mask:

  Mask scores for annotated splice sites (0 = raw, 1 = masked). Default
  0.

- verbose:

  Print messages.

## Value

A `data.table` with one row per variant, containing columns for
`variant`, `gene`, `DS_AG`, `DS_AL`, `DS_DG`, `DS_DL` (delta scores),
and corresponding `DP_*` (delta positions). Returns `NULL` for variants
with no scores.

## Details

**Rate limit:** The public API supports only a handful of queries per
user per minute. For batch processing, use
[`SPLICEAI_query_tsv`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_tsv.md)
with local precomputed files or set up a local instance via
<https://github.com/broadinstitute/SpliceAI-lookup>.

## See also

Other SPLICEAI:
[`SPLICEAI_plot()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_plot.md),
[`SPLICEAI_query_tsv()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_tsv.md),
[`SPLICEAI_query_tsv_iterate()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_tsv_iterate.md),
[`SPLICEAI_query_vcf()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_vcf.md),
[`SPLICEAI_run()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_run.md),
[`SPLICEAI_snp_probs()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_snp_probs.md)

## Examples

``` r
if (FALSE) { # \dontrun{
result <- SPLICEAI_query_api(
    variants = "2-179415988-C-CA",
    genome = "37"
)
} # }
```
