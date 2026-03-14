#' Prepare \emph{IMPACT} annotations
#'
#' Transform \emph{IMPACT} annotations from wide format (one row per SNP) to
#' long format (multiple rows per SNP). Adds a \code{topConsensus} column,
#' sorts loci by mean IMPACT of the top consensus SNP, and creates a
#' combined \code{Cell_Type} label.
#'
#' @param ANNOT_MELT A melted \code{data.table} of IMPACT annotations
#'   (as returned by \code{\link{IMPACT_get_annotations}} or
#'   \code{\link{IMPACT_iterate_get_annotations}}).
#' @param order_loci Whether to reorder loci by mean IMPACT score
#'   of the top consensus SNP.
#' @param no_no_loci Character vector of locus names to exclude.
#'
#' @return A \code{data.table} with postprocessed IMPACT annotations
#'   including a \code{uniqueID} column.
#'
#' @export
#' @family IMPACT
#' @importFrom dplyr group_by summarise arrange mutate
#' @examples
#' \dontrun{
#' ANNOT_MELT <- IMPACT_postprocess_annotations(ANNOT_MELT)
#' }
IMPACT_postprocess_annotations <- function(ANNOT_MELT,
                                           order_loci = TRUE,
                                           no_no_loci = NULL) {

    Locus <- meanIMPACT <- IMPACT_score <- topConsensus <- NULL;
    CellDeriv <- Cell <- NULL;

    sort_loci_by_topConsensus_impact <- function(ANNOT_MELT) {
        locus_sort <- ANNOT_MELT |>
            dplyr::group_by(Locus, .drop = FALSE) |>
            dplyr::summarise(
                meanIMPACT = mean(IMPACT_score[topConsensus],
                                  na.rm = TRUE)) |>
            dplyr::arrange(meanIMPACT) |>
            dplyr::mutate(Locus = factor(Locus, ordered = TRUE))
        locus_sort[is.na(locus_sort$meanIMPACT), "meanIMPACT"] <- 0
        ANNOT_MELT$Locus <- factor(ANNOT_MELT$Locus,
                                   levels = locus_sort$Locus,
                                   ordered = TRUE)
        ANNOT_MELT <- ANNOT_MELT |>
            dplyr::mutate(
                Cell_Type = paste0(
                    ifelse(CellDeriv == "mesendoderm",
                           "hESC derived mesendodermal cells",
                           CellDeriv),
                    ifelse(Cell %in% c("hESC derived mesendodermal cells",
                                       "."),
                           "",
                           paste0(" (", Cell, ")"))))
        return(ANNOT_MELT)
    }

    # Fill NA IMPACT_score (<.1) with 0
    ANNOT_MELT <- echodata::find_top_consensus(ANNOT_MELT)

    if (order_loci) {
        ANNOT_MELT <- sort_loci_by_topConsensus_impact(ANNOT_MELT)
    }
    if (!is.null(no_no_loci)) {
        ANNOT_MELT <- subset(ANNOT_MELT, !Locus %in% no_no_loci)
    }

    ANNOT_MELT$uniqueID <- seq_len(nrow(ANNOT_MELT))
    return(ANNOT_MELT)
}


#' Get the top annotation(s)
#'
#' Get the annotation(s) with the top mean \emph{IMPACT} for a given set
#' of SNPs.
#'
#' @param ANNOT_MELT A melted \code{data.table} of IMPACT annotations.
#' @param snp.filter An expression (as character) used to filter SNPs
#'   when computing summary statistics.
#' @param top_annotations Number of top annotations to keep per locus,
#'   or \code{FALSE} to keep all.
#' @param force_one_annot_per_locus Whether to force exactly one annotation
#'   per locus.
#'
#' @return A \code{data.table} with top annotations per locus.
#'
#' @export
#' @family IMPACT
#' @importFrom dplyr group_by summarise top_n arrange slice
#' @importFrom stats median
#' @examples
#' \dontrun{
#' top_impact <- IMPACT_get_top_annotations(ANNOT_MELT = ANNOT_MELT)
#' }
IMPACT_get_top_annotations <- function(
        ANNOT_MELT,
        snp.filter = "!is.na(IMPACT_score)",
        top_annotations = 1,
        force_one_annot_per_locus = FALSE) {

    Locus <- Tissue <- CellDeriv <- Cell <- TF <- SNP <- NULL;
    IMPACT_score <- mean_IMPACT <- max_IMPACT <- median_IMPACT <- NULL;

    top_impact <- ANNOT_MELT |>
        # Group all SNPs within the snp group (snp filter)
        dplyr::group_by(Locus, Tissue, CellDeriv, Cell, TF,
                         .drop = FALSE) |>
        dplyr::summarise(
            SNPs = dplyr::n_distinct(
                SNP[eval(parse(text = snp.filter))], na.rm = TRUE),
            mean_IMPACT = mean(
                IMPACT_score[eval(parse(text = snp.filter))], na.rm = TRUE),
            max_IMPACT = max(
                IMPACT_score[eval(parse(text = snp.filter))], na.rm = TRUE),
            median_IMPACT = stats::median(
                IMPACT_score[eval(parse(text = snp.filter))], na.rm = TRUE))

    if (any(is.infinite(top_impact$max_IMPACT))) {
        # Max function produces -Inf values when there's only NA values
        top_impact[is.infinite(top_impact$max_IMPACT), "max_IMPACT"] <- NA
    }

    # Get the annotation with the top mean/max/mode
    if (!isFALSE(top_annotations)) {
        top_impact <- top_impact |>
            dplyr::group_by(Locus) |>
            dplyr::top_n(n = top_annotations, wt = max_IMPACT)
    }
    # Sometimes top_n gives multiple rows/group when they have the same value.
    # Use slice to ensure only one row/group.
    if (force_one_annot_per_locus) {
        top_impact <- top_impact |>
            dplyr::group_by(Locus) |>
            dplyr::arrange(-mean_IMPACT, -max_IMPACT, -median_IMPACT) |>
            dplyr::slice(1)
    }
    top_impact$snp.filter <- snp.filter
    return(top_impact)
}
