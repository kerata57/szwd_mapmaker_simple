Run following code in R console:

    shiny::runGitHub("szwd_mapmaker_simple", "0zg", host ="0.0.0.0", port =1234)

**Main URL demo**: https://szwd.nl/self/mapmaker <br>

*Current Version*: 0.1.2

# mapmaker_simple : upload csv, show map

Uses leaflet for the map and has a data tab. 
Not much to say. You upload a CSV and get to see the lat-lon GPS plotted on a map.
Just a few configurations are available, to avoid choice-stress (https://en.wikipedia.org/wiki/The_Paradox_of_Choice#Why_we_suffer )

## References:

none

# Installation

First, download and install R:

    https://cran.rstudio.com

Second, install following R packages:

    # linux R-3.3.3 (current debian env.)
    #install.packages("remotes") #to download and compile older versions of packages 
    #install_version("shiny", version = "0.10.1", repos = "http://cran.us.r-project.org")
    
    # windows R-3.4.1 (current dwr-next env.) 
    # using latest 3.4.x windows-binaries (R3.4.4) so you don't have to compile
    setRepositories(addURLs = c(MRAN_R344="https://cran.microsoft.com/snapshot/2018-04-01/"),ind=0) #R3.4.4
    setRepositories(addURLs = c(MRAN_R403="https://cran.microsoft.com/snapshot/2020-10-12/"),ind=0) #R4.0.3
    install.packages("htmlwidgets") #new versions ask for shiny 1. and throws error
    install.packages("DT") #new versions ask for shiny 1.1 and throws error
    install.packages("shiny") #this installs shiny 1.0.5

Finally, run following code in R console:

    library(shiny)
    shiny::runGitHub("szwd_mapmaker_simple", "0zg")


# License

none
