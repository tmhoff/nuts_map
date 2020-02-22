library(sf)
library(dplyr)
library(ggplot2)
library(shiny)
library(colourpicker)

nuts4        <- readRDS("data/Nuts0_3.RDS")
example_data <- readChar("data/example.txt", file.info("data/example.txt")$size)

shinyOptions(cache = memoryCache(max_size = 80e6, max_age = Inf, evict = "lru"))

plot_map <- function(parsed_data,
                     min_col = "#f0ff00",
                     max_col = "#ff0000"){
  
  mapdata  <- merge(nuts4, parsed_data, by = "nuts")
  
  #generate map
  m <- mapdata %>%
    ggplot() + 
    geom_sf(aes(fill = value)) + 
    scale_fill_gradient(low = min_col, high = max_col) +
    theme_minimal() + 
    theme(axis.text=element_blank(), panel.grid.major = element_blank(), 
          plot.title = element_text(hjust = 0.5)) +
    theme(legend.position = "none")
  
  m
  
}


server <- function(input, output) {
  
  data <- reactiveVal()
  
  observeEvent(input$data_raw, {
    parsed <- read.csv(text = input$data_raw, 
                       header = TRUE,
                       check.names = FALSE,
                       stringsAsFactors = FALSE,
                       quote = "\'")
    data(parsed)
    
  })
  
  output$map <- renderCachedPlot({
    
    plot_map(parsed_data = data(),
             min_col = input$col_min,
             max_col = input$col_max)
    
  },
  cacheKeyExpr = { list(input$col_min, input$col_max, data())},
  sizePolicy = sizeGrowthRatio(width =
                                 700, height = 700, growthRate = 1.4)
  )
  
  

  output$downloadPNG <- downloadHandler(
    
    filename = paste0(Sys.Date(), "_", "map.png"),
    
    content = function(file) {
      
      png(file, width = 800, height = 800)
      
      m <- plot_map(parsed_data = data(),
                    min_col = input$col_min,
                    max_col = input$col_max)
      print(m)
      
      dev.off()
      
    }
  )
  
  output$downloadSVG <- downloadHandler(
    
    filename = paste0(Sys.Date(), "_", "map.svg"),
    
    content = function(file) {
      
      svg(file, width = 800, height = 800)
      
      m <- plot_map(parsed_data = data(),
                    min_col = input$col_min,
                    max_col = input$col_max)
      
      print(m)
      
      dev.off()
      
    }
  )
  
}