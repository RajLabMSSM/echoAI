#' Compute enrichment of IMPACT scores
#'
#' Conduct IMPACT enrichment between SNP groups and fine-mapping methods.
#' Enrichment is computed as the ratio of IMPACT signal in a SNP group
#' to the proportion of SNPs in that group.
#'
#' @param annot_melt A melted \code{data.table} of IMPACT annotations
#'   with columns including IMPACT_score, SNP, TF, Tissue, Cell, CellDeriv,
#'   and various fine-mapping result columns.
#' @param locus Optional locus name to add to the output.
#'
#' @return A \code{data.table} of enrichment results per SNP group and
#'   annotation.
#'
#' @export
#' @family IMPACT
#' @importFrom dplyr group_by summarise arrange n_distinct
#' @importFrom data.table rbindlist
#' @examples
#' \dontrun{
#' enrich <- IMPACT_compute_enrichment(annot_melt = annot_melt,
#'                                     locus = "BST1")
#' }
IMPACT_compute_enrichment <- function(annot_melt,
                                      locus = NULL) {

    TF <- Tissue <- Cell <- CellDeriv <- IMPACT_score <- SNP <- NULL;
    leadSNP <- Support <- ABF.CS <- FINEMAP.CS <- SUSIE.CS <- NULL;
    POLYFUN_SUSIE.CS <- Consensus_SNP <- enrichment <- SNP.group <- NULL;

    annot_melt[is.na(annot_melt$IMPACT_score), "IMPACT_score"] <- 0

    SNP.groups <- list(
        "leadGWAS" = annot_melt |>
            dplyr::group_by(TF, Tissue, Cell, CellDeriv) |>
            dplyr::summarise(
                enrichment = (sum(IMPACT_score[leadSNP], na.rm = TRUE) /
                                  sum(IMPACT_score, na.rm = TRUE)) /
                    (dplyr::n_distinct(SNP[leadSNP], na.rm = TRUE) /
                         dplyr::n_distinct(SNP, na.rm = TRUE))),
        "UCS" = annot_melt |>
            dplyr::group_by(TF, Tissue, Cell, CellDeriv) |>
            dplyr::summarise(
                enrichment = (sum(IMPACT_score[Support > 0], na.rm = TRUE) /
                                  sum(IMPACT_score, na.rm = TRUE)) /
                    (dplyr::n_distinct(SNP[Support > 0], na.rm = TRUE) /
                         dplyr::n_distinct(SNP, na.rm = TRUE))),
        "ABF_CS" = annot_melt |>
            dplyr::group_by(TF, Tissue, Cell, CellDeriv) |>
            dplyr::summarise(
                enrichment = (sum(IMPACT_score[ABF.CS > 0], na.rm = TRUE) /
                                  sum(IMPACT_score, na.rm = TRUE)) /
                    (dplyr::n_distinct(SNP[ABF.CS > 0], na.rm = TRUE) /
                         dplyr::n_distinct(SNP, na.rm = TRUE))),
        "FINEMAP_CS" = annot_melt |>
            dplyr::group_by(TF, Tissue, Cell, CellDeriv) |>
            dplyr::summarise(
                enrichment = (sum(IMPACT_score[FINEMAP.CS > 0],
                                  na.rm = TRUE) /
                                  sum(IMPACT_score, na.rm = TRUE)) /
                    (dplyr::n_distinct(SNP[FINEMAP.CS > 0], na.rm = TRUE) /
                         dplyr::n_distinct(SNP, na.rm = TRUE))),
        "SUSIE_CS" = annot_melt |>
            dplyr::group_by(TF, Tissue, Cell, CellDeriv) |>
            dplyr::summarise(
                enrichment = (sum(IMPACT_score[SUSIE.CS > 0],
                                  na.rm = TRUE) /
                                  sum(IMPACT_score, na.rm = TRUE)) /
                    (dplyr::n_distinct(SNP[SUSIE.CS > 0], na.rm = TRUE) /
                         dplyr::n_distinct(SNP, na.rm = TRUE))),
        "POLYFUN_CS" = annot_melt |>
            dplyr::group_by(TF, Tissue, Cell, CellDeriv) |>
            dplyr::summarise(
                enrichment = (sum(IMPACT_score[POLYFUN_SUSIE.CS > 0],
                                  na.rm = TRUE) /
                                  sum(IMPACT_score, na.rm = TRUE)) /
                    (dplyr::n_distinct(SNP[POLYFUN_SUSIE.CS > 0],
                                       na.rm = TRUE) /
                         dplyr::n_distinct(SNP, na.rm = TRUE))),
        "Consensus" = annot_melt |>
            dplyr::group_by(TF, Tissue, Cell, CellDeriv) |>
            dplyr::summarise(
                enrichment = (sum(IMPACT_score[Consensus_SNP],
                                  na.rm = TRUE) /
                                  sum(IMPACT_score, na.rm = TRUE)) /
                    (dplyr::n_distinct(SNP[Consensus_SNP], na.rm = TRUE) /
                         dplyr::n_distinct(SNP, na.rm = TRUE)))
    )
    enrich <- data.table::rbindlist(SNP.groups, idcol = "SNP.group") |>
        dplyr::arrange(-enrichment)
    enrich <- cbind(Locus = locus, enrich)
    enrich$TF <- factor(enrich$TF, ordered = TRUE)
    enrich$SNP.group <- factor(enrich$SNP.group,
                               levels = names(SNP.groups),
                               ordered = TRUE)
    return(enrich)
}


#' Iterate IMPACT enrichment tests
#'
#' Run \code{\link{IMPACT_compute_enrichment}} across all unique loci
#' in the ANNOT_MELT dataset.
#'
#' @param ANNOT_MELT A melted \code{data.table} of IMPACT annotations
#'   that must include a \code{Locus} column.
#' @param verbose Print messages.
#'
#' @return A \code{data.table} of enrichment results across all loci.
#'
#' @export
#' @family IMPACT
#' @importFrom data.table rbindlist
#' @examples
#' \dontrun{
#' ENRICH <- IMPACT_iterate_enrichment(ANNOT_MELT = ANNOT_MELT)
#' }
IMPACT_iterate_enrichment <- function(ANNOT_MELT,
                                      verbose = TRUE) {

    Locus <- NULL;

    ENRICH <- lapply(unique(ANNOT_MELT$Locus), function(locus) {
        messager("+ IMPACT:: Locus =", locus, v = verbose)
        annot_melt <- subset(ANNOT_MELT, Locus == locus)
        enrich <- IMPACT_compute_enrichment(annot_melt = annot_melt,
                                            locus = locus)
        return(enrich)
    })
    ENRICH <- data.table::rbindlist(ENRICH)
    return(ENRICH)
}
