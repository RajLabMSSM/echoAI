#' Melt deep learning annotations into long format
#'
#' Aggregates deep learning annotation values by SNP group within each
#' locus, then melts the result into long format and parses annotation
#' column names into component fields (\code{Model}, \code{Tissue},
#' \code{Assay}, \code{Type}, \code{Metric}, \code{SNP_group}).
#'
#' @param ANNOT A \code{data.table} of deep learning annotations as
#'   returned by \code{\link{DEEPLEARNING_query}}.
#' @param model Character vector of model names used to identify
#'   annotation columns.
#' @param aggregate_func Name of the aggregation function
#'   (e.g. \code{"mean"}, \code{"median"}).
#' @param replace_NA Value to substitute for \code{NA} before aggregation.
#' @param replace_negInf Value to substitute for \code{-Inf} (currently
#'   unused but reserved for future use).
#' @param save_path File path to save the melted result, or \code{FALSE}
#'   to skip saving.
#' @param verbose Print messages.
#'
#' @returns A \code{data.table} in long format with columns \code{Locus},
#'   \code{Annotation}, \code{value}, \code{Model}, \code{Tissue},
#'   \code{Assay}, \code{Type}, \code{Metric}, and \code{SNP_group}.
#'
#' @export
#' @family DEEPLEARNING
#' @source
#' \url{https://alkesgroup.broadinstitute.org/LDSCORE/DeepLearning/Dey_DeepLearning.tgz}
#' @importFrom data.table data.table melt.data.table
#' @importFrom dplyr group_by summarise_at vars mutate
#' @importFrom tidyr replace_na separate
#' @importFrom echodata snp_group_filters
#' @examples
#' \dontrun{
#' annot_melt <- DEEPLEARNING_melt(
#'     ANNOT = ANNOT,
#'     aggregate_func = "mean",
#'     save_path = "results/deeplearning_snp_groups_mean.csv.gz"
#' )
#' }
DEEPLEARNING_melt <- function(
        ANNOT,
        model = c("Basenji", "BiClassCNN", "DeepSEA",
                   "ChromHMM", "Roadmap", "Others"),
        aggregate_func = "mean",
        replace_NA = NA,
        replace_negInf = NA,
        save_path = FALSE,
        verbose = TRUE) {

    Locus <- P <- leadSNP <- ABF.CS <- SUSIE.CS <- NULL
    POLYFUN_SUSIE.CS <- FINEMAP.CS <- NULL
    Support <- Support_noPF <- NULL
    Consensus_SNP <- Consensus_SNP_noPF <- NULL
    Annotation <- SNP_group <- NULL

    snp_groups_list <- echodata::snp_group_filters()
    agg_func <- get(aggregate_func)

    annot_melt <- ANNOT |>
        dplyr::group_by(Locus) |>
        dplyr::summarise_at(
            .vars = dplyr::vars(
                grep(paste(model, collapse = "|"),
                     colnames(ANNOT), value = TRUE)
            ),
            .funs = list(
                "Random" = ~ agg_func(
                    tidyr::replace_na(
                        sample(.x, size = 3, replace = TRUE), replace_NA
                    ), na.rm = TRUE),
                "All" = ~ agg_func(
                    tidyr::replace_na(.x, replace_NA),
                    na.rm = TRUE),
                "GWAS nom. sig." = ~ agg_func(
                    tidyr::replace_na(.x[P < .05], replace_NA),
                    na.rm = TRUE),
                "GWAS sig." = ~ agg_func(
                    tidyr::replace_na(.x[P < 5e-8], replace_NA),
                    na.rm = TRUE),
                "GWAS lead" = ~ agg_func(
                    tidyr::replace_na(.x[leadSNP], replace_NA),
                    na.rm = TRUE),
                "ABF CS" = ~ agg_func(
                    tidyr::replace_na(.x[ABF.CS > 0], replace_NA),
                    na.rm = TRUE),
                "SUSIE CS" = ~ agg_func(
                    tidyr::replace_na(.x[SUSIE.CS > 0], replace_NA),
                    na.rm = TRUE),
                "POLYFUN-SUSIE CS" = ~ agg_func(
                    tidyr::replace_na(
                        .x[POLYFUN_SUSIE.CS > 0], replace_NA
                    ), na.rm = TRUE),
                "FINEMAP CS" = ~ agg_func(
                    tidyr::replace_na(.x[FINEMAP.CS > 0], replace_NA),
                    na.rm = TRUE),
                "UCS (-PolyFun)" = ~ agg_func(
                    tidyr::replace_na(.x[Support_noPF > 0], replace_NA),
                    na.rm = TRUE),
                "UCS" = ~ agg_func(
                    tidyr::replace_na(.x[Support > 0], replace_NA),
                    na.rm = TRUE),
                "Support==0" = ~ agg_func(
                    tidyr::replace_na(.x[Support == 0], replace_NA),
                    na.rm = TRUE),
                "Support==1" = ~ agg_func(
                    tidyr::replace_na(.x[Support == 1], replace_NA),
                    na.rm = TRUE),
                "Support==2" = ~ agg_func(
                    tidyr::replace_na(.x[Support == 2], replace_NA),
                    na.rm = TRUE),
                "Support==3" = ~ agg_func(
                    tidyr::replace_na(.x[Support == 3], replace_NA),
                    na.rm = TRUE),
                "Support==4" = ~ agg_func(
                    tidyr::replace_na(.x[Support == 4], replace_NA),
                    na.rm = TRUE),
                "Consensus (-PolyFun)" = ~ agg_func(
                    tidyr::replace_na(
                        .x[Consensus_SNP_noPF], replace_NA
                    ), na.rm = TRUE),
                "Consensus" = ~ agg_func(
                    tidyr::replace_na(.x[Consensus_SNP], replace_NA),
                    na.rm = TRUE)
            )
        ) |>
        data.table::data.table() |>
        data.table::melt.data.table(
            id.vars = "Locus",
            variable.name = "Annotation"
        ) |>
        tidyr::separate(
            col = "Annotation",
            sep = "_",
            into = c("Model", "Tissue", "Assay", "Type",
                     "Metric", "SNP_group"),
            remove = FALSE
        ) |>
        dplyr::mutate(
            Annotation = gsub("^_+|_+$", "",
                              trimws(as.character(Annotation))),
            SNP_group = factor(
                SNP_group,
                levels = names(snp_groups_list),
                ordered = TRUE
            )
        )

    if (!isFALSE(save_path)) {
        messager("DEEPLEARNING:: Saving aggregated SNP_group values",
                 aggregate_func, "==>", save_path, v = verbose)
        dir.create(dirname(save_path),
                   showWarnings = FALSE, recursive = TRUE)
        data.table::fwrite(annot_melt, save_path)
    }
    return(annot_melt)
}
