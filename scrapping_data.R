library(rvest)
library(RCurl)
library(stringr)
library(pdftools)
library(reshape2)

#html<-getURL("https://www.who.int/emergencies/diseases/novel-coronavirus-2019/situation-reports/")
#html_parsed<-read_html(html)
#urls<-paste0("https://www.who.int",as.character(unique(html_attr(html_nodes(html_nodes(html_parsed, "p"),"a"),"href"))))
#lista_pdf<-sapply(urls, function(x) download.file(x, destfile=paste0("datasets/",str_extract(x,"sitrep-[0-9]+"),".pdf")))
lista_reportes<-list.files("datasets",pattern="sitrep", full.names=TRUE)
lista_reportes_c<-list.files("datasets",pattern="sitrep", full.names=FALSE)
#file.copy(from=lista_reportes, to=paste0("www/", lista_reportes_c))

lista_muertes<-list()
lista_datos<-list()
lista_fecha<-list()
lista_df<-list()
for(i in 1:length(lista_reportes)){
#for(i in 12){
    verif<-grep(lista_reportes, pattern=paste0("-",i,"\\.pdf$"))
    texto<-pdf_text(lista_reportes[verif])
    texto_c<-paste0(gsub(unlist(texto),pattern="\n",replacement="NUEVA_LINEA"), collapse="NUEVA_PAGINA")
    if(i==1){
        datos<-gsub(str_extract(texto_c, pattern="Table 1.*Total [C|c]onfirmed .*[0-9]{3,6}NUEVA_LINEA *cases"), pattern="NUEVA_LINEA *cases$", replacement="")
        datos<-as.numeric(gsub(str_extract(gsub(datos, pattern="NUEVA_LINEA", replacement="\n"),pattern=".+$"),pattern="[A-z]| |,",replacement=""))
    }
    if(i!=1 & i<7){
        datos<-str_extract(texto_c, pattern="Table 1.*Total *[0-9]{2,6}NUEVA_LINEA|Table 1.*Total *[0-9]{1,2}[ |,][0-9]{3}")
        if(is.na(datos)) datos<-str_extract(texto_c, pattern="Table 1.*Total *[0-9]{2,6}")
        datos<-as.numeric(gsub(str_extract(gsub(datos, pattern="NUEVA_LINEA", replacement="\n"),pattern=".+$"),pattern="[A-z]| |,",replacement=""))
    }
    if(i>6 & i<12){
        datos<-as.numeric(paste0(unlist(str_extract_all(unlist(strsplit(str_extract(texto_c, pattern="Globally.*[0-9] confirmedNUEVA_LINEA"), split="confirmedNUEVA_LINEA"))[1], pattern="[:digit:]")),collapse=""))
    }
#    if(i>11){
#        datos<-as.numeric(paste0(unlist(str_extract_all(gsub(unlist(strsplit(str_extract(texto_c, pattern="Globally.*[0-9] confirmed \\([0-9]+ .*\\)NUEVA_LINEA"), split="confirmed \\([0-9]+ .*\\)NUEVA_LINEA"))[1], pattern="2019|11-12|-19",replacement=""), pattern="[:digit:]")),collapse=""))
#    }
    if(i>11 & i<25){
        datos<-as.numeric(paste0(unlist(str_extract_all(gsub(unlist(strsplit(str_extract(texto_c, pattern="Globally.*[0-9] confirmed \\([0-9]+ .*\\)NUEVA_LINEA"), split="confirmed \\([0-9]+ .*\\)NUEVA_LINEA"))[1], pattern="2019|11-12|-19",replacement=""), pattern="[:digit:]")),collapse=""))
    }
    if(i>24 & i<28){
        datos<-as.numeric(paste0(unlist(str_extract_all(gsub(unlist(strsplit(str_extract(texto_c, pattern="Globally.*[0-9] laboratory-confirmedNUEVA_LINEA"), split="laboratory-confirmedNUEVA_LINEA"))[1], pattern="2019|11-12|-19",replacement=""), pattern="[:digit:]")),collapse=""))
    }
    if((i>27 & i<55) | i>56){
       datos<-as.numeric(paste0(unlist(str_extract_all(gsub(unlist(strsplit(str_extract(texto_c, pattern="Globally.*[0-9] confirmed \\([0-9]+ .*\\)NUEVA_LINEA"), split="confirmed \\([0-9]+ .*\\)NUEVA_LINEA"))[1], pattern="2019|11-12|-19| 19\\.|24 hours|100,000|9 March 2020, a total of 45 States|\\[1\\]",replacement=""), pattern="[:digit:]")),collapse=""))
    }
    if(i>54 & i<57){
       datos<-as.numeric(paste0(unlist(str_extract_all(gsub(unlist(strsplit(str_extract(texto_c, pattern="Globally.*[0-9] confirmedNUEVA_LINEA"), split="confirmedNUEVA_LINEA"))[1], pattern="2019|11-12|-19|24 hours|100,000|9 March 2020, a total of 45 States",replacement=""), pattern="[:digit:]")),collapse=""))
    }
    
#    print(datos)
    lista_datos[[i]]<-datos
    
    n_muertes<-gsub(unlist(str_extract_all(texto_c, pattern="[0-9]+ deaths")),pattern="[A-z]| |,",replacement="")
    lista_muertes[[i]]<-ifelse(length(n_muertes)==0,0,n_muertes)
    
    if(i==1) lista_fecha[[i]]<-as.Date("2020-01-21", format="%Y-%m-%d") else lista_fecha[[i]]<-as.Date(lista_fecha[[1]]+as.numeric(gsub(str_extract(lista_reportes[verif], pattern="[:digit:]+\\.pdf$"),pattern="\\.pdf",replacement=""))-1, format="%Y-%m-%d")
    
    df<-data.frame("Report"=lista_reportes[verif], "Date"=lista_fecha[[i]], "Infected"=as.numeric(lista_datos[[i]]), "Death"=as.numeric(lista_muertes[[i]]))
    lista_df[[i]]<-df
}
DF<-do.call("rbind",lista_df)
DF$Death_rate<-DF$Death/DF$Infected*100
Datos<-melt(DF, id=c("Report","Date"))
colnames(Datos)[3:4]<-c("Tipo","n")
