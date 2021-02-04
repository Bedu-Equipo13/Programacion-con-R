Postwork 5
=============
Equipo 13

03/02/2021

## Desarrollo

 1.- A partir del conjunto de datos de soccer de la liga española de las temporadas 2017/2018, 2018/2019 y 2019/2020, crea el data frame SmallData, que contenga las columnas date, home.team, home.score, away.team y away.score; esto lo puede hacer con ayuda de la función select del paquete dplyr. Luego establece un directorio de trabajo y con ayuda de la función write.csv guarda el data frame como un archivo csv con nombre soccer.csv. Puedes colocar como argumento row.names = FALSE en write.csv.
 
 <!-- end list -->

``` r
#Declaramos las librereias a utlizar

suppressWarnings(suppressMessages(library(dplyr)))
suppressWarnings(suppressMessages(library(reshape2)))
suppressWarnings(suppressMessages(library(ggplot2)))

#Guardamos las url donde se encuentran los datos que ucuparemos
url1718 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"
url1819 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
url1920 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"

#Leemos los datos de los archivos csv presentes en las urls
d1718 <- read.csv(file = url1718) # Importación de los datos a R
d1819 <- read.csv(file = url1819)
d1920 <- read.csv(file = url1920)

#Seleccionamos unicamente las columnas date, home.team, home.score, away.team y away.score
lista <- list(d1718, d1819, d1920)
nlista <- lapply(lista, select, Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)

#Convertimos la columna Date a un formato de fecha
nlista[[1]] <- mutate(nlista[[1]], Date = as.Date(Date, "%d/%m/%Y"))
nlista[[2]] <- mutate(nlista[[2]], Date = as.Date(Date, "%d/%m/%Y"))
nlista[[3]] <- mutate(nlista[[3]], Date = as.Date(Date, "%d/%m/%Y"))

#Combinamos a partir de las columnas los datos
data <- do.call(rbind, nlista)

SmallData <- as.data.frame(data)

SmallData <- select(data, date = Date, home.team = HomeTeam, 
                    home.score = FTHG, away.team = AwayTeam, 
                    away.score = FTAG)

#Creamos el documento csv para guardar los datos
write.csv(SmallData,"soccer.csv",row.names = FALSE)
```
2. Con la función create.fbRanks.dataframes del paquete fbRanks importe el archivo soccer.csv a R y al mismo tiempo asignelo a una variable llamada listasoccer. Se creará una lista con los elementos scores y teams que son data frames listos para la función rank.teams. Asigna estos data frames a variables llamadas anotaciones y equipos.

```r
#Declaramos el uso del paquete fbRanks
suppressWarnings(suppressMessages(library(fbRanks)))

#Con uso de la función create.fbRanks.dataframes importamos el archivo soccer.csv y lo asiganmos a la variable listasoccer
listasoccer <- create.fbRanks.dataframes(scores.file = "soccer.csv")

anotaciones <- listasoccer$scores
equipos <- listasoccer$teams
```

