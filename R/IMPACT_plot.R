#' \emph{IMPACT} SNP group box plot
#'
#' Box plot of \emph{IMPACT} scores from each SNP group,
#' with optional statistical comparisons via \pkg{ggpubr}.
#'
#' @param TOP_IMPACT_all A \code{data.table} with columns \code{SNP_group}
#'   and \code{mean_IMPACT}.
#' @param snp_groups Character vector of SNP groups to include.
#' @param method Statistical test method
#'   (e.g. \code{"wilcox.test"}, \code{"t.test"}).
#' @param comparisons_filter A function applied to filter pairwise
#'   comparisons. Set to \code{NULL} to include all.
#' @param show_plot Whether to display the plot.
#' @param save_path Path to save the plot, or \code{FALSE} to skip saving.
#' @param title Plot title.
#' @param xlabel X-axis label.
#' @param ylabel Y-axis label.
#' @param show_padj Whether to show adjusted p-values.
#' @param show_signif Whether to show significance stars.
#' @param vjust_signif Vertical justification for significance labels.
#' @param show_xtext Whether to show x-axis tick labels.
#' @param shift_points Currently unused; kept for API compatibility.
#' @param height Height of saved plot in inches.
#' @param width Width of saved plot in inches.
#'
#' @return A \code{ggplot} object.
#'
#' @export
#' @family IMPACT
#' @importFrom ggplot2 ggplot aes geom_jitter geom_violin geom_boxplot
#'   geom_hline labs scale_fill_manual theme_bw theme element_text
#'   element_blank ggsave
#' @importFrom echodata snp_group_colorDict
#' @importFrom utils combn
#' @source
#' \href{https://www.r-bloggers.com/add-p-values-and-significance-levels-to-ggplots/}{ggpubr example}
#' @examples
#' \dontrun{
#' bp <- IMPACT_snp_group_boxplot(TOP_IMPACT_all, method = "wilcox.test")
#' }
IMPACT_snp_group_boxplot <- function(
        TOP_IMPACT_all,
        snp_groups = c("GWAS lead", "UCS", "Consensus"),
        method = "wilcox.test",
        comparisons_filter = function(x) {
            if ("Consensus" %in% x) return(x)
        },
        show_plot = TRUE,
        save_path = FALSE,
        title = "IMPACT scores",
        xlabel = NULL,
        ylabel = NULL,
        show_padj = TRUE,
        show_signif = TRUE,
        vjust_signif = 0.5,
        show_xtext = TRUE,
        shift_points = TRUE,
        height = 10,
        width = 10) {

    SNP_group <- mean_IMPACT <- NULL

    colorDict <- echodata::snp_group_colorDict()
    plot_dat <- subset(TOP_IMPACT_all, SNP_group %in% snp_groups) |>
        dplyr::mutate(SNP_group = factor(SNP_group,
                                         levels = names(colorDict),
                                         ordered = TRUE))
    snp_groups_present <- unique(plot_dat$SNP_group)
    comparisons <- utils::combn(
        x = as.character(snp_groups_present),
        m = 2,
        FUN = comparisons_filter,
        simplify = FALSE)
    comparisons <- Filter(Negate(is.null), comparisons)

    pb <- ggplot2::ggplot(
        data = plot_dat,
        ggplot2::aes(x = SNP_group, y = mean_IMPACT,
                     fill = SNP_group)) +
        ggplot2::geom_jitter(alpha = 0.1, width = 0.25,
                             show.legend = FALSE, shape = 16, height = 0) +
        ggplot2::geom_violin(alpha = 0.6, show.legend = FALSE) +
        ggplot2::geom_boxplot(alpha = 0.6, color = "black",
                              show.legend = FALSE) +
        ggplot2::geom_hline(yintercept = 0.5, linetype = 2, alpha = 0.5) +
        ggplot2::labs(x = xlabel, y = ylabel, title = title) +
        ggplot2::scale_fill_manual(values = colorDict) +
        ggplot2::theme_bw() +
        ggplot2::theme(legend.position = "none",
                       axis.text.x = ggplot2::element_text(angle = 45,
                                                           hjust = 1))

    if (show_padj) {
        if (!requireNamespace("ggpubr", quietly = TRUE)) {
            warning("Install ggpubr to show adjusted p-values.")
        } else {
            pb <- pb + ggpubr::stat_compare_means(
                method = method,
                comparisons = comparisons,
                label = "p.adj", vjust = 2, size = 3)
        }
    }
    if (show_signif) {
        if (!requireNamespace("ggpubr", quietly = TRUE)) {
            warning("Install ggpubr to show significance labels.")
        } else {
            pb <- pb + ggpubr::stat_compare_means(
                method = method,
                comparisons = comparisons,
                label = "p.signif", size = 3, vjust = vjust_signif)
        }
    }
    if (!show_xtext) {
        pb <- pb + ggplot2::theme(
            axis.text.x = ggplot2::element_blank(),
            axis.title.x = ggplot2::element_blank())
    }
    if (show_plot) print(pb)
    if (!isFALSE(save_path)) {
        ggplot2::ggsave(save_path, pb, dpi = 300,
                        height = height, width = width)
    }
    return(pb)
}


#' Plot IMPACT score enrichment
#'
#' Visualize IMPACT enrichment results with bar plots and violin plots.
#'
#' @param ENRICH A \code{data.table} of enrichment results
#'   as returned by \code{\link{IMPACT_compute_enrichment}} or
#'   \code{\link{IMPACT_iterate_enrichment}}.
#' @param show_plot Whether to display the plots.
#'
#' @return A list of \code{ggplot} objects (invisibly).
#'
#' @export
#' @family IMPACT
#' @importFrom ggplot2 ggplot aes geom_col geom_jitter geom_hline
#'   geom_violin facet_grid theme_bw theme element_text
#' @importFrom dplyr group_by top_n summarise
#' @examples
#' \dontrun{
#' plots <- IMPACT_plot_enrichment(ENRICH = ENRICH)
#' }
IMPACT_plot_enrichment <- function(ENRICH,
                                   show_plot = TRUE) {

    SNP.group <- enrichment <- mean.enrichment <- NULL
    Tissue <- CellDeriv <- TF <- NULL

    enrich_dat <- ENRICH |>
        dplyr::group_by(SNP.group, Tissue, CellDeriv) |>
        dplyr::top_n(n = 1, wt = enrichment)
    mean_dat <- enrich_dat |>
        dplyr::group_by(SNP.group) |>
        dplyr::summarise(mean.enrichment = mean(enrichment))

    ep1 <- ggplot2::ggplot() +
        ggplot2::geom_col(
            data = mean_dat,
            ggplot2::aes(x = SNP.group, y = mean.enrichment,
                         fill = SNP.group),
            position = "dodge") +
        ggplot2::geom_jitter(
            data = enrich_dat,
            ggplot2::aes(x = SNP.group, y = enrichment),
            size = 1, alpha = 0.25, color = "cyan", height = 0) +
        ggplot2::geom_hline(yintercept = 1, linetype = "dashed",
                            alpha = 0.8) +
        ggplot2::theme_bw() +
        ggplot2::theme(strip.text = ggplot2::element_text(angle = 0),
                       axis.text.x = ggplot2::element_text(angle = 45,
                                                           hjust = 1))

    ep2 <- ggplot2::ggplot(
        ENRICH,
        ggplot2::aes(x = Tissue, y = enrichment, fill = SNP.group)) +
        ggplot2::geom_violin(position = "dodge") +
        ggplot2::geom_jitter(size = 1, alpha = 0.25, color = "cyan",
                             height = 0) +
        ggplot2::geom_hline(yintercept = 1, linetype = "dashed",
                            alpha = 0.8) +
        ggplot2::facet_grid(rows = ggplot2::vars(SNP.group),
                            switch = "y", space = "free_x",
                            scales = "free_x") +
        ggplot2::theme_bw() +
        ggplot2::theme(strip.text = ggplot2::element_text(angle = 0),
                       axis.text.x = ggplot2::element_text(angle = 45,
                                                           hjust = 1))

    ep3 <- ggplot2::ggplot(
        enrich_dat,
        ggplot2::aes(x = TF, y = SNP.group, fill = enrichment)) +
        ggplot2::geom_col(position = "dodge") +
        ggplot2::geom_hline(yintercept = 1, linetype = "dashed",
                            alpha = 0.8) +
        ggplot2::facet_grid(cols = ggplot2::vars(Tissue),
                            switch = "y", space = "free_x",
                            scales = "free_x") +
        ggplot2::theme_bw() +
        ggplot2::theme(
            axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))

    if (show_plot) {
        print(ep1)
        print(ep2)
        print(ep3)
    }
    invisible(list(summary = ep1, violin = ep2, tile = ep3))
}


#' Locus plot of IMPACT scores
#'
#' Multi-panel plot showing GWAS results, fine-mapping posterior probabilities,
#' and per-tissue IMPACT scores across a genomic locus.
#'
#' @param annot_melt A melted \code{data.table} of IMPACT annotations
#'   with columns including POS, P, IMPACT_score, TF, Tissue,
#'   Consensus_SNP, leadSNP, and Support.
#' @param save_path Path to save the plot, or \code{FALSE} to skip saving.
#' @param show_plot Whether to display the plot.
#'
#' @return A \code{ggplot/patchwork} object.
#'
#' @export
#' @family IMPACT
#' @importFrom ggplot2 ggplot aes geom_point geom_density geom_vline
#'   facet_grid labs theme_bw theme element_text element_blank
#'   scale_color_viridis_c ylim ggsave
#' @importFrom dplyr group_by top_n mutate
#' @importFrom data.table data.table
#' @examples
#' \dontrun{
#' impact_plot <- IMPACT_plot_impact_score(annot_melt = annot_melt)
#' }
IMPACT_plot_impact_score <- function(annot_melt,
                                     save_path = FALSE,
                                     show_plot = TRUE) {

    if (!requireNamespace("patchwork", quietly = TRUE)) {
        stop("Package 'patchwork' is required. ",
             "Install it with: install.packages('patchwork')")
    }
    if (!requireNamespace("ggrepel", quietly = TRUE)) {
        stop("Package 'ggrepel' is required. ",
             "Install it with: install.packages('ggrepel')")
    }

    Mb <- P <- IMPACT_score <- TF <- Tissue <- Cell <- CellDeriv <- NULL
    POLYFUN_SUSIE.PP <- POLYFUN_SUSIE.CS <- NULL
    Consensus_SNP <- leadSNP <- Support <- SNP <- NULL

    annot_melt$Mb <- annot_melt$POS / 1000000

    # Get the SNP with the top IMPACT score for each annotation
    annot_top <- annot_melt |>
        dplyr::group_by(Tissue, Cell, CellDeriv, TF) |>
        dplyr::top_n(n = 1, wt = IMPACT_score) |>
        data.table::data.table()

    # Reduce to smaller df for faster plotting
    finemap_cols <- grep("*.PP$|*.CS$", colnames(annot_melt), value = TRUE)
    annot_snp <- subset(
        annot_melt,
        select = c("SNP", "CHR", "POS", "Mb", "P",
                    "Consensus_SNP", "leadSNP", "Support",
                    finemap_cols)) |>
        unique()
    annot_snp <- dplyr::mutate(
        annot_snp,
        SNP.Group = ifelse(
            Consensus_SNP, "Consensus SNP",
            ifelse(leadSNP, "Lead GWAS SNP",
                   ifelse(Support > 0, "Credible Set SNP", NA))))

    # GWAS panel
    gwas <- ggplot2::ggplot(
        annot_snp,
        ggplot2::aes(x = Mb, y = -log10(P), color = -log10(P))) +
        ggplot2::geom_point(size = 1) +
        ggplot2::theme_bw()

    # Fine-mapping panel
    finemap <- ggplot2::ggplot(
        annot_snp,
        ggplot2::aes(x = Mb, y = POLYFUN_SUSIE.PP,
                     color = POLYFUN_SUSIE.PP)) +
        ggplot2::geom_point(size = 1) +
        ggplot2::scale_color_viridis_c(breaks = c(0, 0.5, 1)) +
        ggplot2::ylim(c(0, 1.1)) +
        ggplot2::theme_bw()

    # IMPACT panel
    impact <- ggplot2::ggplot(
        subset(annot_melt, IMPACT_score > 0.5),
        ggplot2::aes(x = Mb, y = IMPACT_score, color = TF)) +
        ggplot2::geom_point(show.legend = FALSE) +
        ggplot2::facet_grid(rows = ggplot2::vars(Tissue), switch = "y") +
        ggplot2::theme_bw() +
        ggplot2::labs(y = "IMPACT score per tissue") +
        ggplot2::theme(
            strip.text.y = ggplot2::element_text(angle = 0),
            panel.grid = ggplot2::element_blank(),
            axis.title.y = ggplot2::element_text(vjust = 0.5))

    impact_plot <- gwas + finemap + impact +
        patchwork::plot_layout(ncol = 1, heights = c(0.2, 0.2, 1))

    if (show_plot) print(impact_plot)
    if (!isFALSE(save_path)) {
        dir.create(dirname(save_path), showWarnings = FALSE, recursive = TRUE)
        messager("IMPACT:: Saving plot ==>", save_path)
        ggplot2::ggsave(save_path, plot = impact_plot,
                        height = 10, width = 10)
    }
    return(impact_plot)
}
