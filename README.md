<img src='https://github.com/RajLabMSSM/echoAI/raw/main/inst/hex/hex.png' title='Hex sticker for echoAI' height='300'><br>
[![License:
GPL-3](https://img.shields.io/badge/license-GPL--3-blue.svg)](https://cran.r-project.org/web/licenses/GPL-3)
[![](https://img.shields.io/badge/doi-10.1093/bioinformatics/btab658-blue.svg)](https://doi.org/10.1093/bioinformatics/btab658)
[![](https://img.shields.io/badge/devel%20version-0.99.0-black.svg)](https://github.com/RajLabMSSM/echoAI)
[![](https://img.shields.io/github/languages/code-size/RajLabMSSM/echoAI.svg)](https://github.com/RajLabMSSM/echoAI)
[![](https://img.shields.io/github/last-commit/RajLabMSSM/echoAI.svg)](https://github.com/RajLabMSSM/echoAI/commits/main)
<br> [![R build
status](https://github.com/RajLabMSSM/echoAI/workflows/rworkflows/badge.svg)](https://github.com/RajLabMSSM/echoAI/actions)
[![](https://codecov.io/gh/RajLabMSSM/echoAI/branch/main/graph/badge.svg)](https://app.codecov.io/gh/RajLabMSSM/echoAI)
<br>
<a href='https://app.codecov.io/gh/RajLabMSSM/echoAI/tree/main' target='_blank'><img src='https://codecov.io/gh/RajLabMSSM/echoAI/branch/main/graphs/icicle.svg' title='Codecov icicle graph' width='200' height='50' style='vertical-align: top;'></a>  
<h4>  
Authors: <i>Brian Schilder, Jack Humphrey, Towfique Raj</i>  
</h4>

## echoAI: API access to variant-level AI/ML predictions including IMPACT (Inference and Modeling of Phenotype-related ACtive Transcription) for immune cell annotations. Part of the echoverse suite for genomic fine-mapping.

This R package is part of the *echoverse* suite that supports
[`echolocatoR`](https://github.com/RajLabMSSM/echolocatoR): an automated
genomic fine-mapping pipeline.

If you use echoAI, please cite:

> Brian M. Schilder, Jack Humphrey, Towfique Raj (2021) echolocatoR: an
> automated end-to-end statistical and functional genomic fine-mapping
> pipeline, *Bioinformatics*; btab658,
> <https://doi.org/10.1093/bioinformatics/btab658>

## Installation

``` r
if(!require("BiocManager")) install.packages("BiocManager")

BiocManager::install("RajLabMSSM/echoAI")
library(echoAI)
```

## Functions

### Query & annotation

- `IMPACT_query()` : Query IMPACT annotations and LD-scores from
  tabix-indexed files on Zenodo. Supports wide, long, and list output
  formats.
- `IMPACT_get_annotations()` : Download raw IMPACT annotation matrices
  from GitHub and merge with your variant data.
- `IMPACT_get_annotation_key()` : Retrieve the IMPACT annotation key
  describing tissue, cell type, and transcription factor metadata for
  all 707 annotations.

### Enrichment

- `IMPACT_compute_enrichment()` : Compute enrichment of IMPACT scores
  across SNP groups (lead GWAS, credible sets, consensus).
- `IMPACT_iterate_enrichment()` : Run enrichment tests across all loci.

### Visualisation

- `IMPACT_snp_group_boxplot()` : Box/violin plot of IMPACT scores by SNP
  group with statistical comparisons.
- `IMPACT_plot_enrichment()` : Bar and violin plots summarising
  enrichment results.
- `IMPACT_plot_impact_score()` : Multi-panel locus plot combining GWAS,
  fine-mapping, and per-tissue IMPACT scores.
- `IMPACT_heatmap()` : ComplexHeatmap of mean IMPACT scores across loci
  and SNP groups.

## Documentation

### [Website](https://rajlabmssm.github.io/echoAI)

### [Get started](https://rajlabmssm.github.io/echoAI/articles/echoAI)

<hr>

## Contact

<a href="https://bschilder.github.io/BMSchilder/" target="_blank">Brian
M. Schilder, Bioinformatician II</a>
<a href="https://rajlab.org" target="_blank">Raj Lab</a>
<a href="https://icahn.mssm.edu/about/departments-offices/neuroscience" target="_blank">Department
of Neuroscience, Icahn School of Medicine at Mount Sinai</a>
