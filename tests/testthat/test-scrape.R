test_that("scrape_github works", {
  ## skip tests if (a) on CRAN, (b) not online
  skip_on_cran()
  skip_if_offline(host = "github.com")

  ## search results for first two pages of 'rstats' query
  p <- scrape_github("rstats", pages = 2)
  expect_true(is.data.frame(p))
  expect_named(p)
  expect_true(
    all(c("id", "repo", "url", "description", "language", "stars") %in% names(p))
  )
  expect_gt(nrow(p), 10L)

  ## these should result in errors
  expect_error(
    scrape_github(data.frame(x = letters)),
    regexp = "is not.*character"
  )
  expect_error(
    scrape_github("rstats", "dinosaur"),
    regexp = "is not.*numeric"
  )
  expect_error(
    scrape_github("rstats", 1, "apple"),
    regexp = "unused"
  )
})
