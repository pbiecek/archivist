# Archiving sets: artifacts, data and functions
April 7, 2015  



Let's prepare some set to be archived.

```r
library(ggplot2)
library(ggthemes)
library(archivist)
createEmptyRepo( "SETS" )
```

```
Directory SETS did not exist. Forced to create a new directory.
```

```r
setLocalRepo( "SETS" )
data(iris)

plotArtifact <- ggplot( iris, aes(x = Sepal.Length, y = Species)) +
  geom_point()+
  theme_wsj()

plotData <- iris
plotFunctions <- list( ggplot, geom_point, theme_wsj)
```

Such set now can be archived using `saveSetToRepo` function

```r
saveSetToRepo( artifact = plotArtifact,
                           data = plotData,
                           functions = plotFunctions)
```

```
[1] "f0745effbbedbf160243a154c6339574"
attr(,"data")
[1] "ff575c261c949d073b2895b05d1097c3"
```

# Description

`saveSetToRepo` function saves desired set of artifacts to the local `Repository` in a given directory.
To learn more about artifacts visit [http://pbiecek.github.io/archivist/](http://pbiecek.github.io/archivist/). 
Set is a collection containing

- an artifact,
- data needed to create the artifact,
- list of functions needed to create the artifact.

# Details
`saveSetToRepo` archives `artifact`, `data` and `functions` using `saveToRepo` function but additionally it adds `Tags` to every part of a set in convention as: `set:md5hashOfArtifact` to remember
 that all objects came originally from one set. This additional tag helps to restore a set from a `Repository`.

# Value
 As a result of this function a character strings is returned, which determines
the `md5hash` of the archived artifact.


# Some technical solutions

`saveSetToRepo` uses `saveToRepo` function so normally names of elements of a set can not be archived as a `name` tag. The names of all archived elements from a set are archived under tag named `set:name:` .

## showLocalRepo

One can check archived elements that come only from sets.


```r
showLocalRepo(method = "sets")
```

```
                           artifact                                  tag         createdDate
1  f0745effbbedbf160243a154c6339574                  labelx:Sepal.Length 2015-04-07 13:49:58
2  f0745effbbedbf160243a154c6339574                       labely:Species 2015-04-07 13:49:58
3  f0745effbbedbf160243a154c6339574                             class:gg 2015-04-07 13:49:58
4  f0745effbbedbf160243a154c6339574                         class:ggplot 2015-04-07 13:49:58
5  f0745effbbedbf160243a154c6339574                        name:artifact 2015-04-07 13:49:58
6  f0745effbbedbf160243a154c6339574             date:2015-04-07 13:49:58 2015-04-07 13:49:58
7  f0745effbbedbf160243a154c6339574                set:name:plotArtifact 2015-04-07 13:49:58
9  69f23bff4eb9f96d6dc971379df9d400                            name:data 2015-04-07 13:49:59
10 69f23bff4eb9f96d6dc971379df9d400                 varname:Sepal.Length 2015-04-07 13:49:59
11 69f23bff4eb9f96d6dc971379df9d400                  varname:Sepal.Width 2015-04-07 13:49:59
12 69f23bff4eb9f96d6dc971379df9d400                 varname:Petal.Length 2015-04-07 13:49:59
13 69f23bff4eb9f96d6dc971379df9d400                  varname:Petal.Width 2015-04-07 13:49:59
14 69f23bff4eb9f96d6dc971379df9d400                      varname:Species 2015-04-07 13:49:59
15 69f23bff4eb9f96d6dc971379df9d400                     class:data.frame 2015-04-07 13:49:59
16 69f23bff4eb9f96d6dc971379df9d400             date:2015-04-07 13:49:59 2015-04-07 13:49:59
17 69f23bff4eb9f96d6dc971379df9d400 set:f0745effbbedbf160243a154c6339574 2015-04-07 13:49:59
18 69f23bff4eb9f96d6dc971379df9d400                    set:name:plotData 2015-04-07 13:49:59
19 80ee573c22a4bf8801e345e480315466                       name:functions 2015-04-07 13:49:59
20 80ee573c22a4bf8801e345e480315466                           class:list 2015-04-07 13:49:59
21 80ee573c22a4bf8801e345e480315466             date:2015-04-07 13:49:59 2015-04-07 13:49:59
22 80ee573c22a4bf8801e345e480315466 set:f0745effbbedbf160243a154c6339574 2015-04-07 13:49:59
23 80ee573c22a4bf8801e345e480315466               set:name:plotFunctions 2015-04-07 13:49:59
```


## loadSetFromLocalRepo

Having a tag named `set:name` and a tag named `set` that specify to which artifacts this element is linked one can restore already archived set with `loadSetFromLocalRepo` function (not yet in the **archivist** package) by giving artifact's `md5hash` that is an output of a `saveSetToRepo` function.


```r
loadSetFromLocalRepo <- function( md5hash, repoDir = NULL ){
  
  stopifnot( is.character( md5hash ), length( md5hash ) == 1 )
  
  # get hashes
  artifactHash <- md5hash
  SetElementsHashes <- searchInLocalRepo( paste0("set:", md5hash ), fixed = FALSE,
                                          repoDir = repoDir) 
  
  # get names
  artifactName <- getTagsLocal( artifactHash, tag="set:name", repoDir = repoDir)
  artifactName <- sub(x = artifactName, pattern = "set:name:", replacement = "")
  
  SetElementsNames <- sapply( SetElementsHashes, function( element ){
    nameElem <- getTagsLocal( md5hash = element, tag="set:name", repoDir = repoDir)
    sub(x = nameElem, pattern = "set:name:", replacement = "")
  })
  
  
  # assign artifact
  assign( x = artifactName, value = loadFromLocalRepo(artifactHash, repoDir = repoDir, value = TRUE), 
          envir = parent.frame(1))
  # assign elements of a set
  for( i in seq_along(SetElementsNames)){
    assign( x = SetElementsNames[i], value = loadFromLocalRepo(SetElementsHashes[i], repoDir = repoDir, value = TRUE), 
            envir = parent.frame(1))
  }
  
}
```

# Example

For archived set, let's remove the set from global environment and then let's load a set from **Repository**


```r
ls()
```

```
[1] "iris"                 "loadSetFromLocalRepo" "plotArtifact"         "plotData"             "plotFunctions"       
```

```r
rm( list = c("plotData", "plotFunctions", "plotArtifact") )
ls()
```

```
[1] "iris"                 "loadSetFromLocalRepo"
```

```r
loadSetFromLocalRepo("f0745effbbedbf160243a154c6339574")
ls()
```

```
[1] "iris"                 "loadSetFromLocalRepo" "plotArtifact"         "plotData"             "plotFunctions"       
```

