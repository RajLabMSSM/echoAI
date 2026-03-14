#' Get \emph{IMPACT} annotation key
#'
#' Includes the study source, tissue, cell type/line,
#' and cell subtype of each of the 500 annotations in \emph{IMPACT}.
#'
#' @param URL URL to the IMPACT annotation key file.
#' @param save_path Local path to save the annotation key.
#' @param save_key Whether to save the annotation key locally.
#' @param force_new_download Whether to force re-downloading even if
#'   a local copy exists.
#' @param verbose Print messages.
#'
#' @return A \code{data.table} with annotation metadata.
#'
#' @export
#' @family IMPACT
#' @importFrom data.table fread fwrite
#' @examples
#' \dontrun{
#' annot_key <- IMPACT_get_annotation_key(save_key = FALSE)
#' head(annot_key)
#' }
IMPACT_get_annotation_key <- function(
        URL = paste0("https://github.com/immunogenomics/IMPACT/",
                     "raw/master/IMPACT707/IMPACT_annotation_key.txt"),
        save_path = "./IMPACT/IMPACT_annotation_key.txt.gz",
        save_key = FALSE,
        force_new_download = FALSE,
        verbose = TRUE) {

    if (file.exists(save_path) & !force_new_download) {
        messager("+ IMPACT:: Importing local annotation key...", v = verbose)
        annot_key <- data.table::fread(save_path)
    } else {
        messager("+ IMPACT:: Downloading annotation key from GitHub...",
                 v = verbose)
        annot_key <- data.table::fread(URL)
        if (!isFALSE(save_key)) {
            data.table::fwrite(annot_key, save_path, sep = "\t")
            if (requireNamespace("R.utils", quietly = TRUE)) {
                R.utils::gzip(save_path)
            } else {
                messager("Install R.utils to gzip the saved file.",
                         v = verbose)
            }
        }
    }
    annot_key$Annot <- as.factor(paste0("Annot", annot_key$IMPACT))
    return(annot_key)
}
