test_that("IMPACT_snp_group_boxplot works", {

    testthat::skip_if_not_installed("ggpubr")
    colorDict <- echodata::snp_group_colorDict()
    TOP_IMPACT_all <- data.table::data.table(
        Locus = rep(c("BST1", "LRRK2"), each = 30),
        SNP_group = factor(
            rep(c("GWAS lead", "UCS", "Consensus"), 20),
            levels = names(colorDict), ordered = TRUE),
        mean_IMPACT = runif(60, 0, 1)
    )
    bp <- IMPACT_snp_group_boxplot(
        TOP_IMPACT_all,
        snp_groups = c("GWAS lead", "UCS", "Consensus"),
        show_plot = FALSE,
        save_path = FALSE
    )
    testthat::expect_true(inherits(bp, "ggplot"))
})

test_that("IMPACT_plot_enrichment works", {

    ENRICH <- data.table::data.table(
        Locus = rep("BST1", 21),
        SNP.group = factor(rep(c("leadGWAS", "UCS", "Consensus"), each = 7)),
        TF = rep(c("CTCF", "NFKB", "STAT1", "PU1",
                    "IRF1", "GATA1", "ETS1"), 3),
        Tissue = "Blood",
        CellDeriv = "Monocyte",
        enrichment = runif(21, 0.5, 3)
    )
    testthat::expect_no_error(
        IMPACT_plot_enrichment(ENRICH)
    )
})

test_that("IMPACT_plot_impact_score works with mock data", {

    testthat::skip_if_not_installed("patchwork")
    testthat::skip_if_not_installed("ggrepel")

    annot_melt <- data.table::data.table(
        SNP = paste0("rs", 1:20),
        CHR = 4, POS = 15700000 + (1:20) * 1000,
        P = 10^(-runif(20, 0, 10)),
        Consensus_SNP = c(TRUE, rep(FALSE, 19)),
        leadSNP = c(TRUE, rep(FALSE, 19)),
        Support = c(3, 2, rep(0, 18)),
        IMPACT_score = runif(20, 0, 1),
        Tissue = "Blood",
        Cell = "Monocyte",
        CellDeriv = "PBMC",
        TF = "CTCF",
        POLYFUN_SUSIE.PP = runif(20),
        POLYFUN_SUSIE.CS = c(1, rep(0, 19))
    )
    plt <- IMPACT_plot_impact_score(annot_melt, show_plot = FALSE)
    testthat::expect_true(inherits(plt, "patchwork"))
})
