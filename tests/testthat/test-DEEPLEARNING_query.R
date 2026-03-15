test_that("DEEPLEARNING_query_one_chr requires base_url", {

    testthat::expect_error(
        DEEPLEARNING_query_one_chr(
            dat = echodata::BST1[1:5, ],
            base_url = NULL
        ),
        "base_url must be provided"
    )
})

test_that("DEEPLEARNING_query_multi_chr requires base_url", {

    testthat::expect_error(
        DEEPLEARNING_query_multi_chr(
            merged_dat = echodata::BST1[1:5, ],
            base_url = NULL
        ),
        "base_url must be provided"
    )
})

test_that("DEEPLEARNING_query requires base_url", {

    testthat::expect_error(
        DEEPLEARNING_query(
            merged_dat = echodata::BST1[1:5, ],
            base_url = NULL
        ),
        "base_url must be provided"
    )
})
