test_that("setLocalRepo sets repo", {
  createLocalRepo("tmp_archivist")
  setLocalRepo(repoDir = "tmp_archivist")
  expect_equal(aoptions("repoDir"), "tmp_archivist")
  
  setRemoteRepo(user = "MarcinKosinski", repo = "archivist", branch = "master", subdir = "clone123")
  expect_equal(aoptions("user"), "MarcinKosinski")
  expect_equal(aoptions("repo"), "archivist")
  expect_equal(aoptions("branch"), "master")
  expect_equal(aoptions("subdir"), "clone123")
  deleteLocalRepo("tmp_archivist", deleteRoot = TRUE)
  aoptions("subdir", "/")
})

test_that(".ArchivistEnv exists", {
  expect_equal(get("sqlite", envir = .ArchivistEnv), DBI::dbDriver( "SQLite" ))
  expect_equal(get(".GithubURL", envir = .ArchivistEnv), "https://raw.githubusercontent.com")
})

test_that("aoptions sets options", {
  aoptions(".repoDir", "test123")
  expect_equal(get(".repoDir", envir = .ArchivistEnv), "test123")
})