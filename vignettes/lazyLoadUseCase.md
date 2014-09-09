<!--
%\VignetteEngine{knitr::docco_classic}
%\VignetteIndexEntry{Lazy load}
-->

# Lazy load with **archivist**
> You can adjust the widths of the two columns using your cursor. What is more, press `T` on your keyboard, and see what happens.

Having problem with a too big `.Rdata` file? Interested only in a few objects from a huge `.Rdata` file?
Regular `load()` into Global Environment takes too long or crashes R session? Want to load or copy an object you don't remember name?

**If you stacked with those questions, this use case is a must read for you.**

The **archivist** package is a great solution that helps administrate, archive and restore your [artifacts](https://github.com/pbiecek/archivist/wiki) created in [R](http://cran.r-project.org/) package.

```r
library(devtools)
install_github("archivist", "pbiecek")
library(archivist)
library(tools)
```

## Combining **archivist** and lazy load may be miraculous

If your `.RData` file is too big and you do not need or do not want to load whole of it, you can simply convert the `.RData` file into a lazy-load database which serializes each entry separately and creates an index. The nice thing is that the loading will be on-demand.


```r
file.info("Huge.RData")$size
```

```
[1] 6040159
```

```r
# convert .RData -> .rdb/.rdx
lazyLoad = local({load("Huge.RData"); environment()})
tools:::makeLazyLoadDB(lazyLoad, "Huge")
```

Loading the DB then only loads the index but not the contents. The contents are loaded as they are used.

```r
lazyLoad("Huge")
```

```
NULL
```

```r
ls()[1:5] ## there is a great number of objects
```

```
[1] "cache"          "cacheRepo"      "crime.by.state" "exampleRepoDir"
[5] "games"         
```

Now you can create your own local **archivist**-like [Repository](https://github.com/pbiecek/archivist/wiki/archivist-package-Repository) which will make maintainig artifacts as easy as possible.

```r
DIRectory <- getwd()
createEmptyRepo( DIRectory )
```
Then objects from `Huge.RData` file may be archived into **Repository** created in `DIRectory` directory.

```r
sapply( ls(), function(x){
  y <- get(x, envir = lazyLoad)
  saveToRepo(y, repoDir = DIRectory ) } )[1:5]
```

```
Error: nie znaleziono obiektu 'DIRectory'
```

You can check the summary of **Repository** using `summaryLocalRepo()` function.

```r
summaryLocalRepo( DIRectory )
```

```
Number of archived artifacts in the Repository:  3 
Number of archived datasets in the Repository:  0 
Number of various classes archived in the Repository: 
            Number
function        1
character       1
data.frame      1
Saves per day in the Repository: 
            Saves
2014-09-09     3
```


<img src="ex1.JPG" width="200px" height="200px" />



