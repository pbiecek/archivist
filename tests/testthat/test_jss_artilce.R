test_that("aread downloads files", {
  aoptions('repoDir', NULL, T) 
  aread("pbiecek/graphGallery/f05f0ed0662fe01850ec1b928830ef32") -> ddl_ggplot
  aread("pbiecek/graphGallery/f05f0ed066") -> ddl_ggplot_abrv
  
  expect_is(ddl_ggplot, "ggplot")
  expect_is(ddl_ggplot_abrv, "ggplot")

  
  model <- aread("pbiecek/graphGallery/2a6e492cb6982f230e48cf46023e2e4f")
  expect_is(model, "lm")

})


test_that("asearch works properly", {
  aoptions('repoDir', NULL, T)
  models <- asearch("pbiecek/graphGallery", patterns = c("class:lm", "coefname:Sepal.Length"))
  
  expect_more_than(length(models), 1)
  plots <- asearch("pbiecek/graphGallery", 
                   patterns = c("class:gg",
                                "labelx:Sepal.Length"))
  
  expect_more_than(length(plots), 1)
})


test_that("createEmptyRepo creates repo", {
  createLocalRepo("arepo")
  
  expect_equal(list.files("arepo"), c("backpack.db", "gallery"))
  expect_error(createLocalRepo("arepo2", force = FALSE))
  deleteLocalRepo("arepo", deleteRoot = TRUE)
})


test_that("copying from other repositories and showRepo", {
  repo <- "arepo"
  invisible(createLocalRepo(repoDir = repo))
  copyRemoteRepo( repoTo = repo, md5hashes= "f05f0ed0662fe01850ec1b928830ef32", 
                  user="pbiecek", repo="graphGallery" )
  expect_is(showLocalRepo(repoDir = repo, method = "tags"), "data.frame")
  expect_equal(names(showLocalRepo(repoDir = repo, method = "tags")), c("artifact", "tag", "createdDate"))
  
  summaryRemoteRepo(user="pbiecek", repo="graphGallery") -> graphGallery
  expect_equal(graphGallery$artifactsNumber > 50, TRUE)
  
})


test_that("saveToRepo funcion works with regular parameters", {
  repo <- "arepo"
  invisible(createLocalRepo(repoDir = repo))
  pl <- plot(iris$Sepal.Length, iris$Petal.Length)
  saveToRepo(pl, repoDir = repo) -> hash
  
  expect_equal(hash %in% showLocalRepo(repoDir = repo, "tags")[, "artifact"], TRUE)
  
  deleteLocalRepo("arepo", deleteRoot = TRUE)
})


test_that("loadFromRepo functions works with regular parameters", {
  pl2 <- loadFromRemoteRepo("2a6e492cb", repo="graphGallery", user="pbiecek", 
                            value=TRUE)
  expect_is(pl2, "lm")
})


test_that("object is properly serialized", {
  model <- aread("pbiecek/graphGallery/2a6e492cb6982f230e48cf46023e2e4f")
  expect_equal(digest::digest(model), "2a6e492cb6982f230e48cf46023e2e4f")
})

test_that("search* functions does search", {
  expect_equal(c("13b2724139eb2c62578b4dab0d7b2cea", "f05f0ed0662fe01850ec1b928830ef32") %in%
  searchInRemoteRepo(pattern="class:gg", user="pbiecek", repo="graphGallery"), c(TRUE, TRUE))
  
  expect_equal(c("f9ebb370fa8fed2057be1bb11005f5fb", "6f6623ab33ae7f98bf8f5d7457c112eb") %in%
  searchInRemoteRepo(pattern = list( dateFrom = "2014-09-01", 
                                     dateTo = "2014-09-30" ),
                     user="pbiecek", repo="graphGallery"), c(TRUE, TRUE))
  
  expect_equal(c("f05f0ed0662fe01850ec1b928830ef32", "13b2724139eb2c62578b4dab0d7b2cea") %in%
  searchInRemoteRepo(pattern=c("class:gg", "labelx:Sepal.Length"),
                          user="pbiecek", repo="graphGallery"), c(TRUE, TRUE))
})

