Postwork 1
================
Equipo 13

- Jesus Antonio Hernandez Aguilera: antoniohdz_21@hotmail.com
- Angel Uriel Meléndez Rivera: amelendezr1100@alumno.ipn.mx
- Adalberto Benitez Zapata: adalb518@gmail.com
- Sergio Maldonado Rodriguez: sermalrod@outlook.com

## Desarrollo

El siguiente postwork, te servirá para ir desarrollando habilidades como
si se tratara de un proyecto que evidencie el progreso del aprendizaje
durante el módulo, sesión a sesión se irá desarrollando. A continuación
aparecen una serie de objetivos que deberás cumplir, es un ejemplo real
de aplicación y tiene que ver con datos referentes a equipos de la liga
española de fútbol (recuerda que los datos provienen siempre de diversas
naturalezas), en este caso se cuenta con muchos datos que se pueden
aprovechar, explotarlos y generar análisis interesantes que se pueden
aplicar a otras áreas. Siendo así damos paso a las instrucciones:

1.  Importa los datos de soccer de la temporada 2019/2020 de la primera
    división de la liga española a R, los datos los puedes encontrar en
    el siguiente [enlace](https://www.football-data.co.uk/spainm.php):

<!-- end list -->

``` r
# url donde se encuentra el archivo csv
url <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv" 
#lectura de datos
data <- read.csv(file = url)
```

2.  Del data frame que resulta de importar los datos a `R`, extrae las
    columnas que contienen los números de goles anotados por los equipos
    que jugaron en casa (FTHG) y los goles anotados por los equipos que
    jugaron como visitante (FTAG)

<!-- end list -->

``` r
#Visualizando los datos:
View(data);head(data)
```

    ##   Div       Date  Time   HomeTeam    AwayTeam FTHG FTAG FTR HTHG HTAG HTR HS AS
    ## 1 SP1 16/08/2019 20:00 Ath Bilbao   Barcelona    1    0   H    0    0   D 11 11
    ## 2 SP1 17/08/2019 16:00      Celta Real Madrid    1    3   A    0    1   A  7 17
    ## 3 SP1 17/08/2019 18:00   Valencia    Sociedad    1    1   D    0    0   D 14 12
    ## 4 SP1 17/08/2019 19:00   Mallorca       Eibar    2    1   H    1    0   H 16 11
    ## 5 SP1 17/08/2019 20:00    Leganes     Osasuna    0    1   A    0    0   D 13  4
    ## 6 SP1 17/08/2019 20:00 Villarreal     Granada    4    4   D    1    1   D 12 14
    ##   HST AST HF AF HC AC HY AY HR AR B365H B365D B365A  BWH  BWD  BWA  IWH  IWD
    ## 1   5   2 14  9  3  8  1  1  0  0  5.25  3.80  1.65 5.50 3.80 1.65 5.00 3.80
    ## 2   4  11 17 12  6  4  5  2  0  1  4.75  4.20  1.65 4.40 4.20 1.72 5.30 4.20
    ## 3   6   3 13 14  3  3  4  4  1  0  1.66  3.75  5.50 1.67 3.75 5.50 1.67 3.75
    ## 4   4   5 13 14  9  3  2  3  0  0  2.80  3.20  2.60 2.95 3.10 2.60 2.90 3.10
    ## 5   2   2 17 11  8  0  1  4  1  0  2.00  3.20  4.20 2.05 3.25 3.90 2.05 3.10
    ## 6   7   7 10 16  2  7  3  1  0  0  1.60  3.80  6.50 1.60 3.80 6.25 1.63 4.00
    ##    IWA  PSH  PSD  PSA  WHH WHD  WHA  VCH  VCD  VCA MaxH MaxD MaxA AvgH AvgD
    ## 1 1.70 5.15 3.84 1.74 5.00 3.8 1.70 5.00 3.80 1.75 5.50 3.95 1.76 5.07 3.81
    ## 2 1.60 4.73 4.18 1.72 5.25 4.2 1.60 4.75 4.20 1.73 5.30 4.40 1.73 4.67 4.12
    ## 3 5.30 1.68 3.94 5.47 1.67 3.8 5.25 1.67 3.90 5.75 1.72 3.98 5.75 1.68 3.80
    ## 4 2.60 2.98 3.14 2.66 2.90 3.1 2.62 2.90 3.13 2.70 3.05 3.20 2.70 2.91 3.09
    ## 5 4.05 2.10 3.21 4.13 2.05 3.2 4.00 2.10 3.20 4.10 2.10 3.30 4.25 2.06 3.18
    ## 6 5.50 1.62 3.99 6.13 1.60 3.9 5.80 1.65 4.00 5.75 1.65 4.15 6.50 1.61 3.95
    ##   AvgA B365.2.5 B365.2.5.1 P.2.5 P.2.5.1 Max.2.5 Max.2.5.1 Avg.2.5 Avg.2.5.1
    ## 1 1.71     1.80       2.00  1.81    2.09    1.85      2.11    1.79      2.05
    ## 2 1.69     1.53       2.50  1.52    2.66    1.53      2.72    1.49      2.58
    ## 3 5.29     2.00       1.80  2.08    1.82    2.14      1.83    2.07      1.77
    ## 4 2.62     2.30       1.61  2.45    1.60    2.47      1.65    2.34      1.60
    ## 5 4.02     2.50       1.53  2.72    1.50    2.75      1.54    2.59      1.49
    ## 6 5.80     1.80       2.00  1.88    2.02    1.90      2.05    1.84      1.98
    ##     AHh B365AHH B365AHA PAHH PAHA MaxAHH MaxAHA AvgAHH AvgAHA B365CH B365CD
    ## 1  0.75    1.99    1.94 1.98 1.94   2.00   1.95   1.96   1.92   5.25   3.80
    ## 2  0.75    2.04    1.89 2.01 1.91   2.05   1.91   2.00   1.88   5.25   4.20
    ## 3 -0.75    1.91    2.02 1.91 2.01   1.93   2.03   1.89   1.99   1.66   3.75
    ## 4  0.00    2.05    1.88 2.07 1.85   2.07   1.88   2.04   1.85   2.87   3.20
    ## 5 -0.50    2.08    1.85 2.10 1.82   2.10   1.85   2.06   1.83   1.90   3.10
    ## 6 -1.00    2.05    1.75 2.11 1.81   2.14   1.85   2.07   1.80   1.53   4.00
    ##   B365CA BWCH BWCD BWCA IWCH IWCD IWCA PSCH PSCD PSCA WHCH WHCD WHCA VCCH VCCD
    ## 1   1.65 4.75 3.75 1.75 5.00 3.80 1.70 5.34 3.62 1.78 5.00  3.8 1.70 4.80 3.80
    ## 2   1.57 4.50 4.10 1.70 4.60 3.80 1.75 5.10 4.46 1.65 5.00  4.2 1.63 5.20 4.40
    ## 3   5.50 1.65 3.80 5.50 1.67 3.80 5.30 1.69 3.88 5.47 1.65  3.9 5.25 1.70 3.90
    ## 4   2.55 2.95 3.10 2.60 2.90 3.10 2.60 2.96 3.26 2.60 2.90  3.1 2.60 3.00 3.13
    ## 5   5.00 1.95 3.20 4.50 1.90 3.15 4.85 1.90 3.18 5.30 2.05  3.2 4.00 1.90 3.20
    ## 6   6.50 1.57 3.80 6.50 1.55 4.05 6.30 1.54 4.19 6.87 1.62  3.9 5.80 1.57 4.00
    ##   VCCA MaxCH MaxCD MaxCA AvgCH AvgCD AvgCA B365C.2.5 B365C.2.5.1 PC.2.5
    ## 1 1.80  5.80  3.90  1.81  5.03  3.66  1.76      1.90        1.90   1.98
    ## 2 1.65  6.00  4.52  1.75  4.93  4.26  1.65      1.44        2.75   1.49
    ## 3 5.50  1.72  3.95  6.20  1.68  3.82  5.37      2.00        1.80   2.06
    ## 4 2.63  3.05  3.29  2.72  2.93  3.14  2.59      2.20        1.66   2.20
    ## 5 5.20  1.95  3.26  5.30  1.90  3.16  4.91      2.75        1.44   2.84
    ## 6 7.00  1.58  4.20  7.30  1.54  4.05  6.66      1.90        1.90   1.95
    ##   PC.2.5.1 MaxC.2.5 MaxC.2.5.1 AvgC.2.5 AvgC.2.5.1  AHCh B365CAHH B365CAHA
    ## 1     1.93     1.99       2.11     1.86       1.97  0.75     1.93     2.00
    ## 2     2.76     1.51       2.88     1.47       2.63  1.00     1.82     1.97
    ## 3     1.85     2.08       1.98     2.00       1.82 -0.75     1.94     1.99
    ## 4     1.74     2.38       1.74     2.24       1.66  0.00     2.11     1.82
    ## 5     1.47     2.85       1.50     2.69       1.46 -0.50     1.89     2.04
    ## 6     1.95     1.98       2.10     1.90       1.92 -1.00     1.96     1.97
    ##   PCAHH PCAHA MaxCAHH MaxCAHA AvgCAHH AvgCAHA
    ## 1  1.91  2.01    2.02    2.03    1.91    1.98
    ## 2  1.85  2.07    2.00    2.20    1.82    2.06
    ## 3  1.92  2.00    1.96    2.12    1.89    2.00
    ## 4  2.09  1.83    2.12    1.88    2.07    1.83
    ## 5  1.90  2.01    1.95    2.06    1.90    1.99
    ## 6  1.96  1.96    1.98    2.12    1.93    1.95

``` r
# Goles anotados por los equipos que jugaron en casa
FTHG <- data$FTHG 
View(FTHG)
FTHG
```

    ##   [1] 1 1 1 2 0 4 1 0 1 1 0 2 0 1 1 1 0 0 0 5 1 2 2 1 2 2 2 3 0 2 0 3 0 2 5 1 0
    ##  [38] 0 1 1 0 2 0 0 2 4 1 1 2 0 1 3 2 1 0 3 2 3 1 3 5 0 0 1 0 0 2 2 1 3 1 1 4 2
    ##  [75] 2 2 1 0 1 4 1 0 1 2 1 2 3 0 1 1 4 1 2 2 0 1 0 2 3 1 5 1 1 3 2 5 2 2 3 1 3
    ## [112] 1 0 3 0 4 0 1 1 1 3 2 0 4 3 2 3 0 1 2 1 2 1 3 1 1 0 1 0 0 1 4 1 2 1 2 2 4
    ## [149] 0 0 2 3 2 5 0 3 0 3 1 1 1 2 0 2 2 2 2 1 1 0 3 0 4 1 1 2 3 1 3 0 2 1 1 0 2
    ## [186] 2 1 1 1 1 0 0 2 0 2 4 3 1 1 1 2 1 2 1 2 0 0 1 3 0 2 1 0 1 2 1 0 1 3 2 2 2
    ## [223] 3 1 1 1 2 1 2 2 2 1 2 2 2 2 0 0 2 3 1 5 3 1 0 2 2 0 3 1 3 2 1 0 3 1 1 0 2
    ## [260] 1 1 2 1 0 1 1 1 1 2 1 2 2 1 2 0 1 0 1 3 1 1 2 0 1 2 2 0 0 2 3 0 1 0 1 1 1
    ## [297] 1 6 2 1 2 0 0 1 1 0 0 2 1 1 1 3 2 2 2 4 2 1 0 2 5 0 2 0 0 0 0 0 2 1 3 1 1
    ## [334] 2 0 0 0 1 1 1 2 1 3 1 1 0 2 1 2 2 2 0 1 0 1 1 2 0 1 1 3 0 1 1 2 0 1 2 0 1
    ## [371] 0 2 4 1 0 4 2 1 2 1

``` r
# Goles anotados por los equipos que jugaron como visitante
FTAG<-data$FTAG
View(FTAG)
FTAG
```

    ##   [1] 0 3 1 1 1 4 0 2 2 0 1 1 0 1 0 1 0 1 1 2 1 0 2 1 0 1 0 2 3 2 0 2 3 0 2 2 1
    ##  [38] 2 1 1 0 0 0 0 0 2 3 1 0 1 1 1 1 1 2 3 0 2 1 0 1 1 2 0 0 2 0 0 1 2 1 2 2 1
    ##  [75] 1 0 0 0 2 0 0 3 1 0 0 0 1 1 1 0 1 0 0 0 1 0 1 0 1 1 1 2 1 0 1 0 1 2 1 2 1
    ## [112] 1 0 0 0 2 1 2 2 1 0 0 4 1 1 1 1 0 2 1 2 1 1 1 1 2 2 3 1 0 2 1 2 1 0 0 4 0
    ## [149] 1 0 0 0 4 2 1 2 0 2 1 1 2 2 0 0 0 2 2 2 1 0 0 2 1 0 1 0 4 2 1 0 2 1 0 3 1
    ## [186] 2 0 2 1 1 3 1 1 0 0 1 0 2 1 0 0 1 0 2 0 0 0 0 0 1 1 0 1 0 1 1 2 1 1 1 1 0
    ## [223] 0 1 0 0 1 4 1 3 2 0 1 1 1 2 0 1 2 3 0 0 0 0 3 1 1 3 1 0 0 1 1 0 2 0 1 1 0
    ## [260] 1 2 2 0 0 0 4 1 2 1 2 0 1 1 0 1 2 4 1 1 1 1 2 0 0 0 2 0 5 0 0 1 1 0 3 0 1
    ## [297] 0 0 0 2 2 0 1 1 0 1 1 0 0 0 1 1 2 1 1 2 0 2 1 1 1 3 2 2 2 2 0 2 1 0 0 1 0
    ## [334] 2 1 1 0 4 1 0 1 1 0 3 0 0 0 2 3 0 1 1 0 2 2 0 0 0 2 2 1 2 2 2 3 2 2 1 0 0
    ## [371] 5 0 0 1 0 0 2 0 2 0

3.  Consulta cómo funciona la función table en R al ejecutar en la
    consola `?table`

<!-- end list -->

``` r
?Table
```

Posteriormente elabora tablas de frecuencias relativas para estimar las
siguientes probabilidades:

  - La probabilidad (marginal) de que el equipo que juega en casa anote
    x goles (x = 0, 1, 2, …)

<!-- end list -->

``` r
(table(FTHG)/length(FTHG))*100
```

    ## FTHG
    ##          0          1          2          3          4          5          6 
    ## 23.1578947 34.7368421 26.0526316 10.0000000  3.6842105  2.1052632  0.2631579

  - La probabilidad (marginal) de que el equipo que juega como visitante
    anote y goles (y = 0, 1, 2, …)

<!-- end list -->

``` r
(table(FTAG)/length(FTAG))*100
```

    ## FTAG
    ##          0          1          2          3          4          5 
    ## 35.7894737 35.2631579 21.3157895  4.7368421  2.3684211  0.5263158

  - La probabilidad (conjunta) de que el equipo que juega en casa anote
    x goles y el equipo que juega como visitante anote y goles (x = 0,
    1, 2, …, y = 0, 1, 2, …)

<!-- end list -->

``` r
(table(FTHG,FTAG)/dim(data)[1])*100
```

    ##     FTAG
    ## FTHG          0          1          2          3          4          5
    ##    0  8.6842105  7.3684211  3.9473684  2.1052632  0.5263158  0.5263158
    ##    1 11.3157895 12.8947368  8.4210526  1.3157895  0.7894737  0.0000000
    ##    2 10.2631579  9.2105263  5.2631579  0.7894737  0.5263158  0.0000000
    ##    3  3.6842105  3.6842105  1.8421053  0.5263158  0.2631579  0.0000000
    ##    4  1.0526316  1.3157895  1.0526316  0.0000000  0.2631579  0.0000000
    ##    5  0.5263158  0.7894737  0.7894737  0.0000000  0.0000000  0.0000000
    ##    6  0.2631579  0.0000000  0.0000000  0.0000000  0.0000000  0.0000000


