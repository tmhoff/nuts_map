library(colourpicker)
example_data <- readChar("data/example.txt", file.info("data/example.txt")$size)


fluidPage(
  tags$head(
    tags$meta(charset="UTF-8"),
    tags$meta(name="description", content="Online map generator to generate statistics maps using NUTS classification."),
    tags$meta(name="keywords", content="generator, map, NUTS, NUTS 1, NUTS 2, NUTS 3, svg, map, europe, countries, statistics"),
  ), 
  titlePanel("Nuts map generator"),
  hr(),
  fluidRow(
    column(1),
    column(4,
           h5("Map generator for data using NUTS classification"),
           hr(),
           textAreaInput(inputId = "data_raw",
                         label = "paste raw data here:",
                         value = example_data, width = '100%', height = '350px')),
    column(7,
           plotOutput(outputId = "map"),
    )
  ),
  
  fluidRow(
    hr(),
    column(1),
    column(2,
           checkboxInput("additional", "show additional settings")),
    column(2,
           colourInput("col_min", "color for min value", value = "#f0ff00")
    ),
    column(2,
           colourInput("col_max", "color for max value", value = "#ff0000")
    ),
    column(3,
           downloadButton('downloadPNG', 'download PNG'),
           downloadButton('downloadSVG', 'download SVG')),
    column(2)
    
  ),
  conditionalPanel(
    condition = "input.additional == 1",
    fluidRow(
      hr(),
      column(1),
      column(2,
             textInput(inputId = "title", label = "maptitle:", value = ""),
             textInput(inputId = "legtitle", label = "title of legend:", value = "")
             
      ),
      column(2,
             numericInput(inputId = "titletext", label = "fontsize title:", min = 6, max = 50, value = 12),
             numericInput(inputId = "legtext", label = "fontsize legend:", min = 6, max = 50, value = 12)
      ),
      column(2),
      column(3),
      column(2)
      
    )
  ),
  fluidRow(
    hr(),
    a("Privacy policy", href="/privacy.html"),
    
    
  )
)