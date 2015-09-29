test_that("showLocalRepo does not show repo that does not exist", {
  expect_error(showLocalRepo("ASD"))
})  