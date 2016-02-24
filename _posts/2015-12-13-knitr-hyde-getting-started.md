---
layout:  post
title: "Getting Started with Knitr-Hyde"
comments:  true
published:  true
author: "Homer White"
date: 2015-12-13 20:00:00
categories: [Documentation]
output:
  html_document:
    mathjax:  default
    fig_caption:  true
---

## Introduction

The aim of this project is to help students and colleagues who for some reason want to blog on R-related topics.  If you have a particular Git Hub project that deals with R and you want to blog about your work as it develops, or if you simply want to blog about R in general, then you can use the material from my [`knitr-hyde`](https://github.com/homerhanumat/knitr-hyde) repository to set up, with minimal fuss, a Jekyll-powered site with good styling borrowed from Mark Otto's [Hyde project](https://github.com/poole/hyde).  With help from Yihui Xie's [`servr`](https://github.com/yihui/servr) package and [knitr-jekyll](https://github.com/yihui/knitr-jekyll) code you 'll be able to write your posts in R Markdown, build and preview the site locally, and push to your Git Hub Pages site when you are ready.

I have tried to minimize what you need to know about Jekyll (and web development generally) in order to get going.  You can learn more about Jekyll when it suits you and eventually make thorough-going alterations to my blog-template, but for now I want you to be able to concentrate on getting your content out there to a waiting public.

**Note**:  Before you commit yourself to a Hyde-themed blog, check out the [same R-set-up](https://homerhanumat.github.io/knitr-lanyon) but using Mark Otto's Lanyon theme with the cool toggle-able sidebar!

## Preliminaries

### Platform

Jekyll is not officially supported on Windows, so you had best try this with Mac OSX, or with a Linux distribution.  (Either way works well, in my experience.)  But if you are determined to give it a try on Windows, consult the documentation [here](http://jekyllrb.com/docs/windows/).

### Get My Files

Consult the [Github Pages guide](https://pages.github.com/).  Decide whether you want a general user site or a site associated with a partcular project repository.

#### Getting Files for a Project Site

If you don't already have an existing project but want a project-associated site, then fork my [knitr-hyde](https://github.com/homerhanumat/knitr-hyde) repository from Git Hub, rename it as you wish and then clone it on your own machine.

If you are using R Studio, then you could accomplish this by creating a new project under version control.  The final step of this process clones from your remote site on Github, and you find yourself in the new project on the master branch.  Click on the Git tab and then the More menu, and open a shell.  You will be in the root directory of your project.  Run these commands:


{% highlight r %}
git fetch
git checkout gh-pages
{% endhighlight %}

and then exit the shell.  You will now be in the local `gh-pages` branch of your project.  All of your blogging work will be done in this branch.  When you want to do actual project work, switch to the master branch.

If you already have a project repository on Git Hub and want a site associated with it, then simply create a `gh-pages` branch, delete all of the files, download a [zip file](https://github.com/homerhanumat/knitr-hyde/archive/gh-pages.zip) of my `gh-pages` branch and extract it into your repo while you have your `gh-pages` branch checked out.

#### Getting Files for a User Site

Having created your user respository (`yourgithubusername.github.io` as per the GitHub Pages guide), clone your user repo onto your own machine.  Stay on your `master` branch:  you don't create a `gh-pages` branch for a user site.  Download a [zip file](https://github.com/homerhanumat/knitr-hyde/archive/gh-pages.zip) of my `gh-pages` branch and extract it into your repo.

## Configuring my Files for Your Use

In the root directory, locate the `_config.yaml` file.  Make some choices:

* Change the `title` and `description`.
* Change the value of `baseurl` as per the commented directions.  For a site associated with a repository named `myProject`, the base url will be set to "/myProject".  For a user site, it's just "", an empty string.
* Change the value of `baseurlknitr`.  It should always be the same as `baseurl`, with the addition of '/' at the end.  So for a project site it's "/myProject/" and for a user site it's just "/".
* Change `url`.  Since you are pushing to Git Hub, it can be `https://yourgithubusername.github.io`.
* Decide if you would like people to be able to comment on your posts.  If you want this, leave `disqus` at `true` and register at the [Disqus.com](https://disqus.com/).  You will have the opportunity to add Disqus to your site.  Do this.  As part of this process you will be asked to create a *shortname* for your site.  Set `shortname` accordingly.  If you don't want commenting, simply set `disqus` to `false`.
* Change `twitter` and `facebook` to `false` if you don't want the Tweet and Facebook buttons for your posts.

### Get the Packages

### Ruby and Gems

You will need to install [Ruby](https://www.ruby-lang.org/en/downloads/), and then install the [Jekyll](http://jekyllrb.com/) gem.  It's best if you install the same version of Jekyll that Git Hub will use to build your page.  You can find the current version [here](https://pages.github.com/versions/).  At the time of writing this is version 3.0.3, so once you have installed Ruby, open a terminal and run the command:

```
sudo gem install jekyll -v 3.0.3
```

You'll also want a gem that keeps your Jekyll version (and all dependencies of Jekyll) at the same version level as used by Git Hub:

```
sudo gem install github-pages
```

In order to stay current with Git Hub, update this gem frequently:

```
sudo gem update github-pages
```

**Note:**  If you simply install the `github-pages` gem first then you don't have to bother with installing Jekyll:  `github-pages` will install the correct version for you.

### The servr Package

You'll need Yihui Xie's `servr` package.  In R, run:


{% highlight r %}
install.packages("servr")
{% endhighlight %}



## Authoring

From the `_source` folder, find an R Markdown document and open it.  You'll see YAML front-matter at the beginning, like this:


{% highlight r %}
layout:  post
title: "Sample Post"
comments:  true
published:  true
author: "Homer White"
date: 2015-12-12 20:00:00
categories: [R]
output:
  html_document:
    mathjax:  default
    fig_caption:  true
{% endhighlight %}

Set the title, author and date as you wish.  If your post has categories, list them, for example:

```
categories:  [R, 'Marsupial Studies']
```

Note that mutli-word category-names are quoted.

Save the post using the date-and-title format:

> `year-mm-dd-your-brief-post-title.Rmd`

Write your post.  As you go, you can run the R command:


{% highlight r %}
servr::jekyll()
{% endhighlight %}

If you are using R Studio then the site will show up in the Viewer.  Every time you save a change to your draft post, the site will re-build, so you can preview your change in real time.  That's the genius of Yihui Xie.

The post will be rendered using version 1.9 of the Ruby gem `kramdown`.  Look in my `sample-post` for examples of inline and displayed mathematics.  Otherwise you can write pretty much as you normally do in R Markdown.

When you are happy with your post, commit your changes and push your `gh-pages` branch to Git Hub.  You can view your site online at:

> https://yourgithubusername.github.io/yourProjectName

**Note on Compatibility**:  If for one reason or another you had already installed Jekyll prior to working with this post, then it's probably a version different from the one currently used by GitHub.  If yo uwant to keep that other version around then you will need to tell `servr::jekyll()` to build your site with the Github-compatible version.  Suppose, for example that the correct version is Jekyll-3.0.2.  Then to preview you would run:


{% highlight r %}
servr::jekyll(command = 'jekyll _3.0.2_ build')
{% endhighlight %}


## Further Customization

Make the site entirely your own by erasing my posts.  Delete the unwanted R Markdown sources, and delete their processed Markdown derivatives from the `_posts` folder.

Styling is provided from Mark Otto's excellent Hyde project.  Hyde comes with eight themes, and you can put the sidebar on the right if you like.  Consult the [Hyde project](https://github.com/poole/hyde) README to learn how to make these changes.

If you know a bit of CSS then you might want to play around with the  `public/css/custom.css` file.

Eventually you should learn more about Jekyll and the [Liquid](http://liquidmarkup.org/) templating system that Jekyll supports.  Then you can customize the site even further:

* adding or taking away sidebar widgets
* displaying author names
* using draft posts

and more.  Happy blogging!
