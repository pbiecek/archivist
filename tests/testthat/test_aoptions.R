# test aoptions
test_that("aread downloads files", {
  
  createEmptyRepo("test1111", default = TRUE)
  data(iris)
  iris %a%
       filter(Sepal.Length < 6) %a%
       lm(Petal.Length~Species, data=.) %a%
       summary() -> obj 
  ahistory(obj)[1,2] -> smry
  deleteRepo("test1111")
  expect_equal(, "summary()")
  
}
)