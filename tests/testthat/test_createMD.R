test_that("createMD works", {
  
  # wrong params classes
  expect_error(createMDGallery(user = 'MarcinKosinski', repo = 'Museum',
    'README_test7.md', addTags = "a"))
    
  #no output
  expect_error(createMDGallery('graphGallery', 'pbiecek',
                                     addMiniature = TRUE, addTags = TRUE))
  
  expect_error(createMDGallery('grapadasdasdasdads', 'MarcinKosinski',
                                     addMiniature = TRUE, addTags = TRUE))
  
  createMDGallery('graphGallery', 'pbiecek',
                        addMiniature = TRUE, addTags = TRUE, output = "example.md")
  
  expect_equal(TRUE, file.info("example.md")$size > 40000)
  
  file.remove("example.md")
  
})