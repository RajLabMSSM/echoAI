test_that("IMPACT_compute_enrichment works with mock data", {

    ## Minimal mock annotated data with required columns
    annot_melt <- data.table::data.table(
        SNP = rep(paste0("rs", 1:20), each = 3),
        Locus = "BST1",
        TF = rep(c("CTCF", "NFKB", "STAT1"), 20),
        Tissue = "Blood",
        Cell = "Monocyte",
        CellDeriv = "PBMC",
        IMPACT_score = runif(60, 0, 1),
        leadSNP = rep(c(TRUE, rep(FALSE, 19)), each = 3),
        Support = rep(c(3, 2, 1, rep(0, 17)), each = 3),
        Consensus_SNP = rep(c(TRUE, TRUE, FALSE, rep(FALSE, 17)), each = 3),
        ABF.CS = rep(c(1, 1, 0, rep(0, 17)), each = 3),
        FINEMAP.CS = rep(c(1, 0, 1, rep(0, 17)), each = 3),
        SUSIE.CS = rep(c(1, 1, 1, rep(0, 17)), each = 3),
        POLYFUN_SUSIE.CS = rep(c(1, 0, 0, rep(0, 17)), each = 3)
    )
    enrich <- IMPACT_compute_enrichment(annot_melt, locus = "BST1")
    testthat::expect_true(is.data.frame(enrich))
    testthat::expect_true("enrichment" %in% colnames(enrich))
    testthat::expect_true("SNP.group" %in% colnames(enrich))
    testthat::expect_true(nrow(enrich) > 0)
})

test_that("IMPACT_iterate_enrichment works", {

    ## Uses global ANNOT_MELT pattern from the original code
    ## Create mock with multiple loci
    annot_melt <- data.table::data.table(
        SNP = paste0("rs", 1:10),
        Locus = rep(c("BST1", "LRRK2"), each = 5),
        TF = "CTCF", Tissue = "Blood",
        Cell = "Monocyte", CellDeriv = "PBMC",
        IMPACT_score = runif(10, 0, 1),
        leadSNP = c(TRUE, rep(FALSE, 9)),
        Support = c(3, 2, 1, 0, 0, 3, 2, 0, 0, 0),
        Consensus_SNP = c(TRUE, TRUE, FALSE, FALSE, FALSE,
                          TRUE, FALSE, FALSE, FALSE, FALSE),
        ABF.CS = c(1, 1, 0, 0, 0, 1, 0, 0, 0, 0),
        FINEMAP.CS = c(1, 0, 1, 0, 0, 0, 1, 0, 0, 0),
        SUSIE.CS = c(1, 1, 0, 0, 0, 1, 0, 0, 0, 0),
        POLYFUN_SUSIE.CS = c(1, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    )
    ## IMPACT_iterate_enrichment expects ANNOT_MELT as a global or passed
    ## It uses unique(ANNOT_MELT$Locus) internally
    assign("ANNOT_MELT", annot_melt, envir = environment())
    ENRICH <- IMPACT_iterate_enrichment(ANNOT_MELT = annot_melt)
    testthat::expect_true(is.data.frame(ENRICH))
    testthat::expect_true(nrow(ENRICH) > 0)
})
