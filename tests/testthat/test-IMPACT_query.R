test_that("IMPACT_query returns correct dimensions", {

    testthat::skip_if_offline()
    query_dat <- echodata::BST1[1:50, ]
    annot_dt <- IMPACT_query(query_dat = query_dat,
                              populations = "EUR")
    testthat::expect_true(is.data.frame(annot_dt))
    testthat::expect_equal(dim(annot_dt), c(13, 1419))
})

test_that("IMPACT_query long format works", {

    testthat::skip_if_offline()
    query_dat <- echodata::BST1[1:50, ]
    annot_dt <- IMPACT_query(query_dat = query_dat,
                              populations = "EUR",
                              output_format = "long")
    testthat::expect_true(is.data.frame(annot_dt))
    testthat::expect_true("variable" %in% colnames(annot_dt))
    testthat::expect_true(nrow(annot_dt) > 13)
})
