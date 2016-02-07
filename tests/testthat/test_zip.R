test_that("zip*Repo does not react on errors as it should ", {
  expect_error(zipRemoteRepo( user="pbiecek", repo="archivist", repoTo = "Repo does not exist" ))
  expect_error(zipRemoteRepo( user="tyu oiyuvthfgy333", repo="archivist"))
  expect_error(zipRemoteRepo( user="wchodor", repo="jbsjdabfb"))
  expect_error(zipRemoteRepo( user="wchodor", repo="archivist", branch = "gajsdasb"))
  expect_error(zipRemoteRepo( user= 10, repo="archivist"))    
})


test_that("zip*Repo reacts properly on proper arguments ", {
  req <- GET("https://api.github.com/repos/MarcinKosinski/Museum/git/trees/master?recursive=1")
  stop_for_status(req)
  filelist <- unlist(lapply(content(req)$tree, "[", "path"), use.names = F)
  liczba_art_gallery <- length(grep("ex1/gallery/", filelist, value = TRUE, fixed = TRUE))
  liczba_art_backpack <- length(unique(showRemoteRepo(repo = "museum",
                                                      user = "MarcinKosinski",
                                                      subdir = "ex1")[,1]))
  zipname <- "test1234.zip"
  zipRemoteRepo( user="MarcinKosinski", repo="Museum", zipname = zipname,
                 subdir="ex1")
  zipfile <- file.path(getwd(), zipname)
  repo_zip <- gsub(pattern = ".zip", replacement = "", x = zipfile)
  unzip(zipfile, exdir = getwd())
  liczba_art_gallery_zip <- length(list.files(file.path(repo_zip, "gallery")))
  liczba_art_backpack_zip <- length(showLocalRepo(repoDir = repo_zip)[,1])
  expect_equal(liczba_art_gallery, liczba_art_gallery_zip)
  expect_equal(liczba_art_backpack, liczba_art_backpack_zip)
  file.remove(zipfile)
  unlink(repo_zip, recursive = TRUE)
})