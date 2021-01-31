#Solucion al Postwork Sesion 2

#Cargar el paquete dplyr. Usamos las funciones suppressWarnings y supperssMessages para que no se impriman mensajes ni advertencias al cargar el paquete.
suppressWarnings(suppressMessages(library(dplyr)))

#Comenzamos importando los datos que se encuentran en archivos csv a R

#Creamos un vector de los urls
urls=c("https://www.football-data.co.uk/mmz4281/1718/SP1.csv",
"https://www.football-data.co.uk/mmz4281/1819/SP1.csv",
"https://www.football-data.co.uk/mmz4281/1920/SP1.csv")

#creamos un vector con el nombre para los archivos csv
names=c("url1718.csv","url1819.csv","url1920.csv")

#Descargamos los csv en caso de ser necesario
for (i in 1:length(urls)){
if (!file.exists(names[i])){
    download.file(urls[i], destfile =  names[i], mode = 'wb')
}
}

#Importamos los csv en una lista 
lista <- lapply(list.files(pattern="*.csv"), read.csv)

#Obtenemos una mejor idea de los datos que se encuentran en los datos con las funciones str, head, View y summary
str(lista[[1]]); str(lista[[2]]); str(lista[[3]])
head(lista[[1]]); head(lista[[2]]); head(lista[[3]])
View(lista[[1]]); View(lista[[2]]); View(lista[[3]])
summary(lista[[1]]); summary(lista[[2]]); summary(lista[[3]])

#Ahora seleccionaremos Unicamente las columnas Date, HomeTeam, AwayTeam, FTHG, FTAG y FTR en cada uno de los data frames. 
lista <- lapply(lista, select, Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)


#Con las funciones lapply y str observaremos la estrucura de nuestros nuevos data frames
lapply(lista, str)


#Arreglamos las columnas Date para que R reconozca los elementos como fechas, esto lo hacemos con las funciones mutate (paquete dplyr) y as.Date.
lista<-lappy(lista,mutate,Date = as.Date(Date, "%d/%m/%y"))

#Verificamos que nuestros cambios se hayan llevado a cabo
lapply(lista, str)

#Finalmente, con ayuda de las funciones rbind y do.call combinamos los data frames contenidos en nlista como un único data frame
data <- do.call(rbind, lista)
dim(data)



str(data)
tail(data)
View(data)
summary(data)



url1718 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"
url1819 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
url1920 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"
d1718 <- read.csv(file = url1718) # Importación de los datos a R
d1819 <- read.csv(file = url1819)
d1920 <- read.csv(file = url1920)

#Obtenemos una mejor idea de los datos que se encuentran en los data frames con las funciones str, head, View y summary
str(d1718); str(d1819); str(d1920)
head(d1718); head(d1819); head(d1920)
View(d1718); View(d1819); View(d1920)
summary(d1718); summary(d1819); summary(d1920)

#Ahora seleccionaremos únicamente las columnas Date, HomeTeam, AwayTeam, FTHG, FTAG y FTR en cada uno de los data frames. 
lista <- list(d1718, d1819, d1920)
nlista <- lapply(lista, select, Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)

#Con las funciones lapply y str observaremos la estrucura de nuestros nuevos data frames
lapply(nlista, str)

#Arreglamos las columnas Date para que R reconozca los elementos como fechas, esto lo hacemos con las funciones mutate (paquete dplyr) y as.Date.
nlista[[1]] <- mutate(nlista[[1]], Date = as.Date(Date, "%d/%m/%y"))
nlista[[2]] <- mutate(nlista[[2]], Date = as.Date(Date, "%d/%m/%Y"))
nlista[[3]] <- mutate(nlista[[3]], Date = as.Date(Date, "%d/%m/%Y"))

#Verificamos que nuestros cambios se hayan llevado a cabo
lapply(nlista, str)

#Finalmente, con ayuda de las funciones rbind y do.call combinamos los data frames contenidos en nlista como un único data frame
data <- do.call(rbind, nlista)
dim(data)

str(data)
tail(data)
View(data)
summary(data)
