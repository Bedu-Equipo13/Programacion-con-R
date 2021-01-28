postwork\_2
================
Equipo-13


## Desarrollo

Ahora vamos a generar un cúmulo de datos mayor al que se tenía, esta es
una situación habitual que se puede presentar para complementar un
análisis, siempre es importante estar revisando las características o
tipos de datos que tenemos, por si es necesario realizar alguna
transformación en las variables y poder hacer operaciones aritméticas si
es el caso, además de sólo tener presente algunas de las variables, no
siempre se requiere el uso de todas para ciertos procesamientos.

1.  Importa los datos de soccer de las temporadas 2017/2018, 2018/2019 y
    2019/2020 de la primera división de la liga española a R, los datos
    los puedes encontrar en el siguiente
    [enlace](https://www.football-data.co.uk/spainm.php):

``` r
#Cargamos librerias necesarias
suppressWarnings(suppressMessages(library(dplyr)))

#Creamos un vector de los urls

urls=c("https://www.football-data.co.uk/mmz4281/1718/SP1.csv",
"https://www.football-data.co.uk/mmz4281/1819/SP1.csv",
"https://www.football-data.co.uk/mmz4281/1920/SP1.csv")
```

``` r
#creamos un vector con el nombre para los archivos csv
names=c("url1718.csv","url1819.csv","url1920.csv")
```

``` r
#Descargamos los csv en caso de ser necesario
for (i in 1:length(urls)){
if (!file.exists(names[i])){
    download.file(urls[i], destfile =  names[i], mode = 'wb')
}
}
```

``` r
#Importamos los csv en una lista 
lista <- lapply(list.files(pattern="*.csv"), read.csv)
```

1.  Obten una mejor idea de las características de los data frames al
    usar las funciones: `str`, `head`, `View` y `summary`

``` r
str(lista[[1]]); str(lista[[2]]); str(lista[[3]])
```

``` r
head(lista[[1]]); head(lista[[2]]); head(lista[[3]])
View(lista[[1]]); View(lista[[2]]); View(lista[[3]])
```

``` r
summary(lista[[1]]); summary(lista[[2]]); summary(lista[[3]])
```

1.  Con la función select del paquete `dplyr` selecciona únicamente las
    columnas `Date`, `HomeTeam`, `AwayTeam`, `FTHG`, `FTAG` y `FTR`;
    esto para cada uno de los data frames. (Hint: también puedes usar
    `lapply`).

``` r
#Ahora seleccionaremos Unicamente las columnas Date, HomeTeam, AwayTeam, FTHG, FTAG y FTR en cada uno de los data frames. 
lista <- lapply(lista, select, Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)

#Con las funciones lapply y str observaremos la estrucura de nuestros nuevos data frames
lapply(lista, str)
```

    ## 'data.frame':    380 obs. of  6 variables:
    ##  $ Date    : chr  "18/08/17" "18/08/17" "19/08/17" "19/08/17" ...
    ##  $ HomeTeam: chr  "Leganes" "Valencia" "Celta" "Girona" ...
    ##  $ AwayTeam: chr  "Alaves" "Las Palmas" "Sociedad" "Ath Madrid" ...
    ##  $ FTHG    : int  1 1 2 2 1 0 2 0 1 0 ...
    ##  $ FTAG    : int  0 0 3 2 1 0 0 3 0 1 ...
    ##  $ FTR     : chr  "H" "H" "A" "D" ...
    ## 'data.frame':    380 obs. of  6 variables:
    ##  $ Date    : chr  "17/08/2018" "17/08/2018" "18/08/2018" "18/08/2018" ...
    ##  $ HomeTeam: chr  "Betis" "Girona" "Barcelona" "Celta" ...
    ##  $ AwayTeam: chr  "Levante" "Valladolid" "Alaves" "Espanol" ...
    ##  $ FTHG    : int  0 0 3 1 1 1 2 1 2 1 ...
    ##  $ FTAG    : int  3 0 0 1 2 2 0 4 1 1 ...
    ##  $ FTR     : chr  "A" "D" "H" "D" ...
    ## 'data.frame':    380 obs. of  6 variables:
    ##  $ Date    : chr  "16/08/2019" "17/08/2019" "17/08/2019" "17/08/2019" ...
    ##  $ HomeTeam: chr  "Ath Bilbao" "Celta" "Valencia" "Mallorca" ...
    ##  $ AwayTeam: chr  "Barcelona" "Real Madrid" "Sociedad" "Eibar" ...
    ##  $ FTHG    : int  1 1 1 2 0 4 1 0 1 1 ...
    ##  $ FTAG    : int  0 3 1 1 1 4 0 2 2 0 ...
    ##  $ FTR     : chr  "H" "A" "D" "H" ...

    ## [[1]]
    ## NULL
    ## 
    ## [[2]]
    ## NULL
    ## 
    ## [[3]]
    ## NULL

1.  Asegúrate de que los elementos de las columnas correspondientes de
    los nuevos data frames sean del mismo tipo (Hint 1: usa `as.Date` y
    `mutate` para arreglar las fechas). Con ayuda de la función `rbind`
    forma un único data frame que contenga las seis columnas mencionadas
    en el punto 3 (Hint 2: la función `do.call` podría ser utilizada).

``` r
#Arreglamos las columnas Date para que R reconozca los elementos como fechas, esto lo hacemos con las funciones mutate (paquete dplyr) y as.Date.

lista<-lapply(lista,mutate,Date = as.Date(Date, "%d/%m/%y"))

#Verificamos que nuestros cambios se hayan llevado a cabo
lapply(lista, str)
```

    ## 'data.frame':    380 obs. of  6 variables:
    ##  $ Date    : Date, format: "2017-08-18" "2017-08-18" ...
    ##  $ HomeTeam: chr  "Leganes" "Valencia" "Celta" "Girona" ...
    ##  $ AwayTeam: chr  "Alaves" "Las Palmas" "Sociedad" "Ath Madrid" ...
    ##  $ FTHG    : int  1 1 2 2 1 0 2 0 1 0 ...
    ##  $ FTAG    : int  0 0 3 2 1 0 0 3 0 1 ...
    ##  $ FTR     : chr  "H" "H" "A" "D" ...
    ## 'data.frame':    380 obs. of  6 variables:
    ##  $ Date    : Date, format: "2020-08-17" "2020-08-17" ...
    ##  $ HomeTeam: chr  "Betis" "Girona" "Barcelona" "Celta" ...
    ##  $ AwayTeam: chr  "Levante" "Valladolid" "Alaves" "Espanol" ...
    ##  $ FTHG    : int  0 0 3 1 1 1 2 1 2 1 ...
    ##  $ FTAG    : int  3 0 0 1 2 2 0 4 1 1 ...
    ##  $ FTR     : chr  "A" "D" "H" "D" ...
    ## 'data.frame':    380 obs. of  6 variables:
    ##  $ Date    : Date, format: "2020-08-16" "2020-08-17" ...
    ##  $ HomeTeam: chr  "Ath Bilbao" "Celta" "Valencia" "Mallorca" ...
    ##  $ AwayTeam: chr  "Barcelona" "Real Madrid" "Sociedad" "Eibar" ...
    ##  $ FTHG    : int  1 1 1 2 0 4 1 0 1 1 ...
    ##  $ FTAG    : int  0 3 1 1 1 4 0 2 2 0 ...
    ##  $ FTR     : chr  "H" "A" "D" "H" ...

    ## [[1]]
    ## NULL
    ## 
    ## [[2]]
    ## NULL
    ## 
    ## [[3]]
    ## NULL

``` r
#Finalmente, con ayuda de las funciones rbind y do.call combinamos los data frames contenidos en nlista como un unico data frame
data <- do.call(rbind, lista)

dim(data)
```

    ## [1] 1140    6

``` r
str(data)
```

    ## 'data.frame':    1140 obs. of  6 variables:
    ##  $ Date    : Date, format: "2017-08-18" "2017-08-18" ...
    ##  $ HomeTeam: chr  "Leganes" "Valencia" "Celta" "Girona" ...
    ##  $ AwayTeam: chr  "Alaves" "Las Palmas" "Sociedad" "Ath Madrid" ...
    ##  $ FTHG    : int  1 1 2 2 1 0 2 0 1 0 ...
    ##  $ FTAG    : int  0 0 3 2 1 0 0 3 0 1 ...
    ##  $ FTR     : chr  "H" "H" "A" "D" ...

``` r
tail(data)
```

    ##            Date HomeTeam    AwayTeam FTHG FTAG FTR
    ## 1135 2020-07-19  Espanol       Celta    0    0   D
    ## 1136 2020-07-19  Granada  Ath Bilbao    4    0   H
    ## 1137 2020-07-19  Leganes Real Madrid    2    2   D
    ## 1138 2020-07-19  Levante      Getafe    1    0   H
    ## 1139 2020-07-19  Osasuna    Mallorca    2    2   D
    ## 1140 2020-07-19  Sevilla    Valencia    1    0   H

``` r
View(data)
summary(data)
```

    ##       Date              HomeTeam           AwayTeam              FTHG      
    ##  Min.   :2017-08-18   Length:1140        Length:1140        Min.   :0.000  
    ##  1st Qu.:2018-03-17   Class :character   Class :character   1st Qu.:1.000  
    ##  Median :2020-03-10   Mode  :character   Mode  :character   Median :1.000  
    ##  Mean   :2019-09-06                                         Mean   :1.479  
    ##  3rd Qu.:2020-09-14                                         3rd Qu.:2.000  
    ##  Max.   :2020-12-23                                         Max.   :8.000  
    ##       FTAG           FTR           
    ##  Min.   :0.000   Length:1140       
    ##  1st Qu.:0.000   Class :character  
    ##  Median :1.000   Mode  :character  
    ##  Mean   :1.108                     
    ##  3rd Qu.:2.000                     
    ##  Max.   :6.000
