# test_that("setLocalRepo sets repo", {
#   setLocalRepo(repoDir = "tmp_archivist")
#   expect_equal(get(".repoDir", envir = .ArchivistEnv), "tmp_archivist/")
#   
#   setGithubRepo("MarcinKosinski", "archivist", "master", "clone123")
#   expect_equal(get(".user", envir = .ArchivistEnv), "MarcinKosinski")
#   expect_equal(get(".repo", envir = .ArchivistEnv), "archivist")
#   expect_equal(get(".branch", envir = .ArchivistEnv), "master")
#   expect_equal(get(".repoDirGit", envir = .ArchivistEnv), "clone123")
# })
# 
# test_that(".ArchivistEnv exists", {
#   expect_equal(get("sqlite", envir = .ArchivistEnv), DBI::dbDriver( "SQLite" ))
#   expect_equal(get(".GithubURL", envir = .ArchivistEnv), "https://raw.githubusercontent.com/")
# })
# 
# test_that("aoptions sets options", {
#   aoptions(".repoDir", "test123")
#   expect_equal(get(".repoDir", envir = .ArchivistEnv), "test123")
# })