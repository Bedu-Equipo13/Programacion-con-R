
#```R
library(fbRanks)
library(dplyr)
library(ggplot2)



# Colocar el directorio de trabajo segun corresponda

#setwd("C:/Users/User/Documents/Bedu/Sesion 8/post/")
#```

#```R
# Descarga de archivos
# https://www.football-data.co.uk/spainm.php

u1011 <- "https://www.football-data.co.uk/mmz4281/1011/SP1.csv"
u1112 <- "https://www.football-data.co.uk/mmz4281/1112/SP1.csv"
u1213 <- "https://www.football-data.co.uk/mmz4281/1213/SP1.csv"
u1314 <- "https://www.football-data.co.uk/mmz4281/1314/SP1.csv"
u1415 <- "https://www.football-data.co.uk/mmz4281/1415/SP1.csv"
u1516 <- "https://www.football-data.co.uk/mmz4281/1516/SP1.csv"
u1617 <- "https://www.football-data.co.uk/mmz4281/1617/SP1.csv"
u1718 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"
u1819 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
u1920 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"

#RawData <- "C:\\\"
download.file(url = u1011, destfile ="SP1-1011.csv", mode = "wb")
download.file(url = u1112, destfile ="SP1-1112.csv", mode = "wb")
download.file(url = u1213, destfile ="SP1-1213.csv", mode = "wb")
download.file(url = u1314, destfile ="SP1-1314.csv", mode = "wb")
download.file(url = u1415, destfile ="SP1-1415.csv", mode = "wb")
download.file(url = u1516, destfile ="SP1-1516.csv", mode = "wb")
download.file(url = u1617, destfile ="SP1-1617.csv", mode = "wb")
download.file(url = u1718, destfile ="SP1-1718.csv", mode = "wb")
download.file(url = u1819, destfile ="SP1-1819.csv", mode = "wb")
download.file(url = u1920, destfile ="SP1-1920.csv", mode = "wb")
#```

#```R
# Lectura de datos

#lista <- lapply(list.files(path = RawData), read.csv)
#```

#```R
# Procesamiento de datos

#lista <- lapply(lista, select, Date:FTR)

d1011 <- read.csv("SP1-1011.csv")
d1112 <- read.csv("SP1-1112.csv")
d1213 <- read.csv("SP1-1213.csv")
d1314 <- read.csv("SP1-1314.csv")
d1415 <- read.csv("SP1-1415.csv")
d1516 <- read.csv("SP1-1516.csv")
d1617 <- read.csv("SP1-1617.csv")
d1718 <- read.csv("SP1-1718.csv")
d1819 <- read.csv("SP1-1819.csv")
d1920 <- read.csv("SP1-1920.csv")

d1011S <- select(d1011, Date:FTAG, BbMx.2.5:BbAv.2.5.1)
d1112S <- select(d1112, Date:FTAG, BbMx.2.5:BbAv.2.5.1)
d1213S <- select(d1213, Date:FTAG, BbMx.2.5:BbAv.2.5.1)
d1314S <- select(d1314, Date:FTAG, BbMx.2.5:BbAv.2.5.1)
d1415S <- select(d1415, Date:FTAG, BbMx.2.5:BbAv.2.5.1)
d1516S <- select(d1516, Date:FTAG, BbMx.2.5:BbAv.2.5.1)
d1617S <- select(d1617, Date:FTAG, BbMx.2.5:BbAv.2.5.1)
d1718S <- select(d1718, Date:FTAG, BbMx.2.5:BbAv.2.5.1)
d1819S <- select(d1819, Date:FTAG, BbMx.2.5:BbAv.2.5.1)
d1920S <- select(d1920, Date:FTAG, Max.2.5:Avg.2.5.1)
d1920S <- select(d1920S, -Time)
#colnames(d1718S); colnames(d1819S); colnames(d1920S)

# Arreglamos las fechas
d1011S <- mutate(d1011S, Date = as.Date(Date, format = "%d/%m/%y"))
d1112S <- mutate(d1112S, Date = as.Date(Date, format = "%d/%m/%y"))
d1213S <- mutate(d1213S, Date = as.Date(Date, format = "%d/%m/%y"))
d1314S <- mutate(d1314S, Date = as.Date(Date, format = "%d/%m/%y"))
d1415S <- mutate(d1415S, Date = as.Date(Date, format = "%d/%m/%y"))
d1516S <- mutate(d1516S, Date = as.Date(Date, format = "%d/%m/%y"))
d1617S <- mutate(d1617S, Date = as.Date(Date, format = "%d/%m/%y"))
d1718S <- mutate(d1718S, Date = as.Date(Date, format = "%d/%m/%y"))
d1819S <- mutate(d1819S, Date = as.Date(Date, format = "%d/%m/%Y"))
d1920S <- mutate(d1920S, Date = as.Date(Date, format = "%d/%m/%Y"))
#```

#```R
# Unimos de d1415S a d1819S

d1019S <- rbind(d1011S, d1112S, d1213S, d1314S, d1415S, d1516S, d1617S, d1718S, d1819S)
#```

#```R
# Renombrar columnas

d1019S <- rename(d1019S,  Max.2.5.O = BbMx.2.5, 
                 Avg.2.5.O = BbAv.2.5, 
                 Max.2.5.U = BbMx.2.5.1,
                 Avg.2.5.U = BbAv.2.5.1)

d1920S <- rename(d1920S,  Max.2.5.O = Max.2.5, 
                 Avg.2.5.O = Avg.2.5, 
                 Max.2.5.U = Max.2.5.1,
                 Avg.2.5.U = Avg.2.5.1)

# Ordenamos las columnas

d1019S <- select(d1019S, colnames(d1920S))

# Volvemos a unir

d1020S <- rbind(d1019S, d1920S)

# Renombramos

d1020S <- rename(d1020S, date = Date, home.team = HomeTeam, home.score = FTHG, away.team = AwayTeam, away.score = FTAG)

# Ordenamos columnas

data <- select(d1020S, date, home.team, home.score, away.team, away.score:Avg.2.5.U) # Este data frame contiene todos los datos necesarios
#```


#```R
head(data, n = 2L); tail(data, n = 2L)
#```

# Data frames de partidos y equipos

#```R
md <- data %>% select(date:away.score)
write.csv(md, "match.data.csv", row.names = FALSE)
df <- create.fbRanks.dataframes(scores.file = "match.data.csv")
teams <- df$teams; scores <- df$scores
#```


#```R
head(teams, n = 2L); dim(teams); head(scores, n = 2L); dim(scores)
#```

# Conjuntos iniciales de entrenamiento y de prueba

#```R
f <- scores$date # Fechas de partidos
fu <- unique(f) # Fechas sin repeticionn
Ym <- format(fu, "%Y-%m") # Meses y añoss
Ym <- unique(Ym) # Meses y aÃ±os sin repetir
places <- which(Ym[15]==format(scores$date, "%Y-%m")) # Consideramos partidos de 15 meses para comenzar a ajustar el modelo
ffe <- scores$date[max(places)] # Fecha final conjunto de entrenamiento
#```

#Consideraremos partidos de 15 meses para comenzar a ajustar el modelo. Asi, nuestro primer conjunto de entrenamiento consiste de datos de partidos hasta el `r ffe` 

#```R
train <- scores %>% filter(date <= ffe)
test <- scores %>% filter(date > ffe)
#```


#```R
head(train, n = 1); tail(train, n = 1)
head(test, n = 1); tail(test, n = 1)
#```

# Primer ajuste del modelo

#```R
traindate <- unique(train$date)
testdate <- unique(test$date)
#```


#```R
ranks <- rank.teams(scores = scores, teams = teams, 
                    min.date = traindate[1], 
                    max.date = traindate[length(traindate)])
#```

# Primera prediccion


#```R
pred <- predict(ranks, date = testdate[1])
#```

#```R
phs <- pred$scores$pred.home.score # predicted home score
pas <- pred$scores$pred.away.score # predicted away score
pht <- pred$scores$home.team # home team in predictions
pat <- pred$scores$away.team # away team in predictions
#```

# Continuar ajustando y prediciendo


#```R
phs <- NULL; pas <- NULL; pht <- NULL; pat <- NULL
for(i in 1:(length(unique(scores$date))-170)){
  ranks <- rank.teams(scores = scores, teams = teams, 
                      min.date = unique(scores$date)[i], 
                      max.date = unique(scores$date)[i+170-1], 
                      silent = TRUE,
                      time.weight.eta = 0.0005)
  pred <- predict(ranks, date = unique(scores$date)[i+170],
                  silent = TRUE)
  
  phs <- c(phs, pred$scores$pred.home.score) # predicted home score
  pas <- c(pas, pred$scores$pred.away.score) # predicted away score
  pht <- c(pht, pred$scores$home.team) # home team in predictions
  pat <- c(pat, pred$scores$away.team) # away team in predictions
}
#```

# Eliminamos NA's


#```R
buenos <- !(is.na(phs) | is.na(pas)) # 
phs <- phs[buenos] # predicted home score
pas <- pas[buenos] # predicted away score
pht <- pht[buenos] # home team in predictions
pat <- pat[buenos] # away team in predictions
momio <- data %>% filter(date >= unique(scores$date)[171]) # momios conjunto de prueba
momio <- momio[buenos,]
mean(pht == momio$home.team); mean(pat == momio$away.team)
mean(phs + pas > 2.5 & momio$home.score + momio$away.score > 2.5)
mean(phs + pas < 2.5 & momio$home.score + momio$away.score < 2.5)
hs <- momio$home.score
as <- momio$away.score
#```

# Probabilidades condicionales


#```R
mean(phs + pas > 3) # proporciÃ³n de partidos con mÃ¡s de tres goles segunn el modelo
mean(phs + pas > 3 & hs + as > 2.5)/mean(phs + pas > 3) 
# probabilidad condicional estimada de ganar en over 2.5
mean(phs + pas < 2.1) # proporciÃ³n de partidos con menos de 2.1 goles segunn el modelo
mean(phs + pas < 2.1 & hs + as < 2.5)/mean(phs + pas < 2.1) 
# probabilidad condicional estimada de ganar en under 2.5
#```

# Apuestas con momios maximos


#```R
cap <- 50000; g <- NULL

for(j in 1:length(phs)){
  if(((phs[j] + pas[j]) > 3) & (0.64/(momio$Max.2.5.O[j]^-1) > 1)){
    if((hs[j] + as[j]) > 2.5) cap <- cap + 1000*(momio$Max.2.5.O[j]-1)
    else cap <- cap - 1000
    g <- c(g, cap)
  }
  
  if(((phs[j] + pas[j]) < 2.1) & (0.58/(momio$Max.2.5.U[j]^-1) > 1)){
    if((hs[j] + as[j]) < 2.5) cap <- cap + 1000*(momio$Max.2.5.U[j]-1)
    else cap <- cap - 1000
    g <- c(g, cap)
  }
}
#```

# Escenario con momios maximos

#```R
g <- data.frame(Num_Ap = 1:length(g), Capital = g)

png(filename='www/max.png',width = 550,height = 350)
p <- ggplot(g, aes(x=Num_Ap, y=Capital)) + geom_line( color="purple") + geom_point() +
  labs(x = "Numero de Apuesta", 
       y = "Capital",
       title = "Realizando una secuencia de apuestas") +
  theme(plot.title = element_text(size=12))  +
  theme(axis.text.x = element_text(face = "bold", color="blue" , size = 10, angle = 25, hjust = 1),
        axis.text.y = element_text(face = "bold", color="blue" , size = 10, angle = 25, hjust = 1))  # color, Ã¡ngulo y estilo de las abcisas y ordenadas 
p
dev.off()
#```

# Escenario con momios promedio

#```R
cap <- 50000; g <- NULL

for(j in 1:length(phs)){
  if(((phs[j] + pas[j]) > 3) & (0.64/(momio$Avg.2.5.O[j]^-1) > 1)){
    if((hs[j] + as[j]) > 2.5) cap <- cap + 1000*(momio$Avg.2.5.O[j]-1)
    else cap <- cap - 1000
    g <- c(g, cap)
  }
  
  if(((phs[j] + pas[j]) < 2.1) & (0.58/(momio$Avg.2.5.U[j]^-1) > 1)){
    if((hs[j] + as[j]) < 2.5) cap <- cap + 1000*(momio$Avg.2.5.U[j]-1)
    else cap <- cap - 1000
    g <- c(g, cap)
  }
}
#```

#```R
g <- data.frame(Num_Ap = 1:length(g), Capital = g)

png(filename='www/prom.png',width = 550,height = 350)
p <- ggplot(g, aes(x=Num_Ap, y=Capital)) + geom_line( color="purple") + geom_point() +
  labs(x = "Numero de Apuesta", 
       y = "Capital",
       title = "Realizando una secuencia de apuestas") +
  theme(plot.title = element_text(size=12))  +
  theme(axis.text.x = element_text(face = "bold", color="blue" , size = 10, angle = 25, hjust = 1),
        axis.text.y = element_text(face = "bold", color="blue" , size = 10, angle = 25, hjust = 1))  # color, angulo y estilo de las abcisas y ordenadas 
p
dev.off()
#```

#Lectura de Datos para la generacion de graficas del del postwork 3
data <-  read.csv("data.csv", header = T)

# Goles anotados por los equipos que jugaron en casa
FTHG <- data$FTHG 

# Goles anotados por los equipos que jugaron como visitante
FTAG<-data$FTAG

#La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x=0,1,2,)
pgol_casa<-(table(FTHG)/length(FTHG))*100

#La probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y=0,1,2,)
pgol_vis<-(table(FTAG)/length(FTAG))*100

#La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como visitante anote y goles (x=0,1,2,, y=0,1,2,)
pc_gol<-round((table(FTHG,FTAG)/dim(data)[1])*100,3)

# gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo de casa
pgol_casa <- as.data.frame(pgol_casa)
pgol_casa <- pgol_casa %>% rename(Goles = FTHG, Probabilidad = Freq)

png(filename='www/plot1.png',width = 640,height = 480)
color_range <- colorRampPalette(c("blue","red"))
plot <- ggplot(pgol_casa, aes(x = Goles, y = Probabilidad)) + 
  geom_col (fill=color_range(9)) + theme_bw()+
  ggtitle('Probabilidades marginales estimadas de goles que anota el equipo de casa')+ xlab("Numero de Goles") + ylab("Probabilidad Marginal (%)")+theme(plot.title = element_text(hjust = 0.5))

plot
dev.off()

#gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo visitante.
pgol_vis <- as.data.frame(pgol_vis)
pgol_vis <- rename(pgol_vis, Goles = FTAG, Probabilidad=Freq)

png(filename='www/plot2.png',width = 640,height = 480)
color_range <- colorRampPalette(c("blue","green"))
plot <- ggplot(pgol_vis, aes(x = Goles, y = Probabilidad)) + 
  geom_col (fill=color_range(7)) + theme_bw()+
  ggtitle('Probabilidades marginales estimadas de goles que anota el equipo visitante')+ xlab("Numero de Goles") + ylab("Probabilidad Marginal (%)")+theme(plot.title = element_text(hjust = 0.5))

plot
dev.off()

# HeatMap para las probabilidades conjuntas estimadas de los números de goles que anotan el equipo de casa y el equipo visitante en un partido.
pc_gol<-as.data.frame(pc_gol)
pc_gol <- rename(pc_gol, goles_casa = FTHG, goles_visita = FTAG, Probabilidad = Freq)

png(filename='www/plot3.png',width = 640,height = 480)
plot<-ggplot(pc_gol, aes(goles_casa, goles_visita)) + 
  geom_tile(aes(fill = Probabilidad),colour = "white")+ 
  scale_fill_gradient(low = "aquamarine", high = "steelblue")+
  labs(fill = "Probabiliad (%)")+
  xlab("Goles de equipo de casa") + 
  ylab("Goles de equipo visitante")+
  ggtitle('Probabilidades conjuntas estimadas')+
  theme(plot.title = element_text(hjust = 0.5))

plot
dev.off()
