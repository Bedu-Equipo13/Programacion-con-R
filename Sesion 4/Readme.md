postwork 4
================
Equipo 13
29/1/2021

## Desarrollo

Ahora investigarás la dependencia o independencia del número de goles
anotados por el equipo de casa y el número de goles anotados por el
equipo visitante mediante un procedimiento denominado bootstrap, revisa
bibliografía en internet para que tengas nociones de este desarrollo.

1.  Ya hemos estimado las probabilidades conjuntas de que el equipo de
    casa anote X=x goles (x=0,1,… ,8), y el equipo visitante anote Y=y
    goles (y=0,1,… ,6), en un partido. Obtén una tabla de cocientes al
    dividir estas probabilidades conjuntas por el producto de las
    probabilidades marginales correspondientes.

<!-- end list -->

``` r
#Librerias que seran ocupadas
suppressWarnings(suppressMessages(library(dplyr)))
suppressWarnings(suppressMessages(library(reshape2)))
suppressWarnings(suppressMessages(library(ggplot2)))
```

``` r
#Comenzamos importando los datos que se encuentran en archivos csv a R

url1718 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"
url1819 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
url1920 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"

#importando los archivos a R
d1718 <- read.csv(file = url1718) 
d1819 <- read.csv(file = url1819)
d1920 <- read.csv(file = url1920)
```

``` r
#Ahora seleccionaremos Unicamente las columnas Date, HomeTeam, AwayTeam, FTHG, FTAG y FTR en cada uno de los data frames.
lista <- list(d1718, d1819, d1920)
nlista <- lapply(lista, select, Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)
```

``` r
#Finalmente, con ayuda de las funciones rbind y do.call combinamos los data frames contenidos en nlista como un único data frame
data <- do.call(rbind, nlista)
```

``` r
#Con ayuda de la función table obtenemos las estimaciones de probabilidades solicitadas

# Probabilidades marginales estimadas para los equipos que juegan en casa
(pcasa <- round(table(data$FTHG)/dim(data)[1], 3)) 
```

    ## 
    ##     0     1     2     3     4     5     6     7     8 
    ## 0.232 0.327 0.267 0.112 0.035 0.019 0.005 0.001 0.001

``` r
# Probabilidades marginales estimadas para los equipos que juegan como visitante
(pvisita <- round(table(data$FTAG)/dim(data)[1], 3)) 
```

    ## 
    ##     0     1     2     3     4     5     6 
    ## 0.352 0.340 0.212 0.054 0.029 0.010 0.003

``` r
# Probabilidades conjuntas estimadas para los partidos
(pcta <- round(table(data$FTHG, data$FTAG)/dim(data)[1], 3)) 
```

    ##    
    ##         0     1     2     3     4     5     6
    ##   0 0.078 0.081 0.046 0.018 0.005 0.004 0.000
    ##   1 0.116 0.115 0.068 0.018 0.009 0.002 0.000
    ##   2 0.088 0.094 0.061 0.011 0.009 0.002 0.002
    ##   3 0.045 0.032 0.025 0.006 0.002 0.002 0.001
    ##   4 0.014 0.011 0.007 0.000 0.004 0.000 0.000
    ##   5 0.009 0.005 0.004 0.000 0.001 0.000 0.000
    ##   6 0.003 0.002 0.000 0.001 0.000 0.000 0.000
    ##   7 0.000 0.001 0.000 0.000 0.000 0.000 0.000
    ##   8 0.000 0.000 0.001 0.000 0.000 0.000 0.000

``` r
#Con la función apply primero dividimos cada elemento de las columnas de la matriz de probabilidades conjuntas, por las probabilidades marginales asociadas y que corresponden al equipo de casa. 

cocientes <- apply(pcta, 2, function(col) col/pcasa)

cocientes <- apply(cocientes, 1, function(fila) fila/pvisita)

#Aplicamos la traspuesta al dataframe para regresar a nuestra tabla inicial
(cocientes <- t(cocientes))
```

    ##    
    ##             0         1         2         3         4         5        6
    ##   0 0.9551332 1.0268763 0.9352635 1.4367816 0.7431629 1.7241379 0.000000
    ##   1 1.0077843 1.0343587 0.9809013 1.0193680 0.9490668 0.6116208 0.000000
    ##   2 0.9363296 1.0354704 1.0776624 0.7629352 1.1623402 0.7490637 2.496879
    ##   3 1.1414367 0.8403361 1.0528976 0.9920635 0.6157635 1.7857143 2.976190
    ##   4 1.1363636 0.9243697 0.9433962 0.0000000 3.9408867 0.0000000 0.000000
    ##   5 1.3456938 0.7739938 0.9930487 0.0000000 1.8148820 0.0000000 0.000000
    ##   6 1.7045455 1.1764706 0.0000000 3.7037037 0.0000000 0.0000000 0.000000
    ##   7 0.0000000 2.9411765 0.0000000 0.0000000 0.0000000 0.0000000 0.000000
    ##   8 0.0000000 0.0000000 4.7169811 0.0000000 0.0000000 0.0000000 0.000000

``` r
#Tranformamos el data frame en tres columnas para tener un mejor manejo
head(cocientes<-melt(as.table(cocientes)))
```

    ##   Var1 Var2     value
    ## 1    0    0 0.9551332
    ## 2    1    0 1.0077843
    ## 3    2    0 0.9363296
    ## 4    3    0 1.1414367
    ## 5    4    0 1.1363636
    ## 6    5    0 1.3456938

``` r
#creamos una nueva Columna combinando las columnas de goles de equipos en casa (var1) y 
# goles de equipos como visitantes (var2)

cocientes<-cocientes%>%mutate("Comb"=paste0(Var1,",",Var2))%>%select(Comb,value)
head(cocientes)
```

    ##   Comb     value
    ## 1  0,0 0.9551332
    ## 2  1,0 1.0077843
    ## 3  2,0 0.9363296
    ## 4  3,0 1.1414367
    ## 5  4,0 1.1363636
    ## 6  5,0 1.3456938

``` r
cocientes<-subset(cocientes,value!=0)
head(cocientes)
```

``` r
#Extraemos la columna recien creada que combina las var1 y var2
cocientes.df<-cocientes[,1,drop=FALSE]
head(cocientes.df)
```

    ##   Comb
    ## 1  0,0
    ## 2  1,0
    ## 3  2,0
    ## 4  3,0
    ## 5  4,0
    ## 6  5,0

2.  Mediante un procedimiento de boostrap, obtén más cocientes similares
    a los obtenidos en la tabla del punto anterior. Esto para tener una
    idea de las distribuciones de la cual vienen los cocientes en la
    tabla anterior. Menciona en cuáles casos le parece razonable suponer
    que los cocientes de la tabla en el punto 1, son iguales a 1 (en tal
    caso tendríamos independencia de las variables aleatorias X y Y).

<!-- end list -->

``` r
# Implementacion del metodo bootstrap el cual se basa en la toma de muestras aleatorias
# con remplazo, para esto se emplea la funcion sample y se realizara 1000 tomas de muestras

for (i in 1:1000) {

    # La implementacion de una semilla (seed) garantizara la reproducibilidad de los resultados
    set.seed(i)
    #Primero extraemos de manera aleatoria algunas filas de nuestro data frame data, esto lo hacemos con ayuda de la función sample.
    indices <- sample(dim(data)[1], size = 1140, replace = TRUE)
    newdata <- data[indices, ]
    
    #Con ayuda de la función table obtenemos las estimaciones de probabilidades
    
    # Probabilidades marginales estimadas para los equipos que juegan en casa
    pcasa1 <- round(table(newdata$FTHG)/dim(newdata)[1], 3)
    
    # Probabilidades conjuntas estimadas para los partidos
    pvisita1 <- round(table(newdata$FTAG)/dim(newdata)[1], 3)
    
    # Probabilidades conjuntas estimadas para los partidos
    pcta1 <- round(table(newdata$FTHG, newdata$FTAG)/dim(newdata)[1], 3)
    
    #Obtenemos nuevamente los cocientes de probabilidades conjuntas entre 
    #probabilidades marginales
    
    cocientes1 <- pcta1/outer(pcasa1, pvisita1, "*")
    
    #transformamos la tabla en un data frame
    cocientes1<-as.data.frame(cocientes1)
    
    #Creamos una nueva columna que combine las variables Var1 y Var2, las cuales
    #significan numero de goles anotados por un equipo jugando en casa
    # y numero de goles de un equipo jugando como visitante respectivamente
    
    cocientes1<-cocientes1%>%mutate("Comb"=paste0(Var1,",",Var2))%>%
        select(Comb,Freq)#%>%rename(x=Freq)
    
    #Guardamos cada resultado generado de cada nuevo muestreo en un data frame
    cocientes.df<-cocientes.df%>%left_join(cocientes1,by="Comb")%>%
        rename_with(.fn = ~paste0("y",i),.cols=starts_with("F"))
    

}
```

``` r
#Despues del ciclo for obtenemos un data frama con las 1000 muestras
dim(cocientes.df);str(cocientes.df)
```

    ## [1]   39 1001

    ## 'data.frame':    39 obs. of  1001 variables:
    ##  $ Comb : chr  "0,0" "1,0" "2,0" "3,0" ...
    ##  $ y1   : num  0.883 1.091 0.888 1.1 1.275 ...
    ##  $ y2   : num  0.942 1.005 0.981 1.073 1.315 ...
    ##  $ y3   : num  0.959 1.169 0.712 1.161 1.196 ...
    ##  $ y4   : num  0.987 0.995 0.972 1.089 1.164 ...
    ##  $ y5   : num  0.992 1.061 0.862 1.209 1.096 ...
    ##  $ y6   : num  1.015 1.045 0.844 1.139 1.093 ...
    ##  $ y7   : num  0.953 1.081 0.895 1.054 1.181 ...
    ##  $ y8   : num  1 1 0.85 1.23 1.14 ...
    ##  $ y9   : num  1.002 1.028 0.979 1.037 0.815 ...
    ##  $ y10  : num  0.87 0.954 0.947 1.246 1.427 ...
    ##  $ y11  : num  0.909 1.047 1.013 1.003 1.108 ...
    ##  $ y12  : num  0.873 1.039 0.97 0.974 1.112 ...
    ##  $ y13  : num  0.988 1.026 0.878 1.064 1.305 ...
    ##  $ y14  : num  1.004 0.972 0.944 1.126 1.411 ...
    ##  $ y15  : num  1.01 0.939 0.974 1.135 1.172 ...
    ##  $ y16  : num  0.891 0.992 1.015 1.226 0.974 ...
    ##  $ y17  : num  1.01 1 0.83 1.23 1.11 ...
    ##  $ y18  : num  0.888 1.014 0.948 1.312 1.005 ...
    ##  $ y19  : num  0.909 0.984 0.9 1.15 1.432 ...
    ##  $ y20  : num  1.002 1.005 0.901 1.08 1.333 ...
    ##  $ y21  : num  0.996 1.042 0.881 1.087 1.014 ...
    ##  $ y22  : num  0.982 1.008 0.842 1.284 1.243 ...
    ##  $ y23  : num  0.993 1.021 0.899 1.173 0.991 ...
    ##  $ y24  : num  0.984 0.926 0.928 1.273 1.12 ...
    ##  $ y25  : num  0.911 0.978 0.973 1.126 1.071 ...
    ##  $ y26  : num  0.932 1.003 0.969 1.117 1.106 ...
    ##  $ y27  : num  1.014 0.938 0.951 1.134 1.344 ...
    ##  $ y28  : num  0.95 0.94 0.916 1.35 1.126 ...
    ##  $ y29  : num  0.906 1.068 1.037 1.009 0.829 ...
    ##  $ y30  : num  0.955 1.057 0.917 1.181 0.974 ...
    ##  $ y31  : num  1.073 0.916 0.881 1.234 1.293 ...
    ##  $ y32  : num  0.947 0.981 0.878 1.429 1.059 ...
    ##  $ y33  : num  0.794 1.036 0.975 1.243 1.231 ...
    ##  $ y34  : num  0.939 1.052 0.88 1.201 1.168 ...
    ##  $ y35  : num  0.916 0.959 0.881 1.331 1.499 ...
    ##  $ y36  : num  0.91 1.025 0.904 1.184 1.04 ...
    ##  $ y37  : num  0.889 1.034 0.99 1.221 0.779 ...
    ##  $ y38  : num  0.836 1.009 0.973 1.191 1.159 ...
    ##  $ y39  : num  0.939 1.023 0.982 0.929 1.249 ...
    ##  $ y40  : num  0.965 1.102 0.884 0.95 0.971 ...
    ##  $ y41  : num  1.03 1.07 0.81 1.19 1.01 ...
    ##  $ y42  : num  0.955 1.031 0.843 1.27 1.359 ...
    ##  $ y43  : num  0.945 0.988 0.813 1.432 1.232 ...
    ##  $ y44  : num  1.022 1.018 0.893 1.111 0.853 ...
    ##  $ y45  : num  0.875 1.125 0.883 1.16 0.791 ...
    ##  $ y46  : num  0.865 1.045 0.927 1.197 1.278 ...
    ##  $ y47  : num  1.019 1.041 0.894 0.969 1.111 ...
    ##  $ y48  : num  1.008 1.14 0.828 1.068 0.623 ...
    ##  $ y49  : num  1.039 1.017 0.867 1.05 0.997 ...
    ##  $ y50  : num  0.998 0.96 0.878 1.128 1.812 ...
    ##  $ y51  : num  1.013 1.052 0.847 1.113 0.958 ...
    ##  $ y52  : num  0.936 1.021 0.917 1.128 1.342 ...
    ##  $ y53  : num  0.967 0.974 0.999 1.195 0.909 ...
    ##  $ y54  : num  0.975 1.005 0.837 1.24 1.462 ...
    ##  $ y55  : num  0.968 0.996 0.895 1.035 1.351 ...
    ##  $ y56  : num  1.04 1.01 0.86 1.06 1.03 ...
    ##  $ y57  : num  0.958 0.915 1.069 1.204 0.769 ...
    ##  $ y58  : num  0.927 1.11 0.764 1.227 1.309 ...
    ##  $ y59  : num  1.034 0.947 0.915 1.158 1.277 ...
    ##  $ y60  : num  1.004 0.904 0.919 1.276 1.391 ...
    ##  $ y61  : num  0.979 0.992 1.019 0.908 1.017 ...
    ##  $ y62  : num  0.928 1.057 0.895 1.308 0.842 ...
    ##  $ y63  : num  1.001 1.058 0.789 1.202 0.983 ...
    ##  $ y64  : num  0.921 1.017 0.872 1.205 1.316 ...
    ##  $ y65  : num  1.01 0.979 0.874 1.217 0.901 ...
    ##  $ y66  : num  0.988 0.922 0.941 1.382 0.886 ...
    ##  $ y67  : num  0.939 0.979 0.951 1.147 1.419 ...
    ##  $ y68  : num  0.927 1.003 0.989 1.073 1.197 ...
    ##  $ y69  : num  0.959 0.969 0.944 1.179 1.127 ...
    ##  $ y70  : num  1.064 1.057 0.837 1.06 0.908 ...
    ##  $ y71  : num  0.786 0.937 1.113 1.297 0.892 ...
    ##  $ y72  : num  1.034 0.995 0.865 1.23 1.365 ...
    ##  $ y73  : num  0.856 1.043 0.995 1.088 0.999 ...
    ##  $ y74  : num  1.007 1.006 0.933 0.908 1.529 ...
    ##  $ y75  : num  0.939 0.908 0.995 1.149 1.399 ...
    ##  $ y76  : num  1.045 1.028 0.879 1.087 0.91 ...
    ##  $ y77  : num  0.963 0.854 1.079 1.173 1.146 ...
    ##  $ y78  : num  1.028 1.061 0.839 1.017 1.282 ...
    ##  $ y79  : num  0.966 1.054 0.933 0.928 1.246 ...
    ##  $ y80  : num  1.141 0.915 0.973 1.078 0.962 ...
    ##  $ y81  : num  0.905 1.06 0.923 1.139 0.963 ...
    ##  $ y82  : num  0.985 0.998 0.93 1.038 0.974 ...
    ##  $ y83  : num  1.093 0.973 0.883 1.154 0.804 ...
    ##  $ y84  : num  0.913 1.026 0.934 1.229 1.109 ...
    ##  $ y85  : num  0.859 1.007 0.957 1.287 1.053 ...
    ##  $ y86  : num  0.981 1.018 0.983 0.949 1.352 ...
    ##  $ y87  : num  0.967 1.062 0.932 1.027 0.905 ...
    ##  $ y88  : num  1.008 1.012 0.911 1.192 0.912 ...
    ##  $ y89  : num  0.882 1.058 0.958 1.025 0.96 ...
    ##  $ y90  : num  0.902 1.016 0.898 1.142 1.672 ...
    ##  $ y91  : num  0.908 0.999 0.983 1.113 0.972 ...
    ##  $ y92  : num  0.942 1.046 0.872 1.122 1.137 ...
    ##  $ y93  : num  0.944 1.027 0.89 1.197 1.108 ...
    ##  $ y94  : num  0.92 1.057 0.779 1.323 1.308 ...
    ##  $ y95  : num  0.992 1.007 0.866 1.108 1.433 ...
    ##  $ y96  : num  0.971 0.949 0.965 1.106 1.142 ...
    ##  $ y97  : num  0.944 1.084 0.923 0.915 1.304 ...
    ##  $ y98  : num  0.858 1.058 0.932 1.227 0.979 ...
    ##   [list output truncated]

Calculamos los parametros estadisticos necesarios para evaluar la
independencia de las variables (var1 y var2), los paramestros que se
calcularon son:

  - `mean`: promedio de la muestra
  - `sd`: desviacion estandar de la muestra
  - `row`: numero de elementos no NA de la muestra
  - `Estimador`: el estimador estadistico (Z0)
  - `z025`: considerando un nivel de significancia de alpha=0.05 debemos
    encontrar z\_{0.025} es decir (z0 \< -z.025) | (z0 \> z.025) la
    region de rechazo es de dos colas
  - `pvalue`: considerando una Ho=1 (hipotesis nula) y Ha\<\>1
    (hipotesis alternativa)
  - `sht`: Shapiro test para determinar si la distribucion es normal y
    se puede aplicar el teorema de limite central

<!-- end list -->

``` r
resumen_cocientes<-cocientes.df%>%rowwise(Comb)%>%
    mutate(mean=mean(c_across(cols = everything()),na.rm = TRUE),
           sd=sd(c_across(cols = everything()),na.rm =TRUE),
           row=sum(!is.na(c_across(cols = everything()))),
           estimador=(mean-1)/(sd/sqrt(row)),
           z025=qnorm(p = 0.025, lower.tail = FALSE),
           pvalue=2*pnorm(abs(estimador), lower.tail = FALSE),
           sht = list(shapiro.test(c_across(cols = everything()))))%>%
    select(mean,sd,estimador,z025,pvalue,sht)
```

``` r
#Extrayendo el p value de la funcion Shapiro.test
resumen_cocientes$p.value_shapiro<-lapply(resumen_cocientes$sht, `[[`, 2) 
```

Data frame final con los resultados

``` r
resumen_cocientes <- subset( resumen_cocientes, select = -sht )
```

    ##    Comb      mean         sd   estimador     z025        pvalue p.value_shapiro
    ## 1   0,0 0.9538946 0.07106138 -20.5377171 1.959964  9.911293e-94     1.41924e-57
    ## 2   1,0 1.0079016 0.05586314   4.4773591 1.959964  7.557209e-06    1.388473e-57
    ## 3   2,0 0.9336241 0.06482727 -32.4105625 1.959964 1.948510e-230    1.433099e-57
    ## 4   3,0 1.1313889 0.11426944  36.3967343 1.959964 4.794736e-290    1.449727e-57
    ## 5   4,0 1.1406889 0.22215718  20.0462645 1.959964  2.175821e-89    1.474701e-57
    ## 6   5,0 1.3057052 0.30832692  31.3852271 1.959964 3.218766e-216     1.52789e-57
    ## 7   6,0 1.5256219 0.67112630  24.7295826 1.959964 5.141982e-135    2.149844e-57
    ## 8   0,1 1.0237134 0.07767355   9.6639348 1.959964  4.290601e-22    1.402949e-57
    ## 9   1,1 1.0286592 0.05776967  15.7035640 1.959964  1.429787e-55    1.402311e-57
    ## 10  2,1 1.0333529 0.06913300  15.2715331 1.959964  1.183574e-52    1.406249e-57
    ## 11  3,1 0.8532213 0.11142689 -41.6971911 1.959964  0.000000e+00    1.465222e-57
    ## 12  4,1 0.8889420 0.21403543 -16.4247230 1.959964  1.272637e-60    1.471999e-57
    ## 13  5,1 0.7939403 0.26638511 -24.4859510 1.959964 2.085028e-132    1.505966e-57
    ## 14  6,1 1.1135565 0.70531835   5.0836358 1.959964  3.702776e-07    2.128112e-57
    ## 15  7,1 2.9420916 0.12274425 395.5565301 1.959964  0.000000e+00    2.714713e-48
    ## 16  0,2 0.9201104 0.10326407 -24.4892200 1.959964 1.924370e-132    1.437617e-57
    ## 17  1,2 0.9856164 0.08063379  -5.6465624 1.959964  1.636878e-08    1.402677e-57
    ## 18  2,2 1.0918107 0.09736758  29.8478178 1.959964 9.370284e-196    1.434807e-57
    ## 19  3,2 1.0227010 0.16070260   4.4715185 1.959964  7.766613e-06    1.429474e-57
    ## 20  4,2 0.9352361 0.29786688  -6.8824754 1.959964  5.882133e-12    1.493635e-57
    ## 21  5,2 1.0921786 0.40532020   7.1988918 1.959964  6.070389e-13    1.537577e-57
    ## 22  8,2 4.7336730 0.27445370 347.3689420 1.959964  0.000000e+00    4.758037e-49
    ## 23  0,3 1.4554957 0.25278348  57.0386806 1.959964  0.000000e+00     1.53674e-57
    ## 24  1,3 0.9969798 0.18282463  -0.5229214 1.959964  6.010290e-01    1.435424e-57
    ## 25  2,3 0.7816919 0.18204513 -37.9598669 1.959964  0.000000e+00    1.489907e-57
    ## 26  3,3 1.0045741 0.34266861   0.4225381 1.959964  6.726323e-01    1.501103e-57
    ## 27  6,3 3.2958212 3.30877196  21.9088112 1.959964 2.140981e-106     5.97636e-57
    ## 28  0,4 0.7796098 0.28671414 -24.3319601 1.959964 9.000167e-131    1.514447e-57
    ## 29  1,4 0.9301196 0.25147624  -8.7961389 1.959964  1.416043e-18    1.476894e-57
    ## 30  2,4 1.1404386 0.30872780  14.3994024 1.959964  5.219286e-47    1.505098e-57
    ## 31  3,4 0.6031823 0.39454741 -31.8365304 1.959964 2.022163e-222    1.575598e-57
    ## 32  4,4 3.6379405 1.49756760  55.7586728 1.959964  0.000000e+00    2.377231e-57
    ## 33  5,4 1.7965901 1.75478578  14.3695992 1.959964  8.029457e-47    2.405172e-57
    ## 34  0,5 1.9917623 0.66798204  46.9977056 1.959964  0.000000e+00    1.736318e-57
    ## 35  1,5 0.6278565 0.40590477 -29.0215164 1.959964 3.521979e-185    1.575622e-57
    ## 36  2,5 0.7475879 0.50882460 -15.7027568 1.959964  1.448100e-55    1.603258e-57
    ## 37  3,5 1.8114736 1.19925451  21.4188872 1.959964 8.909189e-102    2.026651e-57
    ## 38  2,6 2.5516547 1.19371728  39.9373829 1.959964  0.000000e+00    3.322953e-56
    ## 39  3,6 3.1008362 2.85404984  22.6160434 1.959964 3.013223e-113    6.536799e-56

Las conclusiones tras las realización del postwork son las siguientes:

Los únicos casos en donde las variables aleatorias son independientes
son en donde los puntajes son 1,3 y 3,3 siendo puntaje casa y visitante
respectivamente, se ha llegado a tal conclusión tras la aplicación de
una prueba de hipotesis, sin embargo, a partir de simples observaciones
se cree que varios otros casos podrian ser independientes tomando en
cuenta solo las medias y desviaciones estándar de cada caso.

