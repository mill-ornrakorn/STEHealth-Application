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


# ==================================== header ==========================================


header <- dashboardHeader(title = 'STEHealth',
                          
                          # tags$li(class = "dropdown",
                          #         tags$div(
                          #                  
                          #         )),
                          dropdownMenuOutput("messageMenu"))

header$children[[2]]$children <- tags$img(src='STEHealth_logo1.png',width='180', style = "margin-left: -10px; ")


# ==================================== menuItem ==================================== 

sidebar <- dashboardSidebar( 
  sidebarMenu(id="tabs", 
              menuItem(HTML("&ensp;Home"), tabName = "Home", icon = icon("house")),
              menuItem(HTML("&ensp;Upload Data"), tabName = "Upload_data", icon = icon("folder-open")),
              menuItem(HTML("&ensp;Map Distribution"), tabName = "Map_Distribution", icon = icon("map")),
              menuItem(HTML("&ensp;Spatiotemporal <br/>&emsp; &ensp;Epidemiology Analysis"), tabName="Analysis", icon=icon("globe")),
              menuItem(HTML("&ensp;About Application"), tabName = "About", icon = icon("file")),
              menuItem(HTML("&ensp;Manual"), tabName = "Manual", icon = icon("book")),
              menuItem(HTML("&ensp;Help"), tabName = "Help", icon=icon("question")),
              menuItem(HTML("&ensp;Releases"), tabName = "Releases", icon=icon("tasks"))
              
  )
)


body <- dashboardBody(
  tags$script("document.title = 'STEHealth | Spatiotemporal Epidemiological Analysis'"),
  tags$head(tags$link(rel="icon", 
                      href="STEHealth_logo_0.ico")
  ),
  
  tags$head(
    tags$meta(charset="utf-8"),
    tags$link(rel="stylesheet" ,href="https://unicons.iconscout.com/release/v4.0.8/css/line.css"), # UNICONS
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),   # import css file
    tags$script(src="js/index.js") # เป็นตัวช่วยในการลิงก์ tag a ไปยัง tap อื่น ๆ
    
    
  ),
  
  # font
  HTML("<link href='https://fonts.googleapis.com/css?family=Poppins' rel='stylesheet'>"),
  
  #HTML('<link href="https://fonts.googleapis.com/css?family=Poppins:400,500|Raleway:400,500&display=swap" rel="stylesheet">'),
  
  
  fluidRow(
    tabItems(
      # ==================================== Home ==================================== 
      
      tabItem(tabName = "Home",
              
              HTML('
              <div class="header" id="home" >
                   <div class="container">
                     <div class="infos">
                        <img src="STEHealth_logo1.png", class = "home__logo", alt="STEHealth_logo" , height  = "37px", width = "174px">
                        <h1 class="title">
                            Spatiotemporal Epidemiological Analysis
                        </h1>
                        <p class="home__caption"  style = "text-align: justify;">
                            This is an application for analyzing space-time pattern and 
                             association with risk factors of suicide and other health outcomes, 
                             which allows users to import their own data, analyze, and visualize.</p>
                      
                      <div class="button">
                        <a class="btn btn-primary" 
                                 onclick="$(\'li:eq(6) a\').tab(\'show\');" 
                                 role="button"
                                 style = "border-color: #735DFB;" >
                           <strong>Get Started <i class="uil uil-angle-right-b"></i></strong> 
                        </a>
                        
                        
                        <a class="btn btn-outline-primary"
                                 onclick="$(\'li:eq(10) a\').tab(\'show\');"
                                 role="button"
                                 >
                            <strong>How to use?</strong>
                        </a>
                        
                      </div>
                    </div>
                    
                    <div class="img-holder">
                       <img src="home.png" alt="homepage">
                      
                    </div>
                    
                  </div>
               </div>
                   ')
              
              
      ),# tabItem 1 : tabName = "Home"
      
      
      # ==================================== Upload_data ==================================== 
      tabItem(tabName = "Upload_data",
              
              HTML("<div class = 'heading_container'>
                     <h1>Upload Data</h1>
                   </div>"),
              
              
              div(style = "margin-bottom: 30px;"),
              
              HTML("<h2>Input Data</h2>"),
              
              sidebarLayout(
                
                sidebarPanel(
                  style = "height: 80vh; overflow-y: auto;",
                  
                  tags$style(".well {background-color:#FFFFFF;}"),
                  
                  
                  # ==================================== Upload map (shapefile) ==================================== 
                  div(style="display: inline-block;",
                      HTML('<h3><span class="purple">1.</span>
                                   Upload shapefile</h3>
                                   '),
                      
                      div(style = "margin-left: 280px; margin-top: -45px;",
                          bsButton("question_shapefile", label = "", icon = icon("question"), style = "Question"),
                          
                          bsPopover(id = "question_shapefile", title = "Shapefile", 
                                    content = paste0(strong("What is a shapefile? "),br(),
                                                     "A shapefile is a simple, nontopological format for storing the geometric location and attribute information of geographic features. ",
                                                     a("(5)",
                                                       href = "https://desktop.arcgis.com/en/arcmap/latest/manage-data/shapefiles/what-is-a-shapefile.htm",
                                                       target="_blank"),
                                                     
                                                     br(),br(),
                                                     strong("Examples of shapefiles"),br(),
                                                     "This examples shapefiles include shp, dbf, shx, prj. ",
                                                     a("click here to downloads shapefiles",
                                                       href = "https://drive.google.com/drive/folders/1vheBturgr3gclBq7kqp5dWouPf_C0VbQ?usp=share_link",
                                                       target="_blank")
                                    ),
                                    placement = "right",
                                    trigger = "click",
                                    options = list(container = "body")
                          ))
                  ),
                  
                  hr(),
                  HTML("<strong><font color= \"#735DFB\">Upload 4 shapefile at once:</font></strong> shp, dbf, shx and prj."),
                  fileInput("filemap", "", accept=c('.shp','.dbf','.sbn','.sbx','.shx',".prj"), multiple=TRUE),
                  
                  helpText("Select column area name in the map."),
                  fluidRow(column(12, selectInput("columnidareainmap",   label = "area name",   choices = c(""), selected = "")%>%
                                    shinyInput_label_embed(
                                      icon("info") %>%
                                        bs_embed_tooltip(title = '"area name" in the shapefile must be matched to "area name" in the csv file')
                                    )
                  ),
                  #column(6, selectInput("columnnameareainmap", label = "area name", choices = c(""), selected = ""))
                  ),
                  
                  
                  HTML("</br>"),
                  
                  radioButtons("shapefile_from_thailand", "Are these shapefiles from Thailand and do they include all 77 provinces, representing provincial boundaries (Level 1)? ", inline=TRUE, c("Yes" = "yes", "No" = "no"), selected="no"),
                  
                  
                  
                  # ==================================== Upload data (.csv file) ==================================== 
                  div(style="display: inline-block;",
                      HTML('<h3><span class="purple">2.</span>
                                   Upload csv file</h3>'),
                      
                      div(style = "margin-left: 240px; margin-top: -45px;",
                          bsButton("question_csvfile", label = "", icon = icon("question"), style = "Question"),
                          
                          bsPopover(id = "question_csvfile", title = "csv file",
                                    content = paste0(strong("The csv file "),br(),
                                                     ".csv file needs to have columns: ",
                                                     strong("<area id> <area name> <cases> <time point> <population>"),
                                                     br(),br(),
                                                     strong("Examples of csv file "),
                                                     #"This examples csv file include column: ....... ",
                                                     a("click here to downloads csv file",
                                                       href = "https://drive.google.com/drive/folders/1vheBturgr3gclBq7kqp5dWouPf_C0VbQ?usp=share_link",
                                                       target="_blank")
                                    ),
                                    placement = "right",
                                    trigger = "click",
                                    options = list(container = "body")
                          ))
                  ),
                  
                  
                  
                  hr(),
                  HTML("csv file needs to have columns:<strong><font color= \"#735DFB\"> area id, area name, time point, cases, population</font></strong>"),
                  fileInput("file1", "", accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
                  
                  helpText("Select columns:"),
                  fluidRow(column(6, selectInput("columnidareaindata",  label = "area id",  choices = c(""), selected = "")%>%
                                    shinyInput_label_embed(
                                      icon("info") %>%
                                        bs_embed_tooltip(title = '"area id" is a number starting at 1, used to identify provinces.')
                                    )
                  ),
                  column(6, selectInput("columnidareanamedata", label = "area name", choices = c(""), selected = "")%>%
                           shinyInput_label_embed(
                             icon("info") %>%
                               bs_embed_tooltip(title = '"area name" in the shapefile must be matched to "area name" in the csv file.')
                           )
                  )
                  ),
                  fluidRow(#column(6, selectInput("columnexpvalueindata", label = "expected value", choices = c(""), selected = "")),
                    column(6, selectInput("columnpopindata", label = "population", choices = c(""), selected = "")%>%
                             shinyInput_label_embed(
                               icon("info") %>%
                                 bs_embed_tooltip(title = 'population in each area.')
                             )
                           
                    ),
                    column(6, selectInput("columncasesindata", label = "cases", choices = c(""), selected = "")%>%
                             shinyInput_label_embed(
                               icon("info") %>%
                                 bs_embed_tooltip(title = 'number of cases or outcomes in each area.')
                             )
                    )
                  ),
                  fluidRow(column(6, selectInput("columndateindata", label = "time point", choices = c(""), selected = "")%>%
                                    shinyInput_label_embed(
                                      icon("info") %>%
                                        bs_embed_tooltip(title = 'time point in the data, such as day, month, year.')
                                    )
                  )
                  
                  ),
                  
                  
                  HTML("<h4><strong>2.1 Select Expected Value</strong> <font color= \"#03989e\"> (Optional) </font></h4>"),
                  
                  radioButtons("Expected_Value_from_csv", "Does this CSV file have an expected value column?", inline=TRUE, c("Yes" = "yes", "No" = "no"), selected="no"),
                  
                  conditionalPanel(condition = "input.Expected_Value_from_csv == 'yes'",
                                   helpText("Select column:"),
                                   fluidRow(column(12, selectInput("columnexpvalueindata",   label = "expected value",   choices = c(""), selected = "")%>%
                                                     shinyInput_label_embed(
                                                       icon("info") %>%
                                                         bs_embed_tooltip(title = 'The expected value is number of outcomes in the provided area and period which may vary due to the types of diseases.')
                                                     )
                                   )
                                   )
                                   
                  ),
                  
                  
                  conditionalPanel(condition = "input.Expected_Value_from_csv == 'no'",
                                   HTML("<font color= \"#735DFB\"><strong>Note that: </strong></font>
                                        If the CSV file lacks an expected value column, the calculation will use the 'cases' and 'population' columns to derive an expected value."),
                                   
                                   
                  ),
                  
                  
                  HTML("</br>
                       <h4><strong>2.2 Select Covariates</strong> <font color= \"#03989e\"> (Optional) </font></h4>"),
                  HTML("Put covariate in order from 1 to 7, with no blanks."),
                  
                  helpText("Select column(s):"),
                  fluidRow(column(6, selectInput("columncov1indata", label = "covariate 1", choices = c(""), selected = "")),
                           column(6, selectInput("columncov2indata", label = "covariate 2", choices = c(""), selected = ""))
                  ),
                  
                  fluidRow(column(6, selectInput("columncov3indata", label = "covariate 3", choices = c(""), selected = "")),
                           column(6, selectInput("columncov4indata", label = "covariate 4", choices = c(""), selected = ""))
                  ),
                  
                  fluidRow(column(6, selectInput("columncov5indata", label = "covariate 5", choices = c(""), selected = "")),
                           column(6, selectInput("columncov6indata", label = "covariate 6", choices = c(""), selected = ""))
                  ),
                  
                  fluidRow(column(6, selectInput("columncov7indata", label = "covariate 7", choices = c(""), selected = "")),
                           #column(6, selectInput("columncov8indata", label = "covariate 8", choices = c(""), selected = ""))
                  ),
                  
                  HTML("<font color= \"#735DFB\"><strong>Note that: </strong></font>
                                             <ul style = 'text-align: justify;'>
                                              <li>If the user select 1 covariate, the analysis is <strong>univariate</strong>.</li> 
                                              <li>If the user selects covariates more than 1, all covariates will be calculated at the same time, which is a 
                                                <strong>multivariate</strong> analysis. However, the results will be displayed one by one on the 'Spatiotemporal Epidemiological Analysis' page ('Association with Risk Factors' tap).</li>  
                                              
                                             </ul>
                                                
                                            </br>"),
                  
                  
                  fluidRow(column(4, offset=3, actionButton("Preview_Map_Distribution",
                                                            strong("Preview Map Distribution"),
                                                            onclick = "$('li:eq(7) a').tab('show');",
                                                            class = 'btn-primary',
                                                            style='color: #FFFFFF;'
                  ))),
                  
                  
                  
                  
                  
                ),
                # ==================================== Preview Input Data ==================================== 
                mainPanel(
                  div(style = "margin-top: -60px;" ),
                  HTML("<h2>Preview Input Data</h2>"),
                  
                  tabBox(width=12,id="tabBox_next_previous",
                         tabPanel(HTML("<h4>Map data (shapefile)</h4>"), 
                                  #HTML("<p style='text-align:center; margin-top: 60px; margin-bottom: 60px;'> 
                                  #    <img src='nodata.png', alt='nodata', height  = '300px', width = '400px'>"),
                                  
                                  
                                  #verbatimTextOutput("status_map"),
                                  uiOutput('status_map'), 
                                  
                                  # div(
                                  #  plotOutput("uploadmapmap"),
                                  #  style = 'z-index: -1; position: relative; '
                                  #    ),
                                  verbatimTextOutput("uploadmapsummary"), 
                                  dataTableOutput('uploadmaptable')
                                  
                                  
                         ),
                         
                         tabPanel(HTML("<h4>Data (.csv file)</h4>"), 
                                  #HTML("<p style='text-align:center; margin-top: 60px; margin-bottom: 60px;'> 
                                  #      <img src='nodata.png', alt='nodata', height  = '300px', width = '400px'>"),
                                  
                                  #verbatimTextOutput("status_csv"),
                                  uiOutput('status_csv'),
                                  verbatimTextOutput("uploaddatasummary"),
                                  dataTableOutput('uploaddatatable')
                         )
                         
                         
                  )
                  
                  
                ))),
      
      # ==================================== Map_Distribution ==================================== 
      
      tabItem(tabName = "Map_Distribution",
              HTML("<div class = 'heading_container'>
                     <h1>Map Distribution</h1>
                   </div>"),
              div(class = "box-white", 
                  sidebarLayout(
                    sidebarPanel(
                      
                      style = "height: 80vh; overflow-y: auto;",
                      fluidRow(
                        column(12,
                               HTML("<div class='box-white'>
                                             
                                            <img align='left' width='52px'; height='52px'; src='mapdis.png' style = 'margin-top: 10px; margin-right: 10px;' >
                                        
                                            <h4>Map Distribution</h4>
                                            <p>
                                              The Map Distribution displays an interactive distribution map of the user uploaded shapefile 
                                              and csv file on the Upload data page using <strong>case column</strong> to plot. 
                                              Users can visualize and select filters including time point and color scheme.
                                            </p>
                                           
                                          </div>
                                           "),
                               
                               div(
                                 class = "box-white",
                                 HTML("<h4>Filter</h4>"),
                                 
                                 # เลือกช่วงเวลา
                                 selectInput("time_point_filter", label = "Time Point:" ,
                                             choices = c(""), selected = ""),
                                 
                                 #selectInput("time_point_filter", label = "Time Period:", choices = c(""), selected = ""),
                                 
                                 
                                 # เลือกสีแมพ
                                 selectInput("color", label = "Color Scheme:", 
                                             choices = list("Red" = "YlOrRd",  "Pink" = "RdPu", "Green" = "YlGnBu",
                                                            "Red and Blue" = "RdYlBu", "Purple" = "BuPu" ,"Gray" = "Greys"))
                               ),
                               
                               
                               div(
                                 class = "box-white",
                                 HTML('<h4>
                                Capture screenshot
                               </h4>
                               <p>
                                Take a screenshot of map. The captured image is downloaded as a PNG image.
                               </p>
                              '),
                                 
                                 capture(
                                   class="btn btn-outline-primary2",
                                   selector = "#map_distribution",
                                   filename = paste("map_distribution-", Sys.Date(), ".png", sep=""),
                                   icon("camera"), "Screenshot Map",
                                   scale = 3, # bigger scale
                                   options=list(backgroundColor = "white"),
                                   style = "border-radius: 100px;"
                                 )
                                 
                               ),
                               
                               
                               fluidRow(column(4,
                                               offset=3,
                                               actionButton("nextpage",
                                                            strong("Go to analysis page"), # ► ◄
                                                            onclick = "$('li:eq(8) a').tab('show');",
                                                            class = 'btn-primary',
                                                            style='color: #FFFFFF; margin-top: 20px;'
                                               )
                               ))
                               
                               
                        )
                      )
                      
                    )
                    
                    
                    
                    ,
                    mainPanel(uiOutput("status_map_dis"),
                              #leafletOutput("map_distribution", height = "70vh")
                              div(class = 'error',
                                  verbatimTextOutput("messageCheckData_1")
                              ),
                              addSpinner(
                                leafletOutput("map_distribution", height = "75vh"),
                                spin = "bounce", color = "#735DFB")
                              
                    )
                  ))
              
      ),
      
      # ==================================== Analysis ==================================== 
      
      tabItem(
        tabName = "Analysis",
        HTML("
                  <div class = 'heading_container'>
                     <h1>Spatiotemporal Epidemiological Analysis</h1>
                   </div>"),
        
        tabBox(width=12,id="tabBox_next_previous",
               
               # ==================================== Cluster Detection ==================================== 
               
               tabPanel(HTML("<h4>Cluster Detection</h4>"),
                        sidebarLayout(
                          sidebarPanel(
                            style = "height: 80vh; overflow-y: auto;",
                            fluidRow(
                              column(12,
                                     div(
                                       class = "box-white",
                                       tags$img(align='left',width='52px',height='52px',src='cluster.png',style='margin-top: 10px; margin-right: 10px'),
                                       tags$h4("Cluster Detection"),
                                       HTML("The Cluster detection Tab displays a cluster map of the data, which consist of <strong>hotspot</strong>, and <strong>non-hotspot</strong>. 
                                                    Users can visualize and select filters including time point and color scheme. For details of the model, please refer to the"),
                                       tags$a("Help page.", onclick="customHref('Help')", class = "cursor_point"),
                                       br(),br(),
                                       actionButton("interpret_cluster", class="btn btn-outline-primary2", "Examples of Interpretation")
                                       
                                     ),
                                     
                                     
                                     div(
                                       class = "box-white",
                                       HTML("<h4>Filter</h4>"),
                                       
                                       # เลือกช่วงเวลา
                                       # sliderInput("time_point_filter_cluster", label = "Time Period:" , min = 1 ,
                                       #             max = 10 , value = 1, step = 1),
                                       
                                       selectInput("time_point_filter_cluster", label = "Time Point:" ,
                                                   choices = c(""), selected = ""),
                                       
                                       
                                       
                                       # เลือกสีแมพ
                                       selectInput("color_cluster", label = "Color Scheme:", 
                                                   choices = list("Red and Green" = "Set1", 
                                                                  "Green and Purple" = "Dark2",
                                                                  "Orange and Green" = "Spectral",
                                                                  "Yellow and Green" = "BrBG",
                                                                  "Red and Blue" = "RdBu",
                                                                  "Purple and Orange" = "PuOr"
                                                   ))
                                     ),
                                     
                                     div(
                                       class = "box-white",
                                       HTML('<h4>Export Result</h4>
                                                  <p>
                                                     The data obtained from the cluster detection consists of the original data and the <strong>label column</strong>, 
                                                     which in the label column will consist of hotspot and non-hotspot. 
                                                  </p>
                                                  
                                                  '),
                                       
                                       
                                       
                                       downloadButton("downloadData_cluster", "Download (.csv)", 
                                                      class="btn btn-outline-primary2",
                                                      style = "border-radius: 100px;"), 
                                       
                                       HTML('</br>
                                                  </br>
                                                  <h4>
                                                     Capture screenshot
                                                  </h4>
                                                  <p>
                                                  Take a screenshot of map. The captured image is downloaded as a PNG image.
                                                  </p>
                                                  
                                                  '),
                                       
                                       capture(
                                         class="btn btn-outline-primary2",
                                         selector = "#map_cluster",
                                         filename = paste("map_cluster-", Sys.Date(), ".png", sep=""),
                                         icon("camera"), "Screenshot Map",
                                         scale = 3, # bigger scale
                                         options=list(backgroundColor = "white"),
                                         style = "border-radius: 100px;"
                                       )
                                       
                                       
                                     ),
                                     
                                     
                                     # div(
                                     #   class = "box-purple",
                                     #   HTML("<h4></h4>
                                     #        • If the area has a <strong>hotspot</strong>: </br>
                                     #          &emsp;In Kanchanaburi, has a hotspot, meaning that Kanchanaburi has a higher number of suicides than the specified threshold (the base line of our work is defined as the average number of suicides). 
                                     #          
                                     #          </br></br>
                                     #          For other examples of interpretation, please refer to the
                                     #        "
                                     #   ),
                                     #   tags$a("Manual page.", onclick="customHref('Manual')")
                                     # )
                                     
                                     
                                     
                              ),
                              
                              
                              
                              
                              
                            )),
                          
                          mainPanel(
                            uiOutput("status_cluster"),
                            div(class = 'error',
                                verbatimTextOutput("messageCheckData_2")
                            ),
                            #verbatimTextOutput("status_map_cluster"),
                            #leafletOutput("map_cluster", height = "70vh")
                            addSpinner(
                              leafletOutput("map_cluster", height = "80vh"),
                              spin = "bounce", color = "#735DFB"
                            )
                            
                            
                          )
                          
                          
                        )
               ),
               
               # ==================================== Association with Risk Factors ==================================== 
               # sidebarLayout(
               #   
               #   sidebarPanel(
               # mainPanel
               tabPanel(HTML("<h4>Association with Risk Factors</h4>"),
                        sidebarLayout(
                          sidebarPanel(style = "height: 80vh; overflow-y: auto;",
                                       fluidRow(
                                         column(12,
                                                div(
                                                  class = "box-white",
                                                  HTML("
                                            <img align='left' width='52px' height='52px' src='risk.png' style='margin-top: 10px; margin-right: 10px' >
                                            <h4>Association with Risk Factors</h4>
                                            
                                             
                                             This tab displays an association between risk factors and case outcomes. 
                                             From the analysis, this map indicates the <strong>percent increase value</strong> 
                                            and <strong>significance</strong> of each risk factor in each area. 
                                             Users can visualize by using filters including each risk factor and color scheme. 
                                             
                                             For details of the model and value, please refer to the
                                                  "),
                                                  
                                                  tags$a("Help page.", onclick="customHref('Help')",  class = "cursor_point"),
                                                  br(),br(),
                                                  actionButton("interpret_asso_risk", class="btn btn-outline-primary2", "Examples of Interpretation")
                                                ),
                                                
                                                div(
                                                  class = "box-white",
                                                  HTML("<h4>Filter</h4>"),
                                                  selectInput("risk_factor_filter", label = "Risk factor:", choices = c(""), selected = ""),
                                                  
                                                  # เลือกสีแมพ
                                                  selectInput("color_asso", label = "Color Scheme:", 
                                                              choices = list("Red" = "YlOrRd",  "Pink" = "RdPu", "Green" = "YlGnBu",
                                                                             "Red and Blue" = "RdYlBu", "Purple" = "BuPu" ,"Gray" = "Greys"))
                                                  
                                                  
                                                ),
                                                
                                                div(
                                                  class = "box-white",
                                                  HTML("<h4>Export Result</h4>
                                            <p>
                                            The data obtained from the association with risk factors consists of area name, each risk factor calculated as a percentage increase, lower bound, upper bound, and significance                                              </p>
                                                  
                                                  "),
                                                  
                                                  checkboxGroupInput('asso_select_column', 'Column', inline=TRUE, 
                                                                     c("lower bound" = "lowerbound", 'upper bound' = 'upperbound', 'significance' = 'significance'),
                                                                     selected = c("lowerbound", 'upperbound', 'significance' )),
                                                  
                                                  
                                                  downloadButton("downloadData_asso_risk", "Download (.csv)", 
                                                                 class="btn btn-outline-primary2",
                                                                 style = "border-radius: 100px;"),
                                                  
                                                  
                                                  HTML('</br>
                                            </br>
                                            <h4>
                                              Capture screenshot
                                            </h4>
                                            <p>
                                            Take a screenshot of map. The captured image is downloaded as a PNG image.
                                            </p>
                                           '),
                                                  
                                                  capture(
                                                    class="btn btn-outline-primary2",
                                                    selector = "#map_risk_fac",
                                                    filename = paste("map_risk_fac-", Sys.Date(), ".png", sep=""),
                                                    icon("camera"), "Screenshot Map",
                                                    scale = 3, # bigger scale
                                                    options=list(backgroundColor = "white"),
                                                    style = "border-radius: 100px;"
                                                  )
                                                  
                                                  
                                                ),
                                                
                                                #     div(
                                                #       class = "box-purple",
                                                #       HTML("<h4>Examples of interpretation (from sample data)</h4>
                                                # • If the significance is <strong>significant</strong> and risk factor value is <strong>positive (+)</strong>: </br>
                                                #   &emsp;In Lamphun, the percent increase in expenditure is 0.15, which means if expenditure increases by 1 baht (THB), 
                                                #   the suicide risk will <u>increase</u> by 0.15%, or every 100 baht (THB) increase in expenditure increases the suicide risk by 15%.
                                                # 
                                                # </br></br> 
                                                # • If the significance is <strong>significant</strong> and risk factor value is <strong>negative (-)</strong>: </br>
                                                #   &emsp;In Samuut Prakan, the percent increase in expenditure is -0.15, which means if expenditure increases by 1 baht (THB), 
                                                #   the suicide risk will <u>decrease</u> by 0.15%, or every 100 baht (THB) increase in expenditure decrease the suicide risk by 15%.
                                                # 
                                                # </br></br>     
                                                # •If the significance is <strong>not significant</strong>: </br>  
                                                #   &emsp;When the value of significance is not significant, it means that this risk factor and the outcome <u>do not have significant relationships</u>.
                                                # 
                                                # </br></br>   
                                                #   For other examples of interpretation, please refer to the
                                                #  "),
                                                #       tags$a("Manual page.", onclick="customHref('Manual')")
                                                #       
                                                #     )
                                                
                                                
                                         )
                                         
                                         
                                         
                                         
                                       )
                          ),
                          
                          mainPanel(
                            uiOutput("status_risk_fac"),
                            div(class = 'error',
                                verbatimTextOutput("messageCheckData_3")
                            ),  
                            #verbatimTextOutput("status_map_asso"),
                            div(class = 'warning',
                                verbatimTextOutput("status_risk_fac_nocova")
                            ),
                            addSpinner(
                              leafletOutput("map_risk_fac", height = "80vh"),
                              spin = "bounce", color = "#735DFB"
                            )
                            
                            
                          )
                          
                        )
                        
                        
               )
        )
      ),
      
      
      
      
      
      
      tabItem(tabName = "About",
              includeMarkdown("about_webapp.md")
              
      ),
      
      
      tabItem(tabName = "Manual",
              includeMarkdown("Manual.md")
              
      ),
      
      tabItem(tabName = "Help",
              withMathJax(includeMarkdown("help.md")) # withMathJax ช่วยให้แสดงสมการคณิตได้ใน app
      ),
      
      tabItem(tabName = "Releases",
              includeMarkdown("Releases.md")
      ) 
    )
  ))     





# shinyApp(
  ui <-  dashboardPage(skin = "purple",
                       options = list(sidebarExpandOnHover = TRUE),
                       header,
                       sidebar,
                     body
  )
# )


