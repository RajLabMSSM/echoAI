#' Download \emph{IMPACT} annotations
#'
#' Includes the raw annotation itself,
#' as well as per-SNP \emph{IMPACT} scores for each annotation.
#'
#' Unfortunately, you have to download the entire chromosome file at once,
#'  because they aren't Tabix indexed. To minimize the memory load,
#'  this function only keeps the portion of the \emph{IMPACT} file that
#'  overlaps with the coordinates in \code{dat}.
#'
#' @param baseURL Base URL for IMPACT annotation files.
#' @param chrom Chromosome number.
#' @param dat A \code{data.table} with at least columns CHR, SNP, POS.
#' @param nThread Number of threads for \code{data.table::fread}.
#' @param all_snps_in_range Whether to include all SNPs in the range
#'   (not just those in \code{dat}).
#' @param verbose Print messages.
#'
#' @return A melted \code{data.table} of IMPACT annotations
#'   merged with annotation metadata.
#'
#' @export
#' @family IMPACT
#' @importFrom data.table fread merge.data.table data.table melt.data.table
#' @examples
#' \dontrun{
#' BST1 <- echodata::BST1
#' annot_melt <- IMPACT_get_annotations(dat = BST1)
#' }
IMPACT_get_annotations <- function(
        baseURL = paste0("https://github.com/immunogenomics/IMPACT/",
                         "raw/master/IMPACT707/Annotations"),
        chrom = NULL,
        dat = NULL,
        nThread = 1,
        all_snps_in_range = FALSE,
        verbose = TRUE) {

    Annot <- IMPACT_score <- POS <- NULL;

    if (!is.null(dat)) {
        dat$CHR <- as.integer(gsub("chr", "", dat$CHR))
        chrom <- dat$CHR[1]
    }
    URL <- file.path(baseURL,
                     paste0("IMPACT707_EAS_chr", chrom, ".annot.gz"))
    messager("IMPACT:: Importing", URL, v = verbose)
    annot <- data.table::fread(URL, nThread = nThread)

    if (!is.null(dat)) {
        annot_merge <- data.table::merge.data.table(
            data.table::data.table(dat),
            annot,
            by.x = c("SNP", "CHR", "POS"),
            by.y = c("SNP", "CHR", "BP"),
            all.x = TRUE,
            all.y = all_snps_in_range)
    } else {
        annot_merge <- annot
    }
    annot_merge <- subset(annot_merge,
                          POS >= min(dat$POS) & POS <= max(dat$POS))
    # Merge with metadata
    annot_key <- IMPACT_get_annotation_key()
    annot_cols <- grep("^Annot*", colnames(annot_merge), value = TRUE)
    annot_melt <- data.table::melt.data.table(
        annot_merge,
        measure.vars = annot_cols,
        variable.name = "Annot",
        value.name = "IMPACT_score",
        na.rm = FALSE)
    annot_melt <- data.table::merge.data.table(
        annot_melt, annot_key,
        by = "Annot",
        all = TRUE,
        allow.cartesian = TRUE)
    return(annot_melt)
}


#' Gather all \emph{IMPACT} annotations that overlap with your query
#'
#' Iterates over each unique locus.
#' \bold{\emph{WARNING!}} These files are quite large and you need to make sure
#' you have ample memory and storage on your computer for best results.
#'
#' @param merged_DT A merged \code{data.table} containing fine-mapping results
#'   across multiple loci with at least columns CHR and Locus.
#' @param IMPACT_score_thresh Minimum IMPACT score threshold for filtering.
#' @param baseURL Base URL for IMPACT annotation files.
#' @param all_snps_in_range Whether to include all SNPs in range.
#' @param top_annotations Number of top annotations to keep,
#'   or \code{FALSE} to keep all.
#' @param force_one_annot_per_locus Whether to force one annotation per locus.
#' @param snp.filter An expression (as character) used to filter SNPs
#'   for top annotation selection.
#' @param nThread Number of threads for data.table operations.
#' @param verbose Print messages.
#'
#' @return A \code{data.table} of IMPACT annotations across all chromosomes.
#'
#' @export
#' @family IMPACT
#' @importFrom data.table rbindlist
#' @examples
#' \dontrun{
#' data("merged_DT")
#' ANNOT_MELT <- IMPACT_iterate_get_annotations(merged_DT = merged_DT)
#' }
IMPACT_iterate_get_annotations <- function(
        merged_DT,
        IMPACT_score_thresh = 0.1,
        baseURL = paste0("https://github.com/immunogenomics/IMPACT/",
                         "raw/master/IMPACT707/Annotations"),
        all_snps_in_range = TRUE,
        top_annotations = FALSE,
        force_one_annot_per_locus = FALSE,
        snp.filter = "!is.na(SNP)",
        nThread = 1,
        verbose = TRUE) {

    CHR <- Tissue <- CellDeriv <- Cell <- TF <- IMPACT_score <- NULL;

    ANNOT_MELT <- lapply(
        sort(unique(merged_DT$CHR)),
        function(chrom, .merged_DT = merged_DT) {
            messager("+ IMPACT:: Gathering annotations for chrom =",
                     chrom, v = verbose)
            tryCatch({
                dat <- subset(.merged_DT, CHR == chrom)
                annot_melt <- IMPACT_get_annotations(
                    baseURL = baseURL,
                    dat = dat,
                    all_snps_in_range = all_snps_in_range,
                    nThread = nThread,
                    verbose = verbose)
                if (!isFALSE(top_annotations)) {
                    top_impact <- IMPACT_get_top_annotations(
                        ANNOT_MELT = annot_melt,
                        snp.filter = snp.filter,
                        top_annotations = top_annotations,
                        force_one_annot_per_locus = force_one_annot_per_locus)
                    annot_melt <- subset(
                        annot_melt,
                        Tissue %in% top_impact$Tissue &
                            CellDeriv %in% top_impact$CellDeriv &
                            Cell %in% top_impact$Cell &
                            TF %in% top_impact$TF)
                }
                annot_melt <- subset(annot_melt,
                                     IMPACT_score >= IMPACT_score_thresh)
                messager("+ IMPACT::", nrow(annot_melt),
                         "annotations found at IMPACT_score >=",
                         IMPACT_score_thresh, v = verbose)
                return(annot_melt)
            }, error = function(e) {
                messager("+ IMPACT:: Error for chrom", chrom, ":",
                         conditionMessage(e), v = verbose)
                return(NULL)
            })
        })
    ANNOT_MELT <- Filter(Negate(is.null), ANNOT_MELT)
    ANNOT_MELT <- data.table::rbindlist(ANNOT_MELT, fill = TRUE)
    return(ANNOT_MELT)
}
