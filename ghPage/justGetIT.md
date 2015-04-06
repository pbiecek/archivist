# Use case: how to get this object?
April 6, 2015  



# Archivist as an accessibility engine

The graph below presents the evolution of number of casualties in road accidents in selected european countries. The graph is based on data from eurostat.

<img src="justGetIT_files/figure-html/unnamed-chunk-3-1.png" title="" alt="" style="display: block; margin: auto;" />

Now consider two options:

1.  Would it be nice to have an R code that reproduces this plot? First, install all required packages, then connect to eurostat download data and finally creates this plot.
2.  Or would it be even nicer to download this plot directly as an R object?

It some cases one may just need to access the object / table / plot / statsitical model.

The archivist is package that allows to share, store, restore and look for R objects in local or github repositories.

The plot presented above is avaliable in my github repository `pbiecek/graphGallery` as an object with id `fcd70d55b874201d2bece12f591a2ec4`. How to access it?


```r
library(archivist)
pl <- loadFromGithubRepo( md5hash = "fcd70d55b874201d2bece12f591a2ec4" , 
                    user = "pbiecek", repo = "graphGallery", value=TRUE)
```

The object `pl` is ready to be plotted.

So it is easy to access objects created by others, but is it easy to make the object accessible?

Let's start with creation of an object that we would like to share.


```r
library(ggplot2)
library(dplyr)

if (!require(eurostat)) {
  library(devtools)
  install_github("rOpenGov/eurostat")
}
library(eurostat)
t1 <- get_eurostat("tsdtr420") %>% 
       filter(geo %in% c("UK", "SK", "FR", "PL", "ES", "PT", "LV"))
pl <- ggplot(t1, aes(x = time, y = values, color=geo, group=geo, shape=geo)) +
          geom_point(size=4) + 
          geom_line() + theme_bw() + ggtitle("People killed in road accidents")
```

Now let's prepare a local repository.


```r
createEmptyRepo("graphGallery", force = TRUE)
```

The function `saveToRepo` will save an object into the repository, extracts useful elements from the object (like the dataset) and save separatly plot and it's data in the repository. As an result it retuns keys / md5hashes of both objects.


```r
saveToRepo(pl, repoDir = "graphGallery")
```

```
[1] "e91db1eb357629115a5f64f8c0c067e8"
attr(,"data")
[1] "5fc61040fb6234899cbd5c05bba45022"
```
