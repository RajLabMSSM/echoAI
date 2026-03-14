#' Plot \pkg{ComplexHeatmap} of \emph{IMPACT} scores
#'
#' Creates a heatmap of mean IMPACT scores across SNP groups and loci
#' using \pkg{ComplexHeatmap}. Includes a boxplot annotation at the top
#' and a metadata annotation column for transcription factors.
#'
#' @param ANNOT_MELT A melted \code{data.table} of IMPACT annotations
#'   (as returned by \code{\link{IMPACT_postprocess_annotations}}).
#' @param snp_groups Character vector of SNP group names to include.
#' @param no_no_loci Character vector of locus names to exclude.
#' @param save_path Path to save the heatmap (SVG format).
#'   If \code{NULL}, the heatmap is drawn to the current device.
#'
#' @return A \code{data.table} of the heatmap metadata matrix (invisibly).
#'
#' @export
#' @family IMPACT
#' @importFrom data.table rbindlist data.table dcast
#' @importFrom dplyr group_by summarise select mutate
#' @importFrom echodata find_consensus_snps_no_polyfun snp_group_filters
#' @examples
#' \dontrun{
#' mat_meta <- IMPACT_heatmap(ANNOT_MELT = ANNOT_MELT)
#' }
IMPACT_heatmap <- function(
        ANNOT_MELT,
        snp_groups = c("GWAS lead", "UCS (-PolyFun)", "UCS",
                        "Consensus (-PolyFun)", "Consensus"),
        no_no_loci = NULL,
        save_path = NULL) {

    if (!requireNamespace("ComplexHeatmap", quietly = TRUE)) {
        stop("Package 'ComplexHeatmap' is required. ",
             "Install it with: BiocManager::install('ComplexHeatmap')")
    }
    if (!requireNamespace("RColorBrewer", quietly = TRUE)) {
        stop("Package 'RColorBrewer' is required. ",
             "Install it with: install.packages('RColorBrewer')")
    }

    SNP_group <- mean_IMPACT <- max_IMPACT <- median_IMPACT <- NULL
    Locus <- Tissue <- CellDeriv <- Cell <- TF <- NULL

    ## Remove POLYFUN results (introduces circularity)
    ANNOT_MELT <- echodata::find_consensus_snps_no_polyfun(ANNOT_MELT)
    snp_groups_list <- echodata::snp_group_filters()
    snp_groups_list <- snp_groups_list[names(snp_groups_list) %in% snp_groups]

    TOP_IMPACT <- lapply(names(snp_groups_list), function(x) {
        messager(x)
        top_impact <- IMPACT_get_top_annotations(
            ANNOT_MELT = ANNOT_MELT,
            snp.filter = snp_groups_list[[x]],
            top_annotations = 1,
            force_one_annot_per_locus = TRUE)
        top_impact$SNP_group <- x
        return(top_impact)
    })
    TOP_IMPACT <- data.table::rbindlist(TOP_IMPACT)

    if (!is.null(no_no_loci)) {
        TOP_IMPACT <- subset(TOP_IMPACT, !Locus %in% no_no_loci)
    }
    mat_meta <- prepare_mat_meta(TOP_IMPACT = TOP_IMPACT,
                                 snp.group = "Consensus",
                                 value.var = "mean_IMPACT",
                                 fill_na = 0)

    # Prepare data for boxplot
    TOP_IMPACT_all <- lapply(names(snp_groups_list), function(x) {
        messager(x)
        top_impact <- IMPACT_get_top_annotations(
            ANNOT_MELT = ANNOT_MELT,
            snp.filter = snp_groups_list[[x]],
            top_annotations = 1,
            force_one_annot_per_locus = FALSE)
        top_impact$SNP_group <- x
        return(top_impact)
    })
    TOP_IMPACT_all <- data.table::rbindlist(TOP_IMPACT_all)

    if (!is.null(no_no_loci)) {
        TOP_IMPACT_all <- subset(TOP_IMPACT_all,
                                 !Locus %in% no_no_loci)
    }
    TOP_IMPACT_all$SNP_group <- factor(
        TOP_IMPACT_all$SNP_group,
        levels = names(snp_groups_list), ordered = TRUE)
    TOP_IMPACT_all$rowID <- seq_len(nrow(TOP_IMPACT_all))

    # ComplexHeatmap boxplot data
    boxplot_mat <- data.table::dcast(
        TOP_IMPACT_all,
        formula = "rowID ~ SNP_group",
        value.var = "mean_IMPACT") |>
        dplyr::select(dplyr::any_of(c("GWAS lead", "UCS", "Consensus")))

    make_boxplot <- function(boxplot_mat) {
        ComplexHeatmap::HeatmapAnnotation(
            "mean IMPACT scores" = ComplexHeatmap::anno_boxplot(
                boxplot_mat,
                gp = grid::gpar(fill = c("red", "green3",
                                          "goldenrod3", "goldenrod2"),
                                 col = "black", border = "gray",
                                 alpha = 0.75)),
            annotation_name_side = "left",
            height = grid::unit(3, "cm"),
            annotation_name_gp = grid::gpar(cex = 0.5))
    }

    # Main heatmap
    main_heatmap <- function(mat, cex = 0.5, width = 4.5,
                             row_split = NULL) {
        colnames(mat) <- gsub("_", " ", colnames(mat))
        ComplexHeatmap::Heatmap(
            mat, name = "IMPACT score",
            width = grid::unit(width, "cm"),
            heatmap_legend_param = list(
                title = "mean\nIMPACT\nscore",
                at = c(1, 0.5, 0),
                labels = c("1", "0.5", "< 0.1"),
                legend_height = grid::unit(3, "cm")),
            col = rev(RColorBrewer::brewer.pal(n = 11, "Spectral")),
            column_title = "SNP group",
            cluster_columns = FALSE,
            column_names_side = "top",
            column_names_rot = 0,
            column_names_gp = grid::gpar(
                col = c("red", "green3", "goldenrod3", "goldenrod2"),
                cex = 0.75),
            column_names_centered = TRUE,
            column_gap = grid::unit(0.5, "cm"),
            show_row_names = TRUE,
            row_title = "Locus",
            row_names_side = "left",
            row_names_gp = grid::gpar(cex = cex),
            row_dend_reorder = FALSE,
            row_split = row_split,
            cluster_rows = FALSE,
            top_annotation = make_boxplot(boxplot_mat = boxplot_mat))
    }

    # Annotation column
    annotation_col <- function(mat_meta, variable, width_factor = 0.6,
                               rot = 0, na_fill = NA, cex = 0.5,
                               text_color = "white") {
        meta <- data.frame(mat_meta)
        meta[is.na(mat_meta[[variable]]), variable] <- na_fill
        ComplexHeatmap::Heatmap(
            meta[variable], name = variable,
            width = ComplexHeatmap::max_text_width(
                meta[[variable]]) * width_factor,
            show_heatmap_legend = FALSE,
            row_names_side = "right",
            row_names_gp = grid::gpar(cex = 0.5),
            row_split = meta[variable],
            column_names_rot = rot,
            column_names_side = "top",
            column_names_centered = TRUE,
            column_names_gp = grid::gpar(cex = 0.75),
            cluster_rows = FALSE,
            row_km = 4,
            cell_fun = function(j, i, x, y, width, height, fill) {
                grid::grid.text(
                    sprintf("%s", as.matrix(meta[[variable]])[i, j]),
                    x, y,
                    gp = grid::gpar(cex = cex, col = text_color))
            })
    }

    # Draw heatmap
    if (!is.null(save_path)) {
        grDevices::svg(save_path)
        on.exit(grDevices::dev.off())
    }

    set.seed(2019)
    ht_list <- main_heatmap(
        mat = as.matrix(subset(mat_meta, select = names(snp_groups))),
        row_split = mat_meta$Tissue) +
        annotation_col(mat_meta, variable = "TF")
    ComplexHeatmap::draw(ht_list, ht_gap = grid::unit(0.5, "mm"),
                         heatmap_legend_side = "left")

    return(mat_meta)
}


#' Prepare data matrix and metadata for \pkg{ComplexHeatmap}
#'
#' @param TOP_IMPACT A \code{data.table} of top IMPACT annotations.
#' @param snp.group Name of the SNP group to use for metadata merge.
#' @param value.var Name of the value column to use in the cast.
#' @param fill_na Value to use for filling NA entries.
#'
#' @return A \code{data.frame} with loci as rows and SNP groups as columns,
#'   plus metadata columns.
#'
#' @keywords internal
#' @family IMPACT
#' @importFrom dplyr group_by summarise arrange mutate mutate_at
#' @importFrom data.table data.table dcast
prepare_mat_meta <- function(TOP_IMPACT,
                             snp.group = "Consensus",
                             value.var = "mean_IMPACT",
                             fill_na = 0) {

    Locus <- SNP_group <- mean_IMPACT <- max_IMPACT <- NULL
    median_IMPACT <- Tissue <- CellDeriv <- Cell <- TF <- NULL

    # Reorder loci
    TOP_IMPACT <- TOP_IMPACT |>
        dplyr::arrange(Tissue, CellDeriv, Cell, TF)
    TOP_IMPACT$Locus <- factor(
        as.character(TOP_IMPACT$Locus),
        levels = unique(as.character(TOP_IMPACT$Locus)),
        ordered = TRUE)

    mat_meta <- TOP_IMPACT |>
        dplyr::group_by(Locus, SNP_group) |>
        dplyr::summarise(
            mean_IMPACT = mean(mean_IMPACT, na.rm = TRUE),
            max_IMPACT = gsub(-Inf, NA, max(max_IMPACT, na.rm = TRUE)),
            median_IMPACT = mean(median_IMPACT, na.rm = TRUE)) |>
        data.table::data.table() |>
        data.table::dcast(formula = "Locus ~ SNP_group",
                          value.var = value.var)
    mat_meta <- merge(mat_meta,
                      subset(TOP_IMPACT, SNP_group == snp.group),
                      sort = FALSE)
    # Replace NA with 0 (these are SNPs with IMPACT score <.01 during query)
    mat_meta <- mat_meta |>
        dplyr::mutate_at(
            .vars = names(snp.group),
            .funs = function(.) as.numeric(ifelse(is.na(.), fill_na, .)))
    if (requireNamespace("stringr", quietly = TRUE)) {
        mat_meta <- mat_meta |>
            dplyr::mutate(
                Tissue = gsub("STEMCELL", "STEM CELL", Tissue)) |>
            dplyr::mutate(
                Tissue = ifelse(Tissue == "GI", "GI",
                                stringr::str_to_sentence(Tissue)))
    }
    mat_meta <- mat_meta |>
        dplyr::arrange(Tissue, CellDeriv, Cell, TF)
    rownames(mat_meta) <- mat_meta[["Locus"]]
    mat_meta <- subset(mat_meta, select = -Locus)
    return(mat_meta)
}


#' Color tissues/cell types hierarchically
#'
#' Use the same base color for groups of tissues/cell types
#' but vary the brightness within subgroups. Requires \pkg{pals}
#' and \pkg{shades}.
#'
#' @param mat_meta A \code{data.frame} with columns Tissue, CellDeriv,
#'   Cell, and TF.
#'
#' @return A named character vector of colors covering all unique values
#'   of Tissue, CellDeriv, Cell, and TF.
#'
#' @keywords internal
#' @family IMPACT
#' @importFrom dplyr group_by summarise_at n_distinct
hierarchical_colors <- function(mat_meta) {

    if (!requireNamespace("pals", quietly = TRUE)) {
        stop("Package 'pals' is required. ",
             "Install it with: install.packages('pals')")
    }
    if (!requireNamespace("shades", quietly = TRUE)) {
        stop("Package 'shades' is required. ",
             "Install it with: install.packages('shades')")
    }

    meta <- data.frame(mat_meta)
    Tissue_dict <- stats::setNames(
        pals::cols25(n = dplyr::n_distinct(meta$Tissue)),
        unique(meta$Tissue))

    get_new_colors <- function(mat_meta, group = "Tissue",
                               variable = "CellDeriv", dict) {
        counts <- mat_meta |>
            dplyr::group_by(eval(parse(text = group))) |>
            dplyr::summarise_at(
                .vars = variable,
                .funs = c(count = dplyr::n_distinct))
        colnames(counts) <- c(group, "count")

        new_color_dict <- lapply(seq_len(nrow(counts)), function(i) {
            row <- counts[i, ]
            start_color <- dict[row[[group]]]
            incrementer <- rev(seq(0.1, 0.8, by = 0.1))
            colurz <- vapply(seq_len(row$count), function(j) {
                if (is.na(j)) {
                    return("gray")
                } else {
                    shades::brightness(
                        unname(start_color), incrementer[j])[[1]]
                }
            }, character(1))
            colur_namez <- unique(
                mat_meta[mat_meta[[group]] == row[[group]] &
                             !is.na(mat_meta[[group]]), ][[variable]])
            names(colurz) <- colur_namez
            return(colurz)
        })
        new_color_dict <- unlist(new_color_dict)
        return(new_color_dict)
    }

    CellDeriv_dict <- get_new_colors(mat_meta, group = "Tissue",
                                     variable = "CellDeriv",
                                     dict = Tissue_dict)
    Cell_dict <- get_new_colors(mat_meta, group = "Tissue",
                                variable = "Cell",
                                dict = Tissue_dict)
    TF_dict <- get_new_colors(mat_meta, group = "Tissue",
                              variable = "TF",
                              dict = Tissue_dict)

    master_dict <- c(Tissue_dict, CellDeriv_dict, Cell_dict, TF_dict)
    return(master_dict)
}
