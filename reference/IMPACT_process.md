# Process IMPACT files

Process IMPACT files so that they're all tabix-indexed and prepare them
for upload.

## Usage

``` r
IMPACT_process(
  IMPACT_dir,
  sandbox = TRUE,
  title = "IMPACT",
  zipfile = file.path(tempdir(), "IMPACT707"),
  token = Sys.getenv("zenodo_token"),
  validate = TRUE,
  verbose = TRUE
)
```

## Source

` #### Downloading annotations #### git clone IMPACT Mac: git lfs fetch --all git lfs pull Linux: sudo apt-get install git-lfs git-lfs fetch --all git-lfs pull `

` #### Installing zen4R #### ## has some system deps that have to be installed beforehand. sudo apt-get install raptor2-utils sudo apt-get install rasqal-utils sudo apt-get install librdf0-dev `

## Arguments

- IMPACT_dir:

  Directory where IMPACT repo has been cloned to.

- sandbox:

  Whether to use the Zenodo or Zenodo Sandbox API.

- token:

  Zenodo [Personal access
  token](https://zenodo.org/account/settings/applications/tokens/new/).

- verbose:

  Print messages.

## See also

Other IMPACT:
[`IMPACT_compute_enrichment()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_compute_enrichment.md),
[`IMPACT_files`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_files.md),
[`IMPACT_get_annotation_key()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_get_annotation_key.md),
[`IMPACT_get_annotations()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_get_annotations.md),
[`IMPACT_get_ldscores()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_get_ldscores.md),
[`IMPACT_get_top_annotations()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_get_top_annotations.md),
[`IMPACT_heatmap()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_heatmap.md),
[`IMPACT_iterate_enrichment()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_iterate_enrichment.md),
[`IMPACT_iterate_get_annotations()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_iterate_get_annotations.md),
[`IMPACT_plot_enrichment()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_plot_enrichment.md),
[`IMPACT_plot_impact_score()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_plot_impact_score.md),
[`IMPACT_postprocess_annotations()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_postprocess_annotations.md),
[`IMPACT_query()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_query.md),
[`IMPACT_snp_group_boxplot()`](https://rajlabmssm.github.io/echoAI/reference/IMPACT_snp_group_boxplot.md),
[`hierarchical_colors()`](https://rajlabmssm.github.io/echoAI/reference/hierarchical_colors.md),
[`prepare_mat_meta()`](https://rajlabmssm.github.io/echoAI/reference/prepare_mat_meta.md)
