#' Download LD scores from IMPACT publication
#'
#' Downloads per-SNP LD scores from LD Score regression,
#' first conducted in the original IMPACT publication.
#'
#' @param chrom Chromosome number.
#' @param dat A \code{data.table} with at least columns CHR, SNP, POS.
#'   If provided, \code{chrom} is extracted from the first row.
#' @param nThread Number of threads for \code{data.table::fread}.
#'
#' @return A \code{data.table} of LD scores, optionally merged with
#'   \code{dat}.
#'
#' @source
#' T Amariuta et al., IMPACT: Genomic Annotation of Cell-State-Specific
#' Regulatory Elements Inferred from the Epigenome of Bound Transcription
#' Factors. The American Journal of Human Genetics, 1-17 (2019).
#'
#' @export
#' @family IMPACT
#' @importFrom data.table fread data.table
#' @examples
#' \dontrun{
#' BST1 <- echodata::BST1
#' ldscore <- IMPACT_get_ldscores(dat = BST1)
#' }
IMPACT_get_ldscores <- function(chrom = NULL,
                                dat = NULL,
                                nThread = 1) {
    warning("LD scores do not include any SNPs with MAF < 0.5%, ",
            "as they are restricted to HapMap3 SNPs. ",
            "This may affect subsequent analyses (e.g. fine-mapping).")
    if (!is.null(dat)) {
        chrom <- dat$CHR[1]
    }
    baseURL <- paste0("https://github.com/immunogenomics/IMPACT/",
                      "raw/master/IMPACT707/LDscores")
    URL <- file.path(baseURL,
                     paste0("IMPACT707_EAS_chr", chrom, ".l2.ldscore.gz"))
    ldscore <- data.table::fread(URL, nThread = nThread)

    if (!is.null(dat)) {
        ldscore_merge <- data.table::merge.data.table(
            data.table::data.table(dat),
            ldscore,
            by.x = c("SNP", "CHR", "POS"),
            by.y = c("SNP", "CHR", "BP"),
            all = FALSE)
        return(ldscore_merge)
    } else {
        return(ldscore)
    }
}
