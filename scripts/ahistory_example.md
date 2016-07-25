# restoring artifact's pedigree from remote Repository
Marcin Kosiński  
2016-25-07  



# Setting for Repository creation


```r
library(archivist.github)
load('github_token.rda')
load('password.rda')
aoptions("github_token", github_token)
```

```
<Token>
<oauth_endpoint>
 authorize: https://github.com/login/oauth/authorize
 access:    https://github.com/login/oauth/access_token
<oauth_app> github
  key:    dba54f063bab892a9123
  secret: <hidden>
<credentials> access_token, scope, token_type
---
```

```r
aoptions("user", 'MarcinKosinski')
```

```
[1] "MarcinKosinski"
```

```r
invisible(aoptions("password", password))
```




# Repository creation


```r
createGitHubRepo(repo = "ahistory_example", user = "archivistR", default = TRUE) 
```

```
[1] "archivistR"
```

# Artifact's archiving


```r
library(dplyr)
iris %a%
filter(Sepal.Length < 6) %a%
 lm(Petal.Length~Species, data=.) %a%
 summary() -> artifact
```

# Pushing locally archived partial results to GitHub



```r
pushGitHubRepo()
```

# Using ahistory() to get artifact's pedigree from remote Repository


```r
# results='asis'
Sys.sleep(120)
# be sure that GitHub API is aware of past commits
ahistory(
	md5hash = paste0('archivistR/ahistory_example/', 
				 digest::digest(artifact)),
	format = 'kable',
	alink = TRUE)
```

     call                                   md5hash                                                                                                                                               
---  -------------------------------------  ------------------------------------------------------------------------------------------------------------------------------------------------------
4    env[[nm]]                              [ff575c261c949d073b2895b05d1097c3](https://raw.githubusercontent.com/archivistR/ahistory_example/master/gallery/ff575c261c949d073b2895b05d1097c3.rda) 
3    filter(Sepal.Length < 6)               [d3696e13d15223c7d0bbccb33cc20a11](https://raw.githubusercontent.com/archivistR/ahistory_example/master/gallery/d3696e13d15223c7d0bbccb33cc20a11.rda) 
2    lm(Petal.Length ~ Species, data = .)   [802857dee508b128b26564e6b9519bb1](https://raw.githubusercontent.com/archivistR/ahistory_example/master/gallery/802857dee508b128b26564e6b9519bb1.rda) 
1    summary()                              [4e34b66ecaa7fc9f13c2aad4edd042f8](https://raw.githubusercontent.com/archivistR/ahistory_example/master/gallery/4e34b66ecaa7fc9f13c2aad4edd042f8.rda) 



```r
# results='asis'
ahistory(
	md5hash = paste0('archivistR/ahistory_example/', 
				 digest::digest(artifact)),
	format = 'kable')
```

     call                                   md5hash                          
---  -------------------------------------  ---------------------------------
4    env[[nm]]                              ff575c261c949d073b2895b05d1097c3 
3    filter(Sepal.Length < 6)               d3696e13d15223c7d0bbccb33cc20a11 
2    lm(Petal.Length ~ Species, data = .)   802857dee508b128b26564e6b9519bb1 
1    summary()                              4e34b66ecaa7fc9f13c2aad4edd042f8 


```r
ahistory(
	md5hash = paste0('archivistR/ahistory_example/', 
				 digest::digest(artifact)),
	format = 'regular')
```

```
   env[[nm]]                             [ff575c261c949d073b2895b05d1097c3]
-> filter(Sepal.Length < 6)              [d3696e13d15223c7d0bbccb33cc20a11]
-> lm(Petal.Length ~ Species, data = .)  [802857dee508b128b26564e6b9519bb1]
-> summary()                             [4e34b66ecaa7fc9f13c2aad4edd042f8]
```


# Show remote Repository


```r
showRemoteRepo()
```

```
                            md5hash                             name         createdDate
1  ff575c261c949d073b2895b05d1097c3                        env[[nm]] 2016-07-25 19:35:55
2  dfd51b493776e1a7b658a259a70d9b95 dfd51b493776e1a7b658a259a70d9b95 2016-07-25 19:35:55
3  d3696e13d15223c7d0bbccb33cc20a11                          res_val 2016-07-25 19:35:55
4  fefbd488d649c237ccf6af2a54c40ebb fefbd488d649c237ccf6af2a54c40ebb 2016-07-25 19:35:55
5  d3696e13d15223c7d0bbccb33cc20a11                        env[[nm]] 2016-07-25 19:35:55
6  fefbd488d649c237ccf6af2a54c40ebb fefbd488d649c237ccf6af2a54c40ebb 2016-07-25 19:35:55
7  802857dee508b128b26564e6b9519bb1                          res_val 2016-07-25 19:35:55
8  fefbd488d649c237ccf6af2a54c40ebb fefbd488d649c237ccf6af2a54c40ebb 2016-07-25 19:35:55
9  802857dee508b128b26564e6b9519bb1                        env[[nm]] 2016-07-25 19:35:55
10 fefbd488d649c237ccf6af2a54c40ebb fefbd488d649c237ccf6af2a54c40ebb 2016-07-25 19:35:55
11 4e34b66ecaa7fc9f13c2aad4edd042f8                          res_val 2016-07-25 19:35:55
12 fefbd488d649c237ccf6af2a54c40ebb fefbd488d649c237ccf6af2a54c40ebb 2016-07-25 19:35:56
```


