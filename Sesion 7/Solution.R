#Cargamos librerias necesarias
suppressWarnings(suppressMessages(library(dplyr)))
library(mongolite)
#Comenzamos importando los datos que se encuentran en archivos csv a R

url1516 <- "https://www.football-data.co.uk/mmz4281/1516/SP1.csv"
url1415 <- "https://www.football-data.co.uk/mmz4281/1415/SP1.csv"


#importando los archivos a R
d1516 <- read.csv(file = url1516) 
d1415 <- read.csv(file = url1415)


#unimos los datos descargados y transformamos la columna date en formato fecha
lista <- list(d1415,d1516)
lista<-lapply(lista,mutate,Date = as.Date(Date, "%d/%m/%y"))
#Ahora seleccionaremos Unicamente las columnas Date, HomeTeam, AwayTeam, FTHG, FTAG y FTR en cada uno de los data frames.
nlista <- lapply(lista, select, Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)
#unimos los datos en un solo data frame
data <- do.call(rbind, nlista)

#creamos el archivo data.csv con las fechas necesarias
write.csv(data, file = 'data.csv',row.names = FALSE)

#Leemos el archivo Recien creado
match=data.table::fread("data.csv")
#obtenemos una vista del nombre de las columnas
names(match)

#creamos una conexion con mongodb, y creamos la base de datos y la coleccion
my_collection = mongo(collection = "match", db = "match_games",url="mongodb+srv://introabd_18:introabd1234@cluster0.pjr7w.mongodb.net/test?authSource=admin&replicaSet=atlas-13a7dg-shard-0&readPreference=primary&appname=MongoDB%20Compass&ssl=true") 

if ((my_collection$count()==0)){
    my_collection$insert(match)
}

# Número de registros
my_collection$count()

# Visualizar el fichero recien creado
my_collection$find()

# realizando la consulta
my_collection$find('{"Date":"2015-12-20", "HomeTeam":"Real Madrid"}')

#eliminando la base de datos recien creada:
my_collection$drop()

# Cerrando la conexión
rm(my_collection)
