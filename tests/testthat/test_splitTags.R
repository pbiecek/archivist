test_that("split*Repo does not react on errors as it should and works as it's made to", {
  # Creating example default repository
  exampleRepoDir <- tempfile()
  createLocalRepo( exampleRepoDir, default = TRUE )
  aoptions('silent', TRUE)
  # what about empty repo
  expect_error(splitTagsLocal())
  
  # Adding new artifacts to repository
  # with not-friendly for this function Tags
  data(iris)
  iris -> d1
  saveToRepo(d1,
             userTags = c(":", "", "\n", "\t", "\\", "\\\\"),
             repoDir = exampleRepoDir )
  expect_equal(nrow(splitTagsLocal()), 18) # PBI: changed from 14. But this is not a good test, since with new extensions of list of tags it will fail.
  
  expect_equal(names(splitTagsLocal()), c('artifact', 'tagKey',
                                          'tagValue', 'createdDate'))
  
  data(iris3)
  iris3 -> d2
  saveToRepo(d2)
  
  data(longley)
  longley -> d3
  saveToRepo(d3, userTags = 1:2)
  expect_error(splitTagsLocal(1:100))
  expect_equal(ncol(splitTagsLocal()), 4)
  
  deleteLocalRepo(repoDir = exampleRepoDir, deleteRoot = TRUE)
})