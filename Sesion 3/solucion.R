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

# Goles anotados por los equipos que jugaron en casa
FTHG <- data$FTHG 
View(FTHG)
# Goles anotados por los equipos que jugaron como visitante
FTAG<-data$FTAG
View(FTAG)


#La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x = 0, 1, 2, ...)
pgol_casa<-(table(FTHG)/length(FTHG))*100

#(table(data$FTHG)/dim(data)[1])*100

#La probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y = 0, 1, 2, ...)
pgol_vis<-(table(FTAG)/length(FTAG))*100

#La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como visitante anote y goles (x = 0, 1, 2, ..., y = 0, 1, 2, ...)
pc_gol<-(table(FTHG,FTAG)/dim(data)[1])*100

pgol_casa<- as.data.frame(pgol_casa)
str(pgol_casa)

pgol_casa<- pgol_casa%>% rename(Goles = FTHG, Frecuencia = Freq)


pgol_vis<- as.data.frame(pgol_vis)
str(pgol_vis)

#Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo de casa
pgol_casa <- as.data.frame(pgol_casa)
str(pgol_casa)
pgol_casa <- pgol_casa %>% rename(Goles = FTHG, Probabilidad = Freq)
(pgol_casa)

#Realizando grafica 
#png(filename='plot1.png',width = 640,height = 480)
color_range <- colorRampPalette(c("blue","red"))
plot <- ggplot(pgol_casa, aes(x = Goles, y = Probabilidad)) + 
    geom_col (fill=color_range(9)) + theme_bw()+
    ggtitle('Probabilidades marginales estimadas de goles que anota el equipo de casa')+ xlab("Numero de Goles") + ylab("Probabilidad Marginal (%)")+theme(plot.title = element_text(hjust = 0.5))

plot
#dev.off()

#Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo visitante.
pgol_vis <- as.data.frame(pgol_vis)
str(pgol_vis)

pgol_vis <- rename(pgol_vis, Goles = FTAG, Probabilidad=Freq)
(pgol_vis)

#png(filename='plot2.png',width = 640,height = 480)
color_range <- colorRampPalette(c("blue","green"))
plot <- ggplot(pgol_vis, aes(x = Goles, y = Probabilidad)) + 
    geom_col (fill=color_range(7)) + theme_bw()+
    ggtitle('Probabilidades marginales estimadas de goles que anota el equipo visitante')+ xlab("Numero de Goles") + ylab("Probabilidad Marginal (%)")+theme(plot.title = element_text(hjust = 0.5))

plot
#dev.off()

#Un HeatMap para las probabilidades conjuntas estimadas de los números de goles que anotan el equipo de casa y el equipo visitante en un partido.
pc_gol<-as.data.frame(pc_gol)
str(pc_gol)

pc_gol <- rename(pc_gol, goles_casa = FTHG, goles_visita = FTAG, Probabilidad = Freq)
head(pc_gol)

#png(filename='plot3.png',width = 640,height = 480)
plot<-ggplot(pc_gol, aes(goles_casa, goles_visita)) + 
    geom_tile(aes(fill = Probabilidad),colour = "white")+ 
    scale_fill_gradient(low = "aquamarine", high = "steelblue")+
    labs(fill = "Probabiliad (%)")+
    xlab("Goles de equipo de casa") + 
    ylab("Goles de equipo visitante")+
    ggtitle('Probabilidades conjuntas estimadas')+
    theme(plot.title = element_text(hjust = 0.5))

plot
#dev.off()
