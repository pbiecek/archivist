knitr::knit2html(input = "vignettes/archivist.Rmd", 
                 output = "vignettes/archivist.md", 
                 template = system.file("misc", "docco-template.html", 
                 package = "knitr"))