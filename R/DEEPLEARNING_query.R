#' Query deep learning annotations and LD scores (single chromosome)
#'
#' Query deep learning annotations and LD scores for a single chromosome,
#' then merge with \code{dat} by \emph{SNP}.
#'
#' @param dat A \code{data.frame} or \code{data.table} containing at least
#'   columns \code{CHR} and \code{SNP}.
#' @param base_url Base directory path containing the Dey DeepLearning
#'   annotation files. Must be provided explicitly.
#' @param level Annotation level:
#'   \code{"Variant_Level"} or \code{"Allelic_Effect"}.
#' @param tissue Tissue type:
#'   \code{"NTS"}, \code{"Blood"}, or \code{"Brain"}.
#' @param model Deep learning model:
#'   \code{"Basenji"}, \code{"BiClassCNN"}, \code{"DeepSEA"},
#'   \code{"ChromHMM"}, \code{"Roadmap"}, or \code{"Others"}.
#' @param mean_max Aggregation metric: \code{"MEAN"} or \code{"MAX"}.
#' @param type File type: \code{"annot"} or \code{"ldscore"}.
#' @param nThread Number of threads for \code{data.table::fread}.
#' @param verbose Print messages.
#'
#' @returns A \code{data.table} with the original columns plus one new column
#'   per matching annotation file, named
#'   \code{<model>_<tissue>_<assay>_<type>_<mean_max>}.
#'
#' @export
#' @family DEEPLEARNING
#' @source
#' \url{https://console.cloud.google.com/storage/browser/broad-alkesgroup-public-requester-pays}
#' Original URL (now offline):
#' \code{https://alkesgroup.broadinstitute.org/LDSCORE/DeepLearning/Dey_DeepLearning.tgz}
#' @importFrom data.table fread merge.data.table data.table
#' @importFrom dplyr rename
#' @examples
#' \dontrun{
#' BST1 <- echodata::BST1
#' annot_dat <- DEEPLEARNING_query_one_chr(
#'     dat = BST1,
#'     base_url = "/path/to/Dey_DeepLearning",
#'     tissue = "NTS",
#'     model = "Basenji",
#'     type = "annot"
#' )
#' }
DEEPLEARNING_query_one_chr <- function(
        dat,
        base_url = NULL,
        level = c("Variant_Level", "Allelic_Effect"),
        tissue = c("NTS", "Blood", "Brain"),
        model = c("Basenji", "BiClassCNN", "DeepSEA",
                   "ChromHMM", "Roadmap", "Others"),
        mean_max = c("MEAN", "MAX"),
        type = c("annot", "ldscore"),
        nThread = 1,
        verbose = TRUE) {

    AN <- L2 <- SNP <- NULL

    if (is.null(base_url)) {
        stop("base_url must be provided. ",
             "Supply the path to the Dey DeepLearning annotation directory.")
    }

    level <- level[1]
    tissue <- tissue[1]
    model <- model[1]
    mean_max <- mean_max[1]
    type <- type[1]

    if (level == "Allelic_Effect") {
        messager(
            "DEEPLEARNING:: Only the following models are available",
            "when level='Allelic_Effect': Basenji and DeepSEA",
            v = verbose
        )
        model <- model[model %in% c("Basenji", "DeepSEA")]
    }
    dat$CHR <- gsub("chr", "", dat$CHR)
    chrom <- dat$CHR[1]

    messager("DEEPLEARNING:: Searching", base_url,
             "for matching files", v = verbose)
    ## Naming and file formats are inconsistent across folders,
    ## so you have to do a mix of file searching and filtering
    search_dir <- file.path(base_url, level, tissue, model)
    search_files <- list.files(
        search_dir,
        paste("*", chrom, paste0(type, ".gz"), sep = "\\."),
        recursive = TRUE, full.names = TRUE
    )
    ## Filter mean/max
    mean_max_pattern <- if (mean_max == "MEAN") {
        paste(c("MEAN", "AVG"), collapse = "|")
    } else {
        mean_max
    }
    search_files <- search_files[
        grepl(mean_max_pattern, toupper(basename(search_files)))
    ]

    if (length(search_files) == 0) {
        stop("DEEPLEARNING:: No files meeting criterion were found.")
    }
    messager("DEEPLEARNING:: Importing file <<=", search_files, v = verbose)
    annot_dat <- data.frame(dat)
    for (x in search_files) {
        ## Get assay -- assign here because different tissue-model
        ## combinations have somewhat different assays
        assay <- toupper(strsplit(basename(x), "_")[[1]][1])
        new_col_name <- paste(model, tissue, assay, type, mean_max, sep = "_")
        annot <- data.table::fread(x, nThread = 1)
        if ("L2" %in% colnames(annot)) {
            annot <- dplyr::rename(annot, AN = L2)
        }
        merged <- data.table::merge.data.table(
            dat,
            subset(annot, select = -c(SNP, AN)),
            all.x = TRUE,
            by = "SNP"
        ) |> data.frame()
        annot_dat[new_col_name] <- merged$AN
    }
    return(data.table::data.table(annot_dat))
}


#' Query deep learning annotations and LD scores (multiple chromosomes)
#'
#' Iterates \code{\link{DEEPLEARNING_query_one_chr}} across all unique
#' chromosomes in \code{merged_dat} and row-binds the results.
#'
#' @param merged_dat A \code{data.frame} or \code{data.table} containing at
#'   least columns \code{CHR} and \code{SNP}.
#' @inheritParams DEEPLEARNING_query_one_chr
#'
#' @returns A \code{data.table} combining per-chromosome query results.
#'
#' @export
#' @family DEEPLEARNING
#' @source
#' \url{https://console.cloud.google.com/storage/browser/broad-alkesgroup-public-requester-pays}
#' Original URL (now offline):
#' \code{https://alkesgroup.broadinstitute.org/LDSCORE/DeepLearning/Dey_DeepLearning.tgz}
#' @importFrom parallel mclapply
#' @importFrom data.table rbindlist
#' @examples
#' \dontrun{
#' data("merged_DT")
#' ANNOT_DAT <- DEEPLEARNING_query_multi_chr(
#'     merged_dat = merged_DT,
#'     base_url = "/path/to/Dey_DeepLearning",
#'     tissue = "NTS",
#'     model = "Basenji",
#'     type = "annot"
#' )
#' }
DEEPLEARNING_query_multi_chr <- function(
        merged_dat,
        base_url = NULL,
        level = c("Variant_Level", "Allelic_Effect"),
        tissue = c("NTS", "Blood", "Brain"),
        model = c("Basenji", "BiClassCNN", "DeepSEA",
                   "ChromHMM", "Roadmap", "Others"),
        mean_max = c("MEAN", "MAX"),
        type = c("annot", "ldscore"),
        nThread = 1,
        verbose = TRUE) {

    CHR <- NULL

    if (is.null(base_url)) {
        stop("base_url must be provided. ",
             "Supply the path to the Dey DeepLearning annotation directory.")
    }

    ANNOT_DAT <- parallel::mclapply(
        unique(merged_dat$CHR),
        function(chrom) {
            messager("Chromosome:", chrom, v = verbose)
            DEEPLEARNING_query_one_chr(
                dat = subset(merged_dat, CHR == chrom),
                base_url = base_url,
                level = level,
                tissue = tissue,
                model = model,
                mean_max = mean_max,
                type = type,
                nThread = 1,
                verbose = verbose
            )
        },
        mc.cores = nThread
    ) |> data.table::rbindlist()
    return(ANNOT_DAT)
}


#' Iteratively collect deep learning annotations
#'
#' Queries deep learning annotations across all combinations of
#' \code{level}, \code{tissue}, \code{model}, \code{mean_max}, and
#' \code{type}, then column-binds the annotation columns onto
#' \code{merged_dat}.
#'
#' @param merged_dat A \code{data.frame} or \code{data.table} containing at
#'   least columns \code{CHR} and \code{SNP}.
#' @inheritParams DEEPLEARNING_query_one_chr
#'
#' @returns A \code{data.table} with \code{merged_dat} columns plus all
#'   collected annotation columns.
#'
#' @export
#' @family DEEPLEARNING
#' @source
#' \url{https://console.cloud.google.com/storage/browser/broad-alkesgroup-public-requester-pays}
#' Original URL (now offline):
#' \code{https://alkesgroup.broadinstitute.org/LDSCORE/DeepLearning/Dey_DeepLearning.tgz}
#' @importFrom dplyr select any_of
#' @examples
#' \dontrun{
#' merged_dat <- echodata::find_consensus_snps_no_polyfun(merged_dat)
#'
#' ## Allelic_Effect
#' ANNOT_ae <- DEEPLEARNING_query(
#'     merged_dat = merged_dat,
#'     base_url = "/path/to/Dey_DeepLearning",
#'     level = "Allelic_Effect",
#'     type = "annot"
#' )
#'
#' ## Variant_Level
#' ANNOT_vl <- DEEPLEARNING_query(
#'     merged_dat = merged_dat,
#'     base_url = "/path/to/Dey_DeepLearning",
#'     level = "Variant_Level",
#'     type = "annot"
#' )
#' }
DEEPLEARNING_query <- function(
        merged_dat,
        base_url = NULL,
        level = c("Variant_Level", "Allelic_Effect"),
        tissue = c("NTS", "Blood", "Brain"),
        model = c("Basenji", "BiClassCNN", "DeepSEA",
                   "ChromHMM", "Roadmap", "Others"),
        mean_max = c("MEAN", "MAX"),
        type = c("annot", "ldscore"),
        nThread = 1,
        verbose = TRUE) {

    BP <- CM <- NULL

    if (is.null(base_url)) {
        stop("base_url must be provided. ",
             "Supply the path to the Dey DeepLearning annotation directory.")
    }

    ## Get every combination of each argument
    param_combs <- expand.grid(
        level = level,
        tissue = tissue,
        model = model,
        mean_max = mean_max,
        type = type
    )

    col_list <- lapply(seq_len(nrow(param_combs)), function(i) {
        messager("\nParameter combination:", i, v = verbose)
        messager(
            paste(colnames(param_combs),
                  param_combs[i, ],
                  sep = "=", collapse = ", "),
            v = verbose
        )
        annot_cols <- NULL
        try({
            annot <- DEEPLEARNING_query_multi_chr(
                merged_dat = merged_dat,
                base_url = base_url,
                level = param_combs[i, "level"],
                tissue = param_combs[i, "tissue"],
                model = param_combs[i, "model"],
                mean_max = param_combs[i, "mean_max"],
                type = param_combs[i, "type"],
                nThread = 1,
                verbose = verbose
            )
            annot_cols <- dplyr::select(
                annot,
                !dplyr::any_of(c("BP", "CM", colnames(merged_dat)))
            )
        })
        return(annot_cols)
    })
    ANNOT <- cbind(merged_dat, do.call("cbind", col_list))
    return(ANNOT)
}
