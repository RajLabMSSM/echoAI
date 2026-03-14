# Extracted from test-IMPACT_query.R:5

# test -------------------------------------------------------------------------
query_dat <- echodata::BST1[1:50,]
annot_dt <- IMPACT_query(query_dat=query_dat,
                             populations="EUR")
