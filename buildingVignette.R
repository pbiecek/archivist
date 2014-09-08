#docco need to be installed prior
# sudo apt-get install npm
# sudo npm install -g docco


knitr::knit2html(input = "vignettes/chainingUseCase.Rmd", 
                 output = "vignettes/chainingUseCase.md", 
                 template = system.file("misc", "docco-template.html", 
                 package = "knitr"))


knitr::knit2html(input = "vignettes/lazyLoadUseCase.Rmd", 
                 output = "vignettes/lazyLoadUseCase.md", 
                 template = system.file("misc", "docco-template.html", 
                                        package = "knitr"))