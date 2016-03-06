---
layout:  page
title: "Caching"
comments:  true
published:  true
categories: [Use Case]
output:
  html_document:
    mathjax:  default
    fig_caption:  true
---


The archivist package allows to store, restore and look for R objects in repositories stored on hard disk. There are different strategies that can be used to find an object, through it's name, date of creation of meta data. The package is mainly designed as a repository of artifacts, but it can be used in different use-cases.

Let's see how it can be used as caching engine.

Let's consider a function with few arguments, which evaluation may takes a significant amount of time. If there is a chance that the function will be executed with same parameteres more than just one, it would be desireble to cache results to avoid unncessary evaluations.

Such cache can be easily constructed with the `archivist` package.

# Heavyweight function

Let's see an example. The `Heavyweight` function `getMaxDistribution` summarizes the distribution of maximum from N draw of random variables from distribuition D with the use of R replications.


{% highlight r %}
getMaxDistribution <- function(
	D = rnorm, 
	N = 10,
	R = 1000000) {
	res <- replicate(R, max(D(N)))
  summary(res)
}

system.time(getMaxDistribution(rnorm, 10))
{% endhighlight %}



{% highlight text %}
   user  system elapsed 
  4.925   0.018   4.941 
{% endhighlight %}



{% highlight r %}
system.time(getMaxDistribution(rexp, 20))
{% endhighlight %}



{% highlight text %}
   user  system elapsed 
  4.840   0.005   4.842 
{% endhighlight %}



{% highlight r %}
system.time(getMaxDistribution(rnorm, 10))
{% endhighlight %}



{% highlight text %}
   user  system elapsed 
  4.533   0.000   4.530 
{% endhighlight %}

Now, let's load the archivist package and prepare a repository for cached objects.

# Cache preparation

{% highlight r %}
library(archivist)
cacheRepo <- tempfile()
createLocalRepo(cacheRepo)
{% endhighlight %}



{% highlight text %}
Directory /tmp/RtmpZE9Gag/file27d673051be1 did not exist. Forced to create a new directory.
{% endhighlight %}

# How to work with cache

The `cacheRepo` is a folder with already evaluated function calls. 
How to use it?


{% highlight r %}
system.time(cache(cacheRepo, getMaxDistribution, rnorm, 10))
{% endhighlight %}



{% highlight text %}
   user  system elapsed 
  4.420   0.004   4.422 
{% endhighlight %}



{% highlight r %}
system.time(cache(cacheRepo, getMaxDistribution, rexp, 10))
{% endhighlight %}



{% highlight text %}
   user  system elapsed 
  4.333   0.005   4.335 
{% endhighlight %}



{% highlight r %}
system.time(cache(cacheRepo, getMaxDistribution, rnorm, 10))
{% endhighlight %}



{% highlight text %}
   user  system elapsed 
  0.002   0.000   0.002 
{% endhighlight %}

The second evaluation of `getMaxDistribution` is much, much faster. Results are just read from disk.

# How the `cache` function works?

It create a md5 signature of the function FUN and it's arguments and use this signature as a key.
If such key is present in the cache repository, then the object is just restored.
If it's not present then the call is evaluated and result is stored.
Note that, if `cacheRepo` is a shared folder, then you get a shared cache repository!
