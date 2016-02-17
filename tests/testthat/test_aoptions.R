# test aoptions
test_that("test aoptions", {
  
  createLocalRepo("arepo", default = TRUE)
  invisible(aoptions("silent", TRUE))
  data(iris)

   iris %a%
        dplyr::filter(Sepal.Length < 16) %a%
        lm(Petal.Length~Species, data=.) %a%
        summary() -> obj

  expect_is(obj, "summary.lm")

  deleteLocalRepo("arepo", deleteRoot = TRUE)
})