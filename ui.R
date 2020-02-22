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
                         label = "Copy raw data here:",
                         value = example_data, width = '100%', height = '350px')),
    column(7,
           plotOutput(outputId = "map"),
    )
  ),
  
  fluidRow(
    hr(),
    column(5),
    column(2,
           colourInput("col_min", "color for min value", value = "#f0ff00")
    ),
    column(2,
           colourInput("col_max", "color for max value", value = "#ff0000")
    ),
    column(3,
           downloadButton('downloadPNG', 'Download PNG'),
           downloadButton('downloadSVG', 'Download SVG'))
    
  ),
  fluidRow(
    hr(),
    a("Privacy policy", href="/privacy.html"),
    
    
  )
)