test_that("SPLICEAI_query_api returns scores for known splice variant", {

    testthat::skip_if_not_installed("jsonlite")
    testthat::skip_if_offline()

    ## TTN indel known to have high DS_AL score
    result <- tryCatch(
        SPLICEAI_query_api(
            variants = "2-179415988-C-CA",
            genome = "37",
            distance = 50
        ),
        error = function(e) {
            testthat::skip(paste("SpliceAI API unavailable:", e$message))
        }
    )
    testthat::skip_if(is.null(result), "SpliceAI API returned no results")
    testthat::expect_true(is.data.frame(result))
    testthat::expect_true(nrow(result) > 0)
    testthat::expect_true(all(c("variant", "gene", "DS_AG", "DS_AL",
                                 "DS_DG", "DS_DL") %in% colnames(result)))
    ## This variant has a known high acceptor loss score
    max_score <- max(result$DS_AL, na.rm = TRUE)
    testthat::expect_true(max_score >= 0.5)
})

test_that("SPLICEAI_query_api returns NULL for non-genic variant", {

    testthat::skip_if_not_installed("jsonlite")
    testthat::skip_if_offline()

    ## Intergenic variant unlikely to have splice scores
    result <- SPLICEAI_query_api(
        variants = "1-10000-A-G",
        genome = "37"
    )
    testthat::expect_null(result)
})
