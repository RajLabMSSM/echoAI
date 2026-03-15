test_that("IMPACT_get_annotation_key downloads from GitHub", {

    testthat::skip_if_offline()
    annot_key <- IMPACT_get_annotation_key(save_key = FALSE)
    testthat::expect_true(is.data.frame(annot_key))
    testthat::expect_true(nrow(annot_key) > 500)
    testthat::expect_true(all(c("TF", "Tissue", "Cell", "IMPACT", "Annot")
                              %in% colnames(annot_key)))
    ## Annot column should be factor with "Annot" prefix
    testthat::expect_true(is.factor(annot_key$Annot))
    testthat::expect_true(all(grepl("^Annot", levels(annot_key$Annot))))
})

test_that("IMPACT_get_ldscores downloads LD scores", {

    testthat::skip_if_offline()
    query_dat <- echodata::BST1[1:20, ]
    ld <- IMPACT_get_ldscores(dat = query_dat)
    testthat::expect_true(is.data.frame(ld))
    testthat::expect_true(nrow(ld) > 0)
    testthat::expect_true("SNP" %in% colnames(ld))
})
