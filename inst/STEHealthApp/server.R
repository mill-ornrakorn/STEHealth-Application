# ==================================== Check packages  ====================================

list.of.packages <- c("shiny", "shinydashboard", "shinyjs", "shinyBS" , "leaflet" ,
                      "dplyr", "ggplot2" ,"RColorBrewer" , "rgdal" ,"shinyWidgets",
                      "shinydashboardPlus","spdep", "leaflet.extras", "bsplus" ,"remotes")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)


if(!require(INLA)){
  # ต้องใช้ R 4.2.2 ถึงจะลงได้ ลองใช้ 4.3.1 แล้วลงไม่ได้
  install.packages("INLA",repos=c(getOption("repos"),INLA="https://inla.r-inla-download.org/R/stable"), dep=TRUE)
  library(INLA)
}


if(!require(capture)){
  remotes::install_github("dreamRs/capture")
  library(capture)
}


# ==================================== import packages  ====================================

library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinyBS)
library(leaflet)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(rgdal)
library(shinyWidgets)
library(shinydashboardPlus)

library(INLA)
inla.setOption(scale.model.default = TRUE)
library(spdep) # อันนี้ใช้ nb2mat

library(capture) # ลงโดยใช้ remotes::install_github("dreamRs/capture")
library(leaflet.extras)
library(bsplus)

# install.packages("sf")
# ถ้าลง sf ไม่ได้ให้พิมพ์คำสั่งด้านล่างนี้ก่อน
# options("install.lock"= FALSE)


# By default the file size limit is 5MB. Here limit is 70MB.
options(shiny.maxRequestSize = 70*1024^2)

# options(scipen=999)



###############################################################
#  
#                             server
#
###############################################################

server <- function(input, output, session) { 
  
  #observe(print(input$columnexpvalueindata))
  
  # message menu
  
  output$messageMenu <- renderMenu({
    dropdownMenu(type = "messages", 
                 messageItem(
                   from = "Project in Github", 
                   message = "Documentation, Source, Citation",
                   icon = icon("github", style = 'color: #5c5c68;'),
                   href = "https://github.com/mill-ornrakorn/STEHealth-Application"),
                 
                 badgeStatus = NULL,
                 icon = tags$i(tags$img(src='info.png', height='16', width='16')),
                 #icon = icon("circle-info", style = 'color: #5c5c68;'),
                 headerText = "App Information"
    )
  })
  
  
  
  # แบบรูปไม่ position:absolute
  output$status_map <- renderUI({
    if (is.null(input$filemap)) { 
      HTML("<p style='margin-top: 60px; margin-bottom: 40px; text-align:center;'> 
         <img src='nodata.png', alt='nodata', height  = '300px', width = '400px'>")
      
    } 
  })
  
  # แบบ text
  # output$status_csv <- renderPrint({
  #   if (is.null(input$file1)) { 
  #     return(HTML('Please upload "csv file" to preview data.'))
  #   } 
  # })
  
  
  output$status_csv <- renderUI({
    if (is.null(input$file1)) { 
      HTML("<p style='text-align:center; margin-top: 60px; margin-bottom: 40px; '> 
         <img src='nodata.png', alt='nodata', height  = '300px', width = '400px'>")
      
    } 
  })
  
  # แบบ text
  # output$status_map_dis <- renderPrint({
  #   if (is.null(input$filemap) &  is.null(input$file1)) { 
  #     return(HTML('Please upload data in "Upload Data" page to display map distribution.'))
  #   } 
  #   
  # })
  
  output$status_map_dis <- renderUI({
    if (is.null(input$filemap) &  is.null(input$file1)) { 
      HTML("<p style='margin-top: 10%; left: 10%; position:absolute;'> 
         <img src='undraw_world_re.svg',  height  = '500px', width = '700px'>")
      
    } 
  })
  
  
  # แบบ text
  # output$status_cluster <- renderPrint({
  #   if (is.null(input$filemap) &  is.null(input$file1)) { 
  #     return(HTML('Please upload data in "Upload Data" page to display cluster detection.'))
  #   } 
  #   
  # })
  
  output$status_cluster <- renderUI({
    if (is.null(input$filemap) &  is.null(input$file1)) {
      HTML("<p style='margin-top: 15%; left: 15%; position:absolute;'>
         <img src='undraw_location_search_re.svg',  height  = '450px', width = '600px'>")
      
    }
  })
  
  # แบบรูป position:absolute
  # output$status_cluster <- renderUI({
  #   if (is.null(input$filemap) &  is.null(input$file1)) { 
  #     #HTML("<p style='margin-top: 20px; left: 20%; position:absolute;'> 
  #     HTML("<p style='text-align:center; margin-top: 70px; margin-bottom: 80px;'> 
  #      <img src='undraw_location_search_re.svg',  height  = '400px', width = '600px'>")
  #     
  #   } 
  # })
  
  # แบบ text
  # output$status_risk_fac <- renderPrint({
  #   if (is.null(input$filemap) & is.null(input$file1)) { 
  #     return(HTML('Please upload data in "Upload Data" page to display association with risk factors.'))
  #   } 
  #   
  # })
  
  
  output$status_risk_fac <- renderUI({
    if (is.null(input$filemap) &  is.null(input$file1)) { 
      HTML("<p style='margin-top: 15%; left: 15%; position:absolute;'>
         <img src='undraw_adventure_re.svg',  height  = '450px', width = '600px'>")
      
    } 
  })
  
  # ==================================== write error messages ==================================== 
  
  
  output$status_risk_fac_nocova <- renderPrint({
    x1 <- input$columncov1indata
    x2 <- input$columncov2indata
    x3 <- input$columncov3indata
    x4 <- input$columncov4indata
    x5 <- input$columncov5indata
    x6 <- input$columncov6indata
    x7 <- input$columncov7indata
    
    if(x1 == ""& x2== ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ){
      return(HTML('📌 There are no covariates have been selected on the Upload Data page ❗'))
    }
    
    
  })
  
  
  output$messageCheckData_1<-renderText(
    paste(rv$messageCheckDataText_1)
  )
  
  #observeEvent(input$Preview_Map_Distribution | input$tabs == "Map_Distribution", {
  observeEvent(input$Preview_Map_Distribution , {
    
    if (is.null(rv$map) &  is.null(rv$datosOriginal) ){
      rv$messageCheckDataText_1<-"📌 Error: There are no data (shapefile and csv file) have been uploaded on the Upload Data page ❗"
      return(NULL)
    }
    
    
    else if (is.null(rv$map) &  (!is.null(rv$datosOriginal))){
      rv$messageCheckDataText_1<-"📌 Error: There are no shapefile have been uploaded on the Upload Data page ❗"
      return(NULL)
    }
    
    
    else if (!is.null(rv$map) &  is.null(rv$datosOriginal)){
      rv$messageCheckDataText_1<-"📌 Error: There is no csv file have been uploaded on the Upload Data page ❗"
      return(NULL)
    }
    
    else if (!is.null(rv$map) &  (!is.null(rv$datosOriginal))){
      rv$messageCheckDataText_1<-NULL
      return(NULL)
    }
    
    
  })
  
  
  output$messageCheckData_2<-renderText(
    paste(rv$messageCheckDataText_2)
  )
  
  output$messageCheckData_3<-renderText(
    paste(rv$messageCheckDataText_3)
  )
  
  #observeEvent(input$nextpage | input$tabs == "Analysis", {
  observeEvent(input$nextpage , {
    
    if (is.null(rv$map) &  is.null(rv$datosOriginal) ){
      rv$messageCheckDataText_2<-"📌 Error: There are no data (shapefile and csv file) have been uploaded on the Upload Data page ❗"
      rv$messageCheckDataText_3<-"📌 Error: There are no data (shapefile and csv file) have been uploaded on the Upload Data page ❗"
      
      return(NULL)
    }
    
    
    else if (is.null(rv$map) &  (!is.null(rv$datosOriginal))){
      rv$messageCheckDataText_2<-"📌 Error: There are no shapefile have been uploaded on the Upload Data page ❗"
      rv$messageCheckDataText_3<-"📌 Error: There are no shapefile have been uploaded on the Upload Data page ❗"
      
      return(NULL)
    }
    
    
    else if (!is.null(rv$map) &  is.null(rv$datosOriginal)){
      rv$messageCheckDataText_2<-"📌 Error: There is no csv file have been uploaded on the Upload Data page ❗"
      rv$messageCheckDataText_3<-"📌 Error: There is no csv file have been uploaded on the Upload Data page ❗"
      
      return(NULL)
    }
    
    else if (!is.null(rv$map) &  (!is.null(rv$datosOriginal))){
      rv$messageCheckDataText_2<-NULL
      rv$messageCheckDataText_3<-NULL
      
      return(NULL)
    }
    
    
  })
  
  
  # ========================= Modal สำหรับตัวอย่างแปลผล ================================ 
  observeEvent(input$interpret_cluster, {
    showModal(
      modalDialog(
        title = HTML('<div class = "modal__header">
                          <i class="uil uil-clipboard-notes modalicon"></i>
                          <div>
                            <h4 class = "modaltitle">Examples of interpretation</h4>
                            <span class = "modalsubtitle">From sample data, Thailand suicide mortality and risk factors 2011-2021.</span>

                          </div>
                        </div>
                        
                       '),
        tags$img(src="example_cluster_result.png",
                 class = "modal__img"),
        
        HTML("
              <div class = 'modal__body'>
                <span class = 'modal__bodytitle'>If the area has a <strong>hotspot</strong>: </br></span>
                &emsp;In Kanchanaburi, has a hotspot, meaning that Kanchanaburi has a higher number of suicides than the specified threshold (the base line of our work is defined as the average number of suicides). 
              </div>"),
        
        easyClose = TRUE,
        footer = NULL,
        size = "l"
      )
    )
  })
  
  
  observeEvent(input$interpret_asso_risk, {
    showModal(
      modalDialog(
        title = HTML('<div class = "modal__header">
                          <i class="uil uil-clipboard-notes modalicon"></i>
                          <div>
                            <h4 class = "modaltitle">Examples of interpretation</h4>
                            <span class = "modalsubtitle">From sample data, Thailand suicide mortality and risk factors 2011-2021.</span>

                          </div>
                        </div>
                        
                       '),
        
        # แบบที่ 1
        tags$img(src="example_asso-risk_result_1.png",
                 class = "modal__img"),
        
        HTML("
              <div class = 'modal__body'>
                <span class = 'modal__boldbodytitle'>Type 1 </span>
                <span class = 'modal__bodytitle'>If the significance is <strong>significant</strong> and risk factor value is <strong>positive (+)</strong>: </br></span>
                &emsp;In Lamphun, the percent increase in expenditure is 0.15, which means if expenditure increases by 1 baht (THB), 
     the suicide risk will <u>increase</u> by 0.15%, or every 100 baht (THB) increase in expenditure increases the suicide risk by 15%.
              </div>
              <hr>"),
        
        # แบบที่ 2
        tags$img(src="example_asso-risk_result_2.png",
                 class = "modal__img"),
        
        HTML("
              <div class = 'modal__body'>
                <span class = 'modal__boldbodytitle'>Type 2 </span>
                <span class = 'modal__bodytitle'>If the significance is <strong>significant</strong> and risk factor value is <strong>negative (-)</strong>: </br></span>
                &emsp;In Samuut Prakan, the percent increase in expenditure is -0.15, which means if expenditure increases by 1 baht (THB), 
     the suicide risk will <u>decrease</u> by 0.15%, or every 100 baht (THB) increase in expenditure decrease the suicide risk by 15%.
              </div>
              <hr>"),
        
        # แบบที่ 3
        tags$img(src="example_asso-risk_result_3.png",
                 class = "modal__img"),
        
        HTML("
              <div class = 'modal__body'>
                <span class = 'modal__boldbodytitle'>Type 3 </span>
                <span class = 'modal__bodytitle'>If the significance is <strong>not significant</strong>: </br>  </span>
                &emsp;When the value of significance is not significant, it means that this risk factor and the outcome <u>do not have significant relationships</u>.
              </div>
              "),
        
        
        easyClose = TRUE,
        footer = NULL,
        size = "l"
      )
    )
  })
  
  # If the significance is <strong>significant</strong> and risk factor value is <strong>positive (+)</strong>: </br>
  #   &emsp;In Lamphun, the percent increase in expenditure is 0.15, which means if expenditure increases by 1 baht (THB), 
  # the suicide risk will <u>increase</u> by 0.15%, or every 100 baht (THB) increase in expenditure increases the suicide risk by 15%.
  # 
  # </br></br> 
  #   • If the significance is <strong>significant</strong> and risk factor value is <strong>negative (-)</strong>: </br>
  #   &emsp;In Samuut Prakan, the percent increase in expenditure is -0.15, which means if expenditure increases by 1 baht (THB), 
  # the suicide risk will <u>decrease</u> by 0.15%, or every 100 baht (THB) increase in expenditure decrease the suicide risk by 15%.
  # 
  # </br></br>     
  #   •If the significance is <strong>not significant</strong>: </br>  
  #   &emsp;When the value of significance is not significant, it means that this risk factor and the outcome <u>do not have significant relationships</u>.
  # 
  
  
  # ======================================================================== 
  
  
  observe({
    if (is.null(names(rv$datosOriginal)))
      xd <- character(0)
    
    xd<-names(rv$datosOriginal)
    
    if (is.null(xd))
      xd <- character(0)
    
    xd2<- c("-", xd)
    
    # Can also set the label and select items
    #label = paste("Select input label", length(x)),
    updateSelectInput(session, "columnidareaindata", choices = xd,  selected = head(xd, 1))
    updateSelectInput(session, "columnidareanamedata", choices = xd,  selected = head(xd, 1))
    updateSelectInput(session, "columndateindata",   choices = xd,  selected = head(xd, 1))
    updateSelectInput(session, "columnexpvalueindata",    choices = xd,  selected = head(xd, 1))
    updateSelectInput(session, "columncasesindata",  choices = xd,  selected = head(xd, 1))
    updateSelectInput(session, "columnpopindata",  choices = xd,  selected = head(xd, 1))
    
    
    #columncov1indata
    updateSelectInput(session, "columncov1indata",  choices = xd,  selected =  "-")
    updateSelectInput(session, "columncov2indata",  choices = xd,  selected =  "-")
    updateSelectInput(session, "columncov3indata",  choices = xd,  selected =  "-")
    updateSelectInput(session, "columncov4indata",  choices = xd,  selected =  "-")
    updateSelectInput(session, "columncov5indata",  choices = xd,  selected =  "-")
    updateSelectInput(session, "columncov6indata",  choices = xd,  selected =  "-")
    updateSelectInput(session, "columncov7indata",  choices = xd,  selected =  "-")
    #updateSelectInput(session, "columncov5indata",  choices = xd,  selected = "-")
    
  })
  
  
  
  observe({
    x <- names(rv$map)
    xd<-c("-",x)
    # Can use character(0) to remove all choices
    if (is.null(x)){
      x <- character(0)
      xd<-x
    }
    
    updateSelectInput(session, "columnidareainmap",        choices = x,  selected = head(x, 1))
    #updateSelectInput(session, "columnnameareainmap",      choices = x,  selected = head(x, 1))
    #updateSelectInput(session, "columnnamesuperareainmap", choices = xd, selected = head(xd, 1))
    
  })
  
  
  rv <- reactiveValues(
    columnidareainmap=NULL,  columnnameareainmap=NULL, #columnnamesuperareainmap=NULL,
    idpolyhighlighted = NULL, posinmapFilteredIdpolyhighlighted=NULL, colores=NULL,
    minrisk=0, maxrisk=1,
    vblePintar="Risk", textareareactive="NULL",messageCheckDataText_1="", messageCheckDataText_2="", messageCheckDataText_3="",
    map=NULL,datosOriginal=NULL,
    datoswithvaluesforeachidandtime=NULL,
    datossatscan=NULL,
    lastselectstage=NULL,
    usedcovs=NULL,
    usedarealcovs=NULL,
    selectstage='stageuploaddata')
  
  
  
  
  
  # output$uploadmapmap <- renderPlot({
  #   if (is.null(rv$map))
  #     return(NULL)
  #   plot(rv$map)
  # })
  
  output$uploadmapmap <- renderPlot({
    if (!is.null(rv$map))
      plot(rv$map)
  })
  
  output$uploadmapsummary <- renderPrint({
    if (!is.null(rv$map)){
      print(summary(rv$map@data))
    }
  })
  
  output$uploaddatasummary <- renderPrint({
    if (!is.null(rv$datosOriginal)){
      print(summary(rv$datosOriginal))
    }
  })
  
  # output$uploadmaptable  <- renderDataTable({
  #   if (is.null(rv$map))
  #     return(NULL)
  #   rv$map@data
  #   
  # } , options = list(scrollX=TRUE, # แถบเลื่อนแนวแกน x
  #                    pageLength = 5))
  # 
  
  output$uploadmaptable  <- renderDataTable({
    if (!is.null(rv$map))
      rv$map@data
    
  } , options = list(scrollX=TRUE, # แถบเลื่อนแนวแกน x
                     pageLength = 5))
  
  output$uploaddatatable  <- renderDataTable({
    if (is.null(rv$datosOriginal))
      return(NULL)
    rv$datosOriginal
    
  } , options = list(scrollX=TRUE, # แถบเลื่อนแนวแกน x
                     pageLength = 5))
  
  
  
  # Upload shapefile
  observe({
    
    shpdf <- input$filemap
    if(is.null(shpdf)){
      return()
    }
    previouswd <- getwd()
    uploaddirectory <- dirname(shpdf$datapath[1])
    setwd(uploaddirectory)
    for(i in 1:nrow(shpdf)){
      file.rename(shpdf$datapath[i], shpdf$name[i])
    }
    setwd(previouswd)
    
    #map <- readShapePoly(paste(uploaddirectory, shpdf$name[grep(pattern="*.shp", shpdf$name)], sep="/"),  delete_null_obj=TRUE)
    #reads the file that finishes with .shp using $ at the end: grep(pattern="*.shp$", shpdf$name)
    map <- readOGR(paste(uploaddirectory, shpdf$name[grep(pattern="*.shp$", shpdf$name)], sep="/"), encoding = "UTF-8")#,  delete_null_obj=TRUE)
    map <- spTransform(map, CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))
    
    rv$map<-map
    
    
    
    
  })
  
  # Upload data
  observe({
    inFile <- input$file1
    if (is.null(inFile))
      return(invisible())
    rv$datosOriginal<-read.csv(inFile$datapath)
    
  })
  
  
  # ==================================== ปุ่ม preview map dis ==================================== 
  
  #observeEvent(input$Preview_Map_Distribution | input$tabs == "Map_Distribution" , {
  observeEvent(input$Preview_Map_Distribution , {
    if (is.null(rv$datosOriginal)| is.null(rv$map))
      return(NULL)
    
    #print(input$tabs)
    if(input$tabs == "Map_Distribution"){
      data <- rv$datosOriginal
      
      #updateSelectInput(session, "columnidareainmap",        choices = x,  selected = head(x, 1))
      updateSelectInput(session, "time_point_filter", choices = data[,input$columndateindata],  selected = head(data[,input$columndateindata], 1))
      #min = min(data[,input$columndateindata]), max = max(data[,input$columndateindata]) )
      # print(min(data[,input$columndateindata]))
      # print(max(data[,input$columndateindata]))
      # print(range(data[,input$columndateindata]))
      
      updateSelectInput(session, "time_point_filter_cluster", choices = data[,input$columndateindata],  selected = head(data[,input$columndateindata], 1))
      
    }
    
  })
  
  
  
  
  
  
  
  
  # ==================================== ปุ่ม action input$nextpage ==================================== 
  #observeEvent(input$nextpage | input$tabs == "Analysis", {
  observeEvent(input$nextpage , {
    
    if (is.null(rv$datosOriginal) | is.null(rv$map))
      return(NULL)
    
    
    if(input$tabs == "Analysis"){
      data <- rv$datosOriginal
      
      #updateSliderInput(session, "time_point_filter_cluster", min = min(data[,input$columndateindata]), max = max(data[,input$columndateindata]) )
      
      
      
      ######################### คำนวณ cluster ###################################
      map <- rv$map
      #data <- rv$datosOriginal
      
      
      
      # y (case)
      data[,input$columncasesindata] <- as.numeric(data[,input$columncasesindata])
      
      
      ########################## --- คำนวน expected value ---- ######################### 
      
      # # ของเก่า: ค่า E ที่ให้ user ใส่มาเอง
      # data[,input$columnexpvalueindata] <- as.numeric(data[,input$columnexpvalueindata])
      
      
      
      
      if(input$Expected_Value_from_csv == "yes" ){
        if(input$columnexpvalueindata != "" ){
          print("Check: ...this csv have expected value...")
          data['expected_value'] <- as.numeric(data[,input$columnexpvalueindata])
          
        }
        
      }else if (input$Expected_Value_from_csv == "no" ){
        print("Check: ...this csv doesn't have expected value...")
        
        # คิด (sum(case) / (pop))*population
        # sum case กับ pop ทั้งหมด เอามาหารกัน แล้วคูณด้วย pop ของจังหวัด,ปี นั้นๆ
        sum_case <- sum(data[,input$columncasesindata])
        sum_pop <- sum(data[,input$columnpopindata])
        
        divide_case_pop <- sum_case / sum_pop
        
        
        expected_value <- data[,input$columnpopindata] * divide_case_pop
        
        
        # Add a Column to a Data Frame
        data['expected_value'] <- expected_value
        
      }
      
      
      
      # ---------------------------
      
      # area id (data$province)
      data[,input$columnidareaindata] <- as.numeric(data[,input$columnidareaindata]) # id of province 1-77
      
      # # year data$year
      data[,input$columndateindata] <- as.numeric(data[,input$columndateindata]) # id of year 1-11 (?)
      
      # # data$province_year <- seq(1, 1064) # id of province-year interaction
      data$province_year <- seq(1, nrow(data)) # id of year 1-11 (?)
      
      # # interaction id
      province_int <- data[,input$columnidareaindata]
      year_int <- data[,input$columndateindata]
      
      
      
      
      if(input$shapefile_from_thailand == "yes" ){
        
        # build adj matrix from shape file
        tha_adj <- nb2mat(
          poly2nb(map),
          style = "B",
          zero.policy = TRUE)
        
        # add path between Phuket and Pang nga (?)
        tha_adj[38, 47] <- 1
        tha_adj[47, 38] <- 1
        
      }else if (input$shapefile_from_thailand == "no" ){
        
        # build adj matrix from shape file
        tha_adj <- nb2mat(
          poly2nb(map),
          style = "B",
          zero.policy = TRUE)
        
      }
      
      # อันใหม่เด้อ
      # formula_1_bym_rw1 <- data[,input$columncasesindata] ~ 1 +
      #     f(data$x1_id, x1, model = "iid") +
      #     f(data$x2_id, x2, model = "iid") +
      #     f(data$x3_id, x3, model = "iid") +
      #     f(data$x4_id, x4, model = "iid") +
      #     f(data$x5_id, x5, model = "iid") +
      #     f(data$x6_id, x6, model = "iid") +
      #     f(data$x7_id, x7, model = "iid") +
      #   f(data[,input$columnidareaindata], model = "bym", graph = tha_adj) +
      #   f(data[,input$columndateindata], model = "rw1") +
      #   f(province_int, model = "iid")
      
      
      ####################   Cluter   #################### 
      
      
      
      formula_1_bym_rw1_Cluter <- data[,input$columncasesindata] ~ 1 +
        f(data[,input$columnidareaindata], model = "bym", graph = tha_adj) +
        f(data[,input$columndateindata], model = "rw1") +
        f(province_int, model = "iid")
      
      # computing part
      model_Cluter <- inla(
        formula_1_bym_rw1_Cluter,
        family = "poisson",
        data = data,
        #E = data[,input$columnexpvalueindata],
        E = data[, 'expected_value'],
        control.predictor = list(compute = TRUE),
        control.compute = list(
          dic = TRUE,
          waic = TRUE,
          cpo = TRUE,
          return.marginals.predictor = TRUE))
      
      exceedance_prob <- sapply(
        model_Cluter$marginals.fitted.values,
        FUN = function(marg) {
          1 - inla.pmarginal(q = 1, marginal = marg) })
      
      data[, "label"] <- exceedance_prob > 0.95
      data[, "label"] <- ifelse(exceedance_prob > 0.95,
                                "hotspot", "non-hotspot")
      
      rv$data <- data
      
      
      rv$model_Cluter <- model_Cluter
      
      
      # model2 <- rv$model
      
      
      ####################################################
      
      
      
      ####################   asso   #################### 
      
      x1 <- input$columncov1indata
      x2 <- input$columncov2indata
      x3 <- input$columncov3indata
      x4 <- input$columncov4indata
      x5 <- input$columncov5indata
      x6 <- input$columncov6indata
      x7 <- input$columncov7indata
      
      
      
      if(x1 == ""& x2== ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ){
        
        print("Check: ...all null...")
        
        
        
        
        
      }else if (x1 != ""& x2== ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
        
        print("Check: ...1 not null...")
        x1 <- data[,input$columncov1indata]
        
        
        
        # id for association each province
        data$x1_id <- data[,input$columnidareaindata]
        
        
        formula_1_bym_rw1 <- data[,input$columncasesindata] ~ 1 +
          f(data$x1_id, x1, model = "iid") +
          f(data[,input$columnidareaindata], model = "bym", graph = tha_adj) +
          f(data[,input$columndateindata], model = "rw1") +
          f(province_int, model = "iid")
        
        # computing part
        model <- inla(
          formula_1_bym_rw1,
          family = "poisson",
          data = data,
          E = data[,input$columnpopindata],
          control.predictor = list(compute = TRUE),
          control.compute = list(
            dic = TRUE,
            waic = TRUE,
            cpo = TRUE,
            return.marginals.predictor = TRUE))
        
        
        
        rv$data <- data
        
        
        rv$model <- model
        
        
        model2 <- rv$model
        
        association_df <- (data.frame(
          c(exp(model2$summary.random$`data|S|x1_id`$mean))
        ) -1 )*100
        
        
        colnames(association_df) <-  c(paste(input$columncov1indata,"_percent_increase", sep=""))
        
        
        association_wsf <- cbind(map, association_df)
        
        association_wsf_df <- data.frame(association_wsf)
        
        
        #rv$association_wsf_df <- association_wsf_df
        
        
        ad <- names(association_df)
        updateSelectInput(session, "risk_factor_filter",  choices = ad,  selected = head(ad, 1))
        
        
        # ค่า sig
        # x1
        association_wsf_df[, paste( input$columncov1indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x1_id`[,4]
        association_wsf_df[, paste( input$columncov1indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x1_id`[,6]
        
        association_wsf_df[, paste( input$columncov1indata,"_significance", sep="")] <- model2$summary.random$`data|S|x1_id`[,4] > 0
        association_wsf_df[, paste( input$columncov1indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x1_id`[,4] > 0 | model2$summary.random$`data|S|x1_id`[,6] < 0, "significant", "not significant")
        
        rv$association_wsf_df <- association_wsf_df
        
        
        
      }else if (x1 != ""& x2!= ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
        
        print("Check: ...1,2 not null...")
        x1 <- data[,input$columncov1indata]
        x2 <- data[,input$columncov2indata]
        
        
        
        # id for association each province
        data$x1_id <- data[,input$columnidareaindata]
        data$x2_id <- data[,input$columnidareaindata]
        
        
        formula_1_bym_rw1 <- data[,input$columncasesindata] ~ 1 +
          f(data$x1_id, x1, model = "iid") +
          f(data$x2_id, x2, model = "iid") +
          f(data[,input$columnidareaindata], model = "bym", graph = tha_adj) +
          f(data[,input$columndateindata], model = "rw1") +
          f(province_int, model = "iid")
        
        # computing part
        model <- inla(
          formula_1_bym_rw1,
          family = "poisson",
          data = data,
          E = data[,input$columnpopindata],
          control.predictor = list(compute = TRUE),
          control.compute = list(
            dic = TRUE,
            waic = TRUE,
            cpo = TRUE,
            return.marginals.predictor = TRUE))
        
        
        
        rv$model <- model
        
        
        model2 <- rv$model
        
        association_df <- (data.frame(
          c(exp(model2$summary.random$`data|S|x1_id`$mean)),
          c(exp(model2$summary.random$`data|S|x2_id`$mean))
        ) -1 )*100
        
        
        colnames(association_df) <-  c(paste(input$columncov1indata,"_percent_increase", sep=""),
                                       paste(input$columncov2indata,"_percent_increase", sep=""))
        
        association_wsf <- cbind(map, association_df)
        
        association_wsf_df <- data.frame(association_wsf)
        
        
        ad <- names(association_df)
        updateSelectInput(session, "risk_factor_filter",  choices = ad,  selected = head(ad, 1))
        
        
        # ค่า sig
        # x1
        association_wsf_df[, paste( input$columncov1indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x1_id`[,4]
        association_wsf_df[, paste( input$columncov1indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x1_id`[,6]
        
        association_wsf_df[, paste( input$columncov1indata,"_significance", sep="")] <- model2$summary.random$`data|S|x1_id`[,4] > 0
        association_wsf_df[, paste( input$columncov1indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x1_id`[,4] > 0 | model2$summary.random$`data|S|x1_id`[,6] < 0, "significant", "not significant")
        
        
        # x2
        association_wsf_df[, paste( input$columncov2indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x2_id`[,4]
        association_wsf_df[, paste( input$columncov2indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x2_id`[,6]
        
        association_wsf_df[, paste( input$columncov2indata,"_significance", sep="")] <- model2$summary.random$`data|S|x2_id`[,4] > 0
        association_wsf_df[, paste( input$columncov2indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x2_id`[,4] > 0 | model2$summary.random$`data|S|x2_id`[,6] < 0, "significant", "not significant")
        
        
        rv$association_wsf_df <- association_wsf_df
        
        
        
      }else if (x1 != ""& x2!= ""& x3!= ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
        
        print("Check: ...1,2,3 not null...")
        x1 <- data[,input$columncov1indata]
        x2 <- data[,input$columncov2indata]
        x3 <- data[,input$columncov3indata]
        
        
        
        # id for association each province
        data$x1_id <- data[,input$columnidareaindata]
        data$x2_id <- data[,input$columnidareaindata]
        data$x3_id <- data[,input$columnidareaindata]
        
        
        formula_1_bym_rw1 <- data[,input$columncasesindata] ~ 1 +
          f(data$x1_id, x1, model = "iid") +
          f(data$x2_id, x2, model = "iid") +
          f(data$x3_id, x3, model = "iid") +
          f(data[,input$columnidareaindata], model = "bym", graph = tha_adj) +
          f(data[,input$columndateindata], model = "rw1") +
          f(province_int, model = "iid")
        
        # computing part
        model <- inla(
          formula_1_bym_rw1,
          family = "poisson",
          data = data,
          E = data[,input$columnpopindata],
          control.predictor = list(compute = TRUE),
          control.compute = list(
            dic = TRUE,
            waic = TRUE,
            cpo = TRUE,
            return.marginals.predictor = TRUE))
        
        
        
        rv$model <- model
        
        
        model2 <- rv$model
        
        association_df <- (data.frame(
          c(exp(model2$summary.random$`data|S|x1_id`$mean)),
          c(exp(model2$summary.random$`data|S|x2_id`$mean)),
          c(exp(model2$summary.random$`data|S|x3_id`$mean))
        ) -1 )*100
        
        
        colnames(association_df) <-  c(paste(input$columncov1indata,"_percent_increase", sep=""),
                                       paste(input$columncov2indata,"_percent_increase", sep=""),
                                       paste(input$columncov3indata,"_percent_increase", sep=""))
        
        association_wsf <- cbind(map, association_df)
        
        association_wsf_df <- data.frame(association_wsf)
        
        
        ad <- names(association_df)
        updateSelectInput(session, "risk_factor_filter",  choices = ad,  selected = head(ad, 1))
        
        # ค่า sig
        # x1
        association_wsf_df[, paste( input$columncov1indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x1_id`[,4]
        association_wsf_df[, paste( input$columncov1indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x1_id`[,6]
        
        association_wsf_df[, paste( input$columncov1indata,"_significance", sep="")] <- model2$summary.random$`data|S|x1_id`[,4] > 0
        association_wsf_df[, paste( input$columncov1indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x1_id`[,4] > 0 | model2$summary.random$`data|S|x1_id`[,6] < 0, "significant", "not significant")
        
        
        # x2
        association_wsf_df[, paste( input$columncov2indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x2_id`[,4]
        association_wsf_df[, paste( input$columncov2indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x2_id`[,6]
        
        association_wsf_df[, paste( input$columncov2indata,"_significance", sep="")] <- model2$summary.random$`data|S|x2_id`[,4] > 0
        association_wsf_df[, paste( input$columncov2indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x2_id`[,4] > 0 | model2$summary.random$`data|S|x2_id`[,6] < 0, "significant", "not significant")
        
        # x3
        association_wsf_df[, paste( input$columncov3indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x3_id`[,4]
        association_wsf_df[, paste( input$columncov3indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x3_id`[,6]
        
        association_wsf_df[, paste( input$columncov3indata,"_significance", sep="")] <- model2$summary.random$`data|S|x3_id`[,4] > 0
        association_wsf_df[, paste( input$columncov3indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x3_id`[,4] > 0 | model2$summary.random$`data|S|x3_id`[,6] < 0, "significant", "not significant")
        
        
        rv$association_wsf_df <- association_wsf_df
        
        
        
        
      }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5== ""& x6== "" & x7== "" ) {
        
        print("Check: ...1,2,3,4 not null...")
        x1 <- data[,input$columncov1indata]
        x2 <- data[,input$columncov2indata]
        x3 <- data[,input$columncov3indata]
        x4 <- data[,input$columncov4indata]
        
        
        
        # id for association each province
        data$x1_id <- data[,input$columnidareaindata]
        data$x2_id <- data[,input$columnidareaindata]
        data$x3_id <- data[,input$columnidareaindata]
        data$x4_id <- data[,input$columnidareaindata]
        
        
        formula_1_bym_rw1 <- data[,input$columncasesindata] ~ 1 +
          f(data$x1_id, x1, model = "iid") +
          f(data$x2_id, x2, model = "iid") +
          f(data$x3_id, x3, model = "iid") +
          f(data$x4_id, x4, model = "iid") +
          f(data[,input$columnidareaindata], model = "bym", graph = tha_adj) +
          f(data[,input$columndateindata], model = "rw1") +
          f(province_int, model = "iid")
        
        # computing part
        model <- inla(
          formula_1_bym_rw1,
          family = "poisson",
          data = data,
          E = data[,input$columnpopindata],
          control.predictor = list(compute = TRUE),
          control.compute = list(
            dic = TRUE,
            waic = TRUE,
            cpo = TRUE,
            return.marginals.predictor = TRUE))
        
        
        
        rv$model <- model
        
        
        model2 <- rv$model
        
        association_df <- (data.frame(
          c(exp(model2$summary.random$`data|S|x1_id`$mean)),
          c(exp(model2$summary.random$`data|S|x2_id`$mean)),
          c(exp(model2$summary.random$`data|S|x3_id`$mean)),
          c(exp(model2$summary.random$`data|S|x4_id`$mean))
        ) -1 )*100
        
        
        colnames(association_df) <-  c(paste(input$columncov1indata,"_percent_increase", sep=""),
                                       paste(input$columncov2indata,"_percent_increase", sep=""),
                                       paste(input$columncov3indata,"_percent_increase", sep=""),
                                       paste(input$columncov4indata,"_percent_increase", sep=""))
        
        
        association_wsf <- cbind(map, association_df)
        
        association_wsf_df <- data.frame(association_wsf)
        
        ad <- names(association_df)
        updateSelectInput(session, "risk_factor_filter",  choices = ad,  selected = head(ad, 1))
        
        
        # ค่า sig
        # x1
        association_wsf_df[, paste( input$columncov1indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x1_id`[,4]
        association_wsf_df[, paste( input$columncov1indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x1_id`[,6]
        
        association_wsf_df[, paste( input$columncov1indata,"_significance", sep="")] <- model2$summary.random$`data|S|x1_id`[,4] > 0
        association_wsf_df[, paste( input$columncov1indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x1_id`[,4] > 0 | model2$summary.random$`data|S|x1_id`[,6] < 0, "significant", "not significant")
        
        
        # x2
        association_wsf_df[, paste( input$columncov2indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x2_id`[,4]
        association_wsf_df[, paste( input$columncov2indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x2_id`[,6]
        
        association_wsf_df[, paste( input$columncov2indata,"_significance", sep="")] <- model2$summary.random$`data|S|x2_id`[,4] > 0
        association_wsf_df[, paste( input$columncov2indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x2_id`[,4] > 0 | model2$summary.random$`data|S|x2_id`[,6] < 0, "significant", "not significant")
        
        # x3
        association_wsf_df[, paste( input$columncov3indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x3_id`[,4]
        association_wsf_df[, paste( input$columncov3indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x3_id`[,6]
        
        association_wsf_df[, paste( input$columncov3indata,"_significance", sep="")] <- model2$summary.random$`data|S|x3_id`[,4] > 0
        association_wsf_df[, paste( input$columncov3indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x3_id`[,4] > 0 | model2$summary.random$`data|S|x3_id`[,6] < 0, "significant", "not significant")
        
        # x4
        association_wsf_df[, paste( input$columncov4indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x4_id`[,4]
        association_wsf_df[, paste( input$columncov4indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x4_id`[,6]
        
        association_wsf_df[, paste( input$columncov4indata,"_significance", sep="")] <- model2$summary.random$`data|S|x4_id`[,4] > 0
        association_wsf_df[, paste( input$columncov4indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x4_id`[,4] > 0 | model2$summary.random$`data|S|x4_id`[,6] < 0, "significant", "not significant")
        
        rv$association_wsf_df <- association_wsf_df
        
        
      }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6== "" & x7== "" ) {
        
        print("Check: ...1,2,3,4,5 not null...")
        x1 <- data[,input$columncov1indata]
        x2 <- data[,input$columncov2indata]
        x3 <- data[,input$columncov3indata]
        x4 <- data[,input$columncov4indata]
        x5 <- data[,input$columncov5indata]
        
        
        
        # id for association each province
        data$x1_id <- data[,input$columnidareaindata]
        data$x2_id <- data[,input$columnidareaindata]
        data$x3_id <- data[,input$columnidareaindata]
        data$x4_id <- data[,input$columnidareaindata]
        data$x5_id <- data[,input$columnidareaindata]
        
        
        formula_1_bym_rw1 <- data[,input$columncasesindata] ~ 1 +
          f(data$x1_id, x1, model = "iid") +
          f(data$x2_id, x2, model = "iid") +
          f(data$x3_id, x3, model = "iid") +
          f(data$x4_id, x4, model = "iid") +
          f(data$x5_id, x5, model = "iid") +
          f(data[,input$columnidareaindata], model = "bym", graph = tha_adj) +
          f(data[,input$columndateindata], model = "rw1") +
          f(province_int, model = "iid")
        
        # computing part
        model <- inla(
          formula_1_bym_rw1,
          family = "poisson",
          data = data,
          E = data[,input$columnpopindata],
          control.predictor = list(compute = TRUE),
          control.compute = list(
            dic = TRUE,
            waic = TRUE,
            cpo = TRUE,
            return.marginals.predictor = TRUE))
        
        
        rv$model <- model
        
        
        model2 <- rv$model
        
        association_df <- (data.frame(
          c(exp(model2$summary.random$`data|S|x1_id`$mean)),
          c(exp(model2$summary.random$`data|S|x2_id`$mean)),
          c(exp(model2$summary.random$`data|S|x3_id`$mean)),
          c(exp(model2$summary.random$`data|S|x4_id`$mean)),
          c(exp(model2$summary.random$`data|S|x5_id`$mean))
        ) -1 )*100
        
        
        colnames(association_df) <-  c(paste(input$columncov1indata,"_percent_increase", sep=""),
                                       paste(input$columncov2indata,"_percent_increase", sep=""),
                                       paste(input$columncov3indata,"_percent_increase", sep=""),
                                       paste(input$columncov4indata,"_percent_increase", sep=""),
                                       paste(input$columncov5indata,"_percent_increase", sep=""))
        
        association_wsf <- cbind(map, association_df)
        
        association_wsf_df <- data.frame(association_wsf)
        
        
        ad <- names(association_df)
        updateSelectInput(session, "risk_factor_filter",  choices = ad,  selected = head(ad, 1))
        
        
        # ค่า sig
        # x1
        association_wsf_df[, paste( input$columncov1indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x1_id`[,4]
        association_wsf_df[, paste( input$columncov1indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x1_id`[,6]
        
        association_wsf_df[, paste( input$columncov1indata,"_significance", sep="")] <- model2$summary.random$`data|S|x1_id`[,4] > 0
        association_wsf_df[, paste( input$columncov1indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x1_id`[,4] > 0 | model2$summary.random$`data|S|x1_id`[,6] < 0, "significant", "not significant")
        
        
        # x2
        association_wsf_df[, paste( input$columncov2indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x2_id`[,4]
        association_wsf_df[, paste( input$columncov2indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x2_id`[,6]
        
        association_wsf_df[, paste( input$columncov2indata,"_significance", sep="")] <- model2$summary.random$`data|S|x2_id`[,4] > 0
        association_wsf_df[, paste( input$columncov2indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x2_id`[,4] > 0 | model2$summary.random$`data|S|x2_id`[,6] < 0, "significant", "not significant")
        
        # x3
        association_wsf_df[, paste( input$columncov3indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x3_id`[,4]
        association_wsf_df[, paste( input$columncov3indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x3_id`[,6]
        
        association_wsf_df[, paste( input$columncov3indata,"_significance", sep="")] <- model2$summary.random$`data|S|x3_id`[,4] > 0
        association_wsf_df[, paste( input$columncov3indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x3_id`[,4] > 0 | model2$summary.random$`data|S|x3_id`[,6] < 0, "significant", "not significant")
        
        # x4
        association_wsf_df[, paste( input$columncov4indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x4_id`[,4]
        association_wsf_df[, paste( input$columncov4indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x4_id`[,6]
        
        association_wsf_df[, paste( input$columncov4indata,"_significance", sep="")] <- model2$summary.random$`data|S|x4_id`[,4] > 0
        association_wsf_df[, paste( input$columncov4indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x4_id`[,4] > 0 | model2$summary.random$`data|S|x4_id`[,6] < 0, "significant", "not significant")
        
        # x5
        association_wsf_df[, paste( input$columncov5indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x5_id`[,4]
        association_wsf_df[, paste( input$columncov5indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x5_id`[,6]
        
        association_wsf_df[, paste( input$columncov5indata,"_significance", sep="")] <- model2$summary.random$`data|S|x5_id`[,4] > 0
        association_wsf_df[, paste( input$columncov5indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x5_id`[,4] > 0 | model2$summary.random$`data|S|x5_id`[,6] < 0, "significant", "not significant")
        
        rv$association_wsf_df <- association_wsf_df
        
        
      }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6!= "" & x7== "" ) {
        
        print("Check: ...1,2,3,4,5,6 not null...")
        x1 <- data[,input$columncov1indata]
        x2 <- data[,input$columncov2indata]
        x3 <- data[,input$columncov3indata]
        x4 <- data[,input$columncov4indata]
        x5 <- data[,input$columncov5indata]
        x6 <- data[,input$columncov6indata]
        
        
        
        # id for association each province
        data$x1_id <- data[,input$columnidareaindata]
        data$x2_id <- data[,input$columnidareaindata]
        data$x3_id <- data[,input$columnidareaindata]
        data$x4_id <- data[,input$columnidareaindata]
        data$x5_id <- data[,input$columnidareaindata]
        data$x6_id <- data[,input$columnidareaindata]
        
        
        formula_1_bym_rw1 <- data[,input$columncasesindata] ~ 1 +
          f(data$x1_id, x1, model = "iid") +
          f(data$x2_id, x2, model = "iid") +
          f(data$x3_id, x3, model = "iid") +
          f(data$x4_id, x4, model = "iid") +
          f(data$x5_id, x5, model = "iid") +
          f(data$x6_id, x6, model = "iid") +
          f(data[,input$columnidareaindata], model = "bym", graph = tha_adj) +
          f(data[,input$columndateindata], model = "rw1") +
          f(province_int, model = "iid")
        
        # computing part
        model <- inla(
          formula_1_bym_rw1,
          family = "poisson",
          data = data,
          E = data[,input$columnpopindata],
          control.predictor = list(compute = TRUE),
          control.compute = list(
            dic = TRUE,
            waic = TRUE,
            cpo = TRUE,
            return.marginals.predictor = TRUE))
        
        
        rv$model <- model
        
        
        model2 <- rv$model
        
        association_df <- (data.frame(
          c(exp(model2$summary.random$`data|S|x1_id`$mean)),
          c(exp(model2$summary.random$`data|S|x2_id`$mean)),
          c(exp(model2$summary.random$`data|S|x3_id`$mean)),
          c(exp(model2$summary.random$`data|S|x4_id`$mean)),
          c(exp(model2$summary.random$`data|S|x5_id`$mean)),
          c(exp(model2$summary.random$`data|S|x6_id`$mean))
        ) -1 )*100
        
        
        colnames(association_df) <-  c(paste(input$columncov1indata,"_percent_increase", sep=""),
                                       paste(input$columncov2indata,"_percent_increase", sep=""),
                                       paste(input$columncov3indata,"_percent_increase", sep=""),
                                       paste(input$columncov4indata,"_percent_increase", sep=""),
                                       paste(input$columncov5indata,"_percent_increase", sep=""),
                                       paste(input$columncov6indata,"_percent_increase", sep=""))
        
        association_wsf <- cbind(map, association_df)
        
        association_wsf_df <- data.frame(association_wsf)
        
        
        
        ad <- names(association_df)
        updateSelectInput(session, "risk_factor_filter",  choices = ad,  selected = head(ad, 1))
        
        
        # ค่า sig
        # x1
        association_wsf_df[, paste( input$columncov1indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x1_id`[,4]
        association_wsf_df[, paste( input$columncov1indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x1_id`[,6]
        
        association_wsf_df[, paste( input$columncov1indata,"_significance", sep="")] <- model2$summary.random$`data|S|x1_id`[,4] > 0
        association_wsf_df[, paste( input$columncov1indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x1_id`[,4] > 0 | model2$summary.random$`data|S|x1_id`[,6] < 0, "significant", "not significant")
        
        
        # x2
        association_wsf_df[, paste( input$columncov2indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x2_id`[,4]
        association_wsf_df[, paste( input$columncov2indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x2_id`[,6]
        
        association_wsf_df[, paste( input$columncov2indata,"_significance", sep="")] <- model2$summary.random$`data|S|x2_id`[,4] > 0
        association_wsf_df[, paste( input$columncov2indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x2_id`[,4] > 0 | model2$summary.random$`data|S|x2_id`[,6] < 0, "significant", "not significant")
        
        # x3
        association_wsf_df[, paste( input$columncov3indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x3_id`[,4]
        association_wsf_df[, paste( input$columncov3indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x3_id`[,6]
        
        association_wsf_df[, paste( input$columncov3indata,"_significance", sep="")] <- model2$summary.random$`data|S|x3_id`[,4] > 0
        association_wsf_df[, paste( input$columncov3indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x3_id`[,4] > 0 | model2$summary.random$`data|S|x3_id`[,6] < 0, "significant", "not significant")
        
        # x4
        association_wsf_df[, paste( input$columncov4indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x4_id`[,4]
        association_wsf_df[, paste( input$columncov4indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x4_id`[,6]
        
        association_wsf_df[, paste( input$columncov4indata,"_significance", sep="")] <- model2$summary.random$`data|S|x4_id`[,4] > 0
        association_wsf_df[, paste( input$columncov4indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x4_id`[,4] > 0 | model2$summary.random$`data|S|x4_id`[,6] < 0, "significant", "not significant")
        
        # x5
        association_wsf_df[, paste( input$columncov5indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x5_id`[,4]
        association_wsf_df[, paste( input$columncov5indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x5_id`[,6]
        
        association_wsf_df[, paste( input$columncov5indata,"_significance", sep="")] <- model2$summary.random$`data|S|x5_id`[,4] > 0
        association_wsf_df[, paste( input$columncov5indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x5_id`[,4] > 0 | model2$summary.random$`data|S|x5_id`[,6] < 0, "significant", "not significant")
        
        # x6
        association_wsf_df[, paste( input$columncov6indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x6_id`[,4]
        association_wsf_df[, paste( input$columncov6indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x6_id`[,6]
        
        association_wsf_df[, paste( input$columncov6indata,"_significance", sep="")] <- model2$summary.random$`data|S|x6_id`[,4] > 0
        association_wsf_df[, paste( input$columncov6indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x6_id`[,4] > 0 | model2$summary.random$`data|S|x6_id`[,6] < 0, "significant", "not significant")
        
        rv$association_wsf_df <- association_wsf_df
        
        
        
      }else {
        print("Check: ...all not null...")
        x1 <- data[,input$columncov1indata]
        x2 <- data[,input$columncov2indata]
        x3 <- data[,input$columncov3indata]
        x4 <- data[,input$columncov4indata]
        x5 <- data[,input$columncov5indata]
        x6 <- data[,input$columncov6indata]
        x7 <- data[,input$columncov7indata]
        
        
        
        # id for association each province
        data$x1_id <- data[,input$columnidareaindata]
        data$x2_id <- data[,input$columnidareaindata]
        data$x3_id <- data[,input$columnidareaindata]
        data$x4_id <- data[,input$columnidareaindata]
        data$x5_id <- data[,input$columnidareaindata]
        data$x6_id <- data[,input$columnidareaindata]
        data$x7_id <- data[,input$columnidareaindata]
        
        
        formula_1_bym_rw1 <- data[,input$columncasesindata] ~ 1 +
          f(data$x1_id, x1, model = "iid") +
          f(data$x2_id, x2, model = "iid") +
          f(data$x3_id, x3, model = "iid") +
          f(data$x4_id, x4, model = "iid") +
          f(data$x5_id, x5, model = "iid") +
          f(data$x6_id, x6, model = "iid") +
          f(data$x7_id, x7, model = "iid") +
          f(data[,input$columnidareaindata], model = "bym", graph = tha_adj) +
          f(data[,input$columndateindata], model = "rw1") +
          f(province_int, model = "iid")
        
        # computing part
        model <- inla(
          formula_1_bym_rw1,
          family = "poisson",
          data = data,
          E = data[,input$columnpopindata],
          control.predictor = list(compute = TRUE),
          control.compute = list(
            dic = TRUE,
            waic = TRUE,
            cpo = TRUE,
            return.marginals.predictor = TRUE))
        
        
        
        rv$model <- model
        
        
        model2 <- rv$model
        
        association_df <- (data.frame(
          c(exp(model2$summary.random$`data|S|x1_id`$mean)),
          c(exp(model2$summary.random$`data|S|x2_id`$mean)),
          c(exp(model2$summary.random$`data|S|x3_id`$mean)),
          c(exp(model2$summary.random$`data|S|x4_id`$mean)),
          c(exp(model2$summary.random$`data|S|x5_id`$mean)),
          c(exp(model2$summary.random$`data|S|x6_id`$mean)),
          c(exp(model2$summary.random$`data|S|x7_id`$mean))
        ) -1 )*100
        
        
        
        colnames(association_df) <-  c(paste(input$columncov1indata,"_percent_increase", sep=""),
                                       paste(input$columncov2indata,"_percent_increase", sep=""),
                                       paste(input$columncov3indata,"_percent_increase", sep=""),
                                       paste(input$columncov4indata,"_percent_increase", sep=""),
                                       paste(input$columncov5indata,"_percent_increase", sep=""),
                                       paste(input$columncov6indata,"_percent_increase", sep=""),
                                       paste(input$columncov7indata,"_percent_increase", sep=""))
        
        
        
        association_wsf <- cbind(map, association_df)
        
        association_wsf_df <- data.frame(association_wsf)
        
        
        # rv$association_wsf_df <- association_wsf_df
        
        ad <- names(association_df)
        updateSelectInput(session, "risk_factor_filter",  choices = ad,  selected = head(ad, 1))
        
        
        # ค่า sig
        # x1
        association_wsf_df[, paste( input$columncov1indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x1_id`[,4]
        association_wsf_df[, paste( input$columncov1indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x1_id`[,6]
        
        association_wsf_df[, paste( input$columncov1indata,"_significance", sep="")] <- model2$summary.random$`data|S|x1_id`[,4] > 0
        association_wsf_df[, paste( input$columncov1indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x1_id`[,4] > 0 | model2$summary.random$`data|S|x1_id`[,6] < 0, "significant", "not significant")
        
        
        # x2
        association_wsf_df[, paste( input$columncov2indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x2_id`[,4]
        association_wsf_df[, paste( input$columncov2indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x2_id`[,6]
        
        association_wsf_df[, paste( input$columncov2indata,"_significance", sep="")] <- model2$summary.random$`data|S|x2_id`[,4] > 0
        association_wsf_df[, paste( input$columncov2indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x2_id`[,4] > 0 | model2$summary.random$`data|S|x2_id`[,6] < 0, "significant", "not significant")
        
        # x3
        association_wsf_df[, paste( input$columncov3indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x3_id`[,4]
        association_wsf_df[, paste( input$columncov3indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x3_id`[,6]
        
        association_wsf_df[, paste( input$columncov3indata,"_significance", sep="")] <- model2$summary.random$`data|S|x3_id`[,4] > 0
        association_wsf_df[, paste( input$columncov3indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x3_id`[,4] > 0 | model2$summary.random$`data|S|x3_id`[,6] < 0, "significant", "not significant")
        
        # x4
        association_wsf_df[, paste( input$columncov4indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x4_id`[,4]
        association_wsf_df[, paste( input$columncov4indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x4_id`[,6]
        
        association_wsf_df[, paste( input$columncov4indata,"_significance", sep="")] <- model2$summary.random$`data|S|x4_id`[,4] > 0
        association_wsf_df[, paste( input$columncov4indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x4_id`[,4] > 0 | model2$summary.random$`data|S|x4_id`[,6] < 0, "significant", "not significant")
        
        # x5
        association_wsf_df[, paste( input$columncov5indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x5_id`[,4]
        association_wsf_df[, paste( input$columncov5indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x5_id`[,6]
        
        association_wsf_df[, paste( input$columncov5indata,"_significance", sep="")] <- model2$summary.random$`data|S|x5_id`[,4] > 0
        association_wsf_df[, paste( input$columncov5indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x5_id`[,4] > 0 | model2$summary.random$`data|S|x5_id`[,6] < 0, "significant", "not significant")
        
        # x6
        association_wsf_df[, paste( input$columncov6indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x6_id`[,4]
        association_wsf_df[, paste( input$columncov6indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x6_id`[,6]
        
        association_wsf_df[, paste( input$columncov6indata,"_significance", sep="")] <- model2$summary.random$`data|S|x6_id`[,4] > 0
        association_wsf_df[, paste( input$columncov6indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x6_id`[,4] > 0 | model2$summary.random$`data|S|x6_id`[,6] < 0, "significant", "not significant")
        
        # x7
        association_wsf_df[, paste( input$columncov7indata,"_lowerbound", sep="")] <- model2$summary.random$`data|S|x7_id`[,4]
        association_wsf_df[, paste( input$columncov7indata,"_upperbound", sep="")] <- model2$summary.random$`data|S|x7_id`[,6]
        
        association_wsf_df[, paste( input$columncov7indata,"_significance", sep="")] <- model2$summary.random$`data|S|x7_id`[,4] > 0
        association_wsf_df[, paste( input$columncov7indata,"_significance", sep="")] <- ifelse(model2$summary.random$`data|S|x7_id`[,4] > 0 | model2$summary.random$`data|S|x7_id`[,6] < 0, "significant", "not significant")
        
        
        rv$association_wsf_df <- association_wsf_df
        
        
        
        
      } # จบ else
      
      
      
    }
  })
  
  # =====================================================
  
  
  
  
  # ==================================== map_distribution ==================================== 
  output$map_distribution <- renderLeaflet({
    
    if (is.null(rv$datosOriginal)| is.null(rv$map))
      return(NULL)
    
    print("Plot: ...map distribution...")
    
    map <- rv$map
    data <- rv$datosOriginal
    
    
    data <- data %>%
      filter(
        data[,input$columndateindata] %in% input$time_point_filter
        
      )
    
    
    
    #datafiltered <- data[which(data[,input$columndateindata] == input$time_point_filter), ]
    datafiltered <- data
    ordercounties <- match(map@data[, input$columnidareainmap], datafiltered[, input$columnidareanamedata])
    map@data <- datafiltered[ordercounties, ]
    
    # Create leaflet
    l <- leaflet(map) %>% addTiles()
    pal <- colorNumeric(palette = input$color, domain = map@data[, input$columncasesindata])
    labels <- sprintf("<strong> %s </strong> <br/>  %s : %s ",
                      map@data[, input$columnidareanamedata] , input$columncasesindata, map@data[, input$columncasesindata]
    ) %>%
      lapply(htmltools::HTML)
    
    l %>%
      addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Open Street Map") %>%
      addProviderTiles(providers$Esri.WorldImagery, group = "ESRI World Imagery") %>%
      addProviderTiles(providers$Esri.NatGeoWorldMap, group = "ESRI National Geographic World Map") %>%
      addProviderTiles(providers$CartoDB.Positron, group = "CartoDB Positron") %>%
      #addProviderTiles(providers$Stamen.Watercolor, group = "Stamen Watercolor") %>%
      #addProviderTiles(providers$Stamen.Toner, group = "Stamen Toner") %>%
      
      addPolygons(
        color = "grey", weight = 1,
        fillColor = ~ pal(map@data[, input$columncasesindata]), fillOpacity = 0.7,
        highlightOptions = highlightOptions(weight = 4),
        label = labels,
        labelOptions = labelOptions(
          style = list(
            "font-weight" = "normal",
            padding = "3px 8px"
          ),
          textsize = "15px", direction = "auto"
        )
      ) %>%
      addLegend(
        pal = pal, values = ~map@data[, input$columncasesindata], opacity = 0.7,
        title = input$columncasesindata, position = "bottomright"
      ) %>%
      addLayersControl(baseGroups = c("Open Street Map", "ESRI World Imagery", "ESRI National Geographic World Map", "CartoDB Positron"
                                      #"Stamen Watercolor", "Stamen Toner"
      ),
      position = c("topleft"),
      options = layersControlOptions(collapsed =  TRUE)
      ) %>%
      addFullscreenControl()
    
    
    
  })
  
  
  # ==================================== cluster_dec ver ลองplot ==================================== 
  
  output$map_cluster <- #renderPrint({  
    renderLeaflet({
      
      if (is.null(rv$datosOriginal) | is.null(rv$map))
        return(NULL)
      
      print("Plot: ...map cluster...")
      #print(rv$data) # ได้แน้วออกเป็นlabelเรย
      
      data2 <- rv$data
      map <- rv$map
      
      # plot
      data2 <- data2 %>%
        filter(
          data2[,input$columndateindata] %in% input$time_point_filter_cluster
          
        )
      
      
      datafiltered <- data2
      ordercounties <- match(map@data[, input$columnidareainmap], datafiltered[, input$columnidareanamedata])
      map@data <- datafiltered[ordercounties, ]
      
      # print(map@data[, "label"])
      
      # Create leaflet c("red", "blue")
      l <- leaflet(map) %>% addTiles()
      pal <- colorFactor(palette = input$color_cluster, domain = map@data[, "label"],
                         levels = c("hotspot", "non-hotspot"))
      labels <- sprintf("<strong> %s </strong> <br/>  label : %s ",
                        map@data[, input$columnidareanamedata] ,  map@data[, "label"]
      ) %>%
        lapply(htmltools::HTML)
      
      l %>%
        addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Open Street Map") %>%
        addProviderTiles(providers$Esri.WorldImagery, group = "ESRI World Imagery") %>%
        addProviderTiles(providers$Esri.NatGeoWorldMap, group = "ESRI National Geographic World Map") %>%
        addProviderTiles(providers$CartoDB.Positron, group = "CartoDB Positron") %>%
        #addProviderTiles(providers$Stamen.Watercolor, group = "Stamen Watercolor") %>%
        #addProviderTiles(providers$Stamen.Toner, group = "Stamen Toner") %>%
        
        addPolygons(
          color = "grey", weight = 1,
          fillColor = ~ pal(map@data[, "label"]), fillOpacity = 0.7,
          highlightOptions = highlightOptions(weight = 4),
          label = labels,
          labelOptions = labelOptions(
            style = list(
              "font-weight" = "normal",
              padding = "3px 8px"
            ),
            textsize = "15px", direction = "auto"
          )
        ) %>%
        addLegend(
          pal = pal, values = ~map@data[, "label"] , opacity = 0.7,
          title = "label", position = "bottomright"
        )%>%
        addLayersControl(baseGroups = c("Open Street Map", "ESRI World Imagery", "ESRI National Geographic World Map", "CartoDB Positron"
                                        #"Stamen Watercolor", "Stamen Toner"
        ),
        position = c("topleft"),
        options = layersControlOptions(collapsed =  TRUE)
        )%>%
        addFullscreenControl()
      
      #labels  =  c("hotspot", "non-hotspot")
      
      
    })
  
  
  
  # ==================================== risk_fac ==================================== 
  
  
  output$map_risk_fac <- renderLeaflet({
    
    if (is.null(rv$datosOriginal) | is.null(rv$map))
      return(NULL)
    
    print("Plot: ...map risk factor...")
    
    map <- rv$map
    
    association_wsf_df <- rv$association_wsf_df 
    
    datafiltered <- association_wsf_df
    ordercounties <- match(map@data[, input$columnidareainmap], datafiltered[, input$columnidareainmap])
    map@data <- datafiltered[ordercounties, ]
    
    
    if (input$risk_factor_filter == paste(input$columncov1indata,"_percent_increase", sep="")){
      sig_col <- map@data[, paste(input$columncov1indata,"_significance", sep="")]
      
    } else if (input$risk_factor_filter == paste(input$columncov2indata,"_percent_increase", sep="")) {
      sig_col <- map@data[, paste(input$columncov2indata,"_significance", sep="")]
      
    } else if (input$risk_factor_filter == paste(input$columncov3indata,"_percent_increase", sep="")) {
      sig_col <- map@data[, paste(input$columncov3indata,"_significance", sep="")]
      
    } else if (input$risk_factor_filter == paste(input$columncov4indata,"_percent_increase", sep="")) {
      sig_col <- map@data[, paste(input$columncov4indata,"_significance", sep="")]
      
    } else if (input$risk_factor_filter == paste(input$columncov5indata,"_percent_increase", sep="")) {
      sig_col <- map@data[, paste(input$columncov5indata,"_significance", sep="")]
      
    } else if (input$risk_factor_filter == paste(input$columncov6indata,"_percent_increase", sep="")) {
      sig_col <- map@data[, paste(input$columncov6indata,"_significance", sep="")]
      
    } else if (input$risk_factor_filter == paste(input$columncov7indata,"_percent_increase",sep="")) {
      sig_col <- map@data[, paste(input$columncov7indata,"_significance", sep="")]
      
    } 
    
    
    # Create leaflet
    l <- leaflet(map) %>% addTiles()
    pal <- colorNumeric(palette = input$color_asso, domain = map@data[, input$risk_factor_filter])
    labels <- sprintf("<strong> %s </strong> <br/>  %s : %s <br/> Significance: %s",
                      map@data[, input$columnidareainmap] , input$risk_factor_filter, map@data[, input$risk_factor_filter] , sig_col #paste(input$columncov1indata,"_significance", sep="")
    ) %>%
      lapply(htmltools::HTML)
    
    l %>%
      addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Open Street Map") %>%
      addProviderTiles(providers$Esri.WorldImagery, group = "ESRI World Imagery") %>%
      addProviderTiles(providers$Esri.NatGeoWorldMap, group = "ESRI National Geographic World Map") %>%
      addProviderTiles(providers$CartoDB.Positron, group = "CartoDB Positron") %>%
      #addProviderTiles(providers$Stamen.Watercolor, group = "Stamen Watercolor") %>%
      #addProviderTiles(providers$Stamen.Toner, group = "Stamen Toner") %>%
      
      addPolygons(
        color = "grey", weight = 1,
        fillColor = ~ pal(map@data[, input$risk_factor_filter]), fillOpacity = 0.7,
        highlightOptions = highlightOptions(weight = 4),
        label = labels,
        labelOptions = labelOptions(
          style = list(
            "font-weight" = "normal",
            padding = "3px 8px"
          ),
          textsize = "15px", direction = "auto"
        )
      ) %>%
      addLegend(
        pal = pal, values = ~map@data[, input$risk_factor_filter], opacity = 0.7,
        title = input$risk_factor_filter, position = "bottomright"
      ) %>%
      addLayersControl(baseGroups = c("Open Street Map", "ESRI World Imagery", "ESRI National Geographic World Map", "CartoDB Positron"
                                      #"Stamen Watercolor", "Stamen Toner"
      ),
      position = c("topleft"),
      options = layersControlOptions(collapsed =  TRUE)
      )%>%
      addFullscreenControl()
    
    
  })
  
  
  # ==================================== ปุุ่ม  downloadData ==================================== 
  
  dataresult_cluster <- reactive({
    # data <- rv$data
    
    if(input$Expected_Value_from_csv == "yes" ){
      if(input$columnexpvalueindata != "" ){
        print("download data: ...this csv have expected value...")
        
        # Remove  Columns in List
        data <- rv$data[,!names(rv$data) %in% c("province_year", "x1_id",	"x2_id",	"x3_id",	"x4_id",	"x5_id",	"x6_id",	"x7_id","expected_value")]
        
        
      }
      
    }else if (input$Expected_Value_from_csv == "no" ){
      print("download data: ...this csv doesn't have expected value...")
      
      # Remove  Columns in List
      data <- rv$data[,!names(rv$data) %in% c("province_year", "x1_id",	"x2_id",	"x3_id",	"x4_id",	"x5_id",	"x6_id",	"x7_id")]
      
      
    }
    
  })
  
  
  
  output$downloadData_cluster <- downloadHandler(
    filename = function() {
      paste("result-cluster-detection-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(dataresult_cluster(), file)
    }
  )
  
  
  dataresult_asso_risk <- reactive({
    
    x1 <- input$columncov1indata
    x2 <- input$columncov2indata
    x3 <- input$columncov3indata
    x4 <- input$columncov4indata
    x5 <- input$columncov5indata
    x6 <- input$columncov6indata
    x7 <- input$columncov7indata
    
    
    asso_select_column <- paste(input$asso_select_column, collapse = ",")
    
    
    
    if (asso_select_column != ""){
      
      if (asso_select_column == "lowerbound,upperbound,significance"){
        
        if(x1 == ""& x2== ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ){
          
          # print("all null")
          
        }else if (x1 != ""& x2== ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_lowerbound", sep=""),
                         paste(input$columncov3indata,"_upperbound", sep=""),
                         paste(input$columncov3indata,"_significance", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_lowerbound", sep=""),
                         paste(input$columncov3indata,"_upperbound", sep=""),
                         paste(input$columncov3indata,"_significance", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_lowerbound", sep=""),
                         paste(input$columncov4indata,"_upperbound", sep=""),
                         paste(input$columncov4indata,"_significance", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6== "" & x7== "" ) {
          
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_lowerbound", sep=""),
                         paste(input$columncov3indata,"_upperbound", sep=""),
                         paste(input$columncov3indata,"_significance", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_lowerbound", sep=""),
                         paste(input$columncov4indata,"_upperbound", sep=""),
                         paste(input$columncov4indata,"_significance", sep=""),
                         
                         paste(input$columncov5indata,"_percent_increase", sep=""),
                         paste(input$columncov5indata,"_lowerbound", sep=""),
                         paste(input$columncov5indata,"_upperbound", sep=""),
                         paste(input$columncov5indata,"_significance", sep=""))
          
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6!= "" & x7== "" ) {
          
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_lowerbound", sep=""),
                         paste(input$columncov3indata,"_upperbound", sep=""),
                         paste(input$columncov3indata,"_significance", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_lowerbound", sep=""),
                         paste(input$columncov4indata,"_upperbound", sep=""),
                         paste(input$columncov4indata,"_significance", sep=""),
                         
                         paste(input$columncov5indata,"_percent_increase", sep=""),
                         paste(input$columncov5indata,"_lowerbound", sep=""),
                         paste(input$columncov5indata,"_upperbound", sep=""),
                         paste(input$columncov5indata,"_significance", sep=""),
                         
                         paste(input$columncov6indata,"_percent_increase", sep=""),
                         paste(input$columncov6indata,"_lowerbound", sep=""),
                         paste(input$columncov6indata,"_upperbound", sep=""),
                         paste(input$columncov6indata,"_significance", sep=""))
          
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6!= "" & x7!= "" ) {
          
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_lowerbound", sep=""),
                         paste(input$columncov3indata,"_upperbound", sep=""),
                         paste(input$columncov3indata,"_significance", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_lowerbound", sep=""),
                         paste(input$columncov4indata,"_upperbound", sep=""),
                         paste(input$columncov4indata,"_significance", sep=""),
                         
                         paste(input$columncov5indata,"_percent_increase", sep=""),
                         paste(input$columncov5indata,"_lowerbound", sep=""),
                         paste(input$columncov5indata,"_upperbound", sep=""),
                         paste(input$columncov5indata,"_significance", sep=""),
                         
                         paste(input$columncov6indata,"_percent_increase", sep=""),
                         paste(input$columncov6indata,"_lowerbound", sep=""),
                         paste(input$columncov6indata,"_upperbound", sep=""),
                         paste(input$columncov6indata,"_significance", sep=""),
                         
                         paste(input$columncov7indata,"_percent_increase", sep=""),
                         paste(input$columncov7indata,"_lowerbound", sep=""),
                         paste(input$columncov7indata,"_upperbound", sep=""),
                         paste(input$columncov7indata,"_significance", sep=""))
          
        }
        
      } # จบ if (asso_select_column == "lowerbound,upperbound,significance"){
      else if (asso_select_column == "lowerbound,upperbound"){
        if(x1 == ""& x2== ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ){
          
          # print("all null")
          
        }else if (x1 != ""& x2== ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_lowerbound", sep=""),
                         paste(input$columncov3indata,"_upperbound", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_lowerbound", sep=""),
                         paste(input$columncov3indata,"_upperbound", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_lowerbound", sep=""),
                         paste(input$columncov4indata,"_upperbound", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6== "" & x7== "" ) {
          
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_lowerbound", sep=""),
                         paste(input$columncov3indata,"_upperbound", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_lowerbound", sep=""),
                         paste(input$columncov4indata,"_upperbound", sep=""),
                         
                         paste(input$columncov5indata,"_percent_increase", sep=""),
                         paste(input$columncov5indata,"_lowerbound", sep=""),
                         paste(input$columncov5indata,"_upperbound", sep=""))
          
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6!= "" & x7== "" ) {
          
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_lowerbound", sep=""),
                         paste(input$columncov3indata,"_upperbound", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_lowerbound", sep=""),
                         paste(input$columncov4indata,"_upperbound", sep=""),
                         
                         paste(input$columncov5indata,"_percent_increase", sep=""),
                         paste(input$columncov5indata,"_lowerbound", sep=""),
                         paste(input$columncov5indata,"_upperbound", sep=""),
                         
                         paste(input$columncov6indata,"_percent_increase", sep=""),
                         paste(input$columncov6indata,"_lowerbound", sep=""),
                         paste(input$columncov6indata,"_upperbound", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6!= "" & x7!= "" ) {
          
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_lowerbound", sep=""),
                         paste(input$columncov3indata,"_upperbound", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_lowerbound", sep=""),
                         paste(input$columncov4indata,"_upperbound", sep=""),
                         
                         paste(input$columncov5indata,"_percent_increase", sep=""),
                         paste(input$columncov5indata,"_lowerbound", sep=""),
                         paste(input$columncov5indata,"_upperbound", sep=""),
                         
                         paste(input$columncov6indata,"_percent_increase", sep=""),
                         paste(input$columncov6indata,"_lowerbound", sep=""),
                         paste(input$columncov6indata,"_upperbound", sep=""),
                         
                         paste(input$columncov7indata,"_percent_increase", sep=""),
                         paste(input$columncov7indata,"_lowerbound", sep=""),
                         paste(input$columncov7indata,"_upperbound", sep=""))
          
        }
        
        
      }else if (asso_select_column == "upperbound,significance"){
        if(x1 == ""& x2== ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ){
          
          # print("all null")
          
        }else if (x1 != ""& x2== ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_upperbound", sep=""),
                         paste(input$columncov3indata,"_significance", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_upperbound", sep=""),
                         paste(input$columncov3indata,"_significance", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_upperbound", sep=""),
                         paste(input$columncov4indata,"_significance", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6== "" & x7== "" ) {
          
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_upperbound", sep=""),
                         paste(input$columncov3indata,"_significance", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_upperbound", sep=""),
                         paste(input$columncov4indata,"_significance", sep=""),
                         
                         paste(input$columncov5indata,"_percent_increase", sep=""),
                         paste(input$columncov5indata,"_upperbound", sep=""),
                         paste(input$columncov5indata,"_significance", sep=""))
          
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6!= "" & x7== "" ) {
          
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_upperbound", sep=""),
                         paste(input$columncov3indata,"_significance", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_upperbound", sep=""),
                         paste(input$columncov4indata,"_significance", sep=""),
                         
                         paste(input$columncov5indata,"_percent_increase", sep=""),
                         paste(input$columncov5indata,"_upperbound", sep=""),
                         paste(input$columncov5indata,"_significance", sep=""),
                         
                         paste(input$columncov6indata,"_percent_increase", sep=""),
                         paste(input$columncov6indata,"_upperbound", sep=""),
                         paste(input$columncov6indata,"_significance", sep=""))
          
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6!= "" & x7!= "" ) {
          
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_upperbound", sep=""),
                         paste(input$columncov3indata,"_significance", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_upperbound", sep=""),
                         paste(input$columncov4indata,"_significance", sep=""),
                         
                         paste(input$columncov5indata,"_percent_increase", sep=""),
                         paste(input$columncov5indata,"_upperbound", sep=""),
                         paste(input$columncov5indata,"_significance", sep=""),
                         
                         paste(input$columncov6indata,"_percent_increase", sep=""),
                         paste(input$columncov6indata,"_upperbound", sep=""),
                         paste(input$columncov6indata,"_significance", sep=""),
                         
                         paste(input$columncov7indata,"_percent_increase", sep=""),
                         paste(input$columncov7indata,"_upperbound", sep=""),
                         paste(input$columncov7indata,"_significance", sep=""))
          
        }
        
      }else if (asso_select_column == "lowerbound,significance"){
        if(x1 == ""& x2== ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ){
          
          # print("all null")
          
        }else if (x1 != ""& x2== ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_lowerbound", sep=""),
                         paste(input$columncov3indata,"_significance", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_lowerbound", sep=""),
                         paste(input$columncov3indata,"_significance", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_lowerbound", sep=""),
                         paste(input$columncov4indata,"_significance", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6== "" & x7== "" ) {
          
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_lowerbound", sep=""),
                         paste(input$columncov3indata,"_significance", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_lowerbound", sep=""),
                         paste(input$columncov4indata,"_significance", sep=""),
                         
                         paste(input$columncov5indata,"_percent_increase", sep=""),
                         paste(input$columncov5indata,"_lowerbound", sep=""),
                         paste(input$columncov5indata,"_significance", sep=""))
          
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6!= "" & x7== "" ) {
          
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_lowerbound", sep=""),
                         paste(input$columncov3indata,"_significance", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_lowerbound", sep=""),
                         paste(input$columncov4indata,"_significance", sep=""),
                         
                         paste(input$columncov5indata,"_percent_increase", sep=""),
                         paste(input$columncov5indata,"_lowerbound", sep=""),
                         paste(input$columncov5indata,"_significance", sep=""),
                         
                         paste(input$columncov6indata,"_percent_increase", sep=""),
                         paste(input$columncov6indata,"_lowerbound", sep=""),
                         paste(input$columncov6indata,"_significance", sep=""))
          
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6!= "" & x7!= "" ) {
          
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_lowerbound", sep=""),
                         paste(input$columncov3indata,"_significance", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_lowerbound", sep=""),
                         paste(input$columncov4indata,"_significance", sep=""),
                         
                         paste(input$columncov5indata,"_percent_increase", sep=""),
                         paste(input$columncov5indata,"_lowerbound", sep=""),
                         paste(input$columncov5indata,"_significance", sep=""),
                         
                         paste(input$columncov6indata,"_percent_increase", sep=""),
                         paste(input$columncov6indata,"_lowerbound", sep=""),
                         paste(input$columncov6indata,"_significance", sep=""),
                         
                         paste(input$columncov7indata,"_percent_increase", sep=""),
                         paste(input$columncov7indata,"_lowerbound", sep=""),
                         paste(input$columncov7indata,"_significance", sep=""))
          
        }
        
      }else if (asso_select_column == "lowerbound"){
        if(x1 == ""& x2== ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ){
          
          # print("all null")
          
        }else if (x1 != ""& x2== ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_lowerbound", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_lowerbound", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_lowerbound", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6== "" & x7== "" ) {
          
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_lowerbound", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_lowerbound", sep=""),
                         
                         paste(input$columncov5indata,"_percent_increase", sep=""),
                         paste(input$columncov5indata,"_lowerbound", sep=""))
          
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6!= "" & x7== "" ) {
          
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_lowerbound", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_lowerbound", sep=""),
                         
                         paste(input$columncov5indata,"_percent_increase", sep=""),
                         paste(input$columncov5indata,"_lowerbound", sep=""),
                         
                         paste(input$columncov6indata,"_percent_increase", sep=""),
                         paste(input$columncov6indata,"_lowerbound", sep=""))
          
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6!= "" & x7!= "" ) {
          
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_lowerbound", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_lowerbound", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_lowerbound", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_lowerbound", sep=""),
                         
                         paste(input$columncov5indata,"_percent_increase", sep=""),
                         paste(input$columncov5indata,"_lowerbound", sep=""),
                         
                         paste(input$columncov6indata,"_percent_increase", sep=""),
                         paste(input$columncov6indata,"_lowerbound", sep=""),
                         
                         paste(input$columncov7indata,"_percent_increase", sep=""),
                         paste(input$columncov7indata,"_lowerbound", sep=""))
          
        }
        
        
      }else if (asso_select_column == "upperbound"){
        if(x1 == ""& x2== ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ){
          
          # print("all null")
          
        }else if (x1 != ""& x2== ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_upperbound", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_upperbound", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_upperbound", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6== "" & x7== "" ) {
          
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_upperbound", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_upperbound", sep=""),
                         
                         paste(input$columncov5indata,"_percent_increase", sep=""),
                         paste(input$columncov5indata,"_upperbound", sep=""))
          
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6!= "" & x7== "" ) {
          
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_upperbound", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_upperbound", sep=""),
                         
                         paste(input$columncov5indata,"_percent_increase", sep=""),
                         paste(input$columncov5indata,"_upperbound", sep=""),
                         
                         paste(input$columncov6indata,"_percent_increase", sep=""),
                         paste(input$columncov6indata,"_upperbound", sep=""))
          
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6!= "" & x7!= "" ) {
          
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_upperbound", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_upperbound", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_upperbound", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_upperbound", sep=""),
                         
                         paste(input$columncov5indata,"_percent_increase", sep=""),
                         paste(input$columncov5indata,"_upperbound", sep=""),
                         
                         paste(input$columncov6indata,"_percent_increase", sep=""),
                         paste(input$columncov6indata,"_upperbound", sep=""),
                         
                         paste(input$columncov7indata,"_percent_increase", sep=""),
                         paste(input$columncov7indata,"_upperbound", sep=""))
          
        }
        
        
      }else if (asso_select_column == "significance"){
        if(x1 == ""& x2== ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ){
          
          # print("all null")
          
        }else if (x1 != ""& x2== ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_significance", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5== ""& x6== "" & x7== "" ) {
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_significance", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_significance", sep=""))
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6== "" & x7== "" ) {
          
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_significance", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_significance", sep=""),
                         
                         paste(input$columncov5indata,"_percent_increase", sep=""),
                         paste(input$columncov5indata,"_significance", sep=""))
          
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6!= "" & x7== "" ) {
          
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_significance", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_significance", sep=""),
                         
                         paste(input$columncov5indata,"_percent_increase", sep=""),
                         paste(input$columncov5indata,"_significance", sep=""),
                         
                         paste(input$columncov6indata,"_percent_increase", sep=""),
                         paste(input$columncov6indata,"_significance", sep=""))
          
          
          
        }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6!= "" & x7!= "" ) {
          
          col_order <- c(input$columnidareainmap,
                         paste(input$columncov1indata,"_percent_increase", sep=""),
                         paste(input$columncov1indata,"_significance", sep=""),
                         
                         paste(input$columncov2indata,"_percent_increase", sep=""),
                         paste(input$columncov2indata,"_significance", sep=""),
                         
                         paste(input$columncov3indata,"_percent_increase", sep=""),
                         paste(input$columncov3indata,"_significance", sep=""),
                         
                         paste(input$columncov4indata,"_percent_increase", sep=""),
                         paste(input$columncov4indata,"_significance", sep=""),
                         
                         paste(input$columncov5indata,"_percent_increase", sep=""),
                         paste(input$columncov5indata,"_significance", sep=""),
                         
                         paste(input$columncov6indata,"_percent_increase", sep=""),
                         paste(input$columncov6indata,"_significance", sep=""),
                         
                         paste(input$columncov7indata,"_percent_increase", sep=""),
                         paste(input$columncov7indata,"_significance", sep=""))
          
        }
      }
      
      
      
    } # จบ  if (asso_select_column != ""){
    else if (asso_select_column == ""){
      if(x1 == ""& x2== ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ){
        
        # print("all null")
        
      }else if (x1 != ""& x2== ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
        col_order <- c(input$columnidareainmap,
                       paste(input$columncov1indata,"_percent_increase", sep=""))
        
        
      }else if (x1 != ""& x2!= ""& x3== ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
        col_order <- c(input$columnidareainmap,
                       paste(input$columncov1indata,"_percent_increase", sep=""),
                       
                       paste(input$columncov2indata,"_percent_increase", sep=""))
        
        
      }else if (x1 != ""& x2!= ""& x3!= ""& x4== ""& x5== ""& x6== "" & x7== "" ) {
        col_order <- c(input$columnidareainmap,
                       paste(input$columncov1indata,"_percent_increase", sep=""),
                       
                       paste(input$columncov2indata,"_percent_increase", sep=""),
                       
                       paste(input$columncov3indata,"_percent_increase", sep=""))
        
        
      }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5== ""& x6== "" & x7== "" ) {
        col_order <- c(input$columnidareainmap,
                       paste(input$columncov1indata,"_percent_increase", sep=""),
                       
                       paste(input$columncov2indata,"_percent_increase", sep=""),
                       
                       paste(input$columncov3indata,"_percent_increase", sep=""),
                       
                       paste(input$columncov4indata,"_percent_increase", sep=""))
        
        
      }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6== "" & x7== "" ) {
        
        col_order <- c(input$columnidareainmap,
                       paste(input$columncov1indata,"_percent_increase", sep=""),
                       
                       paste(input$columncov2indata,"_percent_increase", sep=""),
                       
                       paste(input$columncov3indata,"_percent_increase", sep=""),
                       
                       paste(input$columncov4indata,"_percent_increase", sep=""),
                       
                       paste(input$columncov5indata,"_percent_increase", sep=""))
        
        
        
      }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6!= "" & x7== "" ) {
        
        col_order <- c(input$columnidareainmap,
                       paste(input$columncov1indata,"_percent_increase", sep=""),
                       
                       paste(input$columncov2indata,"_percent_increase", sep=""),
                       
                       paste(input$columncov3indata,"_percent_increase", sep=""),
                       
                       paste(input$columncov4indata,"_percent_increase", sep=""),
                       
                       paste(input$columncov5indata,"_percent_increase", sep=""),
                       
                       paste(input$columncov6indata,"_percent_increase", sep=""))
        
        
        
      }else if (x1 != ""& x2!= ""& x3!= ""& x4!= ""& x5!= ""& x6!= "" & x7!= "" ) {
        
        col_order <- c(input$columnidareainmap,
                       paste(input$columncov1indata,"_percent_increase", sep=""),
                       
                       paste(input$columncov2indata,"_percent_increase", sep=""),
                       
                       paste(input$columncov3indata,"_percent_increase", sep=""),
                       
                       paste(input$columncov4indata,"_percent_increase", sep=""),
                       
                       paste(input$columncov5indata,"_percent_increase", sep=""),
                       
                       paste(input$columncov6indata,"_percent_increase", sep=""),
                       
                       paste(input$columncov7indata,"_percent_increase", sep=""))
        
      }
      
      
      
    } # จบ else if (is.null(asso_select_column)){
    
    
    
    df2 <- rv$association_wsf_df[,col_order]
    
    
    
  })
  
  
  
  output$downloadData_asso_risk <- downloadHandler(
    filename = function() {
      paste("result-association-risk-factor-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(dataresult_asso_risk(), file)
    }
  )
  
  
  # ---------------------------- portable App ------------------------------ 
  
  
  
  # session$onSessionEnded(function() {
  #   stopApp()
  # })
  
  
  # ------------------------------------------------------------------------
  
} # end shinyApp


##------------------------------Run Shiny App--------------------------------##

# shinyApp(ui = ui, server = server)






