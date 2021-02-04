Postwork 5
=============
Equipo 13

- Jesus Antonio Hernandez Aguilera: antoniohdz_21@hotmail.com
- Angel Uriel Meléndez Rivera: amelendezr1100@alumno.ipn.mx
- Adalberto Benitez Zapata: adalb518@gmail.com
- Sergio Maldonado Rodriguez: sermalrod@outlook.com

## Desarrollo

1. A partir del conjunto de datos de soccer de la liga española de las temporadas 2017/2018, 2018/2019 y 2019/2020, crea el data frame SmallData, que contenga las columnas date, home.team, home.score, away.team y away.score; esto lo puede hacer con ayuda de la función select del paquete dplyr. Luego establece un directorio de trabajo y con ayuda de la función write.csv guarda el data frame como un archivo csv con nombre soccer.csv. Puedes colocar como argumento row.names = FALSE en write.csv.
 
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
Datos que se almacenaron (primeras 5 filas).
##
##  date  home.team home.score  away.team away.score
##1 0017-08-18    Leganes          1     Alaves          0
##2 0017-08-18   Valencia          1 Las Palmas          0
##3 0017-08-19      Celta          2   Sociedad          3
##4 0017-08-19     Girona          2 Ath Madrid          2
##5 0017-08-19    Sevilla          1    Espanol          1
##6 0017-08-20 Ath Bilbao          0     Getafe          0


2. Con la función create.fbRanks.dataframes del paquete fbRanks importe el archivo soccer.csv a R y al mismo tiempo asignelo a una variable llamada listasoccer. Se creará una lista con los elementos scores y teams que son data frames listos para la función rank.teams. Asigna estos data frames a variables llamadas anotaciones y equipos.

```r
#Declaramos el uso del paquete fbRanks
suppressWarnings(suppressMessages(library(fbRanks)))

#Con uso de la función create.fbRanks.dataframes importamos el archivo soccer.csv y lo asiganmos a la variable listasoccer
listasoccer <- create.fbRanks.dataframes(scores.file = "soccer.csv")

anotaciones <- listasoccer$scores
equipos <- listasoccer$teams
```
3. Con ayuda de la función unique crea un vector de fechas (fecha) que no se repitan y que correspondan a las fechas en las que se jugaron partidos. Crea una variable llamada n que contenga el número de fechas diferentes. Posteriormente, con la función rank.teams y usando como argumentos los data frames anotaciones y equipos, crea un ranking de equipos usando unicamente datos desde la fecha inicial y hasta la penúltima fecha en la que se jugaron partidos, estas fechas las deberá especificar en max.date y min.date. Guarda los resultados con el nombre ranking.

```r
#Creamos el vector de fechas que no se repiten
fecha <- unique(anotaciones$date)

#Con la función length aplicada en el vactor fecha creado obtenemos el numero de fechas diferentes
n <- length(fecha)

#Con la funcion rank.teams obtenemos el ranking de los equipos
ranking <- rank.teams(scores = anotaciones, teams = equipos,
                      max.date = fecha[n-1],
                      min.date = fecha[1])
```

4. Finalmente estima las probabilidades de los eventos, el equipo de casa gana, el equipo visitante gana o el resultado es un empate para los partidos que se jugaron en la última fecha del vector de fechas fecha. Esto lo puedes hacer con ayuda de la función predict y usando como argumentos ranking y fecha[n] que deberá especificar en date.

```r
#Estimamos las probabilidades de los eventos
pred <- predict(ranking, date = fecha[n])
```
