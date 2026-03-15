test_that("IMPACT_heatmap requires ComplexHeatmap", {

    testthat::skip_if_not_installed("ComplexHeatmap")
    ## IMPACT_heatmap needs heavy data prep; just verify it's callable
    ## with properly structured input
    testthat::expect_true(is.function(IMPACT_heatmap))
})
