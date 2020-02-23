library(colourpicker)
example_data <- readChar("data/example.txt", file.info("data/example.txt")$size)


fluidPage(
  tags$head(
    tags$meta(charset="UTF-8"),
    tags$meta(name="description", content="Online map generator to generate statistics maps using NUTS classification."),
    tags$meta(name="keywords", content="generator, map, NUTS, NUTS 1, NUTS 2, NUTS 3, svg, map, europe, countries, statistics")
  ), 
  titlePanel("NUTS map generator"),
  hr(),
  fluidRow(
    column(1),
    column(4,
           h5("Map generator for data using NUTS classification. This classification is further described here:"),
           a("Nomenclature des unités territoriales statistiques",
             href   = "https://en.wikipedia.org/wiki/Nomenclature_of_Territorial_Units_for_Statistics",
             target = "_blank"),
    
           hr(),
           textAreaInput(inputId = "data_raw",
                         label = "paste raw data here:",
                         value = example_data, width = '100%', height = '550px')),
    column(7,
           plotOutput(outputId = "map", height = '750px', width = '100%')
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
    column(2,
           downloadButton('downloadPNG', 'download PNG'),
           downloadButton('downloadSVG', 'download SVG')),
    column(2,
           h5("A similar map generator for maps of germany (PLZ, AGS) can be found here:"),
           a("https://karte-plz.de",
             href   = "https://karte-plz.de",
             target = "_blank")),
    column(1)
    
  ),
  conditionalPanel(
    condition = "input.additional == 1",
    fluidRow(
      hr(),
      column(1),
      column(2,
             textInput(inputId = "title",    label = "maptitle:",        value = ""),
             textInput(inputId = "legtitle", label = "title of legend:", value = ""),
             checkboxInput("showlegend", "show legend without title")
             
      ),
      column(2,
             numericInput(inputId = "titletext",   label = "fontsize title:",        min = 6, max = 50, value = 12),
             numericInput(inputId = "legtext",     label = "fontsize legend title:", min = 6, max = 50, value = 12),
             numericInput(inputId = "legtextsize", label = "fontsize legend text:",  min = 6, max = 50, value = 12)
             
      ),
      column(2,
             selectInput(inputId = "titlefont", label = "title font:",  choices = extrafont::fonts()),
             selectInput(inputId = "legfont",   label = "legend font:", choices = extrafont::fonts())),
      column(3),
      column(2)
      
    )
  ),
  fluidRow(
    hr(),
    a("Privacy policy", href="/privacy.html")
    
    
  )
)