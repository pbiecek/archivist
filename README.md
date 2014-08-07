A set of tools for datasets and figures archivisation
=====================================================

Downloading archivist package:
```{Ruby}
if (!require(devtools)) {
    install.packages("devtools")
    require(devtools)
}
install_github("pbiecek/archivist")
```
Make sure you have [rtools](http://cran.r-project.org/bin/windows/Rtools/) installed on your computer.

The list of available functions:
```{Ruby}
help(package="archivist")
```