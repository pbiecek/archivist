test_that("createMD works", {
  
  # wrong params classes
  expect_error(createGithubMDGallery(user = 'MarcinKosinski', repo = 'Museum',
    'README_test7.md', addTags = "a"))
    
  #no output
  expect_error(createGithubMDGallery('graphGallery', 'pbiecek',
                                     addMiniature = TRUE, addTags = TRUE))
  
  expect_error(createGithubMDGallery('grapadasdasdasdads', 'MarcinKosinski',
                                     addMiniature = TRUE, addTags = TRUE))
  
  createGithubMDGallery('graphGallery', 'pbiecek',
                        addMiniature = TRUE, addTags = TRUE, output = "example.md")
  
  expect_equal(TRUE, file.info("example.md")$size > 50000)
  
  file.remove("example.md")
  
})