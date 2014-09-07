<!--
%\VignetteEngine{knitr::docco_linear}
%\VignetteIndexEntry{The archivist package compendium}
-->

# Archiving artifacts with their chaining code


The **archivist** package is very efficient and advantageous when the archived artifacts were created with a chaining code, offered by [dplyr](https://github.com/hadley/dplyr) package. It is higly useful because the origin of the artifact is archived, what means that the artifact can be easly reproduced and it's origin code is stored for future use.

Below are examples of creating artifacts with a chaining code, that requires using a `%>%` and  a `%.%` operators, offered by **dplyr** package.

Let us prepare a [**Repository**](https://github.com/pbiecek/archivist/wiki/archivist-package-Repository) where archived artifacts will be stored.

```r
library(devtools)
install_github("archivist", "pbiecek")
library(archivist)
exampleRepoDir <- getwd()
createEmptyRepo( exampleRepoDir )
```

Then one might create artifacts like those below. The code lines are ordered in chaining code, which will be used by `saveToRepo` function to store an artifact and archive it's origin code as a `name` of this artifact.

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
Here is an example of traditional `R` call and one that uses `chaining code` philosophy.

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

Many of various operations can be performed on a single `data.frame` before one consideres to archive this artifacts. The **archivist** guarantees that all of them will be `archived`, which means a code alone will no longer be needed to be stored in a separate file. The `CrimeStatebyState` data set can be downloaded from [here](https://github.com/MarcinKosinski/Museum).

```r
# example 3
crime.by.state <- read.csv("CrimeStatebyState.csv")
crime.by.state %.%
   filter(State=="New York", Year==2005) %.%
   arrange(desc(Count)) %.%
   select(Type.of.Crime, Count) %.%
   mutate(Proportion=Count/sum(Count)) %.%
   group_by(Type.of.Crime) %.%
   summarise(num.types = n(), counts = sum(Count)) %>%
   saveToRepo( exampleRepoDir )
```

```
[1] "09cbff009bfb9b8535f1bb65f5cdec1b"
```

Dozens of artifacts may now be stored in one, full of links **Repository**. Every of them
might have additional Tag specified by an user. This will simplify searching for this artifact in the future.

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

One might save artifact's [md5hash](https://github.com/pbiecek/archivist/wiki/archivist-package-md5hash) in case to check his origin stored in a [Tag](https://github.com/pbiecek/archivist/wiki/archivist-package---Tags)
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

After archiving all desired artifacts created with their chaining code, the summary of the **Repository** might be performed. Below is a single call of stored artifacts' names and the summary of the whole created **Repository** in this use case.


```r
# summary
showLocalRepo( exampleRepoDir )[, 2]
```

```
[1] "hflights %>% group_by(Year, Month, DayofMonth) %>% select(Year:DayofMonth,     ArrDelay, DepDelay) %>% summarise(arr = mean(ArrDelay, na.rm = TRUE),     dep = mean(DepDelay, na.rm = TRUE)) %>% filter(arr > 30 |     dep > 30)"                              
[2] "Batting %.% group_by(playerID) %.% summarise(total = sum(G)) %.%     arrange(desc(total)) %.% head(5)"                                                                                                                                                         
[3] "crime.by.state %.% filter(State == \"New York\", Year == 2005) %.%     arrange(desc(Count)) %.% select(Type.of.Crime, Count) %.%     mutate(Proportion = Count/sum(Count)) %.% group_by(Type.of.Crime) %.%     summarise(num.types = n(), counts = sum(Count))"
[4] "diamonds %.% group_by(cut, clarity, color) %.% summarize(meancarat = mean(carat,     na.rm = TRUE), ndiamonds = length(carat)) %>% head(10) %>%     `attr<-`(\"tags\", \"operations on diamonds\")"                                                            
[5] "mtcars %.% group_by(cyl, am) %.% select(mpg, cyl, wt, am) %.%     summarise(avgmpg = mean(mpg), avgwt = mean(wt)) %.% filter(avgmpg >     20)"                                                                                                                 
```

```r
summaryLocalRepo( exampleRepoDir )
```

```
Number of archived artifacts in the Repository:  5 
Number of archived datasets in the Repository:  0 
Number of various classes archived in the Repository: 
            Number
grouped_df      3
tbl_df          5
tbl             5
data.frame      5
Saves per day in the Repository: 
            Saves
2014-09-04     5
```

One can restore the origin of the artifact created in example 5.

```r
returnTagLocal( md5hash = hash, exampleRepoDir )
```

```
[1] "name:mtcars %.% group_by(cyl, am) %.% select(mpg, cyl, wt, am) %.%     summarise(avgmpg = mean(mpg), avgwt = mean(wt)) %.% filter(avgmpg >     20)"
```

There is always a way to restore the origin when one does not remember `md5hash` but remembers one or more `Tags` related to the artifact. As was shown in example 4, that artifact had special `Tag` named `operations on diamonds`. Easy `searchInLocalRepo` call can return `md5hash` of the artifact related to this `Tag`, and then the origin (saved as `name` `Tag`) can be restored.


```r
hash2 <- searchInLocalRepo( pattern = "operations on diamonds", exampleRepoDir )
returnTagLocal( md5hash = hash2, exampleRepoDir )
```

```
[1] "name:diamonds %.% group_by(cut, clarity, color) %.% summarize(meancarat = mean(carat,     na.rm = TRUE), ndiamonds = length(carat)) %>% head(10) %>%     `attr<-`(\"tags\", \"operations on diamonds\")"
```

It could also be done with chaining code sequence.

```r
"operations on diamonds" %>%
  searchInLocalRepo( exampleRepoDir ) %>%
  returnTagLocal( exampleRepoDir )
```

```
[1] "name:diamonds %.% group_by(cut, clarity, color) %.% summarize(meancarat = mean(carat,     na.rm = TRUE), ndiamonds = length(carat)) %>% head(10) %>%     `attr<-`(\"tags\", \"operations on diamonds\")"
```

<h5> Note. </h5>
- Note that the last operator should be `%>%` instead of `%.%`, if one urge to store the origin of the artifact.
- The `attr<-`("tags", "operations on diamonds") is the equivalent of `attr( "tags") <- "operations on diamonds"` but this form seem to not cooperate with `%>%` operator. Also the attributes might be set in chaining code using `setattr` from `data.table` package.


```r
iris %>% setattr(., "date", Sys.Date())
```





