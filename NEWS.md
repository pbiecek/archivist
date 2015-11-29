archivist 1.8
----------------------------------------------------------------
	
* **Archivist Integration With GitHub API:** new functions:
	1. It is possible to create new GitHub repository with an empty `archivist`-like `Repository` with `createEmptyGithubRepo` function. We also added `createEmptyLocalRepo` to maintain consistency with other sister functions. `createEmptyRepo` is now a wrapper around `createEmptyLocalRepo` and `createEmptyGithubRepo` functions.
	2. One can now clone GitHub-archivist repo with new `cloneGithubRepo` function.
	3. One can automatically archive artifacts to Local and synchronized GitHub archivist-like Repositiories with new `archive` function.
	4. Added manual page to enable easier usage of this integration: ``?`archivist-github-integration``` (or shorter `?agithub`).
* **New functions** `splitTagsLocal` and `splitTagsGithub` enabling to split `tag` column in database into two separate columns: `tagKey` and `tagValue`.
* **Bugs fixed:**
	1. `checkDirectory` function is now immune to directories that don't exist. This made
`showLocalRepo` function working properly when passed an argument to the directory
that do not exist.
	2. Changed `dbDisconnect( conn )` call to the `on.exit(dbDisconnect( conn ))` in `executeSingleQuery` function to prevent a situation in which during an error inside a function (which might be produced), the connection stays open, when it shouldn`t.
	3. `%a%` operator does react on `default = TRUE` in `createEmpyRepo` function.
  4. `deleteRoot = TRUE` argument of the `deleteRepo` function works properly and enables removing root directory of the Repository.
  5. Some changes in `rmFromRepo`'s body:
    1. Function will give a warning when a user uses wrong md5hash (that does not exist in the `Repository`).
    In case of wrong md5hash abbreviation a user will receive an error message.
    2. Artifacts' data is now removed from tag table in `backpack.db` file when
    `many = TRUE`. They were not removed before.
    3. Artifacts' data files are now removed from `gallery` folder.
    They were not removed before.
    4. `Invisible(NULL)` is the result of the function evaluation.
  6. Some changes in `copy*Repo`'s body:
    1. `Invisible(NULL)` is the result of the function evaluation
    2. `repoFrom` parameter in `copyLocalRepo` is set to `NULL` as default.
  7. `copyFromLocalRepo` and `copyFromGithubRepo` copies only distinct records for table `tag` and `artifact` in `backpack.db` file, that can be seen with `show*Repo` and copies all mentioned artifacts for local version.
  8. `downloadDB` in `createEmptyRepo` function gives a user-friendly error.
  9. In `zipGithubRepo` unzipped file has the same name as zip file. Earlier it had a name of the temporary file that was difficult to notice.
  10. In `setGithubRepo` it is now possible to use repoDirGit parameter. Before there was wrong `stopifnot` condition.
  11. `paste0()` was replaced by `file.path()` in appropriate places of function's bodies in the following R scripts: `archive.R`, `copyToRepo.R`, `createEmptyRepo.R`, `deleteRepo.R`,
`extractMiniature.R`, `loadFromRepo.R`, `rmFromRepo.R`, `saveToRepo.R`, `zipRepo.R`.
  12. Two crucial parts of `checkDirectory`'s function body were removed due to changes in point 11.
`checkDirectory2` was completely removed as it is unnecessary now.
  13. Small change in `test_base_functionalities.R` due to changes in point 11 and 12.
  14. `aoptions` for `user` and `repo` will work properly with `showGithubRepo` and `summaryGithubRepo` when set. It might have not been noticed in version 1.7, it might have been a bug that occured in the development between 1.7 and 1.8 version.
* **New features:**
	1. `print.ahistory` function can now print outputs of the artifact's history as the `knitr::kable` would.
	2. Examples for `searchInGithubRepo` now works for `user='pbiecek'` and `repo='archivist` parameters as we added new backpack.db file. The previous one was almost empty (for 7 months).
	3. Additional examples to better understand usage of archivist package functions:
		1. in `loadFromRepo` function - Loading artifacts from the repository which is built in the archivist package and saving them on the example repository.
		2. in `createEmptyRepo` function - creating a default local Repository in non existing directory.
		3. in `rmFromRepo` function - removing artifacts with `many = TRUE` argument.
		4. in `deleteRepo` function - using `deleteRoot = TRUE` argument. 
		5. in `copy*Repo` function - using graphGallery local repository in `copyLocalRepo` function.
		6. in `get*Tags` function - additional example using `getTagsLocal` function.
    7. in `aoptions` function - added two new examples concerning usage of `silent` and `repoDir` parameters in this function.
	4. Alterations in the text of: `?Tags`, `?Repository`, `?md5hash`, `archivist-package`, `?saveToRepo`, `loadFromRepo`, `summaryRepo`, `showRepo`, `?searchInRepo`, `?createEmptyRepo`, `?rmFromRepo`, `?deleteRepo`, `copyToRepo`, `zipRepo`, `setRepo`, `getTags`, `addTagsRepo`, `magrittr`, `archivistOptions`, `?aread` documentation pages.
	5. Adding missing functions which are used in the archivist package now to `?Repository` documentation page.
	6. `tempdir()` was replaced by `tempfile()` in examples sections of: `?addTagsRepo`, `?cache`, `copyToRepo`, `createEmptyRepo`, `?deleteRepo`, `loadFromRepo`, `?rmFromRepo`, `?saveToRepo`, `setRepo`, `showRepo`, `summaryRepo`, `?Tags`, `zipRepo` documentation pages. `tempdir` is existing  directory in which R works so calling `deleteRepo( exampleRepoDir, deleteRoot=TRUE)` removed important R files.
	7. New tests for the following functions: `zip*Repo`.
  8. In order to obtain cohesion with `Tags` in all functions there has been stated
such an order:
    1. If we use `Tags` in the text of function's documentation, examples' comments, then `Tags` are considered as a proper name and they begin with capital letter.
    2. If we use `tags` in function's body, as parameters, as R object's atrributes, then they begin with small letter.
  9. Added checking if parameters have appropriate lengths in the following function's bodies:
`?addTagsRepo`, `asearch`, `?cloneGithubRepo`, `copy*Repo`, `createEmptyLocalRepo`, `getTags*`, `loadFrom*Repo`, `?rmFromRepo`, `?saveToRepo`, `searchIn*Repo`, `set*Repo`, `?shinySearchInLocalRepo`, `showRepo`, `summary*Repo`, `zip*Repo`
    

archivist 1.7
----------------------------------------------------------------
	
* The order of parameters in asearch has changed!
* Added graphGallery for self-contained examples
* aread allows for single MD5 hash (which will be read from the default repo)
* asearch allows for only patterns (will be searched in local repo)
* ahistory has now 'artifact' argument instead of 'obj'

* Added tests.
* Removed unnecessary dependencies - now archivist is free of dependencies.
* shiny package is in Suggests so you
should load that package before running shinySearchInLocalRepo function.
* Moved `saveSetToRepo` with a new function `loadSetFromRepo` to the `github.com/pbiecek/archivist2` repository.

archivist 1.6
----------------------------------------------------------------
	
* Fix in aread(), now subdirectories are handled properly
* aoption() handles default values for archivist parameters
* createEmptyRepo() takes 'default' argument. If set to TRUE, then the new empty repo becomes the default one.
* Added CITATION
* Added new demo, as for JSS article replication script

archivist 1.5
----------------------------------------------------------------
	
	...should be updated...

archivist 1.4
----------------------------------------------------------------
	
	...should be updated...

archivist 1.3
----------------------------------------------------------------
	
* Added `setLocalRepo` and `setGithubRepo` functions.
...should be updated...
