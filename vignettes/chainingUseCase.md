<!--
%\VignetteEngine{knitr::docco_linear}
%\VignetteIndexEntry{The archivist package compendium}
-->

# Archiving artifacts with their chaining code


The **archivist** package is very efficient and advantageous when the archived artifacts were created with a chaining code offered by the [dplyr](https://github.com/hadley/dplyr) package. It is higly useful because the origin of the artifact is archived, which means that the artifact can be easly reproduced and it's origin code is stored for future use.

Below are examples of creating artifacts with a chaining code, that requires using a `%>%` and  a `%.%` operators, offered by the **dplyr** package.

Let us prepare a [**Repository**](https://github.com/pbiecek/archivist/wiki/archivist-package-Repository) where archived artifacts will be stored.

```r
library(devtools)
install_github("archivist", "pbiecek")
library(archivist)
exampleRepoDir <- getwd()
createEmptyRepo( exampleRepoDir )
```

Then one might create artifacts like those below. The code lines are ordered in chaining code, which will be used by the `saveToRepo` function to store an artifact and archive it's origin code as a `name` of this artifact.

```r
# example 1
library(dplyr)

data("hflights", package = "hflights")
hflights %>%
   group_by(Year, Month, DayofMonth) %>%
   select(Year:DayofMonth, ArrDelay, DepDelay) %>%
   summarise(
      arr = mean(ArrDelay, na.rm = TRUE),
      dep = mean(DepDelay, na.rm = TRUE)
   ) %>%
   filter(arr > 30 | dep > 30) %>%
   saveToRepo( exampleRepoDir )  
```

```
[1] "9013563d1069359f9b7d7a49c49b0a1f"
```

One may see a vast difference in code evalution when using chaining code.
Here is an example of a traditional `R` call and one that uses the `chaining code` philosophy.

```r
# example 2
library(Lahman)

# Traditional R code
players <- group_by(Batting, playerID)
games <- summarise(players, total = sum(G))
head(arrange(games, desc(total)), 5)
```

```
Source: local data frame [5 x 2]

   playerID total
1  rosepe01  3562
2 yastrca01  3308
3 aaronha01  3298
4 henderi01  3081
5  cobbty01  3035
```

```r
# Corresponding chaining code
Batting %.%
   group_by(playerID) %.%
   summarise(total = sum(G)) %.%
   arrange(desc(total)) %.%
   head(5) %>%
   saveToRepo( exampleRepoDir )
```

```
[1] "6defe8a423a1363463a3ed98435c02e8"
```

Many of various operations can be performed on a single `data.frame` before one consideres to archive these artifacts. **Archivist** guarantees that all of them will be `archived`, which means a code alone will no longer be needed to be stored in a separate file. Also an artifact may be saved during operations are performed and used in further code evaluations. This can be done when
argument \code{chain = TRUE} in `saveToRepo` is specified.

```r
# example 3
crime.by.state <- read.csv("CrimeStatebyState.csv")
crime.by.state %.%
   filter(State=="New York", Year==2005) %.%
   arrange(desc(Count)) %.%
   select(Type.of.Crime, Count) %.%
   mutate(Proportion=Count/sum(Count)) %>%
   saveToRepo( exampleRepoDir, chain = TRUE) %>%
   group_by(Type.of.Crime) %.%
   summarise(num.types = n(), counts = sum(Count)) %>%
   saveToRepo( exampleRepoDir )
```

```
[1] "09cbff009bfb9b8535f1bb65f5cdec1b"
```

The `CrimeStatebyState` data set can be downloaded from [here](https://github.com/MarcinKosinski/Museum).

Dozens of artifacts may now be stored in one **Repository**. Every artifact
may have an additional Tag specified by an user. This will simplify searching for this artifact in the future.

```r
# example 4
library(ggplot2)

diamonds %.% 
   group_by(cut, clarity, color) %.%  
   summarize(
      meancarat = mean(carat, na.rm = TRUE), 
      ndiamonds = length(carat)
   ) %>%
   head( 10) %>%
   `attr<-`("tags", "operations on diamonds") %>%
   saveToRepo( exampleRepoDir )
```

```
[1] "d68774d04b8b2a2c608cf68216d00cc6"
```

One can also save artifact's [md5hash](https://github.com/pbiecek/archivist/wiki/archivist-package-md5hash) if there is a need check its origin, which is stored in a [Tag](https://github.com/pbiecek/archivist/wiki/archivist-package---Tags)
named `name`.

```r
# example 5
data(mtcars)
hash <- mtcars %.% 
   group_by(cyl, am) %.%
   select(mpg, cyl, wt, am) %.%
   summarise(avgmpg = mean(mpg), avgwt = mean(wt)) %.%
   filter(avgmpg > 20) %>%
   saveToRepo( exampleRepoDir )
```

### Summary of the Repository
After archiving all desired artifacts created with their chaining code, the summary of the **Repository** might be performed. Below is a single call of stored artifacts' names and the summary of the whole created **Repository** in this use case.


```r
# summary
showLocalRepo( exampleRepoDir )[, 2]
```

```
[1] "hflights %>% group_by(Year, Month, DayofMonth) %>% select(Year:DayofMonth,     ArrDelay, DepDelay) %>% summarise(arr = mean(ArrDelay, na.rm = TRUE),     dep = mean(DepDelay, na.rm = TRUE)) %>% filter(arr > 30 |     dep > 30)"                                                                               
[2] "Batting %.% group_by(playerID) %.% summarise(total = sum(G)) %.%     arrange(desc(total)) %.% head(5)"                                                                                                                                                                                                          
[3] "crime.by.state %.% filter(State == \"New York\", Year == 2005) %.%     arrange(desc(Count)) %.% select(Type.of.Crime, Count) %.%     mutate(Proportion = Count/sum(Count))"                                                                                                                                     
[4] "crime.by.state %.% filter(State == \"New York\", Year == 2005) %.%     arrange(desc(Count)) %.% select(Type.of.Crime, Count) %.%     mutate(Proportion = Count/sum(Count)) %>% saveToRepo(exampleRepoDir,     chain = TRUE) %>% group_by(Type.of.Crime) %.% summarise(num.types = n(),     counts = sum(Count))"
[5] "diamonds %.% group_by(cut, clarity, color) %.% summarize(meancarat = mean(carat,     na.rm = TRUE), ndiamonds = length(carat)) %>% head(10) %>%     `attr<-`(\"tags\", \"operations on diamonds\")"                                                                                                             
[6] "mtcars %.% group_by(cyl, am) %.% select(mpg, cyl, wt, am) %.%     summarise(avgmpg = mean(mpg), avgwt = mean(wt)) %.% filter(avgmpg >     20)"                                                                                                                                                                  
```

```r
summaryLocalRepo( exampleRepoDir )
```

```
Number of archived artifacts in the Repository:  6 
Number of archived datasets in the Repository:  0 
Number of various classes archived in the Repository: 
            Number
grouped_df      3
tbl_df          5
tbl             5
data.frame      6
Saves per day in the Repository: 
            Saves
2014-09-08     6
```

### Restoring origin code
One can restore the origin of the artifact created in example 5.

```r
getTagsLocal( md5hash = hash, exampleRepoDir )
```

```
[1] "name:mtcars %.% group_by(cyl, am) %.% select(mpg, cyl, wt, am) %.%     summarise(avgmpg = mean(mpg), avgwt = mean(wt)) %.% filter(avgmpg >     20)"
```

There is always a way to restore the origin code when one does not remember `md5hash` but remembers one or more `Tags` related to the artifact. As was shown in example 4, that artifact had special `Tag` named `operations on diamonds`. An easy `searchInLocalRepo` call can return `md5hash` of the artifact related to this `Tag`, so that now the origin code (saved as `name` `Tag`) can be restored.


```r
hash2 <- searchInLocalRepo( pattern = "operations on diamonds", exampleRepoDir )
getTagsLocal( md5hash = hash2, exampleRepoDir )
```

```
[1] "name:diamonds %.% group_by(cut, clarity, color) %.% summarize(meancarat = mean(carat,     na.rm = TRUE), ndiamonds = length(carat)) %>% head(10) %>%     `attr<-`(\"tags\", \"operations on diamonds\")"
```

The above result can also be achieved with a chaining code sequence.

```r
"operations on diamonds" %>%
  searchInLocalRepo( exampleRepoDir ) %>%
  getTagsLocal( exampleRepoDir )
```

```
[1] "name:diamonds %.% group_by(cut, clarity, color) %.% summarize(meancarat = mean(carat,     na.rm = TRUE), ndiamonds = length(carat)) %>% head(10) %>%     `attr<-`(\"tags\", \"operations on diamonds\")"
```

### Note
- Note that the last operator should be `%>%` instead of `%.%`, if one needs to store the origin code of the artifact.
- The `attr<-`("tags", "operations on diamonds") is the equivalent of `attr( "tags") <- "operations on diamonds"` but this form seems to not cooperate with the `%>%` operator. Also the attributes may be set in the chaining code using `setattr` from the `data.table` package.


```r
iris %>% setattr(., "date", Sys.Date())
```





