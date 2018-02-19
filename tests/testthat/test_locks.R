test_that("test locks", {
  
  aoptions("hashFunction", value = "md5")
  createLocalRepo("flocks_test", default = TRUE, force = TRUE)
  invisible(aoptions("use_flocks", TRUE))
  data(iris)
  
  iris %a%
    dplyr::filter(Sepal.Length < 16) %a%
    lm(Petal.Length~Species, data=.) %a%
    summary() -> obj
  
  invisible(aoptions("use_flocks", FALSE))
  deleteLocalRepo("flocks_test", deleteRoot = TRUE)
})
