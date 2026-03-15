#' Plot \emph{SpliceAI} predictions
#'
#' Multi-panel plot showing GWAS significance (\code{-log10(P)}) and the
#' four \emph{SpliceAI} delta-score channels across genomic position,
#' arranged vertically using \pkg{patchwork}.
#'
#' @param dat_merged A \code{data.table} with at least columns
#'   \code{POS}, \code{P}, \code{DS_AG}, \code{DS_AL}, \code{DS_DG},
#'   and \code{DS_DL}.
#'
#' @returns A \code{patchwork} composite \code{ggplot} object.
#'
#' @export
#' @family SPLICEAI
#' @importFrom ggplot2 ggplot aes geom_point scale_color_viridis_c
#'   theme_classic
#' @source
#' \url{https://github.com/Illumina/SpliceAI}
#' \doi{10.1016/j.cell.2018.12.015}
#' @examples
#' \dontrun{
#' dat_merged <- data.table::fread("spliceAI_merged.tsv.gz")
#' plt <- SPLICEAI_plot(dat_merged)
#' }
SPLICEAI_plot <- function(dat_merged) {

    POS <- P <- DS_AG <- DS_AL <- DS_DG <- DS_DL <- NULL;

    if (!requireNamespace("patchwork", quietly = TRUE)) {
        stop("Package 'patchwork' is required. ",
             "Install it with: install.packages('patchwork')")
    }

    plt <-
        ggplot2::ggplot(dat_merged,
                        ggplot2::aes(x = POS, y = -log10(P),
                                     color = -log10(P))) +
        ggplot2::geom_point() +
        ggplot2::theme_classic() +

        ggplot2::ggplot(dat_merged,
                        ggplot2::aes(x = POS, y = DS_AG,
                                     color = DS_AG)) +
        ggplot2::geom_point() +
        ggplot2::scale_color_viridis_c() +
        ggplot2::theme_classic() +

        ggplot2::ggplot(dat_merged,
                        ggplot2::aes(x = POS, y = DS_AL,
                                     color = DS_AL)) +
        ggplot2::geom_point() +
        ggplot2::scale_color_viridis_c() +
        ggplot2::theme_classic() +

        ggplot2::ggplot(dat_merged,
                        ggplot2::aes(x = POS, y = DS_DG,
                                     color = DS_DG)) +
        ggplot2::geom_point() +
        ggplot2::scale_color_viridis_c() +
        ggplot2::theme_classic() +

        ggplot2::ggplot(dat_merged,
                        ggplot2::aes(x = POS, y = DS_DL,
                                     color = DS_DL)) +
        ggplot2::geom_point() +
        ggplot2::scale_color_viridis_c() +
        ggplot2::theme_classic() +

        patchwork::plot_layout(ncol = 1)

    print(plt)
    return(plt)
}
