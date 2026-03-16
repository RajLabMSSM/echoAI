# Run pre-trained *SpliceAI* model

Run the pre-trained *SpliceAI* deep learning model to predict
splice-site alterations from genetic variants. Requires the `spliceai`
command-line tool to be installed and on the system `PATH` (e.g. via
`pip install spliceai`).

## Usage

``` r
SPLICEAI_run(
  vcf_path = "./GWAS_converted.vcf",
  output_path = "spliceai_predictions.vcf",
  reference_fasta,
  gene_annotation = "grch37",
  distance = 50,
  mask = 0
)
```

## Source

<https://github.com/Illumina/SpliceAI>
[doi:10.1016/j.cell.2018.12.015](https://doi.org/10.1016/j.cell.2018.12.015)

## Arguments

- vcf_path:

  Path to the input VCF file.

- output_path:

  Path to the output VCF file.

- reference_fasta:

  Path to the reference genome FASTA file (must be unzipped).

- gene_annotation:

  Path to a gene annotation file, or one of `"grch37"` / `"grch38"` to
  use the GENCODE canonical annotations bundled with SpliceAI.

- distance:

  Maximum distance (in bases) between the variant and a gained/lost
  splice site. Defaults to 50.

- mask:

  Integer flag controlling score masking. When set to 1, masks scores
  representing annotated acceptor/donor gain and unannotated
  acceptor/donor loss. Defaults to 0 (no masking).

## Value

The exit code from the `spliceai` system call (invisibly).

## See also

Other SPLICEAI:
[`SPLICEAI_plot()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_plot.md),
[`SPLICEAI_query_api()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_api.md),
[`SPLICEAI_query_tsv()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_tsv.md),
[`SPLICEAI_query_tsv_iterate()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_tsv_iterate.md),
[`SPLICEAI_query_vcf()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_query_vcf.md),
[`SPLICEAI_snp_probs()`](https://rajlabmssm.github.io/echoAI/reference/SPLICEAI_snp_probs.md)

## Examples

``` r
if (FALSE) { # \dontrun{
SPLICEAI_run(
    vcf_path = "variants.vcf",
    output_path = "spliceai_predictions.vcf",
    reference_fasta = "hg19.fa",
    gene_annotation = "grch37"
)
} # }
```
