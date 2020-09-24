#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# backwards compatibility
# windows R-3.4.1 (current dwr-next env.) 
# using latest 3.4.x windows-binaries (R3.4.4) so you don't have to compile
#setRepositories(addURLs = c(MRAN_R344="https://cran.microsoft.com/snapshot/2018-04-01/"),ind=0) #R3.4.4
#install.packages("htmlwidgets") #new versions ask for shiny 1.1 and throws error
#install.packages("DT") #new versions ask for shiny 1.1 and throws error
#install.packages("shiny") #this installs shiny 1.0.5

library(htmlwidgets )
library(DT)
library(shiny)

library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)


# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
    navbarPage("szwd mapmaker", id="nav",
         tabPanel("Import CSV", value="tab1",
                  
                  # Input: Select a file ---
                  fileInput("file1", "Kies een CSV bestand met postcodes en/of coordinaten om deze op de kaart te tonen.",
                            multiple = TRUE,
                            accept = c("text/csv",
                         "text/comma-separated-values,text/plain",
                         ".csv")),
                  
                  # Horizontal line ----
                  tags$hr(),
                  # Input: Select separator ----
                  radioButtons("sep", "Scheidingsteken",
                               choices = c(Puntkomma = ";",
                                           Komma = ","),
                               selected = ";"),
                  tags$hr(),
                  actionButton("showmap", "Toon op kaart"),
                  tags$br(),tags$br(),
                  verbatimTextOutput("txt1", placeholder = TRUE),
                  tags$br(),tags$br(),
                  tableOutput("contents")
                  
                  ),   
         tabPanel("Toon Kaart", value="tab2",

            div(class="outer",
                
                tags$head(
                    # Include our custom CSS
                    includeCSS("styles.css"),
                    includeScript("gomap.js")
                ),
                
                # If not using custom CSS, set height of leafletOutput to a number instead of percent
                leafletOutput("map", width="100%", height="100%"),
                
                tags$div(id="cite",
                         'Data compiled for ', tags$em('Ministery of Social Afairs and Employment, 2019–2020'), ' by Oz.'
                )
            )
         )
    )

))

