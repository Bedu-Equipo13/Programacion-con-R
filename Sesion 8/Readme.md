postwork 8
================
Equipo 13

    Jesus Antonio Hernandez Aguilera: antoniohdz_21@hotmail.com
    Angel Uriel Meléndez Rivera: amelendezr1100@alumno.ipn.mx
    Adalberto Benitez Zapata: adalb518@gmail.com
    Sergio Maldonado Rodriguez: sermalrod@outlook.com


## Desarrollo

Para este postwork genera un dashboard en un solo archivo app.R, para
esto realiza lo siguiente:

1.  Ejecuta el código momios.R

<!-- end list -->

``` r
source("momios.R", echo = FALSE)
```

2.  Almacena los gráficos resultantes en formato png, estos se generan
    automaticamente al correr momios.R en la carpeta `www`

3.  Crea un dashboard donde se muestren los resultados con 4 pestañas:
    
      - Una con las gráficas de barras, donde en el eje de las x se
        muestren los goles de local y visitante con un menu de
        selección, con una geometría de tipo barras además de hacer un
        facet\_wrap con el equipo visitante
      - Realiza una pestaña donde agregues las imágenes de las gráficas
        del postwork 3
      - En otra pestaña coloca el data table del fichero match.data.csv
      - Por último en otra pestaña agrega las imágenes de las gráficas
        de los factores de ganancia mínimo y máximo

<!-- end list -->

``` r
library(ggplot2)
library(shiny)
library(shinydashboard)
library(shinythemes)

ui <- 

    fluidPage(shinythemes::themeSelector(),

        dashboardPage(

            dashboardHeader(title = "Prediccion de Resultados"),

            dashboardSidebar(

                sidebarMenu(
                    menuItem("Graficos de barras", tabName = "Dashboard", icon = icon("bar-chart")),
                    menuItem("Probabilidades de goles", tabName = "goles", icon = icon("area-chart")),
                    menuItem("Data Table", tabName = "data_table", icon = icon("file-excel-o")),
                    menuItem("Factores de ganancia", tabName = "momios", icon = icon("refresh fa-spin"))

                )

            ),

            dashboardBody(

                tabItems(

                    # Histograma
                    tabItem(tabName = "Dashboard",
                            fluidRow(

                                titlePanel("Goles a favor y en contra por equipo"), 
                                selectInput("x", "Seleccione el valor de X",
                                            choices = c("home.score", "away.score")),

                                plotOutput("plot1", height = 450, width = 750)

                            )
                    ),

                    # imÃ¡genes
                    tabItem(tabName = "goles", 
                            fluidRow(
                                titlePanel(h3("Probabilidad de goles en casa, visitante y conjunta")),

                            img(src = "plot1.png") ,
                            img(src = "plot2.png"),
                            img(src = "plot3.png")

                            )
                    ),

                    tabItem(tabName = "data_table",
                            fluidRow(        
                                titlePanel(h3("Data Table")),
                                dataTableOutput ("data_table")
                            )
                    ), 

                    tabItem(tabName = "momios",
                            fluidRow(
                                titlePanel(h3("Factores de ganancia")),
                                h3("Factor de ganancia Maximo"),
                                img( src = "max.png", 
                                     height = 350, width = 550),
                                h3("Factor de ganancia Promedio"),
                                img( src = "prom.png", 
                                     height = 350, width = 550)

                    )

                            )

                )
            )
        )
    )

server <- function(input, output) {
    library(ggplot2)

    #Grafico de barras
    output$plot1 <- renderPlot({

        data <-  read.csv("match.data.csv", header = T)

        data <- mutate(data, FTR = ifelse(home.score > away.score, "H", ifelse(home.score < away.score, "A", "D")))

        x <- data[,input$x]

     
        data %>% ggplot(aes(x, fill = FTR)) + 
            geom_bar() + 
            facet_wrap("away.team") +
            labs(x =input$x, y = "Goles") + 
            ylim(0,50)

    })

    #Data Table
    output$data_table <- renderDataTable( {data}, 
                                          options = list(aLengthMenu = c(10,25,50),
                                                         iDisplayLength = 10)
    )

}


shinyApp(ui, server)
```
