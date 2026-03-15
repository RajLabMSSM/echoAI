test_that("IMPACT_get_top_annotations works", {

    ANNOT_MELT <- data.table::data.table(
        Locus = rep(c("BST1", "LRRK2"), each = 30),
        SNP = rep(paste0("rs", 1:10), 6),
        Tissue = rep(c("Blood", "Brain"), each = 15, times = 2),
        CellDeriv = "Monocyte",
        Cell = "CD14+",
        TF = rep(c("CTCF", "NFKB", "STAT1"), 20),
        IMPACT_score = runif(60, 0, 1)
    )
    top <- IMPACT_get_top_annotations(
        ANNOT_MELT = ANNOT_MELT,
        snp.filter = "!is.na(IMPACT_score)",
        top_annotations = 1,
        force_one_annot_per_locus = TRUE
    )
    testthat::expect_true(is.data.frame(top))
    testthat::expect_true("mean_IMPACT" %in% colnames(top))
    testthat::expect_true("max_IMPACT" %in% colnames(top))
    ## Should have at most 1 row per locus
    testthat::expect_true(
        nrow(top) <= length(unique(ANNOT_MELT$Locus))
    )
})

test_that("IMPACT_postprocess_annotations works", {

    ANNOT_MELT <- data.table::data.table(
        Locus = rep("BST1", 20),
        SNP = paste0("rs", 1:20),
        Consensus_SNP = c(TRUE, rep(FALSE, 19)),
        Support = c(3, rep(0, 19)),
        mean.PP = runif(20, 0, 1),
        IMPACT_score = runif(20, 0, 1),
        Tissue = "Blood",
        CellDeriv = "Monocyte",
        Cell = "CD14+"
    )
    ## find_top_consensus adds topConsensus column
    ANNOT_MELT <- echodata::find_top_consensus(ANNOT_MELT)
    result <- IMPACT_postprocess_annotations(ANNOT_MELT,
                                              order_loci = FALSE)
    testthat::expect_true(is.data.frame(result))
    testthat::expect_true("uniqueID" %in% colnames(result))
})
