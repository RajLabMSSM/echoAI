# Postprocess *SpliceAI* results

Compute per-SNP maximum splice-alteration probabilities from pre-queried
*SpliceAI* scores, match risk alleles to the SpliceAI ALT allele, and
filter to lead SNPs above a probability threshold.

## Usage

``` r
SPLICEAI_snp_probs(DAT, save_path = FALSE)
```

## Source

<https://github.com/Illumina/SpliceAI>
[doi:10.1016/j.cell.2018.12.015](https://doi.org/10.1016/j.cell.2018.12.015)

## Arguments

- DAT:

  A `data.table` of SpliceAI results merged with summary statistics.
  Must contain at minimum the columns: `DS_AG`, `DS_AL`, `DS_DG`,
  `DS_DL`, `A1`, `A2`, `REF`, `ALT`, `Locus`, `SNP`, `CHR`, `POS`,
  `Effect`, `P`, `leadSNP`, `Consensus_SNP`, `Support`, `mean.PP`, and
  `SYMBOL`.

- save_path:

  Path to save the filtered results, or `FALSE` to skip saving.

## Value

A `data.table` of allele-matched, filtered SpliceAI hits with added
columns `max_spliceAI_group`, `max_spliceAI_prob`, and `GWAS.sig`.

## See also

Other SPLICEAI:
[`SPLICEAI_plot()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_plot.md),
[`SPLICEAI_query_api()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_api.md),
[`SPLICEAI_query_tsv()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_tsv.md),
[`SPLICEAI_query_tsv_iterate()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_tsv_iterate.md),
[`SPLICEAI_query_vcf()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_vcf.md),
[`SPLICEAI_run()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_run.md)

## Examples

``` r
if (FALSE) { # \dontrun{
DAT <- data.table::fread("spliceAI_merged.tsv.gz")
matchDAT <- SPLICEAI_snp_probs(DAT)
} # }
```
