options(shiny.maxRequestSize = 9*1024^2)

function(input,output,session){

    output$serie<-renderDygraph({
        dygraph(TS, main="World Coronavirus Evolution from Daily WHO Data", height=600) %>% dyAxis("y", label="Indivuduals", valueRange=c(0,max(Datos$n)+1000)) %>% dyRangeSelector() %>% dyLegend(labelsDiv = "legendDivID", labelsSeparateLines = T) %>% dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>% dyOptions(axisLineWidth = 1.5, fillGraph = TRUE, drawGrid = T)#, colors = rev(RColorBrewer::brewer.pal(5, "Set1")[3:5]))
    })
    
    output$reporte<-renderUI({
        a<-as.character(input$serie_click$x)
        a<-gsub(gsub(a,pattern="T",replacement=" "), pattern="Z", replacement="")
        #Corregir a
        fecha<-as.Date(a, format="%Y-%m-%d %H:%M:%S.000")
        reporte_pdf<-gsub(DF$Report[DF$Date==fecha], pattern="datasets/", replacement="")
#        print(fecha)
#        print(reporte_pdf)

        tags$iframe(style="height:700px; width:100%", src=reporte_pdf)
#        )
    })
}
