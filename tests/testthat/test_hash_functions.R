test_that("test sha256", {
  
  aoptions("hashFunction", value = "sha256")
  createLocalRepo("sha256", default = TRUE, force = TRUE)
  invisible(aoptions("silent", TRUE))
  data(iris)
  
  iris %a%
    dplyr::filter(Sepal.Length < 16) %a%
    lm(Petal.Length~Species, data=.) %a%
    summary() -> obj
  
  hash1 <- digest::digest(dplyr::filter(iris, Sepal.Length < 16), algo = "sha256")
  expect_equal(getTagsLocal(hash1), c("name:res_val", "name:iris %a% dplyr::filter(Sepal.Length < 16)"))
  
  deleteLocalRepo("sha256", deleteRoot = TRUE)
})
