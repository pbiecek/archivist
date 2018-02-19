test_that("test locks", {
  
  aoptions("hashFunction", value = "md5")
  createLocalRepo("flocks_test", default = TRUE, force = TRUE)
  invisible(aoptions("use_flocks", TRUE))
  data(iris)
  
  saveToRepo(iris)
  
  invisible(aoptions("use_flocks", FALSE))
  deleteLocalRepo("flocks_test", deleteRoot = TRUE)
})
