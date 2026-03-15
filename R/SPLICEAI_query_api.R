#' Query SpliceAI Lookup API
#'
#' Query the public
#' \href{https://spliceailookup.broadinstitute.org/}{SpliceAI Lookup}
#' web API hosted by the Broad Institute. This service runs the SpliceAI
#' model on-the-fly for individual variants without requiring local
#' installation or precomputed files.
#'
#' @param variants Character vector of variants in
#'   \code{"chrom-pos-ref-alt"} format (e.g. \code{"2-179415988-C-CA"}).
#' @param genome Genome build: \code{"37"} (GRCh37/hg19) or
#'   \code{"38"} (GRCh38/hg38).
#' @param distance Maximum distance between the variant and gained/lost
#'   splice site (default 50, max 10000).
#' @param mask Mask scores for annotated splice sites
#'   (0 = raw, 1 = masked). Default 0.
#' @param verbose Print messages.
#'
#' @returns A \code{data.table} with one row per variant, containing
#'   columns for \code{variant}, \code{gene}, \code{DS_AG}, \code{DS_AL},
#'   \code{DS_DG}, \code{DS_DL} (delta scores), and corresponding
#'   \code{DP_*} (delta positions). Returns \code{NULL} for variants
#'   with no scores.
#'
#' @details
#' \strong{Rate limit:} The public API supports only a handful of
#' queries per user per minute. For batch processing, use
#' \code{\link{SPLICEAI_query_tsv}} with local precomputed files or
#' set up a local instance via
#' \url{https://github.com/broadinstitute/SpliceAI-lookup}.
#'
#' @export
#' @family SPLICEAI
#' @source
#' \url{https://spliceailookup.broadinstitute.org/}
#' \doi{10.1016/j.cell.2018.12.015}
#' @importFrom data.table data.table rbindlist
#' @examples
#' \dontrun{
#' result <- SPLICEAI_query_api(
#'     variants = "2-179415988-C-CA",
#'     genome = "37"
#' )
#' }
SPLICEAI_query_api <- function(variants,
                               genome = c("37", "38"),
                               distance = 50,
                               mask = 0,
                               verbose = TRUE) {

    genome <- match.arg(genome)
    base_url <- paste0("https://spliceai-", genome,
                       "-xwkwwwxdwq-uc.a.run.app/spliceai/")

    results <- lapply(variants, function(v) {
        messager("SPLICEAI:: Querying API for:", v, v = verbose)
        url <- paste0(base_url,
                      "?hg=", genome,
                      "&distance=", distance,
                      "&mask=", mask,
                      "&variant=", v)
        tryCatch({
            resp <- readLines(url(url), warn = FALSE)
            json <- jsonlite::fromJSON(resp, flatten = TRUE)
            if (!is.null(json$error)) {
                messager("SPLICEAI:: No scores for", v, ":", json$error,
                         v = verbose)
                return(NULL)
            }
            scores <- json$scores
            if (is.null(scores) || length(scores) == 0) return(NULL)
            dt <- data.table::data.table(
                variant = v,
                gene = scores$g_name,
                transcript = scores$t_id,
                DS_AG = as.numeric(scores$DS_AG),
                DS_AL = as.numeric(scores$DS_AL),
                DS_DG = as.numeric(scores$DS_DG),
                DS_DL = as.numeric(scores$DS_DL),
                DP_AG = as.integer(scores$DP_AG),
                DP_AL = as.integer(scores$DP_AL),
                DP_DG = as.integer(scores$DP_DG),
                DP_DL = as.integer(scores$DP_DL)
            )
            return(dt)
        }, error = function(e) {
            messager("SPLICEAI:: API error for", v, ":",
                     conditionMessage(e), v = verbose)
            return(NULL)
        })
    })
    results <- Filter(Negate(is.null), results)
    if (length(results) == 0) return(NULL)
    data.table::rbindlist(results, fill = TRUE)
}
