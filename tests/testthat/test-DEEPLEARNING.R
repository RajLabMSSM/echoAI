test_that("DEEPLEARNING_plot works with mock data", {

    colorDict <- echodata::snp_group_colorDict()
    annot_melt <- data.table::data.table(
        Locus = rep("BST1", 60),
        Model = rep(c("Basenji", "DeepSEA"), each = 30),
        Tissue = "Brain",
        Assay = "DNASE",
        Type = "annot",
        Metric = "MAX",
        SNP_group = factor(
            rep(c("GWAS lead", "UCS", "Consensus"), 20),
            levels = names(colorDict), ordered = TRUE),
        Annotation = "test",
        value = runif(60, 0, 0.5)
    )
    gp <- DEEPLEARNING_plot(
        annot_melt,
        snp_groups = c("GWAS lead", "UCS", "Consensus"),
        show_plot = FALSE,
        show_padj = FALSE,
        show_signif = FALSE
    )
    testthat::expect_true(inherits(gp, "ggplot"))
})

test_that("DEEPLEARNING_query_one_chr requires base_url", {

    testthat::expect_error(
        DEEPLEARNING_query_one_chr(
            dat = echodata::BST1[1:5, ],
            base_url = NULL
        ),
        "base_url must be provided"
    )
})

test_that("DEEPLEARNING_melt works with mock data", {

    ## Create minimal mock data with expected columns
    mock <- data.table::data.table(
        Locus = rep(c("BST1", "LRRK2"), each = 10),
        SNP = paste0("rs", 1:20),
        P = runif(20, 0, 1),
        leadSNP = c(rep(TRUE, 2), rep(FALSE, 18)),
        Consensus_SNP = c(rep(TRUE, 4), rep(FALSE, 16)),
        Consensus_SNP_noPF = c(rep(TRUE, 4), rep(FALSE, 16)),
        Support = sample(0:3, 20, replace = TRUE),
        Support_noPF = sample(0:3, 20, replace = TRUE),
        ABF.CS = sample(0:1, 20, replace = TRUE),
        SUSIE.CS = sample(0:1, 20, replace = TRUE),
        FINEMAP.CS = sample(0:1, 20, replace = TRUE),
        POLYFUN_SUSIE.CS = sample(0:1, 20, replace = TRUE),
        Basenji_Brain_DNASE_annot_MEAN = runif(20, 0, 0.5)
    )
    result <- DEEPLEARNING_melt(
        ANNOT = mock,
        model = "Basenji",
        save_path = FALSE
    )
    testthat::expect_true(is.data.frame(result))
    testthat::expect_true("SNP_group" %in% colnames(result))
    testthat::expect_true("value" %in% colnames(result))
    testthat::expect_true(nrow(result) > 0)
})
