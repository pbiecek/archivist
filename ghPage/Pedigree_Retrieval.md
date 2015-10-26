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
```

```
Directory Pedigree_Example did not exist. Forced to create a new directory.
```

```r
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
-> lm(Petal.Length ~ Species, data = .)  [990861c7c27812ee959f10e5f76fe2c3]
-> summary()                             [050e41ec3bc40b3004bc6bdd356acae7]
```


```r
# results='asis'
ahistory(artifact, aformat = "kable")
```

     call                                   md5hash                          
---  -------------------------------------  ---------------------------------
4    iris                                   ff575c261c949d073b2895b05d1097c3 
3    filter(Sepal.Length < 6)               d3696e13d15223c7d0bbccb33cc20a11 
2    lm(Petal.Length ~ Species, data = .)   990861c7c27812ee959f10e5f76fe2c3 
1    summary()                              050e41ec3bc40b3004bc6bdd356acae7 



