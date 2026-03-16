# Plot *SpliceAI* predictions

Multi-panel plot showing GWAS significance (`-log10(P)`) and the four
*SpliceAI* delta-score channels across genomic position, arranged
vertically using patchwork.

## Usage

``` r
SPLICEAI_plot(dat_merged)
```

## Source

<https://github.com/Illumina/SpliceAI>
[doi:10.1016/j.cell.2018.12.015](https://doi.org/10.1016/j.cell.2018.12.015)

## Arguments

- dat_merged:

  A `data.table` with at least columns `POS`, `P`, `DS_AG`, `DS_AL`,
  `DS_DG`, and `DS_DL`.

## Value

A `patchwork` composite `ggplot` object.

## See also

Other SPLICEAI:
[`SPLICEAI_query_api()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_api.md),
[`SPLICEAI_query_tsv()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_tsv.md),
[`SPLICEAI_query_tsv_iterate()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_tsv_iterate.md),
[`SPLICEAI_query_vcf()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_vcf.md),
[`SPLICEAI_run()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_run.md),
[`SPLICEAI_snp_probs()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_snp_probs.md)

## Examples

``` r
if (FALSE) { # \dontrun{
dat_merged <- data.table::fread("spliceAI_merged.tsv.gz")
plt <- SPLICEAI_plot(dat_merged)
} # }
```
