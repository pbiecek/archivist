<!--
%\VignetteEngine{knitr::docco_classic}
%\VignetteIndexEntry{Lazy load}
-->

# Lazy load with **archivist**
> You can adjust the widths of the two columns using your cursor. What is more, press `T` on your keyboard, and see what happens.

<img src="fig11.jpg" width="250px" height="180px" align="right" />
Having problem with a too big `.Rdata` file? Interested only in a few objects from a huge `.Rdata` file?
Regular `load()` into Global Environment takes too long or crashes R session? Want to load or copy an object you don't remember name? Maintaing environment with thousands of objects became perplexing and troublesome  

**If you stacked with those questions, this use case is a must read for you.**

The **archivist** package is a great solution that helps administrate, archive and restore your [artifacts](https://github.com/pbiecek/archivist/wiki) created in [R](http://cran.r-project.org/) package.

```r
library(devtools)
if (!require(archivist)) install_github("archivist", "pbiecek")
library(tools)
```

## Combining **archivist** and lazy load may be miraculous

If your `.RData` file is too big and you do not need or do not want to load whole of it, you can simply convert the `.RData` file into a lazy-load database which serializes each entry separately and creates an index. The nice thing is that the loading will be on-demand.


```r
# convert .RData -> .rdb/.rdx
lazyLoad = local({load("Huge.RData"); environment()})
tools:::makeLazyLoadDB(lazyLoad, "Huge")
```

Loading the database then only loads the index but not the contents. The contents are loaded as they are used.

```r
lazyLoad("Huge")
objNames <- ls() ## 234 objects
```

Now you can create your own local **archivist**-like [Repository](https://github.com/pbiecek/archivist/wiki/archivist-package-Repository) which will make maintainig artifacts as easy as possible.

```r
DIRectory <- getwd()
createEmptyRepo( DIRectory )
```
Then objects from `Huge.RData` file may be archived into **Repository** created in `DIRectory` directory. The attribute `tags` (see [Tags](https://github.com/pbiecek/archivist/wiki/archivist-package---Tags)) spicified as `realName` is added to the every  artifact before `saveToRepo()` call, in case to remeber its name in **Repository**.



```r
lapply( as.list(objNames[-208]), function(x){
  y <- get( x, envir = lazyLoad )
  attr(y, "tags") <- paste0("realName: ", x)
  saveToRepo( y, repoDir = DIRectory )
  } )[1:2]
```

```
[[1]]
[1] "7754f8ec2eca40cba05e22a71e933c28"

[[2]]
[1] "ea36e8ee461e2e87477a27face48de21"
```

You can check the summary of **Repository** using `summaryLocalRepo()` function.

```r
summaryLocalRepo( DIRectory )
```

```
Number of archived artifacts in the Repository:  233 
Number of archived datasets in the Repository:  11 
Number of various classes archived in the Repository: 
               Number
character          8
data.frame        51
function          19
performance        3
coxph             11
cox.zph            3
numeric           43
survfitms          1
survfit            4
matrix             7
cuminc             2
integer           18
glm                2
lm                 4
list              20
coxph.penal        4
coxph.null         1
kmeans             1
logical            7
factor             5
environment        1
loess              3
lda                2
svm.formula        1
svm                1
agnes              2
twins              2
prcomp             3
prediction         1
smooth.spline      3
table              2
survdiff           2
gg                 7
ggplot             7
Saves per day in the Repository: 
            Saves
2014-09-09   244
```





