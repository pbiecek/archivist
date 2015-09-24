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

  ahistory(obj)[1,2] -> smry
  ahistory(md5hash = "d550755d93b74707aa11a479656390a4")[1,2] -> smry
  # temporary 
  #  expect_equal(smry, "")
  expect_equal(smry, "summary()")
  
})