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
# convert .RData -> .rdb/.rdx
lazyLoad = local({load("Huge.RData"); environment()})
tools:::makeLazyLoadDB(lazyLoad, "Huge")
```

Loading the DB then only loads the index but not the contents. The contents are loaded as they are used.

```r
# lazyLoad("New")
# ls()
# x
```

<img src="ex1.JPG" width="200px" height="200px" />



