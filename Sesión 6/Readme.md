Postwork 6
===========
Equipo 13 
03/02/2021

## Desarrollo
1. Importa el conjunto de datos y realiza lo siguiente:

 <!-- end list -->

´´´ r
#Importamos el conjunto de datos de match.data.csv
#no podia descarga el csv, por eso uso directaemente el link de github
url <- 'https://raw.githubusercontent.com/beduExpert/Programacion-con-R-Santander/master/Sesion-06/Postwork/match.data.csv'
matchdata <- read.table(url, header = TRUE, sep = ',')
View(matchdata)
str(matchdata)

attach(matchdata)

#agregar una nueva columna sumagoles que contena la suma de goles por partido
matchdata['sumagoles'] <- matchdata[,3] + matchdata[,5]
´´´
2. Obtén el promedio por mes de la suma de goles.

´´´r
#obtener el promedio por mes de la suma de los goles
library(dplyr)
install.packages('lubridate') #paquete para usar años.
library(lubridate)
matchdata$date<- as.Date(matchdata$date) #modificar tipo de dato en el dataframe

matchdata['Mes'] <-months(matchdata$date)
matchdata['Año'] <-year(matchdata$date)

#Agrupamos los datos por año y mes, y sacamos el promedio de goles por mes
agrupado1 <- matchdata %>% group_by(Año,Mes)
agru <- agrupado1 %>% summarise(promedio.goles = mean(sumagoles))

install.packages('zoo')#paquete para acomodar meses de forma Jan-Dic
library(zoo)

df <- data.frame('Año' = agru$Año, 'Mes'=agru$Mes, 'Promedio de goles' = agru$promedio.goles) #organizamos como Dataframe

df$my <- as.yearmon(paste(df$Mes, df$Año)) #acomodamos Jan-Dic
df <- df[order(df$my),] #sorteamos correctamente

#Seleccionamos hasta diciembre de 2019
n <-dim(df)[1]-5
df <-df[1:n,] 

´´´
3. Crea la serie de tiempo del promedio por mes de la suma de goles hasta diciembre de 2019
´´´r
class(df)
df <- ts(df[,3], start = 2010, end = 2019 ,frequency= 10)

class(df)
´´´
4. Grafica la serie de tiempo.
library(ggplot2)
plot(df, main = 'Promedio de Goles Anotados por Mes', xlab = 'Tiempo', ylab= 'Promedio', sub= 'Agosto 2010 - Diciembre 2019')



