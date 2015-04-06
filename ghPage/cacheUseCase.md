# Cache
April 6, 2015  

# Archivist as an caching engine

The archivist package allows to store, restore and look for R objects in repositories stored on hard disk. There are different strategies that can be used to find an object, through it's name, date of creation of meta data. The package is mainly designed as a repository of artifacts, but it can be used in different use-cases.

Let's see how it can be used as caching engine.

Let's consider a function with few arguments, which evaluation may takes a significant amount of time. If there is a chance that the function will be executed with same parameteres more than just one, it would be desireble to cache results to avoid unncessary evaluations.

Such cache can be easily constructed with the archivist package.

# Heavyweight function

Let's see an example. The ,,Heavyweight'' function `getMaxDistribution` summarizes the distribution of maximum from N draw of random variables from distribuition D with the use of R replications.


```r
getMaxDistribution <- function(D = rnorm, N = 10, R = 1000000) {
  res <- replicate(R, max(D(N)))
  summary(res)
}

system.time( getMaxDistribution(rnorm, 10) )
```

```
   user  system elapsed 
   6.77    0.07    6.88 
```

```r
system.time( getMaxDistribution(rexp, 20) )
```

```
   user  system elapsed 
   6.13    0.01    6.21 
```

```r
system.time( getMaxDistribution(rnorm, 10) )
```

```
   user  system elapsed 
   5.57    0.00    5.60 
```

Now, let's load the archivist package and prepare a repository for cached objects.

# Cache preparation

```r
if (!require(archivist)){
  library(devtools)
  install_github("pbiecek/archivist", build_vignettes=FALSE)
}
library(archivist)
library(digest)


# this function is also included in the archivist package
cache <- function(cacheRepo, FUN, ...) {
  tmpl <- list(...)
  tmpl$.FUN <- FUN
  outputHash <- digest(tmpl)
  isInRepo <- searchInLocalRepo(paste0("cacheId:", outputHash), cacheRepo)
  if (length(isInRepo) > 0)
    return(loadFromLocalRepo(isInRepo[1], repoDir = cacheRepo, value = TRUE))
  
  output <- do.call(FUN, list(...))
  attr( output, "tags") <- paste0("cacheId:", outputHash)
  attr( output, "call") <- ""
  saveToRepo(output, repoDir = cacheRepo, archiveData = TRUE, archiveMiniature = FALSE, rememberName = FALSE)
  output
}

cacheRepo <- tempdir()
createEmptyRepo( cacheRepo )
```

# How to work with cache

The `cacheRepo` is a folder with already evaluated function calls. 
How to use it?


```r
system.time( cache(cacheRepo, getMaxDistribution, rnorm, 10) )
```

```
   user  system elapsed 
   6.85    0.05    6.94 
```

```r
system.time( cache(cacheRepo, getMaxDistribution, rexp, 10) )
```

```
   user  system elapsed 
   5.89    0.00    5.93 
```

```r
system.time( cache(cacheRepo, getMaxDistribution, rnorm, 10) )
```

```
   user  system elapsed 
      0       0       0 
```

The second evaluation of `getMaxDistribution` is much, much faster. Results are just read from disk.

# How the `cache` function works?

It create a md5 signature of the function FUN and it's arguments and use this signature as a key.
If such key is present in the cache repository, then the object is just restored.
If it's not present then the call is evaluated and result is stored.
Note that, if `cacheRepo` is a shared folder, then you get a shared cache repository!
