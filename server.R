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

  sv <- reactiveValues()# sessionvalues
    
    ## Interactive Map ###########################################
    
    # Create the map
    output$map <- renderLeaflet({
      sv$coords <- data.frame(lat=c(52.120,52.120,52.120),lon=c(5.88,5.89,5.87),id=c(1,2,3))
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
    
    output$txt1 <- renderText({ input$txt 
      
      req(input$file1)
      str_log <- ""
      # when reading semicolon separated files,
      # having a comma separator causes `read.csv` to error
      tryCatch(
        {
          df <- read.csv(input$file1$datapath,
                         sep = input$sep)
          
          if("latitude" %in% colnames(df))
          {
            if("longitude" %in% colnames(df)){
              str_log <- "kolommen gevonden in csv 'latitude' en 'longitude', wordt gebruikt als coordinaat data. \n"
              coords <- as.data.frame(df$latitude)#assiging colnames at creation does not work (or is errorprone code)
              coords$lon <- df$longitude
              colnames(coords) <- c("lat","lon")
              sv$coords <- coords
            }
          }
          else if("lat" %in% colnames(df))
          {
            if("lon" %in% colnames(df)){
              str_log <- "kolommen gevonden in csv 'lat' en 'lon', wordt gebruikt als coordinaat data. \n"
              coords <- as.data.frame(df$lat)#assiging colnames at creation does not work (or is errorprone code)
              coords$lon <- df$lon
              colnames(coords) <- c("lat","lon")
              sv$coords <- coords
            }
            else if("lng" %in% colnames(df)){
              str_log <- "kolommen gevonden in csv 'lat' en 'lng', wordt gebruikt als coordinaat data. \n"
              coords <- as.data.frame(df$lat)#assiging colnames at creation does not work (or is errorprone code)
              coords$lon <- df$lng
              colnames(coords) <- c("lat","lon")
              sv$coords <- coords
            }
          }
          else if("gps_lat" %in% colnames(df))
          {
            if("gps_lon" %in% colnames(df)){
              str_log <- "kolommen gevonden in csv 'gps_lat' en 'gps_lon', wordt gebruikt als coordinaat data. \n"
              coords <- as.data.frame(df$gps_lat)#assiging colnames at creation does not work (or is errorprone code)
              coords$lon <- df$gps_lon
              colnames(coords) <- c("lat","lon")
              sv$coords <- coords
            }
            else if("gps_lng" %in% colnames(df)){
              str_log <- "kolommen gevonden in csv 'gps_lat' en 'gps_lng', wordt gebruikt als coordinaat data. \n"
              coords <- as.data.frame(df$gps_lat)#assiging colnames at creation does not work (or is errorprone code)
              coords$lon <- df$gps_lng
              colnames(coords) <- c("lat","lon")
              sv$coords <- coords
            }
          }
          else (str_log <- "geen kolommen gevonden voor locatie-duiding. \n - Kies de correcte sheidingsteken. \n - Zorg dat coordinaat kolommen 'lat','lon','latitude','longitude' o.i.d. heten. \n - Of zorg dat de postcode kolom 'postcode','pc','pc6' o.i.d. heet. \n")
          
        },
        error = function(e) {
          # return a safeError if a parsing error occurs
          stop(safeError(e))
        }
      )
      
      
      str_tbl <- capture.output(head(df,n=9,addrownums=FALSE))
      return(paste0(str_log," \n head('",(input$file1$name),"') \n", paste0(str_tbl, collapse="\n")) )

    })

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
        leafletProxy("map", data = sv$coords) %>%
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



