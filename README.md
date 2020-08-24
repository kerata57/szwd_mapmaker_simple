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

    #linux R-3.3.3
    #install.packages("remotes") #to download and compile older versions of packages 
    #install_version("shiny", version = "0.10.1", repos = "http://cran.us.r-project.org")
    
    #windows R-3.4.1 (using Microsoft binaries for R3.4.1, so you don't have to compile)
    setRepositories(addURLs = c(MRAN_R341="https://cran.microsoft.com/snapshot/2017-09-01/"),ind=0) #R3.4.1
    install.packages("shiny")

Finally, run following code in R console:

    shiny::runGitHub("szwd_mapmaker_simpel", "0zg")


# License

none
