#' Plot deep learning predictions
#'
#' Violin/box plot of deep learning annotation values across SNP groups,
#' with optional pairwise statistical comparisons via \pkg{ggpubr}.
#' Outliers are optionally removed before plotting.
#'
#' @param annot_melt A \code{data.table} in long format as returned by
#'   \code{\link{DEEPLEARNING_melt}}, with columns including
#'   \code{Metric}, \code{SNP_group}, and \code{value}.
#' @param snp_groups Character vector of SNP groups to include in the plot.
#' @param comparisons_filter A function applied to each pairwise combination
#'   of SNP groups. Return the pair to keep it; return \code{NULL} to drop.
#'   Set to \code{NULL} to include all pairwise comparisons.
#' @param model_metric Character vector of metric values to include
#'   (e.g. \code{"MAX"}).
#' @param facet_formula Facet formula passed to
#'   \code{\link[ggplot2]{facet_grid}}.
#' @param remove_outliers Logical; if \code{TRUE}, outliers identified by
#'   \code{\link[graphics]{boxplot}} are removed before plotting.
#' @param show_padj Whether to show adjusted p-values
#'   (requires \pkg{ggpubr}).
#' @param show_signif Whether to show significance stars
#'   (requires \pkg{ggpubr}).
#' @param vjust_signif Vertical justification for significance labels.
#' @param show_plot Whether to display the plot.
#' @param save_path File path to save the plot, or \code{FALSE} to skip.
#' @param height Height of saved plot in inches.
#' @param width Width of saved plot in inches.
#'
#' @returns A \code{ggplot} object.
#'
#' @export
#' @family DEEPLEARNING
#' @source
#' \url{https://alkesgroup.broadinstitute.org/LDSCORE/DeepLearning/Dey_DeepLearning.tgz}
#' @importFrom ggplot2 ggplot aes geom_jitter geom_violin geom_boxplot
#'   facet_grid labs scale_fill_manual theme_bw theme element_text
#'   element_rect ggsave
#' @importFrom echodata snp_group_colorDict
#' @importFrom utils combn
#' @importFrom stats as.formula
#' @examples
#' \dontrun{
#' gp <- DEEPLEARNING_plot(
#'     annot_melt = annot_melt,
#'     facet_formula = "Tissue ~ Model",
#'     comparisons_filter = NULL,
#'     save_path = "results/deeplearning_plot.png"
#' )
#' }
DEEPLEARNING_plot <- function(
        annot_melt,
        snp_groups = c("GWAS lead", "UCS",
                        "Consensus (-POLYFUN)", "Consensus"),
        comparisons_filter = function(x) {
            if ("Consensus" %in% x) return(x)
        },
        model_metric = c("MAX"),
        facet_formula = ". ~ Model",
        remove_outliers = TRUE,
        show_padj = TRUE,
        show_signif = TRUE,
        vjust_signif = 0,
        show_plot = TRUE,
        save_path = FALSE,
        height = 6,
        width = 8) {

    Metric <- SNP_group <- value <- NULL

    if (remove_outliers) {
        ## Suppress the side-effect plot device from boxplot()
        outliers <- graphics::boxplot(annot_melt$value,
                                      plot = FALSE)$out
        annot_melt <- annot_melt[-which(annot_melt$value %in% outliers), ]
    }
    colorDict <- echodata::snp_group_colorDict()
    dat_plot <- subset(
        annot_melt,
        Metric %in% model_metric & SNP_group %in% snp_groups
    ) |>
        dplyr::mutate(
            SNP_group = factor(SNP_group,
                               levels = names(colorDict),
                               ordered = TRUE)
        )
    snp_groups_present <- unique(dat_plot$SNP_group)
    comparisons <- utils::combn(
        x = as.character(snp_groups_present),
        m = 2,
        FUN = comparisons_filter,
        simplify = FALSE
    )
    comparisons <- Filter(Negate(is.null), comparisons)

    method <- "wilcox.test"
    gp <- ggplot2::ggplot(
        data = dat_plot,
        ggplot2::aes(x = SNP_group, y = value, fill = SNP_group)
    ) +
        ggplot2::geom_jitter(alpha = 0.1, width = 0.3, height = 0) +
        ggplot2::geom_violin(alpha = 0.6) +
        ggplot2::geom_boxplot(alpha = 0.6, color = "black") +
        ggplot2::facet_grid(
            facets = stats::as.formula(facet_formula),
            scales = "free"
        ) +
        ggplot2::labs(
            title = paste0("Deep learning annotations (",
                           tolower(model_metric), ")"),
            y = "value",
            x = "SNP Group"
        ) +
        ggplot2::scale_fill_manual(values = colorDict) +
        ggplot2::theme_bw() +
        ggplot2::theme(
            axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
            legend.position = "none",
            strip.background = ggplot2::element_rect(fill = "grey20"),
            strip.text = ggplot2::element_text(color = "white")
        )

    if (show_padj) {
        if (!requireNamespace("ggpubr", quietly = TRUE)) {
            warning("Install ggpubr to show adjusted p-values.")
        } else {
            gp <- gp + ggpubr::stat_compare_means(
                method = method,
                comparisons = comparisons,
                label = "p.adj", size = 3, vjust = 2
            )
        }
    }
    if (show_signif) {
        if (!requireNamespace("ggpubr", quietly = TRUE)) {
            warning("Install ggpubr to show significance labels.")
        } else {
            gp <- gp + ggpubr::stat_compare_means(
                method = method,
                comparisons = comparisons,
                label = "p.signif", size = 3, vjust = vjust_signif
            )
        }
    }
    if (show_plot) print(gp)
    if (!isFALSE(save_path)) {
        ggplot2::ggsave(save_path, gp, dpi = 300,
                        height = height, width = width)
    }
    return(gp)
}
