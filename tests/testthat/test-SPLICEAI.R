test_that("SPLICEAI_snp_probs works with mock data", {

    DAT <- data.table::data.table(
        Locus = "BST1",
        SNP = paste0("rs", 1:5),
        CHR = 4,
        POS = 15700000 + 1:5,
        Effect = runif(5),
        P = c(1e-10, 0.5, 0.01, 1e-8, 0.3),
        A1 = c("A", "C", "G", "T", "A"),
        A2 = c("G", "T", "A", "C", "G"),
        leadSNP = c(TRUE, FALSE, FALSE, FALSE, FALSE),
        Consensus_SNP = c(TRUE, FALSE, FALSE, TRUE, FALSE),
        Support = c(3, 0, 1, 2, 0),
        mean.PP = runif(5),
        REF = c("G", "T", "A", "C", "G"),
        ALT = c("A", "C", "G", "T", "A"),
        SYMBOL = "BST1",
        DS_AG = c(0.5, 0.01, 0.02, 0.8, 0.001),
        DS_AL = c(0.1, 0.02, 0.01, 0.1, 0.002),
        DS_DG = c(0.2, 0.005, 0.03, 0.3, 0.001),
        DS_DL = c(0.05, 0.01, 0.02, 0.1, 0.003)
    )
    result <- SPLICEAI_snp_probs(DAT)
    testthat::expect_true(is.data.frame(result))
    testthat::expect_true("max_spliceAI_group" %in% colnames(result))
    testthat::expect_true("max_spliceAI_prob" %in% colnames(result))
    testthat::expect_true("GWAS.sig" %in% colnames(result))
})

test_that("SPLICEAI_plot works with mock data", {

    testthat::skip_if_not_installed("patchwork")
    dat_merged <- data.table::data.table(
        POS = 15700000 + 1:20,
        P = 10^(-runif(20, 0, 10)),
        DS_AG = runif(20, 0, 1),
        DS_AL = runif(20, 0, 0.5),
        DS_DG = runif(20, 0, 0.3),
        DS_DL = runif(20, 0, 0.2)
    )
    plt <- SPLICEAI_plot(dat_merged)
    testthat::expect_true(inherits(plt, "patchwork"))
})

test_that("SPLICEAI_run requires spliceai CLI", {

    has_cli <- nchar(Sys.which("spliceai")) > 0
    testthat::skip_if_not(has_cli, "spliceai CLI not installed")
    testthat::expect_true(is.function(SPLICEAI_run))
})

test_that("SPLICEAI_query_vcf is callable", {

    testthat::expect_true(is.function(SPLICEAI_query_vcf))
})

test_that("SPLICEAI_query_tsv is callable", {

    testthat::expect_true(is.function(SPLICEAI_query_tsv))
})

test_that("SPLICEAI_query_tsv_iterate is callable", {

    testthat::expect_true(is.function(SPLICEAI_query_tsv_iterate))
})
