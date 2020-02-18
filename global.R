library(shinydashboard)
library(dygraphs)
library(xts)
library(RColorBrewer)

source("scrapping_data.R")
niveles<-as.character(unique(Datos$Tipo))
lista_ts<-list()
for(i in 1:length(niveles)){
    datos<-Datos[Datos$Tipo==niveles[i],]
    df_ts<-xts(datos$n, order.by=as.POSIXct(datos$Date, format="%Y-%m-%d"))
    colnames(df_ts)<-niveles[i]
    lista_ts[[i]]<-df_ts
}
TS<-do.call("cbind",lista_ts)
