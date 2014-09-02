A set of tools for datasets and plots archivisation
=====================================================

Project is supported by [Travis CI](https://travis-ci.org/).
[![Build Status](https://api.travis-ci.org/pbiecek/archivist.png)](https://travis-ci.org/pbiecek/archivist)
[![Stories in Ready](https://badge.waffle.io/pbiecek/archivist.png?label=READY)](http://waffle.io/pbiecek/archivist)


### Please see the  [archivist wiki](https://github.com/pbiecek/archivist/wiki) for information. 


<h5> Installing archivist package: </h5>
To get started, install the latest version of **archivist** from CRAN:
```{Ruby}
install.packages("archivist")
```
or use:
```{Ruby}
if (!require(devtools)) {
    install.packages("devtools")
    require(devtools)
}
install_github("pbiecek/archivist")
```
Make sure you have [rtools](http://cran.r-project.org/bin/windows/Rtools/) installed on your computer.

<h5> The list of available functions: </h5>
```{Ruby}
help(package="archivist")
```
<h5> The list of use-cases: </h5>

<a href="https://rawgit.com/pbiecek/archivist/master/vignette/cacheUseCase.html">Cache with the archivist package</a>
[Archiving artifacts with their chaining code.](https://rawgit.com/MarcinKosinski/Museum/master/chaining.html)

<h5> Authors of the project: </h5>
> Przemysław Biecek, przemyslaw.biecek@gmail.com
>
> Marcin Kosiński, m.p.kosinski@gmail.com
