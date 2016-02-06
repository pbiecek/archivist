test_that("aread downloads files", {
  aoptions('repoDir', NULL, T) 
  aread("pbiecek/graphGallery/2166dfbd3a7a68a91a2f8e6df1a44111") -> ddl_ggplot
  aread("pbiecek/graphGallery/2166d") -> ddl_ggplot_abrv
  
  expect_is(ddl_ggplot, "gg")
  expect_is(ddl_ggplot, "ggplot")
  expect_output(str(ddl_ggplot), "List of 2")
  expect_equal(ddl_ggplot$labels$x, "Sepal.Length")
  
  expect_is(ddl_ggplot_abrv, "gg")
  expect_is(ddl_ggplot_abrv, "ggplot")
  expect_output(str(ddl_ggplot_abrv), "List of 2")
  expect_equal(ddl_ggplot_abrv$labels$y, "Petal.Length")
  
  
  model <- aread("pbiecek/graphGallery/2a6e492cb6982f230e48cf46023e2e4f")
  expect_is(model, "lm")
  expect_output(str(model), "List of 13")
  expect_equal(names(model$coefficients)[2], "Sepal.Length")
  expect_equal(dim(model$model), c(150, 3))
  
})


test_that("asearch works properly", {
  aoptions('repoDir', NULL, T)
  models <- asearch("pbiecek/graphGallery", patterns = c("class:lm", "coefname:Sepal.Length"))
  
  expect_output(str(models), "List of 2")
  expect_output(str(models[1]), "List of 12")
  expect_output(str(models[2]), "List of 13")
  expect_equal(round(unlist(lapply(models, coef)[[1]]),4), round(c(`(Intercept)` = -7.101443,
                                                                   Sepal.Length = 1.858433),4))
  plots <- asearch("pbiecek/graphGallery", 
                   patterns = c("class:gg",
                                "labelx:Sepal.Length"))
  expect_output(str(plots), "List of 2")
  expect_equal(dim(plots[[1]]$data), c(150, 5))
})


test_that("createEmptyRepo creates repo", {
  createEmptyRepo("tmp_archivist")
  
  expect_equal(list.files("tmp_archivist"), c("backpack.db", "gallery"))
  expect_error(createEmptyRepo("tmp_archivist_2", force = FALSE))
  deleteRepo("tmp_archivist", deleteRoot = TRUE)
})


# test_that("ahistory and piper works ", {
#   invisible(createEmptyRepo("tmp"))
#   setLocalRepo("tmp")
#   aoptions("silent", TRUE)
#   iris %a%
#     dplyr::filter(Sepal.Length < 6) %a%
#     lm(Petal.Length~Species, data=.) %a%
#     summary() -> tmp
#   
#   ahistory(tmp) -> a_tmp
#   loadFromLocalRepo(a_tmp$md5hash[1], value = TRUE) -> b_tmp
#   
#   expect_equal(tmp$call, b_tmp$call)
#   expect_equal(tmp$coefficients, b_tmp$coefficients)
#   deleteRepo("tmp")
# })


test_that("copying from other repositories and showRepo", {
  repo <- "new_repo"
  invisible(createEmptyRepo(repoDir = repo))
  copyRemoteRepo( repoTo = repo, md5hashes= "2166dfbd3a7a68a91a2f8e6df1a44111", 
                  user="pbiecek", repo="graphGallery" )
  expect_is(showLocalRepo(repoDir = repo, method = "tags"), "data.frame")
  expect_equal(dim(showLocalRepo(repoDir = repo, method = "tags")), c(6, 3))
  expect_equal(names(showLocalRepo(repoDir = repo, method = "tags")), c("artifact", "tag", "createdDate"))
  
  summaryRemoteRepo(user="pbiecek", repo="graphGallery") -> graphGallery
  expect_output(str(graphGallery), "List of 5")
  expect_equal(graphGallery$artifactsNumber > 55, TRUE)
  
})


test_that("saveToRepo funcion works with regular parameters", {
  repo <- "new_repo"
  invisible(createEmptyRepo(repoDir = repo))
  pl <- plot(iris$Sepal.Length, iris$Petal.Length)
  saveToRepo(pl, repoDir = repo) -> hash
  
  expect_equal(hash %in% showLocalRepo(repoDir = repo, "tags")[, "artifact"], TRUE)
  
  deleteRepo("new_repo", deleteRoot = TRUE)
})


test_that("loadFromRepo functions works with regular parameters", {
  pl2 <- loadFromRemoteRepo("92ada1", repo="graphGallery", user="pbiecek", 
                            value=TRUE)
  expect_output(str(pl2), "List of 9")
})


test_that("object is properly serialized", {
  model <- aread("pbiecek/graphGallery/2a6e492cb6982f230e48cf46023e2e4f")
  expect_equal(digest::digest(model), "2a6e492cb6982f230e48cf46023e2e4f")
})

test_that("search* functions does search", {
  expect_equal(c("d74472d5b4eee352ba17c5a6f2472c07", "4305c5b68bade4fdf2d7b4033dc19fa5") %in%
  searchInRemoteRepo(pattern="class:gg", user="pbiecek", repo="graphGallery"), c(TRUE, TRUE))
  
  expect_equal(c("6dcb47aaff74b1b5f292b3eddc471c17", "c112c80ae9039b658149e1d66e7507e9") %in%
  searchInRemoteRepo(pattern = list( dateFrom = "2014-09-01", 
                                     dateTo = "2014-09-30" ),
                     user="pbiecek", repo="graphGallery"), c(TRUE, TRUE))
  
  expect_equal(c("2166dfbd3a7a68a91a2f8e6df1a44111", "92ada1e052d4d963e5787bfc9c4b506c") %in%
  multiSearchInRemoteRepo(pattern=c("class:gg", "labelx:Sepal.Length"),
                          user="pbiecek", repo="graphGallery"), c(TRUE, TRUE))
})

