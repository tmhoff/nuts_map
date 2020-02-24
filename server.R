library(sf)
library(dplyr)
library(ggplot2)
library(shiny)
library(colourpicker)
library(extrafont)
library(shinytest)
library(testthat)
library(packrat)

# extrafont::font_import(prompt = FALSE)

nuts4        <- readRDS("data/Nuts0_3.RDS")
example_data <- readChar("data/example.txt", file.info("data/example.txt")$size)

shinyOptions(cache = memoryCache(max_size = 80e6, max_age = Inf, evict = "lru"))

plot_map <- function(parsed_data,
                     min_col = "#f0ff00",
                     max_col = "#ff0000",
                     maptitle = "",
                     maplegendtitle = "",
                     maptitletext = 12,
                     maplegtext = 12,
                     maptitlefont = "Ubuntu",
                     maplegfont = "Ubuntu",
                     maplegfontsize = 12,
                     mapshowlegend = FALSE,
                     maplabel = FALSE,
                     mapaxislines = FALSE,
                     mapgrid = FALSE){
  
  mapdata  <- merge(nuts4, parsed_data, by = "nuts")
  
  #generate map
  m <- mapdata %>%
    ggplot() + 
    geom_sf(aes(fill = value)) + 
    scale_fill_gradient(low = min_col, high = max_col) +
    theme_minimal() + 
    theme(axis.text=element_blank(), panel.grid.major = element_blank(), 
          plot.title = element_text(hjust = 0.5)) + 
    ggtitle(maptitle) + 
    theme(plot.title   = element_text(size = maptitletext,   family = maptitlefont), 
          legend.title = element_text(size = maplegtext,     family = maplegfont), 
          legend.text  = element_text(size = maplegfontsize, family = maplegfont))

  if (maplegendtitle == "" & (!mapshowlegend)) m <- m + theme(legend.position = "none")
  if (maplegendtitle != "") m <- m + guides(fill = guide_legend(title = maplegendtitle))
  if (mapshowlegend)        m <- m + guides(fill = guide_legend(title = ""))
  if (maplabel)             m <- m + theme(axis.text=element_text())
  if (mapaxislines)         m <- m + theme(axis.line=element_line())
  if (mapgrid)              m <- m + theme(panel.grid.major=element_line())
  
  m
  
}


server <- function(input, output) {
  
  data <- reactiveVal()
  
  observeEvent(input$data_raw, {
    parsed <- read.table(text = input$data_raw, 
                         header = TRUE,
                         check.names = FALSE,
                         stringsAsFactors = FALSE,
                         quote = "\'")
    data(parsed)
    
  })
  
  output$map <- renderCachedPlot({
    
    plot_map(parsed_data    = data(),
             min_col        = input$col_min,
             max_col        = input$col_max,
             maptitle       = input$title,
             maplegendtitle = input$legtitle,
             maptitletext   = input$titletext,
             maplegtext     = input$legtext,
             maptitlefont   = input$titlefont,
             maplegfont     = input$legfont,
             maplegfontsize = input$legtextsize,
             mapshowlegend  = input$showlegend,
             maplabel       = input$axislabel,
             mapaxislines   = input$axislines,
             mapgrid        = input$grid)
    
  },
  cacheKeyExpr = { list(input$col_min, input$col_max, data(), input$title, input$legtitle,
                        input$titletext, input$legtext, input$titlefont, input$legfont,
                        input$legtextsize, input$showlegend, input$axislabel, input$axislines,
                        input$grid)},
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