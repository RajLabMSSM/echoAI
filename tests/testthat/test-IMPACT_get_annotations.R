test_that("IMPACT_get_annotations downloads and merges", {

    testthat::skip_if_offline()
    ## Use small subset to keep test fast
    query_dat <- echodata::BST1[1:10, ]
    annot <- IMPACT_get_annotations(dat = query_dat)
    testthat::expect_true(is.data.frame(annot))
    testthat::expect_true(nrow(annot) > 0)
    testthat::expect_true("IMPACT_score" %in% colnames(annot))
    testthat::expect_true("Annot" %in% colnames(annot))
})

test_that("IMPACT_iterate_get_annotations works for single chromosome", {

    testthat::skip_if_offline()
    merged_DT <- echodata::BST1[1:10, ]
    ANNOT_MELT <- IMPACT_iterate_get_annotations(
        merged_DT = merged_DT,
        IMPACT_score_thresh = 0.1,
        top_annotations = FALSE
    )
    testthat::expect_true(is.data.frame(ANNOT_MELT))
    testthat::expect_true(nrow(ANNOT_MELT) > 0)
})
