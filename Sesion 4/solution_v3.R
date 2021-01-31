        
#Librerias que seran ocupadas
suppressWarnings(suppressMessages(library(dplyr)))
suppressWarnings(suppressMessages(library(reshape2)))
suppressWarnings(suppressMessages(library(ggplot2)))

#Comenzamos importando los datos que se encuentran en archivos csv a R

url1718 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"
url1819 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
url1920 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"

d1718 <- read.csv(file = url1718) # Importación de los datos a R
d1819 <- read.csv(file = url1819)
d1920 <- read.csv(file = url1920)

#Obtenemos una mejor idea de los datos que se encuentran en los data frames con las funciones str, head, View y summary

#str(d1718); str(d1819); str(d1920)
#head(d1718); head(d1819); head(d1920)
#View(d1718); View(d1819); View(d1920)
#summary(d1718); summary(d1819); summary(d1920)

#Ahora seleccionaremos únicamente las columnas Date, HomeTeam, AwayTeam, FTHG, FTAG y FTR en cada uno de los data frames. 
lista <- list(d1718, d1819, d1920)
nlista <- lapply(lista, select, Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)

#Con las funciones lapply y str observaremos la estrucura de nuestros nuevos data frames
#lapply(nlista, str)

#Arreglamos las columnas Date para que R reconozca los elementos como fechas, esto lo hacemos con las funciones mutate (paquete dplyr) y as.Date.
nlista[[1]] <- mutate(nlista[[1]], Date = as.Date(Date, "%d/%m/%y"))
nlista[[2]] <- mutate(nlista[[2]], Date = as.Date(Date, "%d/%m/%Y"))
nlista[[3]] <- mutate(nlista[[3]], Date = as.Date(Date, "%d/%m/%Y"))

#Verificamos que nuestros cambios se hayan llevado a cabo
lapply(nlista, str)

#Finalmente, con ayuda de las funciones rbind y do.call combinamos los data frames contenidos en nlista como un único data frame
data <- do.call(rbind, nlista)
#dim(data)
#str(data)
#tail(data)
#View(data)
#summary(data)

#Con ayuda de la función table obtenemos las estimaciones de probabilidades solicitadas
(pcasa <- round(table(data$FTHG)/dim(data)[1], 3)) # Probabilidades marginales estimadas para los equipos que juegan en casa

(pvisita <- round(table(data$FTAG)/dim(data)[1], 3)) # Probabilidades marginales estimadas para los equipos que juegan como visitante

(pcta <- round(table(data$FTHG, data$FTAG)/dim(data)[1], 3)) # Probabilidades conjuntas estimadas para los partidos

#Con la función apply primero dividimos cada elemento de las columnas de la matriz de probabilidades conjuntas, por las probabilidades marginales asociadas y que corresponden al equipo de casa. 
(cocientes <- apply(pcta, 2, function(col) col/pcasa))

(cocientes <- apply(cocientes, 1, function(fila) fila/pvisita))

#Aplicamos la traspuesta al dataframe para regresar a nuestra tabla inicial
(cocientes <- t(cocientes))

#Tranformamos el data frame en tres columnas para tener un mejor manejo
(cocientes<-melt(as.table(cocientes)))

#creamos una nueva Columna combinando las columnas de goles de equipos en casa (var1) y 
# goles de equipos como visitantes (var2)

cocientes<-cocientes%>%mutate("Comb"=paste0(Var1,",",Var2))%>%select(Comb,value)

#Extraemos la columna recien creada que combina las var1 y var2
cocientes.df<-cocientes[,1,drop=FALSE]

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

#Despues del ciclo for obtenemos un data frama con las 1000 muestras
dim(cocientes.df);head(cocientes)

#Calculamos los parametros estadisticos necesarios para evaluar la independencia de
#las variables (var1 y var2), los paramestros que se calcularon son:
#-mean: promedio de la muestra
#-sd: desviacion estandar de la muestra
#- row: numero de elementos no NA de la muestra
#- Estimador: el estimador estadistico (Z0)
#- z025: considerando un nivel de significancia de alpha=0.05 debemos encontrar
#       z_{0.025} es decir (z0 < -z.025) | (z0 > z.025) la region de rechazo es de dos colas
#- pvalue: considerando una Ho=1 (hipotesis nula) y Ha<>1 (hipotesis alternativa) 
#-sht: Shapiro test para determinar si la distribucion es normal y se puede aplicar el
#        teorema de limite central

resumen_cocientes<-cocientes.df%>%rowwise(Comb)%>%
    mutate(mean=mean(c_across(cols = everything()),na.rm = TRUE),
           sd=sd(c_across(cols = everything()),na.rm =TRUE),
           row=sum(!is.na(c_across(cols = everything()))),
           estimador=(mean-1)/(sd/sqrt(row)),
           z025=qnorm(p = 0.025, lower.tail = FALSE),
           pvalue=2*pnorm(abs(estimador), lower.tail = FALSE),
           sht = list(shapiro.test(c_across(cols = everything()))))%>%
    select(mean,sd,estimador,z025,pvalue,sht)

#Extrayendo el p value de la funcion Shapiro.test
resumen_cocientes$p.value_shapiro<-lapply(resumen_cocientes$sht, `[[`, 2) 

#Data frame final con los resultados
(resumen_cocientes <- subset( resumen_cocientes, select = -sht ))

# Las conclusiones tras las realización del postwork son las siguientes:
# Los únicos casos en donde las variables aleatorias son independientes son en donde 
# los puntajes son 1,3 y 3,3 siendo puntaje casa y visitante respectivamente, se ha llegado a tal 
# conclusión tras la aplicación de una prueba de hipotesis, sin embargo, a partir de simples observaciones 
# se cree que varios otros casos podrian ser independientes tomando en cuenta solo las medias y 
# desviaciones estándar de cada caso.



