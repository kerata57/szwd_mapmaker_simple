#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output, session) {

    coords <- data.frame(lat=c(52.120,52.120,52.120),lon=c(5.88,5.89,5.87),id=c(1,2,3))
    
    ## Interactive Map ###########################################
    
    # Create the map
    output$map <- renderLeaflet({
        leaflet() %>%
            addTiles(
                #urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                #"https://api.mapbox.com/styles/v1/0zg/ckdzzqso40y0q19qkz9bbem7h/"
                #attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
                urlTemplate = "https://api.mapbox.com/styles/v1/0zg/ckdzzqso40y0q19qkz9bbem7h/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiMHpnIiwiYSI6ImNrZHp6aXhvdjF0NnAyeHBpa2pybGxxdGEifQ.QXfc6_r36FDKb1d62krTqw",
                attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
            ) %>%
            setView(lat = 52.120, lng = 5.887, zoom = 8)
        
    })
    
    
   # df <- read.csv(input$file1$datapath,
      #             sep = input$sep)
    # observe({input$showmap
    #     coords <- bind_rows(coords,coords)
    #     leafletProxy("map", data = coords) %>%
    #         clearShapes() %>%
    #         addMarkers(lng=~lon, lat=~lat, clusterOptions = markerClusterOptions())
    # })
    outputOptions(output, "map", suspendWhenHidden = FALSE)
    
    observeEvent(input$showmap, {
        updateTabsetPanel(session, "nav",
                          selected = "tab2")
        leafletProxy("map", data = coords) %>%
            clearShapes() %>%
            addMarkers(lng=~lon, lat=~lat, clusterOptions = markerClusterOptions())
    })

})


#Make the application 
app <- shinyApp(ui = ui, server = server)

#Run the application
#for more options: https://shiny.rstudio.com/reference/shiny/0.14/shiny-options.html
runApp(app, port = 3127, host =  "0.0.0.0",
       launch.browser =  interactive(), workerId = "",
       quiet = FALSE, display.mode = c( "normal"))








