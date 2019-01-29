[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/archivist)](https://cran.r-project.org/package=archivist)
[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.47154.svg)](http://dx.doi.org/10.5281/zenodo.47154)
[![Downloads](http://cranlogs.r-pkg.org/badges/archivist)](http://cran.rstudio.com/package=archivist)
[![Total Downloads](http://cranlogs.r-pkg.org/badges/grand-total/archivist?color=orange)](http://cranlogs.r-pkg.org/badges/grand-total/archivist)

[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Build Status](https://api.travis-ci.org/pbiecek/archivist.png)](https://travis-ci.org/pbiecek/archivist)
[![Github Issues](http://githubbadges.herokuapp.com/pbiecek/archivist/issues.svg)](https://github.com/pbiecek/archivist/issues)
[![Coverage coveralls](https://coveralls.io/repos/pbiecek/archivist/badge.svg)](https://coveralls.io/r/pbiecek/archivist)
[![Coverage codecov](https://img.shields.io/codecov/c/github/pbiecek/archivist/master.svg)](https://codecov.io/github/pbiecek/archivist?branch=master)

A set of tools for datasets and plots archiving
=====================================================

Everything that exists in *R* is an object.
`archivist` is an R package that stores copies of all objects along with their metadata. It helps to manage and recreate objects with final or partial results from data analysis.

Use the `archivist` to record every result, to share these results with future you or with others, to search through repository of objects created in the past but needed now.

## Installation

To get started, install the latest version of **archivist** from CRAN:

```{Ruby}
install.packages("archivist")
```

or from GitHub:

```{Ruby}
devtools::install_github("pbiecek/archivist")
```

## Cheatsheet 

![The cheatsheet](https://github.com/pbiecek/archivist/raw/master/cheatsheets/archivistCheatsheet.png)

## Citation 

To cite the `archivist` in publications please use:

```
Biecek P and Kosinski M (2017). “archivist: An R Package for Managing,
Recording and Restoring Data Analysis Results.” _Journal of Statistical
Software_, *82*(11), pp. 1-28. doi: 10.18637/jss.v082.i11 (URL:
http://doi.org/10.18637/jss.v082.i11).

A BibTeX entry for LaTeX users is

  @Article{,
    title = {{archivist}: An {R} Package for Managing, Recording and Restoring Data Analysis Results},
    author = {Przemyslaw Biecek and Marcin Kosinski},
    journal = {Journal of Statistical Software},
    year = {2017},
    volume = {82},
    number = {11},
    pages = {1--28},
    doi = {10.18637/jss.v082.i11},
  }
```

## Misc

![The new overview of archivist package](https://raw.githubusercontent.com/pbiecek/archivist/master/archivist2_0.png)

![Overview of archivist package](https://raw.githubusercontent.com/pbiecek/archivist/master/archiwum2.png)

Project is supported by [Travis CI](https://travis-ci.org/) and [waffle.io](https://waffle.io/).

The list of available functions:

```{Ruby}
help(package="archivist")
```

<h4> The list of use-cases: is available on archivist webpage http://pbiecek.github.io/archivist/</h4>


<h5> Authors of the project: </h5>

> Przemysław Biecek, przemyslaw.biecek@gmail.com
>
> Marcin Kosiński, m.p.kosinski@gmail.com
>
> Witold Chodor, witoldchodor@gmail.com

### [archivist.github](http://marcinkosinski.github.io/archivist.github/): Archiving, Managing and Sharing R Objects via GitHub

![Workflow of archivist.github package](https://raw.githubusercontent.com/MarcinKosinski/archivist.github/master/vignettes/archivist_github_workflow.png)

