# test aoptions
test_that("test aoptions", {
  
  createEmptyRepo("test1111", default = TRUE)
#  setLocalRepo("test1111")
  invisible(aoptions("silent", TRUE))
  data(iris)
  #iris %a% head()

   iris %a%
        dplyr::filter(Sepal.Length < 16) %a%
        lm(Petal.Length~Species, data=.) %a%
        summary() -> obj
   
  ahistory(md5hash = digest::digest(obj))[1,2] -> smry
  expect_equal(smry, "summary()")
  
})