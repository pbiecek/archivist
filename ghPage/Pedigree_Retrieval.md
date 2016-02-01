# Retrieval of the Artifact’s Pedigree
Marcin Kosinski  
`r Sys.Date()`  




### Motivation

In the archivist, when possible, objects are stored with instructions (function calls) used for
their creation. Having such trace at our disposal, it is easier to recreate objects or check how
they were created.
The archivist provides a new operator `%a%`, which works as the extended pipe operator `%>%` from
the [magrittr](https://cran.r-project.org/web/packages/magrittr/index.html) package. In addition, it saves
the resulting object to the default archivist repository together with the function call and its
parameters. 

### Repository Preparations


```r
library(archivist)
createEmptyRepo("Pedigree_Example", default = TRUE)
invisible(aoptions("silent", TRUE))
```

### Archiving Example

Let us consider the following example.



```r
library(dplyr)
iris %a%
filter(Sepal.Length < 6) %a%
 lm(Petal.Length~Species, data=.) %a%
 summary() -> artifact
```

### Pedigree Retrieval


```r
ahistory(artifact)
```

```
   iris                                  [ff575c261c949d073b2895b05d1097c3]
-> filter(Sepal.Length < 6)              [d3696e13d15223c7d0bbccb33cc20a11]
-> lm(Petal.Length ~ Species, data = .)  [6776c3a99b5946919800a99355814d24]
-> summary()                             [591fad1bb4a61ddd5458c1c84926f7da]
```


```r
# results='asis'
ahistory(artifact, format = "kable")
```

     call                                   md5hash                          
---  -------------------------------------  ---------------------------------
4    iris                                   ff575c261c949d073b2895b05d1097c3 
3    filter(Sepal.Length < 6)               d3696e13d15223c7d0bbccb33cc20a11 
2    lm(Petal.Length ~ Species, data = .)   6776c3a99b5946919800a99355814d24 
1    summary()                              591fad1bb4a61ddd5458c1c84926f7da 

#### With hooks

Supposing those artifacts exist on a GitHub repository

```r
# results='asis'
ahistory(artifact, format = "kable", repoDir = "Pedigree_Example", alink = TRUE,
         user = "MarcinKosinski", repo = "Museum")
```

     call                                   md5hash                                                                                                                                        
---  -------------------------------------  -----------------------------------------------------------------------------------------------------------------------------------------------
4    iris                                   [ff575c261c949d073b2895b05d1097c3](https://github.com/MarcinKosinski/Museum/blob/master/gallery/ff575c261c949d073b2895b05d1097c3.rda?raw=true) 
3    filter(Sepal.Length < 6)               [d3696e13d15223c7d0bbccb33cc20a11](https://github.com/MarcinKosinski/Museum/blob/master/gallery/d3696e13d15223c7d0bbccb33cc20a11.rda?raw=true) 
2    lm(Petal.Length ~ Species, data = .)   [6776c3a99b5946919800a99355814d24](https://github.com/MarcinKosinski/Museum/blob/master/gallery/6776c3a99b5946919800a99355814d24.rda?raw=true) 
1    summary()                              [591fad1bb4a61ddd5458c1c84926f7da](https://github.com/MarcinKosinski/Museum/blob/master/gallery/591fad1bb4a61ddd5458c1c84926f7da.rda?raw=true) 


