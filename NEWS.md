archivist 1.8
----------------------------------------------------------------

* `checkDirectory` function is now immune to directories that don't exist. This made
`showLocalRepo` function working properly when passed an argument to the directory
that do not exist.
* Changed `dbDisconnect( conn )` call to the `on.exit(dbDisconnect( conn ))` in `executeSingleQuery` function to prevent a situation in which during an error inside a function (which might be produced), the connection stays open, when it shouldn`t.
* Added new `format` parameter so now `saveToRepo` and `%a%` can archive artifacts in `rdb/rdx` format. In future there are plans to rebuild `loadFrom*Repo` functions to load also `rdb/rdx` formats.
* `%a%` operator does react on `default = TRUE` in `createEmpyRepo` function.
* `print.ahistory` function can now print outputs of the artifact's history as the `knitr::kable` would.
* Examples for `searchInGithubRepo` now works for `user='pbiecek'` and `repo='archivist` parameters as we added new backpack.db file. The previous one was almost empty (for 7 months).
* Alterations in the text of `loadFromrepo` function
* Additional example in `loadFromRepo` function - Loading artifacts from the repository which is built in the archivist package and saving them on the example repository
* Alterations in the text of `summaryRepo` function

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
