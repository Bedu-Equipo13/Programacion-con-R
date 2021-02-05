
## Dash board para el postwork de la sesión 8

library(ggplot2)
library(shiny)
library(shinydashboard)
#install.packages("shinythemes")
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

                    # imágenes
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