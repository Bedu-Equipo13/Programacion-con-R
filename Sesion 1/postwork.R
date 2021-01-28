#Importa los datos de soccer de la temporada 2019/2020 de la primera división de la liga española a R, los datos los puedes encontrar en el siguiente enlace:
# https://www.football-data.co.uk/spainm.php

# url donde se encuentra el archivo csv
url <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv" 
#lectura de datos
data <- read.csv(file = url)

#Del data frame que resulta de importar los datos a R, extrae las columnas que contienen los números de goles anotados por los equipos que jugaron en casa (FTHG) y los goles anotados por los equipos que jugaron como visitante (FTAG)
#Visualizando los datos:
View(data);head(data)

# Goles anotados por los equipos que jugaron en casa
FTHG <- data$FTHG 
View(FTHG)
# Goles anotados por los equipos que jugaron como visitante
FTAG<-data$FTAG
View(FTAG)

#Consulta cómo funciona la función table en R al ejecutar en la consola ?table
?Table


#La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x = 0, 1, 2, ...)
(table(FTHG)/length(FTHG))*100

#(table(data$FTHG)/dim(data)[1])*100

#La probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y = 0, 1, 2, ...)
(table(FTAG)/length(FTAG))*100

#La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como visitante anote y goles (x = 0, 1, 2, ..., y = 0, 1, 2, ...)
(table(FTHG,FTAG)/dim(data)[1])*100

