# Download LD scores from IMPACT publication

Downloads per-SNP LD scores from LD Score regression, first conducted in
the original IMPACT publication.

## Usage

``` r
IMPACT_get_ldscores(chrom = NULL, dat = NULL, nThread = 1)
```

## Source

T Amariuta et al., IMPACT: Genomic Annotation of Cell-State-Specific
Regulatory Elements Inferred from the Epigenome of Bound Transcription
Factors. The American Journal of Human Genetics, 1-17 (2019).

## Arguments

- chrom:

  Chromosome number.

- dat:

  A `data.table` with at least columns CHR, SNP, POS. If provided,
  `chrom` is extracted from the first row.

- nThread:

  Number of threads for
  [`data.table::fread`](https://rdrr.io/pkg/data.table/man/fread.html).

## Value

A `data.table` of LD scores, optionally merged with `dat`.

## See also

Other IMPACT:
[`IMPACT_compute_enrichment()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_compute_enrichment.md),
[`IMPACT_files`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_files.md),
[`IMPACT_get_annotation_key()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_get_annotation_key.md),
[`IMPACT_get_annotations()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_get_annotations.md),
[`IMPACT_get_top_annotations()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_get_top_annotations.md),
[`IMPACT_heatmap()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_heatmap.md),
[`IMPACT_iterate_enrichment()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_iterate_enrichment.md),
[`IMPACT_iterate_get_annotations()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_iterate_get_annotations.md),
[`IMPACT_plot_enrichment()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_plot_enrichment.md),
[`IMPACT_plot_impact_score()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_plot_impact_score.md),
[`IMPACT_postprocess_annotations()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_postprocess_annotations.md),
[`IMPACT_process()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_process.md),
[`IMPACT_query()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_query.md),
[`IMPACT_snp_group_boxplot()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_snp_group_boxplot.md),
[`hierarchical_colors()`](https://rajlabmssm.github.io/echoAI/reference/hierarchical_colors.md),
[`prepare_mat_meta()`](https://rajlabmssm.github.io/echoAI/reference/prepare_mat_meta.md)

## Examples

``` r
if (FALSE) { # \dontrun{
BST1 <- echodata::BST1
ldscore <- IMPACT_get_ldscores(dat = BST1)
} # }
```
