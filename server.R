#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
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

library(shiny)

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output, session) {

  sv <- reactiveValues()# sessionvalues
  sv$pc4 <- read.csv("pc4_gps_2019.csv", stringsAsFactors = FALSE) #postcode numbers, for conversion to lat.lon.
  sv$pc6 <- readRDS("pc6_gps_2019.rds") #postcode with letters, for conversion to lat.lon.
    ## Interactive Map ###########################################
    
    # Create the map
    output$map <- renderLeaflet({

      sv$coords <- sv$pc4 #default markers, if no file is uploaded
      #colnames(sv$coords) <- c("lat","lon","label") 
      #sv$coords <- data.frame(lat=c(52.120,52.120,52.120),lon=c(5.88,5.89,5.87),id=c(1,2,3))
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
                         sep = input$sep, stringsAsFactors = FALSE)
          latlon_colnames <- c("")
          label_colname <-  ""

          if("latitude" %in% colnames(df))
          {
            if("longitude" %in% colnames(df)){
              latlon_colnames <- c("latitude","longitude")
              str_log <- "kolommen gevonden in csv 'latitude' en 'longitude', wordt gebruikt als coordinaat data. \n"
            }
          }
          else if("lat" %in% colnames(df))
          {
            if("lon" %in% colnames(df)){
              latlon_colnames <- c("lat","lon")
              str_log <- "kolommen gevonden in csv 'lat' en 'lon', wordt gebruikt als coordinaat data. \n"
            }
            else if("lng" %in% colnames(df)){
              latlon_colnames <- c("lat","lng")
              str_log <- "kolommen gevonden in csv 'lat' en 'lng', wordt gebruikt als coordinaat data. \n"
            }
          }
          else if("gps_lat" %in% colnames(df))
          {
            if("gps_lon" %in% colnames(df)){
              latlon_colnames <- c("gps_lat","gps_lon")
              str_log <- "kolommen gevonden in csv 'gps_lat' en 'gps_lon', wordt gebruikt als coordinaat data. \n"
            }
            else if("gps_lng" %in% colnames(df)){
              latlon_colnames <- c("gps_lat","gps_lng")
              str_log <- "kolommen gevonden in csv 'gps_lat' en 'gps_lng', wordt gebruikt als coordinaat data. \n"
            }
          }
          else if("postcode" %in% colnames(df))
          {
            if( max(nchar(df$postcode)) == 4){
              df2 <- sv$pc4
              df <- left_join(df, df2, by = c("postcode"="pc4"), suffix= c("_input","_pc4") )
              
              latlon_colnames <- c("lat","lon")
              str_log <- "kolom gevonden in csv, 'postcode' (vier cijferig) wordt gebruikt voor herleiden van coordinaat data. \n"
            }
            else if( max(nchar(df$postcode)) > 4){
              df2 <- sv$pc6
              df <- left_join(df, df2, by = c("postcode"="pc6"), suffix= c("_input","_pc6") )
              
              latlon_colnames <- c("lat","lon")
              str_log <- "kolom gevonden in csv, 'postcode' wordt gebruikt voor herleiden van coordinaat data. \n"
            }
          }
          else if("kvk_postcode" %in% colnames(df))
          {
            if( max(nchar(df$kvk_postcode)) == 4){
              df2 <- sv$pc4
              df$postcode_to_match <- gsub(" ", "", df$kvk_postcode, fixed = TRUE)
              df <- left_join(df, df2, by = c("postcode_to_match"="pc4"), suffix= c("_input","_pc4") )
              
              latlon_colnames <- c("lat","lon")
              str_log <- "kolom gevonden in csv, 'kvk_postcode' (vier cijferig) wordt gebruikt voor herleiden van coordinaat data. \n"
            }
            else if( max(nchar(df$kvk_postcode)) > 4){
              df2 <- sv$pc6
              df$postcode_to_match <- gsub(" ", "", df$kvk_postcode, fixed = TRUE)
              df <- left_join(df, df2, by = c("postcode_to_match"="pc6"), suffix= c("_input","_pc6") )
              
              latlon_colnames <- c("lat","lon")
              str_log <- "kolom gevonden in csv, 'kvk_postcode' wordt gebruikt voor herleiden van coordinaat data. \n"
            }
          }
          else (str_log <- "geen kolommen gevonden voor locatie-duiding. \n - Kies de correcte sheidingsteken. \n - Zorg dat coordinaat kolommen 'lat','lon','latitude','longitude' o.i.d. heten. \n - Of zorg dat de postcode kolom 'postcode','pc','pc4','pc6' o.i.d. heet. \n")

          if(length(latlon_colnames) > 1) { #eerste kolom wat eindigt op naam gebruiken als label
            if( !is.na(grep("name",colnames(df),ignore.case = TRUE)[1]) ){  
              label_colname <- colnames(df[ grep("name",colnames(df),ignore.case = TRUE)[1] ])
            }
            else if( !is.na(grep("naam",colnames(df),ignore.case = TRUE)[1]) )  {
              label_colname <- colnames(df[ grep("naam",colnames(df),ignore.case = TRUE)[1] ])
            }
          }
          
          if(length(latlon_colnames) > 1) {
            colnames <- c(latlon_colnames, label_colname)
            colnames <- colnames[colnames != ""] #filter away empty strings
            coords <- as.data.frame(df[colnames])#assiging colnames at creation does not work (or is errorprone code)
            if(length(colnames) == 3) {
              colnames(coords) <- c("lat","lon","label") 
            sv$coords <- coords
            }
            if(length(colnames) == 2) {
              coords$label <- "" #empty label if no name label is given
              colnames(coords) <- c("lat","lon","label") 
              sv$coords <- coords
              }
            
          }
          
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


# Make the application 
#app <- shinyApp(ui = ui, server = server)

# Run the application
# for more options: https://shiny.rstudio.com/reference/shiny/0.14/shiny-options.html
#runApp(app, port = 3127, host =  "0.0.0.0",
#       launch.browser =  interactive(), workerId = "",
#       quiet = FALSE, display.mode = c( "normal"))
#


