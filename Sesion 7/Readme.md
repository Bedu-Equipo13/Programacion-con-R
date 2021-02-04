postwork 7
================
Equipo 13
29/1/2021

## Desarrollo

Utilizando el manejador de BDD Mongodb Compass (previamente instalado),
deberás de realizar las siguientes acciones:

  - Alojar el fichero `data.csv` en una base de datos llamada
    match\_games, nombrando al collection como match
      - Antes debemos crear el archivo `data.csv` con las fechas
        adecuadas

<!-- end list -->

``` r
#Librerias que seran ocupadas
suppressWarnings(suppressMessages(library(dplyr)))
suppressWarnings(suppressMessages(library(mongolite)))
```

``` r
#Comenzamos importando los datos que se encuentran en archivos csv a R

url1516 <- "https://www.football-data.co.uk/mmz4281/1516/SP1.csv"
url1415 <- "https://www.football-data.co.uk/mmz4281/1415/SP1.csv"

#importando los archivos a R
d1516 <- read.csv(file = url1516) 
d1415 <- read.csv(file = url1415)
```

``` r
#unimos los datos descargados y transformamos la columna date en formato fecha
lista <- list(d1415,d1516)
lista<-lapply(lista,mutate,Date = as.Date(Date, "%d/%m/%y"))
#Ahora seleccionaremos Unicamente las columnas Date, HomeTeam, AwayTeam, FTHG, FTAG y FTR en cada uno de los data frames.
nlista <- lapply(lista, select, Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)
#unimos los datos en un solo data frame
data <- do.call(rbind, nlista)
```

``` r
#creamos el archivo data.csv con las fechas necesarias
write.csv(data, file = 'data.csv',row.names = FALSE)
```

Una vez creado el archivo podemos importarlo

``` r
#Leemos el archivo Recien creado
match=data.table::fread("data.csv")
#obtenemos una vista del nombre de las columnas
names(match)
```

    ## [1] "Date"     "HomeTeam" "AwayTeam" "FTHG"     "FTAG"     "FTR"

``` r
#creamos una conexion con mongodb, y creamos la base de datos y la coleccion
my_collection = mongo(collection = "match", db = "match_games",
                      url="mongodb+srv://introabd_18:introabd1234@cluster0.pjr7w.mongodb.net/test?authSource=admin&replicaSet=atlas-13a7dg-shard-0&readPreference=primary&appname=MongoDB%20Compass&ssl=true") 
```

``` r
if ((my_collection$count()==0)){
    my_collection$insert(match)
}
```

    ## List of 5
    ##  $ nInserted  : num 760
    ##  $ nMatched   : num 0
    ##  $ nRemoved   : num 0
    ##  $ nUpserted  : num 0
    ##  $ writeErrors: list()

  - Una vez hecho esto, realizar un `count` para conocer el número de
    registros que se tiene en la base

<!-- end list -->

``` r
# Número de registros
my_collection$count()
```

    ## [1] 760

``` r
# Visualizar el fichero recien creado
head(my_collection$find())
```

    ##         Date  HomeTeam   AwayTeam FTHG FTAG FTR
    ## 1 2014-08-23   Almeria    Espanol    1    1   D
    ## 2 2014-08-23   Granada  La Coruna    2    1   H
    ## 3 2014-08-23    Malaga Ath Bilbao    1    0   H
    ## 4 2014-08-23   Sevilla   Valencia    1    1   D
    ## 5 2014-08-24 Barcelona      Elche    3    0   H
    ## 6 2014-08-24     Celta     Getafe    3    1   H

  - Realiza una consulta utilizando la sintaxis de Mongodb, en la base
    de datos para conocer el número de goles que metió el Real Madrid el
    20 de diciembre de 2015 y contra que equipo jugó, ¿perdió ó fue
    goleada?

<!-- end list -->

``` r
# realizando la consulta
my_collection$find('{"Date":"2015-12-20", "HomeTeam":"Real Madrid"}')
```

    ##         Date    HomeTeam  AwayTeam FTHG FTAG FTR
    ## 1 2015-12-20 Real Madrid Vallecano   10    2   H

Como podemos ver en la consulta el partido que jugo el Real Maadrid fue
en contra del Vallecano, el resultado fue una victoria por goleada por
parte del Real Madrid

``` r
#eliminando la base de datos recien creada:
my_collection$drop()
```

  - Por último, no olvides cerrar la conexión con la BDD

<!-- end list -->

``` r
# Cerrando la conexión
rm(my_collection)
```
