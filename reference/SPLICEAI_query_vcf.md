# Query genome-wide *SpliceAI* results (VCF format)

Subset a genome-wide pre-computed *SpliceAI* VCF file using `bcftools`
for the region covered by the supplied data.

## Usage

``` r
SPLICEAI_query_vcf(dat, precomputed_path, subset_vcf = "subset.vcf")
```

## Source

<https://github.com/Illumina/SpliceAI>
[doi:10.1016/j.cell.2018.12.015](https://doi.org/10.1016/j.cell.2018.12.015)

## Arguments

- dat:

  A `data.table` with at least columns `CHR` (chromosome) and `POS`
  (base-pair position).

- precomputed_path:

  Path to the bgzipped and tabix-indexed pre-computed SpliceAI VCF file.

- subset_vcf:

  Path to write the subset VCF output.

## Value

The exit code from the `bcftools` system call (invisibly).

## See also

Other SPLICEAI:
[`SPLICEAI_plot()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_plot.md),
[`SPLICEAI_query_api()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_api.md),
[`SPLICEAI_query_tsv()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_tsv.md),
[`SPLICEAI_query_tsv_iterate()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_tsv_iterate.md),
[`SPLICEAI_run()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_run.md),
[`SPLICEAI_snp_probs()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_snp_probs.md)

## Examples

``` r
if (FALSE) { # \dontrun{
dat <- data.table::data.table(CHR = 1, POS = 100000:100500)
SPLICEAI_query_vcf(
    dat = dat,
    precomputed_path = "spliceai_scores.vcf.gz",
    subset_vcf = "subset.vcf"
)
} # }
```
