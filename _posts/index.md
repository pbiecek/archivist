---
layout:  page
title: "Installation"
comments:  true
published:  true
categories: [RTCGA]
output:
  html_document:
    mathjax:  default
    fig_caption:  true
---



## Mission

Welcome to the archivist package website!

Data exploration and modelling is a process in which a lot of data artifacts are produced. Artifacts like: subsets, data aggregates, plots, statistical models, different versions of data sets and different versions of results. The more projects we work with the more artifacts are produced and the harder it is to manage these artifacts.

Archivist helps to store and manage artifacts created in R. 

![Overview of archivist package](https://raw.githubusercontent.com/pbiecek/archivist/master/archiwum.png)


## Functionality

Archivist allows you to store selected artifacts as binary files together with their metadata and relations. Archivist allows you to share artifacts with others, either through a shared folder or github. Archivist allows you to look for already created artifacts by using its class, name, date of creation or other properties. It also facilitates restoring such artifacts. Archivist allows to check if a new artifact is the exact copy of the one that was produced some time ago. This might be useful either for testing or caching.

Archivist is a set of tools for datasets and plots archiving.

## Installation

### Please see the  [archivist wiki](https://github.com/pbiecek/archivist/wiki) for information. 

### Information for [developers](https://github.com/pbiecek/archivist/wiki/For-developers)

[![Gitter](https://badges.gitter.im/pbiecek/archivist.svg)](https://gitter.im/pbiecek/archivist?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

<h5> Installation of the archivist package: </h5>
To get started, install the latest version of **archivist** from CRAN:

{% highlight ruby %}
install.packages("archivist")
{% endhighlight %}
or use:

{% highlight ruby %}
if (!require(devtools)) {
    install.packages("devtools")
    require(devtools)
}
install_github("pbiecek/archivist")
{% endhighlight %}
Make sure you have [rtools](http://cran.r-project.org/bin/windows/Rtools/) installed on your computer.

<h5> The list of available functions: </h5>

{% highlight ruby %}
help(package="archivist")
{% endhighlight %}
<h4> The list of use-cases: is available on archivist webpage http://pbiecek.github.io/archivist/</h4>


<h5> Authors of the project: </h5>
> Przemysław Biecek, przemyslaw.biecek@gmail.com
>
> Marcin Kosiński, m.p.kosinski@gmail.com
>
> Witold Chodor, witoldchodor@gmail.com
