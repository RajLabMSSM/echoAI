#' Query genome-wide \emph{SpliceAI} results (VCF format)
#'
#' Subset a genome-wide pre-computed \emph{SpliceAI} VCF file using
#' \code{bcftools} for the region covered by the supplied data.
#'
#' @param dat A \code{data.table} with at least columns \code{CHR}
#'   (chromosome) and \code{POS} (base-pair position).
#' @param precomputed_path Path to the bgzipped and tabix-indexed
#'   pre-computed SpliceAI VCF file.
#' @param subset_vcf Path to write the subset VCF output.
#'
#' @returns The exit code from the \code{bcftools} system call
#'   (invisibly).
#'
#' @export
#' @family SPLICEAI
#' @source
#' \url{https://github.com/Illumina/SpliceAI}
#' \doi{10.1016/j.cell.2018.12.015}
#' @examples
#' \dontrun{
#' dat <- data.table::data.table(CHR = 1, POS = 100000:100500)
#' SPLICEAI_query_vcf(
#'     dat = dat,
#'     precomputed_path = "spliceai_scores.vcf.gz",
#'     subset_vcf = "subset.vcf"
#' )
#' }
SPLICEAI_query_vcf <- function(dat,
                               precomputed_path,
                               subset_vcf = "subset.vcf") {

    CHR <- POS <- NULL;

    chrom <- gsub("chr", "", dat$CHR[1])
    min_POS <- min(dat$POS)
    max_POS <- max(dat$POS)

    cmd <- paste(
        "bcftools query", precomputed_path,
        "-i",
        paste0("'CHROM=\"", chrom,
               "\" & (POS>=", min_POS,
               " & POS<=", max_POS, ")'"),
        "-f '%CHROM\\t%POS\\t%ID\\t%REF\\t%ALT\\t%QUAL\\t%FILTER\\t%INFO\\n'",
        "-H",
        ">", subset_vcf
    )
    messager(cmd)
    res <- system(cmd)
    invisible(res)
}


#' Query genome-wide \emph{SpliceAI} results (TSV format)
#'
#' Subset a genome-wide pre-computed \emph{SpliceAI} TSV file for the
#' region covered by the supplied data, using tabix.
#'
#' @param dat A \code{data.table} with at least columns \code{CHR}
#'   (chromosome) and \code{POS} (base-pair position).
#' @param precomputed_path Path to the bgzipped and tabix-indexed
#'   pre-computed SpliceAI TSV file.
#' @param merge_data Whether to merge the SpliceAI results back onto
#'   \code{dat}. If \code{FALSE}, returns the raw query result.
#' @param drop_na If \code{TRUE}, only keeps rows that match between
#'   \code{dat} and the SpliceAI results.
#' @param filtered Whether the pre-computed file is in the filtered
#'   format (with extra columns such as ID, QUAL, FILTER, STRAND, TYPE).
#'
#' @returns A \code{data.table} of SpliceAI scores, optionally merged
#'   with \code{dat}.
#'
#' @export
#' @family SPLICEAI
#' @importFrom data.table fread
#' @source
#' \url{https://github.com/Illumina/SpliceAI}
#' \doi{10.1016/j.cell.2018.12.015}
#' @examples
#' \dontrun{
#' dat <- data.table::fread("my_sumstats.tsv.gz")
#' spliceai_dat <- SPLICEAI_query_tsv(
#'     dat = dat,
#'     precomputed_path = "spliceai_scores.tsv.gz"
#' )
#' }
SPLICEAI_query_tsv <- function(dat,
                               precomputed_path,
                               merge_data = TRUE,
                               drop_na = TRUE,
                               filtered = TRUE) {

    CHR <- POS <- ID <- QUAL <- FILTER <- NULL;

    ## TODO: Migrate to echotabix::query() once query_granges API is
    ##   finalised. The old TABIX.query(fullSS.gz, chrom, start_pos,
    ##   end_pos) call is replaced here with a direct tabix system call
    ##   piped into data.table::fread().
    chrom <- dat$CHR[1]
    start_pos <- min(dat$POS)
    end_pos <- max(dat$POS)
    tabix_cmd <- paste0("tabix ", precomputed_path, " ",
                        chrom, ":", start_pos, "-", end_pos)
    spliceai_dat <- data.table::fread(cmd = tabix_cmd, header = FALSE)

    if (filtered) {
        colnames(spliceai_dat) <- c(
            "CHROM", "POS", "ID", "REF", "ALT", "QUAL", "FILTER",
            "SYMBOL", "STRAND", "TYPE", "DIST",
            "DS_AG", "DS_AL", "DS_DG", "DS_DL",
            "DP_AG", "DP_AL", "DP_DG", "DP_DL"
        )
        spliceai_dat <- subset(spliceai_dat,
                               select = -c(ID, QUAL, FILTER))
        by.x <- c("CHR", "POS")
        by.y <- c("CHROM", "POS")
    } else {
        colnames(spliceai_dat) <- c(
            "CHROM", "POS", "REF", "ALT", "MUT", "SYMBOL",
            "DS_AG", "DS_AL", "DS_DG", "DS_DL",
            "DP_AG", "DP_AL", "DP_DG", "DP_DL"
        )
        by.x <- c("CHR", "POS")
        by.y <- c("CHROM", "POS")
    }

    if (merge_data) {
        dat_merged <- data.table::merge.data.table(
            x = dat,
            y = spliceai_dat,
            by.x = by.x,
            by.y = by.y,
            all.x = !drop_na
        )
        return(dat_merged)
    } else {
        return(spliceai_dat)
    }
}


#' Iterate \emph{SpliceAI} TSV queries across multiple loci
#'
#' Make multiple queries to a genome-wide pre-computed \emph{SpliceAI}
#' results file (TSV format), one per summary-statistics file.
#' Results are optionally merged and saved.
#'
#' @param sumstats_paths Character vector of paths to per-locus
#'   summary-statistics files (TSV / TSV.GZ).
#' @param precomputed_path Path to the bgzipped and tabix-indexed
#'   pre-computed SpliceAI TSV file.
#' @param nThread Number of threads for \code{\link[parallel]{mclapply}}
#'   and \code{\link[data.table]{fwrite}}.
#' @param merge_data Passed to \code{\link{SPLICEAI_query_tsv}}.
#' @param drop_na Passed to \code{\link{SPLICEAI_query_tsv}}.
#' @param filtered Passed to \code{\link{SPLICEAI_query_tsv}}.
#' @param save_path Path to save the combined results, or \code{FALSE}
#'   to skip saving.
#'
#' @returns A \code{data.table} of combined SpliceAI results across
#'   all loci.
#'
#' @export
#' @family SPLICEAI
#' @importFrom data.table fread rbindlist fwrite
#' @importFrom parallel mclapply
#' @source
#' \url{https://github.com/Illumina/SpliceAI}
#' \doi{10.1016/j.cell.2018.12.015}
#' @examples
#' \dontrun{
#' sumstats_paths <- list.files(
#'     "path/to/sumstats",
#'     pattern = "*.tsv.gz",
#'     recursive = TRUE, full.names = TRUE
#' )
#' DAT <- SPLICEAI_query_tsv_iterate(
#'     sumstats_paths = sumstats_paths,
#'     precomputed_path = "spliceai_scores.tsv.gz"
#' )
#' }
SPLICEAI_query_tsv_iterate <- function(
        sumstats_paths,
        precomputed_path,
        nThread = 1,
        merge_data = TRUE,
        drop_na = TRUE,
        filtered = FALSE,
        save_path = "./spliceAI_subset.tsv.gz") {

    Locus <- NULL;

    DAT <- parallel::mclapply(sumstats_paths, function(x) {
        dat <- data.table::fread(x)
        dat_merged <- SPLICEAI_query_tsv(
            dat,
            precomputed_path = precomputed_path,
            merge_data = merge_data,
            drop_na = drop_na,
            filtered = filtered
        )
        if (!"Locus" %in% colnames(dat_merged)) {
            locus <- basename(dirname(dirname(x)))
            messager("Adding Locus column:", locus)
            dat_merged <- cbind(Locus = locus, dat_merged)
        }
        return(dat_merged)
    }, mc.cores = nThread) |>
        data.table::rbindlist(fill = TRUE)

    if (!isFALSE(save_path)) {
        messager("Saving SpliceAI subset ==>", save_path)
        dir.create(dirname(save_path),
                   showWarnings = FALSE, recursive = TRUE)
        data.table::fwrite(DAT, save_path,
                           nThread = nThread, sep = "\t")
    }
    return(DAT)
}
