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

    install(remotes)
    install_version("shiny", version = "0.10.1", repos = "http://cran.us.r-project.org")

Finally, run following code in R console:

    shiny::runGitHub("szwd_mapmaker_simpel", "0zg")


# License

none
