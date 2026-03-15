#' Postprocess \emph{SpliceAI} results
#'
#' Compute per-SNP maximum splice-alteration probabilities from
#' pre-queried \emph{SpliceAI} scores, match risk alleles to the
#' SpliceAI ALT allele, and filter to lead SNPs above a probability
#' threshold.
#'
#' @param DAT A \code{data.table} of SpliceAI results merged with
#'   summary statistics. Must contain at minimum the columns:
#'   \code{DS_AG}, \code{DS_AL}, \code{DS_DG}, \code{DS_DL},
#'   \code{A1}, \code{A2}, \code{REF}, \code{ALT}, \code{Locus},
#'   \code{SNP}, \code{CHR}, \code{POS}, \code{Effect}, \code{P},
#'   \code{leadSNP}, \code{Consensus_SNP}, \code{Support},
#'   \code{mean.PP}, and \code{SYMBOL}.
#' @param save_path Path to save the filtered results, or \code{FALSE}
#'   to skip saving.
#'
#' @returns A \code{data.table} of allele-matched, filtered SpliceAI
#'   hits with added columns \code{max_spliceAI_group},
#'   \code{max_spliceAI_prob}, and \code{GWAS.sig}.
#'
#' @export
#' @family SPLICEAI
#' @importFrom dplyr rename mutate
#' @importFrom data.table fwrite
#' @source
#' \url{https://github.com/Illumina/SpliceAI}
#' \doi{10.1016/j.cell.2018.12.015}
#' @examples
#' \dontrun{
#' DAT <- data.table::fread("spliceAI_merged.tsv.gz")
#' matchDAT <- SPLICEAI_snp_probs(DAT)
#' }
SPLICEAI_snp_probs <- function(DAT,
                               save_path = FALSE) {

    DS_AG <- DS_AL <- DS_DG <- DS_DL <- NULL;
    Locus <- SNP <- A1 <- A2 <- Effect <- P <- NULL;
    leadSNP <- Consensus_SNP <- Support <- mean.PP <- NULL;
    SYMBOL <- max_spliceAI_prob <- max_spliceAI_group <- NULL;
    REF <- ALT <- Risk_allele <- ALT.spliceAI <- NULL;

    DF <- DAT[, c("DS_AG", "DS_AL", "DS_DG", "DS_DL")]
    DAT$max_spliceAI_group <- colnames(DF)[max.col(DF,
                                                   ties.method = "first")]
    DAT$max_spliceAI_prob <- apply(DF, 1, max)

    matchDAT <- DAT |>
        dplyr::rename(
            Risk_allele = A1,
            Nonrisk_allele = A2,
            REF.spliceAI = REF,
            ALT.spliceAI = ALT
        ) |>
        subset(
            Risk_allele == ALT.spliceAI,
            select = c(
                "Locus", "SNP", "CHR", "POS", "Effect", "P",
                "leadSNP", "Consensus_SNP", "Support", "mean.PP",
                "Risk_allele", "Nonrisk_allele",
                "SYMBOL", "REF.spliceAI", "ALT.spliceAI",
                "DS_AG", "DS_AL", "DS_DG", "DS_DL",
                "max_spliceAI_group", "max_spliceAI_prob"
            )
        ) |>
        dplyr::mutate(GWAS.sig = P < 5e-8) |>
        subset(max_spliceAI_prob > .1 & leadSNP)

    if (!isFALSE(save_path)) {
        dir.create(dirname(save_path),
                   showWarnings = FALSE, recursive = TRUE)
        data.table::fwrite(matchDAT, save_path, sep = "\t")
    }
    return(matchDAT)
}
