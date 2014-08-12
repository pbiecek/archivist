#docco need to be installed prior
# sudo apt-get install npm
# sudo npm install -g docco


knitr::knit2html(input = "vignettes/archivist.Rmd", 
                 output = "vignettes/archivist.md", 
                 template = system.file("misc", "docco-template.html", 
                 package = "knitr"))