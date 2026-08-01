# ================================================================

# @29-apr-26

# ================================================================

# ==================================== Check packages  ==================================== 

list.of.packages <- c("shiny", "shinydashboard", "shinyjs", "shinyBS" , "leaflet" ,
                      "dplyr", "ggplot2" ,"RColorBrewer" , "shinyWidgets", "sf",
                      "shinydashboardPlus","spdep", "leaflet.extras", "bsplus" ,"remotes",
                      "readxl", "plotly", "DT")


new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)


if(!require(INLA)){
  # ต้องใช้ R 4.2.2 ถึงจะลงได้ ลองใช้ 4.3.1 แล้วลงไม่ได้
  install.packages("INLA",repos=c(getOption("repos"),INLA="https://inla.r-inla-download.org/R/stable"), dep=TRUE)
  library(INLA)
}


# if(!require(capture)){
#   remotes::install_github("dreamRs/capture")
#   library(capture)
# }

# ==================================== import packages  ==================================== 

library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinyBS)
library(leaflet)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(sf)
library(shinyWidgets)
library(shinydashboardPlus)

library(INLA)
inla.setOption(scale.model.default = TRUE)
library(spdep) # อันนี้ใช้ nb2mat

library(capture) # ลงโดยใช้ remotes::install_github("dreamRs/capture")
library(leaflet.extras)
library(bsplus)
library(DT)
library(readxl)


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
  collapsed = TRUE,
  sidebarMenu(id="tabs", 
              menuItem(HTML("&ensp;Home"), tabName = "Home", icon = icon("house")),
              menuItem(HTML("&ensp;Upload Data"), tabName = "Upload_data", icon = icon("folder-open")),
              menuItem(HTML("&ensp;Map Distribution"), tabName = "Map_Distribution", icon = icon("map")),
              menuItem(HTML("&ensp;Spatial &amp; Spatio-Temporal <br/>&emsp; &ensp;Epidemiology Analysis"), tabName="Analysis", icon=icon("globe")),
              menuItem(HTML("&ensp;About Application"), tabName = "About", icon = icon("file")),
              menuItem(HTML("&ensp;Manual"), tabName = "Manual", icon = icon("book")),
              menuItem(HTML("&ensp;Help"), tabName = "Help", icon=icon("question")),
              menuItem(HTML("&ensp;Releases"), tabName = "Releases", icon=icon("tasks"))
              
  )
)


body <- dashboardBody(
  useShinyjs(),
  # เพิ่ม CSS เพื่อทำให้เมนูที่โดน Disable ดูเป็นสีเทาและกดไม่ได้
  tags$head(
    tags$style(HTML("
      /* สไตล์สำหรับเมนูที่ถูกล็อก */
      .shinyjs-disabled {
        cursor: not-allowed !important;
        opacity: 0.4 !important;
      }
      .shinyjs-disabled a {
        pointer-events: none !important;
      }
      
      /* ===== Tooltip แบบใหม่ที่แยกเฉพาะ ไม่ชนกับ .info-tooltip-container เดิม ===== */
      .mr-tip {
        position: relative;
        display: inline-block;
        margin-left: 6px;
        vertical-align: middle;
        cursor: help;
      }
      .mr-tip .mr-tip-icon {
        color: #999999;
        font-size: 14px;
      }
      .mr-tip .mr-tip-text {
        visibility: hidden;
        opacity: 0;
        display: block;
        position: absolute;
        top: 130%;
        left: 0;
        background: #2b2b2b;
        color: #ffffff;
        text-align: left;
        padding: 10px 12px;
        border-radius: 8px;
        font-size: 12.5px;
        font-weight: normal;
        line-height: 1.5;
        width: 260px;
        max-width: 260px;
        white-space: normal;
        word-wrap: break-word;
        z-index: 99999;
        box-shadow: 0 2px 8px rgba(0,0,0,0.25);
        transition: opacity 0.15s ease-in-out;
        pointer-events: none;
      }
      .mr-tip:hover .mr-tip-text {
        visibility: visible;
        opacity: 1;
      }
      
      /* ===== ทำให้ 2 คอลัมน์ในแถวเดียวกันสูงเท่ากันเสมอ (สำหรับ Upload Shapefile/CSV และ Association) ===== */
      .equal-height-row, .equal-height-row > .row {
        display: flex !important;
        flex-wrap: wrap !important;
      }
      .equal-height-row > [class*='col-'],
      .equal-height-row > .row > [class*='col-'] {
        display: flex !important;
        flex-direction: column !important;
      }
      

      .info-tooltip-container {
        position: relative !important;
        display: inline-block !important;
        margin-left: 6px !important;
        vertical-align: middle !important;
      }
      .info-tooltip-container .tooltip-text {
        display: block !important;
        visibility: hidden;
        opacity: 0;
        position: absolute !important;
        top: 135% !important;
        bottom: auto !important;
        left: 0 !important;
        right: auto !important;
        transform: none !important;
        background: #2b2b2b !important;
        color: #fff !important;
        padding: 10px 12px !important;
        border-radius: 8px !important;
        font-size: 12.5px !important;
        font-weight: normal !important;
        line-height: 1.5 !important;
        height: auto !important;
        min-height: 0 !important;
        max-height: none !important;
        overflow: visible !important;
        width: 280px !important;
        max-width: 280px !important;
        white-space: normal !important;
        word-wrap: break-word !important;
        z-index: 99999 !important;
        transition: opacity 0.15s ease-in-out;
        pointer-events: none;
        box-shadow: 0 2px 8px rgba(0,0,0,0.25);
      }
      .info-tooltip-container .tooltip-text::after {
        display: none !important;
      }
      .info-tooltip-container:hover .tooltip-text {
        visibility: visible;
        opacity: 1;
      }
    "))
  ),
  tags$script("document.title = 'STEHealth | Spatial & Spatio-Temporal Epidemiological Analysis'"),
  tags$head(tags$link(rel="icon", 
                      href="STEHealth_logo_0.ico")
  ),
  
  tags$head(
    tags$meta(charset="utf-8"),
    tags$link(rel="stylesheet" ,href="https://unicons.iconscout.com/release/v4.0.8/css/line.css"), # UNICONS
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),   # import css file
    tags$script(src="js/index.js"), # เป็นตัวช่วยในการลิงก์ tag a ไปยัง tap อื่นม ๆ
    # สคริปต์สร้าง Tooltip ด้วยตัวเองเมื่อเอาเมาส์ชี้เมนูสีเทา
    tags$script(HTML("
      $(document).on('mouseenter', 'a.locked-menu', function() {
        // แก้ไขข้อความเป็นภาษาอังกฤษที่นี่
        var tooltip = $('<div class=\"custom-locked-tooltip\">Please upload data first</div>');
        
        $('body').append(tooltip);
        var offset = $(this).offset();
        tooltip.css({
            top: offset.top + 8 + 'px',
            left: '235px', 
            position: 'absolute',
            zIndex: 999999,
            backgroundColor: '#333333',
            color: '#ffffff',
            padding: '6px 12px',
            borderRadius: '4px',
            fontSize: '14px',
            pointerEvents: 'none'
        });
      }).on('mouseleave', 'a.locked-menu', function() {
        $('.custom-locked-tooltip').remove();
      });
    ")),
    
    tags$style(HTML("
      #divide_by {
        position: absolute;
        top: 10px;
        right: 10px;
        z-index: 9999;
      }
      
    "))
    
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
                            Spatial &amp; Spatio-Temporal<br>Epidemiological Analysis
                        </h1>
                        <p class="home__caption"  style = "text-align: justify;">
                            An advanced analytical platform designed for exploring 
                            spatiotemporal patterns and identifying risk factor associations 
                            for health outcomes. Empowers researchers to import custom datasets 
                            for integrated statistical analysis and high-resolution visualization.
                        </p>
                      
                      <div class="button">
                        
                        <!-- ปรับขนาดปุ่ม Get Started: เพิ่ม font-size และ padding -->
                        <a class="btn btn-primary" 
                                 onclick="$(\'.sidebar-menu a[data-value=Upload_data]\').click();" 
                                 role="button"
                                 style = "border-color: #735DFB; cursor: pointer; font-size: 16px; padding: 12px 30px; margin-right: 10px;" >
                           <strong>Get Started <i class="uil uil-angle-right-b"></i></strong> 
                        </a>
                        
                        <!-- ปรับขนาดปุ่ม How to use?: เพิ่ม font-size และ padding -->
                        <a class="btn btn-outline-primary"
                                 onclick="$(\'.sidebar-menu a[data-value=Manual]\').click();"
                                 role="button"
                                 style="cursor: pointer; font-size: 16px; padding: 12px 30px;"
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
              
              tags$script(HTML("
                $(document).on('click', '.btn-file', function() {
                  var currentScroll = $(window).scrollTop();
                  setTimeout(function() {
                    $(window).scrollTop(currentScroll);
                  }, 10);
                });
              ")),
              
              fluidPage(
                
                # ==================== STEP 1: Data Source ====================
                fluidRow(class = "box-white",
                         column(12,
                                # Section Header
                                div(class = "section-header",
                                    # div(class = "section-number", "1"),
                                    HTML('<h3><span class="purple">1.</span></h3>'),
                                    div(
                                      h3(class = "section-title-text", 
                                         tags$i(class = "uil uil-database", style = "color:#735DFB; margin-right:6px;"),
                                         "Data Source"),
                                      p(class = "section-subtitle", "Choose how you want to provide data for analysis")
                                    )
                                ),
                                div(class = "section-divider"),
                                
                                # Card selector (ส่วนนี้ใช้ HTML cards แต่ยังผูกกับ input$data_source_type เดิม)
                                div(class = "source-card-group",
                                    
                                    # Card: Upload own files
                                    tags$div(
                                      class = "source-card",
                                      id = "card_upload",
                                      onclick = "
                                  $('#data_source_type input[value=upload]').prop('checked', true).trigger('change');
                                  $('.source-card').removeClass('selected');
                                  $('#card_upload').addClass('selected');
                                  Shiny.setInputValue('source_confirmed', true, {priority: 'event'});
                                ",
                                      div(class = "check-badge", HTML("&#10003;")),
                                      tags$span(class = "card-icon", HTML("&#128193;")),
                                      div(class = "card-title", "Upload Your Own Files"),
                                      div(class = "card-desc", "Upload a shapefile (.shp, .dbf, .shx, .prj) and a CSV file with your own data.")
                                    ),
                                    
                                    # Card: Sample data
                                    tags$div(
                                      class = "source-card",
                                      id = "card_sample",
                                      onclick = "
                                  $('#data_source_type input[value=sample]').prop('checked', true).trigger('change');
                                  $('.source-card').removeClass('selected');
                                  $('#card_sample').addClass('selected');
                                  Shiny.setInputValue('source_confirmed', true, {priority: 'event'});
                                ",
                                      div(class = "check-badge", HTML("&#10003;")),
                                      tags$span(class = "card-icon", HTML("&#128161;")),
                                      div(class = "card-title", "Use Sample Data"),
                                      div(class = "card-desc", "3 ready-to-use sample datasets are available - pick one from the dropdown below."),
                                      
                                      # CSS สำหรับ badge เล็กๆ ใน dropdown (Spatial / Spatial-Temporal)
                                      tags$style(HTML("
                                        .sample-badge {
                                          display: inline-block; padding: 2px 10px; border-radius: 10px;
                                          font-size: 11px; font-weight: 600; margin-left: 10px; vertical-align: middle;
                                          white-space: nowrap;
                                        }
                                        .badge-st { background: #e6f4ea; color: #1e7e34; border: 1px solid #1e7e34; }
                                        .badge-s  { background: #fff4e5; color: #b25400; border: 1px solid #b25400; }
                                        
                                        /* ตัวกล่องที่แสดงค่าที่เลือกอยู่ (.selectize-input) ไม่ได้ถูกย้ายไปที่ <body> เหมือน
                                           dropdown list เลย CSS ปกติ scope ผ่านนี้ได้ - ใช้ปิด search <input> ที่ selectize
                                           แทรกไว้ต่อจาก item ของเรา ไม่งั้นพอ item กว้าง 100% แล้ว input จะถูกดันลงบรรทัดใหม่
                                           ทำให้เห็นเป็นเคอร์เซอร์กระพริบบรรทัดที่ 2 เวลาเปิด dropdown */
                                        #sample_dataset_choice + .selectize-control .selectize-input > input {
                                          position: absolute !important;
                                          width: 1px !important;
                                          height: 1px !important;
                                          padding: 0 !important;
                                          margin: 0 !important;
                                          opacity: 0;
                                        }
                                      ")),
                                      
                                      # Sample data: dropdown เลือกชุดข้อมูลตัวอย่าง (มี 3 ชุดให้เลือก) -
                                      # วางไว้ในการ์ด "Use Sample Data" เอง ไม่ให้หลุดไปอยู่ฝั่ง Upload
                                      conditionalPanel(
                                        condition = "input.data_source_type == 'sample'",
                                        div(
                                          # กัน click ที่ dropdown ไม่ให้ไปเด้ง onclick ของการ์ดซ้ำ
                                          onclick = "event.stopPropagation();",
                                          style = "margin-top: 14px; text-align: left;",
                                          selectizeInput("sample_dataset_choice",
                                                         label = "Choose a sample dataset:",
                                                         choices = c(
                                                           "Thailand Suicide Mortality 2011–2021 (77 provinces)" = "thailand",
                                                           "Pollution & Health Data, 2007–2011 (CARBayesST)" = "pollution",
                                                           "Pollution & Health Data, 2007 Only (CARBayesST)" = "pollution_2007"
                                                         ),
                                                         selected = "thailand", width = "100%",
                                                         # หมายเหตุ: Shiny เมาท์ dropdown ของ selectize ไว้ที่ <body> ไม่ใช่ในตัว
                                                         # .selectize-control เอง ทำให้ CSS ที่ scope ผ่าน DOM nesting ใช้ไม่ได้
                                                         # -> ใส่ inline style ลงใน HTML ที่ return จาก render function โดยตรงแทน
                                                         # ซึ่งจะทำงานได้แน่นอนไม่ว่า dropdown จะถูกเมาท์ไว้ที่ไหนก็ตาม
                                                         options = list(render = I("{
                                                        option: function(item, escape) {
                                                          var meta = {
                                                            thailand: {badge:'Spatial-Temporal', cls:'badge-st'},
                                                            pollution: {badge:'Spatial-Temporal', cls:'badge-st'},
                                                            pollution_2007: {badge:'Spatial', cls:'badge-s'}
                                                          };
                                                          var m = meta[item.value] || {badge:'', cls:''};
                                                          var b = m.badge ? (`<span class=\"sample-badge ${m.cls}\">${m.badge}</span>`) : '';
                                                          return `<div style=\"display:flex; align-items:center; justify-content:space-between;
                                                                              width:100%; padding:6px 10px; line-height:1.4;
                                                                              box-sizing:border-box; white-space:normal;\">
                                                                    <span>${escape(item.label)}</span>${b}
                                                                  </div>`;
                                                        },
                                                        item: function(item, escape) {
                                                          var meta = {
                                                            thailand: {badge:'Spatial-Temporal', cls:'badge-st'},
                                                            pollution: {badge:'Spatial-Temporal', cls:'badge-st'},
                                                            pollution_2007: {badge:'Spatial only', cls:'badge-s'}
                                                          };
                                                          var m = meta[item.value] || {badge:'', cls:''};
                                                          var b = m.badge ? (`<span class=\"sample-badge ${m.cls}\">${m.badge}</span>`) : '';
                                                          return `<div style=\"display:flex; align-items:center; justify-content:space-between;
                                                                              width:100%; padding-right:22px; box-sizing:border-box;\">
                                                                    <span>${escape(item.label)}</span>${b}
                                                                  </div>`;
                                                        }
                                                      }"))
                                          ),
                                          # คำอธิบาย coverage (Spatial / Spatial-Temporal) ของ dataset ที่เลือกอยู่ - อัปเดตอัตโนมัติ
                                          uiOutput("sample_dataset_info"),
                                          div(class = "info-note",
                                              HTML("<i class='uil uil-info-circle'></i> <strong>Sample data loaded.</strong> Columns will be auto-filled below. You can proceed directly to <em>Next</em>.")
                                          ),
                                          br(),
                                          actionButton("view_data_dictionary", class = "btn btn-outline-primary2",
                                                       icon = icon("table"), label = "View Data Dictionary"),
                                          downloadButton("download_sample_csv", class = "btn btn-outline-primary2",
                                                         label = "Download sample data (.csv)",
                                                         style = "margin-left: 8px;")
                                        )
                                      )
                                    )
                                ),
                                
                                # radio button ซ่อนไว้ (ยังทำงานอยู่เบื้องหลัง)
                                div(style = "display:none;",
                                    radioButtons("data_source_type", "",
                                                 choices = c("Upload your own files" = "upload",
                                                             "Use Sample Data" = "sample"),
                                                 selected = "upload", inline = TRUE)
                                )
                         )
                ), # end Data Source row
                
                conditionalPanel(
                  condition = "input.source_confirmed",
                  # ==================================== STEP 2: Shapefile ==================================== 
                  fluidRow( class='box-white equal-height-row',
                            column(4, class='box-white',
                                   
                                   # 1. เพิ่ม div ครอบตรงนี้ และตั้ง position: relative เพื่อเป็นจุดอ้างอิง
                                   div(style = "position: relative;", 
                                       div(class = "section-header",
                                           # div(class = "section-number", "1"),
                                           HTML('<h3><span class="purple">2.</span></h3>'),
                                           div(
                                             h3(class = "section-title-text", 
                                                tags$i(class = "uil uil-map-marker", style = "color:#735DFB; margin-right:6px;"),
                                                "Upload Shapefile")
                                             # p(class = "section-subtitle", "Upload all 4 components together")
                                           )
                                       ),
                                       
                                       # 2. เปลี่ยนสไตล์ตรงนี้เป็น position: absolute ชิดขวา (right: 0px)
                                       # สามารถปรับค่า top (บน) หรือ right (ขวา)
                                       div(style = "position: absolute; right: 0px; top: 15px;",
                                           
                                           # 1. ใช้ actionButton แทน bsButton และใส่ CSS บังคับทรงกลม กว้างยาวเท่ากัน
                                           actionButton("question_shapefile", label = icon("question"), 
                                                        style = "border-radius: 50% !important; width: 32px; height: 32px; padding: 0; display: inline-flex; align-items: center; justify-content: center; background-color: #735DFB; color: white; border: none;"),
                                           
                                           bsPopover(id = "question_shapefile", title = "Shapefile", 
                                                     content = paste0(strong("What is a shapefile? "),br(),
                                                                      "A shapefile is a simple, nontopological format for storing the geometric location and attribute information of geographic features. ",
                                                                      a("[Reference]",
                                                                        href = "https://desktop.arcgis.com/en/arcmap/latest/manage-data/shapefiles/what-is-a-shapefile.htm",
                                                                        target="_blank")
                                                     ),
                                                     placement = "right", trigger = "click", options = list(container = "body")
                                           )
                                       )
                                   ), # จบ div(position: relative)
                                   
                                   hr(),
                                   HTML("<strong><font color= \"#735DFB\">Upload 4 shapefile components at once:</font></strong> shp, dbf, shx and prj."),
                                   fileInput("filemap", "", accept=c('.shp','.dbf','.sbn','.sbx','.shx',".prj"), multiple=TRUE),
                                   
                                   helpText("Select the column that matches the area id in the CSV file (e.g. a unique code such as IZ). Do NOT use a descriptive name column here if it contains duplicate values."),
                                   fluidRow(
                                     column(12, selectInput("columnidareainmap",   
                                                            label = HTML('area id <div class="info-tooltip-container"><i class="fa fa-info" style="cursor:help;"></i><span class="tooltip-text">This column is used to match each shapefile polygon to a row in the CSV. It must contain a value that uniquely identifies each area (e.g. an area code like "IZ"), matched against the "area id" column selected on the data page. Do not use a descriptive name column here if names can repeat.</span></div>'),   
                                                            choices = c(""), selected = "")
                                     )),
                                   
                                   HTML("</br>"),
                                   
                                   radioButtons("shapefile_from_thailand", 
                                                "Does this shapefile represent Thailand's provincial boundaries (Admin Level 1) including all 77 provinces?", 
                                                inline=TRUE, c("Yes" = "yes", "No" = "no"), 
                                                selected="no")
                                   
                            ), # จบ column(4)
                            
                            column(7, 
                                   # เพิ่ม min-height ป้องกันหน้าเว็บเด้งตอนเปลี่ยนสถานะ
                                   div(style = "min-height: 500px; padding: 20px; border-radius: 10px;",
                                       HTML("<h3 style='margin-top: 0;'><i class='uil uil-map' style='color: #735DFB;'></i> Preview Shapefile</h3>"),
                                       
                                       uiOutput('status_map'),  
                                       
                                       # ซ่อนกรอบตารางไว้ จนกว่าผู้ใช้จะอัปโหลดไฟล์
                                       conditionalPanel(
                                         condition = "output.filemap_uploaded",
                                         
                                         # กรอบแผนที่ ให้เห็นหน้าตาของพื้นที่ในชั้นข้อมูล sf ทันทีที่อัปโหลด
                                         div(style = "background: #ffffff; padding: 15px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); margin-bottom: 20px; border-left: 4px solid #03989e;",
                                             HTML("<h4 style='margin-top: 0; color: #333;'><i class='uil uil-location-point'></i> Shapefile Boundary Preview</h4>"),
                                             plotOutput("uploadmapmap", height = "300px")
                                         ),
                                         
                                         # กรอบ Data Table
                                         div(style = "background: #ffffff; padding: 15px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); margin-bottom: 20px; border-left: 4px solid #735DFB;",
                                             HTML("<h4 style='margin-top: 0; color: #333;'><i class='uil uil-table'></i> Shapefile Table</h4>"),
                                             DTOutput('uploadmaptable')
                                         ),
                                         
                                         # กรอบ Data Summary
                                         div(style = "background: #ffffff; padding: 15px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); border-left: 4px solid #03989e;",
                                             HTML("<h4 style='margin-top: 0; color: #333;'><i class='uil uil-analytics'></i> Shapefile Summary</h4>"),
                                             tableOutput("uploadmapsummary")
                                         )
                                       )
                                   )
                            ) # จบ column(7) ของ Shapefile
                            
                  ), # จบ fluidRow
                  
                  # ==================================== STEP 3: Upload Data file ==================================== 
                  fluidRow( class='box-white equal-height-row',
                            column(4, class='box-white',
                                   
                                   # 1. เปลี่ยนตรงนี้เป็น position: relative; เพื่อใช้เป็นกรอบอ้างอิง
                                   div(style = "position: relative;",
                                       div(class = "section-header",
                                           # div(class = "section-number", "1"),
                                           HTML('<h3><span class="purple">3.</span></h3>'),
                                           div(
                                             h3(class = "section-title-text", 
                                                tags$i(class = "uil uil-clipboard-notes", style = "color:#735DFB; margin-right:6px;"),
                                                "Upload CSV Data File")
                                             # p(class = "section-subtitle", "Upload all 4 components together")
                                           )
                                       )
                                   ), # จบ div(position: relative)
                                   
                                   hr(),
                                   HTML("CSV or Excel (.xlsx/.xls) file needs to have columns:<strong><font color= \"#735DFB\"> area id, area name, time point, cases, population</font></strong>"),
                                   fileInput("file1", "", accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv", ".xlsx", ".xls")),
                                   
                                   helpText("Select columns:"),
                                   
                                   # area id (unique code, e.g. IZ) and area name (display label) on the same row
                                   fluidRow(
                                     column(6, selectInput("columnidareaindata", 
                                                           label = HTML('area id <div class="info-tooltip-container"><i class="fa fa-info" style="cursor:help;"></i><span class="tooltip-text">A column with a UNIQUE code for each area (e.g. "IZ"). This is used to match rows to the shapefile ("area id" selected on the Upload Shapefile page) and to run the statistical model. Do not select a descriptive name column here if its values can repeat.</span></div>'), 
                                                           choices = c(""), selected = "")
                                     ),
                                     column(6, selectInput("columnidareanamedata", 
                                                           label = HTML('area name <div class="info-tooltip-container"><i class="fa fa-info" style="cursor:help;"></i><span class="tooltip-text">A descriptive name for each area, shown as the label on the maps (e.g. in tooltips/popups). This can repeat across different areas - it is NOT used to match data, only to display text.</span></div>'), 
                                                           choices = c(""), selected = "")
                                     )
                                   ),
                                   
                                   fluidRow(
                                     column(6, selectInput("columnpopindata", 
                                                           label = HTML('population <div class="info-tooltip-container"><i class="fa fa-info" style="cursor:help;"></i><span class="tooltip-text">The raw population count for each area. Used to calculate the expected number of cases in every tab (Cluster Detection, Association with Risk Factors). If your data already has a pre-computed expected-cases column (e.g. the &quot;expected&quot; column in CARBayesST&#39;s pollutionhealthdata), leave this as population and instead answer &quot;Yes&quot; in section 3.1 below and select that column there.</span></div>'), 
                                                           choices = c(""), selected = "")
                                     ),
                                     column(6, selectInput("columncasesindata", 
                                                           label = HTML('cases <div class="info-tooltip-container"><i class="fa fa-info" style="cursor:help;"></i><span class="tooltip-text">number of cases or outcomes in each area.</span></div>'), 
                                                           choices = c(""), selected = "")
                                     )
                                   ),
                                   fluidRow(
                                     column(6, selectInput("columndateindata", 
                                                           label = HTML('time point <div class="info-tooltip-container"><i class="fa fa-info" style="cursor:help;"></i><span class="tooltip-text">time point in the data, such as day, month, year.</span></div>'), 
                                                           choices = c(""), selected = "")
                                     )
                                   ),
                                   
                                   # ===================== 3.1 Select Expected Value =====================
                                   HTML("<h4><strong>3.1 Expected Value</strong> <font color= \"#03989e\"> (Optional) </font></h4>"),
                                   
                                   radioButtons("Expected_Value_from_csv", "Does this CSV file have an expected value column?", 
                                                inline = TRUE, choices = c("Yes" = "yes", "No" = "no"), selected = "no"),
                                   
                                   conditionalPanel(
                                     condition = "input.Expected_Value_from_csv == 'yes'",
                                     helpText("Select column:"),
                                     fluidRow(
                                       column(12, selectInput("columnexpvalueindata", 
                                                              label = HTML('expected value <div class="info-tooltip-container"><i class="fa fa-info" style="cursor:help;"></i><span class="tooltip-text">The expected value is number of outcomes in the provided area and period which may vary due to the types of diseases.</span></div>'), 
                                                              choices = c(""), selected = "")
                                       )
                                     )
                                   ),
                                   
                                   conditionalPanel(
                                     condition = "input.Expected_Value_from_csv == 'no'",
                                     # div(style = "margin-bottom: 15px;",
                                     #     HTML("<font color=\"#735DFB\"><strong>Note that: </strong></font>
                                     #          If the CSV file lacks an expected value column, the calculation will use the 'cases' and 'population' columns to derive an expected value. For details on how the expected value is calculated, please refer to the "),
                                     #     tags$a("Help page.", onclick="customHref('Help')", class = "cursor_point")
                                     # )
                                     div(class = "info-note",
                                         HTML("<strong>Note:</strong> If no expected value column is provided, 
                                          it will be calculated automatically from <em>cases</em> and <em>population</em>. 
                                          See the "),
                                         tags$a("Help page", onclick = "customHref('Help')", class = "cursor_point"),
                                         HTML(" for details.")
                                     )
                                   ),
                                   # ==========================================================
                                   
                                   HTML("</br><h4><strong>3.2 Covariates</strong> <font color= \"#03989e\"> (Optional) </font></h4>"),
                                   # HTML("Please arrange the covariates in order from 1 to 7, 
                                   #       ensuring that all positions are filled consecutively without any skipped numbers. 
                                   #       This sequential ordering is essential for the model to correctly interpret each covariate’s priority 
                                   #       or influence in the analysis."),
                                   
                                   
                                   div(class = "cov-hint",
                                       HTML("<i class='uil uil-info-circle'></i> 
                                        Assign covariates <strong>in order from 1 onwards</strong>, 
                                        without skipping any numbers. 
                                        Leave unused slots as <strong>–</strong>.")
                                   ),
                                   
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
                                   
                                   fluidRow(column(6, selectInput("columncov7indata", label = "covariate 7", choices = c(""), selected = ""))
                                   )
                                   
                            ), # จบ column(4) ของ Row 2
                            
                            column(7, 
                                   # เพิ่ม min-height ป้องกันหน้าเว็บเด้งตอนเปลี่ยนสถานะ
                                   div(style = "min-height: 600px; padding: 20px;  border-radius: 10px;",
                                       HTML("<h3 style='margin-top: 0;'><i class='uil uil-clipboard-notes' style='color: #735DFB;'></i> Preview Data</h3>"),
                                       
                                       uiOutput('status_csv'),  
                                       
                                       # ซ่อนกรอบตารางไว้ จนกว่าผู้ใช้จะอัปโหลดไฟล์
                                       conditionalPanel(
                                         condition = "output.file1_uploaded",
                                         
                                         # กรอบ Data Table
                                         div(style = "background: #ffffff; padding: 15px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); margin-bottom: 20px; border-left: 4px solid #735DFB;",
                                             HTML("<h4 style='margin-top: 0; color: #333;'><i class='uil uil-table'></i> Data Table</h4>"),
                                             DTOutput('uploaddatatable')
                                         ),
                                         
                                         # กรอบ Data Summary
                                         div(style = "background: #ffffff; padding: 15px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); border-left: 4px solid #03989e;",
                                             HTML("<h4 style='margin-top: 0; color: #333;'><i class='uil uil-analytics'></i> Data Summary</h4>"),
                                             tableOutput("uploaddatasummary")
                                         )
                                       )
                                   )
                            ) # จบ column(7) ของ CSV
                  ), # จบ fluidRow
                ), # end conditionalPanel: STEP 2 + STEP 3 (only show after Data Source is chosen)
                
                # ==================================== Note ==================================== 
                # fluidRow(
                #   class='box-white',
                #   HTML("<font color= \"#735DFB\"><strong>Note: </strong></font>
                #       Please ensure that the uploaded shapefile matches the data file, with consistent area names or codes to align the spatial map with the associated data. Mismatched files may lead to errors in visualization and analysis
                #       </br>")
                # ),
                # 
                fluidRow(class = "box-white",
                         column(12,
                                div(class = "info-note",
                                    HTML("<i class='uil uil-exclamation-triangle'></i>
                                    <strong>Important:</strong> 
                                    The shapefile and CSV file must use <strong>matching area names</strong>. 
                                    Mismatched names will cause errors in visualization and analysis.")
                                )
                         )
                ),
                
                # ==================================== Buttons ==================================== 
                fluidRow(
                  column(2, offset = 8,
                         actionButton("reload_btn",
                                      label = tagList(icon("refresh"), "Refresh Data"),
                                      class = "btn-outline-primary",
                                      style = "width:90%; height:50px; font-size:18px;",
                                      onclick = "location.reload();")
                  ),
                  column(2,
                         
                         # ปุ่มที่ 1: ปุ่มหลอกสีเทา พร้อม CSS Tooltip ที่เราเพิ่งสร้าง
                         tags$div(id = "btn_disabled_wrapper", class = "my-custom-tooltip",
                                  actionButton("dummy_btn", 
                                               label = tagList("Next", icon("angle-right")), 
                                               class = "btn-primary", 
                                               style = "width:100%; height:50px; font-size:18px; opacity: 0.5; pointer-events: none;"),
                                  tags$span(class = "tooltiptext", "⚠️ Please upload shapefile (map) and csv file first.")
                         ),
                         
                         # ปุ่มที่ 2: ปุ่มจริงสีสว่าง ซ่อนไว้ก่อน
                         shinyjs::hidden(
                           actionButton("Preview_Map_Distribution", 
                                        label = tagList("Next", icon("angle-right")), 
                                        class = "btn-primary", 
                                        style = "width:90%; height:50px; font-size:18px;")
                         )
                  )
                ),
                
                HTML("</br>")
              )
      ),
      
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
                                              The Map Distribution tab provides an interactive map displaying the spatial distribution of cases based on the shapefile 
                                              and case data uploaded on the Upload Data page. 
                                              This map uses the designated <strong>case column</strong> to plot the data, allowing users to visualize case distributions across regions. 
                                              Users can customize the display by selecting filters such as time points and color schemes to enhance data interpretation.
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
                                 
                               )
                        )
                      )
                      
                      
                    ),
                    
                    # mainPanel(uiOutput("status_map_dis"),
                    #           #leafletOutput("map_distribution", height = "70vh")
                    #           div(class = 'error',
                    #           verbatimTextOutput("messageCheckData_1")
                    #             ),
                    #           addSpinner(
                    #             leafletOutput("map_distribution", height = "75vh"),
                    #             spin = "bounce", color = "#735DFB")
                    #           
                    # )
                    
                    mainPanel(
                      # uiOutput("status_map_dis"),
                      div(class = 'error',
                          verbatimTextOutput("messageCheckData_1")
                      ),
                      fluidRow(
                        column(
                          6,  # 50% of the width
                          HTML("<h4 style = 'text-align: center;'>Y Value Distribution Map</h4>"),
                          div(
                            class = "box-white",
                            uiOutput("mapDisError"),
                            addSpinner(
                              leafletOutput("map_distribution", height = "70vh"),  # แผนที่แรก
                              spin = "bounce", color = "#735DFB"
                            )
                          )
                        ),
                        column(
                          6,  
                          HTML("<h4 style = 'text-align: center;'>Normalized Y Value Distribution Map</h4>"),
                          div(
                            class = "box-white",
                            absolutePanel(
                              top = 10, right = 10, width = 200, draggable = TRUE,
                              class = "bg-white",
                              selectInput("divide_by", "Divide by:",
                                          choices = list("Population" = "columnpopindata",
                                                         "Expected Value" = "expected_value"), 
                                          selected = "columnpopindata")
                            ),
                            uiOutput("mapDisError_2"),
                            addSpinner(
                              leafletOutput("map_distribution_2", height = "70vh"),  # แผนที่ที่สอง
                              spin = "bounce", color = "#735DFB"
                            )
                          )
                        )
                      ), 
                      HTML('<p class = "mapNote"> 
                              If the map on this page takes more than 2-3 minutes to load, please check the uploaded data again.
          
                           </p>')
                    )
                    
                    
                    
                  )),
              fluidRow(
                column(2, offset = 10,
                       
                       actionButton("nextpage", 
                                    label = tagList("Next", icon("angle-right")), 
                                    onclick = "$('.sidebar-menu a[data-value=Analysis]').click();",
                                    class = "btn-primary", 
                                    style = "width:90%; height:50px; font-size:18px;")
                )
              )
              
      ),
      
      # ==================================== Analysis ==================================== 
      
      tabItem(
        tabName = "Analysis",
        HTML("
                  <div class = 'heading_container'>
                     <h1>Spatial &amp; Spatio-Temporal Epidemiological Analysis</h1>
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
                                       HTML("The Cluster Detection tab presents a cluster map of the data, 
                                            highlighting <strong>hotspots</strong> and <strong>non-hotspots</strong>. Users can adjust the visualization by selecting filters such as 
                                            time points and color schemes to better interpret clustering patterns
                                            For further information on the underlying models, please refer to the "),
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
                                                     The data obtained from the cluster detection consists of the original data and the <strong>hotspot label column</strong>, 
                                                     which in the hotspot label column will consist of hotspot and non-hotspot. 
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
                            uiOutput("clusterError"),
                            uiOutput("status_cluster"),
                            div(class = 'error',
                                verbatimTextOutput("messageCheckData_2")
                            ),
                            
                            
                            # div(
                            #   class = "box-white",
                            #   HTML('<h4 style="display:inline-block; margin-right:6px;">Cluster Detection Results</h4>'),
                            #   HTML('<p style="margin-top:8px; margin-bottom:8px; font-size:13px; color:#666;">Number of area/time observations classified as a hotspot (posterior probability of risk &gt; 1 exceeds 95%), out of the total number of observations, and how many distinct areas were flagged as a hotspot at least once.</p>'),
                            #   DTOutput("cluster_summary_table")
                            # ),
                            
                            
                            #verbatimTextOutput("status_map_cluster"),
                            #leafletOutput("map_cluster", height = "70vh")
                            uiOutput("runtime_card_cluster"),
                            uiOutput("map_cluster_title"),
                            addSpinner(
                              leafletOutput("map_cluster", height = "80vh"),
                              spin = "bounce", color = "#735DFB"
                            ),
                            HTML('<p class = "mapNote"> 
                              If the map on this page takes more than 5 minutes to load, please check the uploaded data again.
          
                           </p>')
                            
                            
                          )
                          
                          
                        )
               ),
               
               # ==================================== Association with Risk Factors ==================================== 
               # sidebarLayout(
               #   
               #   sidebarPanel(
               # mainPanel
               tabPanel(HTML("<h4>Association with Risk Factors</h4>"),
                        div(class = "equal-height-row",
                            sidebarLayout(
                              sidebarPanel(
                                           fluidRow(
                                             column(12,
                                                    div(
                                                      class = "box-white",
                                                      HTML("
                                            <img align='left' width='52px' height='52px' src='risk.png' style='margin-top: 10px; margin-right: 10px' >
                                            <h4>Association with Risk Factors</h4>
                                            
                                             
                                             This tab displays the association between risk factors and case outcomes, 
                                             showing the <strong>relative risk (RR)</strong> and significance of each risk factor by area. 
                                             Users can adjust the view using filters for specific risk factors and color schemes. 
                                             For more information on the model and interpretation of values, please refer to the 
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
                                            This presents detailed data from the risk factor association analysis, including area names, 
                                            the calculated percentage increase for each risk factor, along with lower and upper bounds, 
                                            and the significance status of each factor. 
                                            Users can choose to display additional details such as the lower bound, upper bound, and significance indicators.                                           </p>
                                                  
                                                  "),
                                                      
                                                      checkboxGroupInput('asso_select_column', 'Column', inline=TRUE, 
                                                                         c("lower bound %95" = "lowerbound", 'upper bound' = 'upperbound', 'significance' = 'significance'),
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
                                uiOutput("assocError"),
                                uiOutput("status_risk_fac"),
                                div(class = 'error',
                                    verbatimTextOutput("messageCheckData_3")
                                ),  
                                #verbatimTextOutput("status_map_asso"),
                                div(class = 'warning',
                                    verbatimTextOutput("status_risk_fac_nocova")
                                ),
                                div(
                                  class = "box-white rr-model-results",
                                  tags$style(HTML('
                                .rr-model-results .nav-tabs > li {
                                  margin-right: 14px;
                                }
                              ')),
                                  HTML('<h4 style="display:inline-block; margin-right:6px;">Model Results</h4>'),
                                  uiOutput("model_type_badge", inline = TRUE),
                                  uiOutput("runtime_card_asso"),
                                  # ==================================================================
                                  # เอาแท็บ Overall RR ออกแล้ว (ไม่ใช้ tabsetPanel อีกต่อไป เพราะเหลือแท็บเดียว)
                                  # เอาตารางออกมาแสดงตรงๆ พร้อมหัวข้อ <h5> สไตล์เดียวกับ "Area-level Significance"
                                  # ดึงค่าจาก model_fixed (โมเดลที่ 2 - fixed effect) ไม่ใช่ model เดิม (random slope รายพื้นที่)
                                  # NOTE: ยังรอยืนยันกับอาจารย์เรื่องว่าจะตัด BYM/RW1/province_int ออกจาก
                                  # formula_fixed_only ด้วยหรือไม่ (ดู TODO ใน server logic ของแต่ละ branch)
                                  #
                                  # Model Fit / Hyperparameters: ปิดไว้ก่อน (comment ออก) ตามที่ตกลงกันไว้
                                  # ต้องการเปิดใหม่ในอนาคต ให้เขียน tabPanel/tabsetPanel กลับมาใหม่
                                  # ==================================================================
                                  HTML('<h5 style="margin-top:8px; margin-bottom:2px;">Overall RR <span class="mr-tip"><i class="fa fa-info mr-tip-icon"></i><span class="mr-tip-text">Overall (region-wide) relative risk for each risk factor, estimated using a fixed-effect model (a single effect shared across the whole study region). This is a separate model from the area-by-area map below, which uses a random-slope model that lets the effect vary by area \u2014 a risk factor can therefore be significant overall while showing few or no significant areas on the map, or vice versa.</span></span></h5>'),
                                  uiOutput("overall_rr_model_line"),
                                  tableOutput("overall_rr_table"),
                                  
                                  # ตารางใหม่แบบง่าย: covariate ไหน significant กี่พื้นที่จากทั้งหมด
                                  HTML('<h5 style="margin-top:20px; margin-bottom:2px;">Area-level Significance <span style="font-weight:400; font-size:13px; color:#666;">\u2014 random-slope model (per-area estimate)</span></h5>'),
                                  HTML('<p style="margin-top:8px; margin-bottom:8px; font-size:13px; color:#666;">Number of areas where each risk factor shows a statistically significant local deviation, out of the total number of areas.</p>'),
                                  DTOutput("significance_summary_table")
                                ),
                                # ชื่อแผนที่ + คำอธิบายกรอบดำ (significant areas) - ก่อนหน้านี้แผนที่ไม่มีชื่อ/คำอธิบายเลย
                                uiOutput("map_risk_fac_title"),
                                HTML('<p style="margin:4px 0 10px 0; font-size:13px; color:#555;">
                                  <span style="display:inline-block; width:22px; height:0; border-top:4px solid black; vertical-align:middle; margin-right:6px;"></span>
                                  Thick black outline = <strong>significant</strong> area (the local deviation for this risk factor differs from zero at the 95% level)
                                  &emsp;
                                  <span style="display:inline-block; width:22px; height:0; border-top:1px solid grey; vertical-align:middle; margin-right:6px;"></span>
                                  Thin grey outline = not significant
                                </p>'),
                                addSpinner(
                                  leafletOutput("map_risk_fac", height = "80vh"),
                                  spin = "bounce", color = "#735DFB"
                                ),
                                HTML('<p class = "mapNote"> 
                              If the map on this page takes more than 5 minutes to load, please check the uploaded data again.
          
                           </p>')
                                
                                
                              )
                              
                              
                            )
                        ) # end div.equal-height-row (Association tab)
                        
                        
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
              includeMarkdown("releases.md")
      ) 
    )
  ))     



shinyApp(
  ui <-  dashboardPage(skin = "purple",
                       options = list(sidebarExpandOnHover = TRUE),
                       header,
                       sidebar,
                       body
  ),
  
  
  
  ###############################################################
  #  
  #                             server
  #
  ###############################################################
  
  server <- function(input, output, session) { 
    
    # ====================================
    # ดึง fixed effect (ภาพรวมทั้ง region) จากโมเดล INLA มาแปลงเป็น Relative Risk
    # เทียบได้กับตาราง RR.summary ในเปเปอร์ CARBayesST (Section 5.3)
    # ====================================
    # ====================================
    # ตรวจสอบว่า area id ใน Shapefile กับ CSV Data ตรงกันกี่พื้นที่ ก่อนไปหน้า Map Distribution / Analysis
    # ====================================
    # ====================================
    # สรุปว่า covariate แต่ละตัว significant กี่พื้นที่ จากทั้งหมดกี่พื้นที่ (แบบง่าย ไม่ต้อง fixed effect)
    # ====================================
    compute_significance_summary <- function(association_wsf_df) {
      if (is.null(association_wsf_df)) return(NULL)
      df <- tryCatch(sf::st_drop_geometry(association_wsf_df), error = function(e) as.data.frame(association_wsf_df))
      
      sig_cols <- grep("_significance$", names(df), value = TRUE)
      if (length(sig_cols) == 0) return(NULL)
      
      total_areas <- nrow(df)
      n_sig <- vapply(sig_cols, function(cl) sum(df[[cl]] == "significant", na.rm = TRUE), integer(1))
      
      out <- data.frame(
        `Risk factor`        = sub("_significance$", "", sig_cols),
        `Significant areas`  = as.integer(n_sig),
        `Total areas`        = as.integer(total_areas),
        `% significant`      = round(n_sig / total_areas * 100, 1),
        check.names = FALSE,
        stringsAsFactors = FALSE
      )
      # เรียงจาก risk factor ที่ significant มากที่สุดไปน้อยที่สุด ให้เห็นตัวสำคัญก่อนทันที
      out <- out[order(-out$`% significant`), ]
      rownames(out) <- NULL
      out
    }
    
    # ====================================
    # สรุปผล Cluster Detection: hotspot กี่ area-time / กี่พื้นที่ จากทั้งหมด
    # ====================================
    compute_cluster_summary <- function(data, area_id_col) {
      if (is.null(data) || !("hotspot label" %in% names(data)) || is.null(area_id_col) || !(area_id_col %in% names(data))) {
        return(NULL)
      }
      
      total_obs   <- nrow(data)
      n_hot_obs   <- sum(data[["hotspot label"]] == "hotspot", na.rm = TRUE)
      
      total_areas <- length(unique(data[[area_id_col]]))
      hot_areas   <- length(unique(data[[area_id_col]][data[["hotspot label"]] == "hotspot"]))
      
      data.frame(
        Metric = c("Area-time observations flagged as hotspot", "Distinct areas flagged as hotspot (at least once)"),
        Count  = c(n_hot_obs, hot_areas),
        Total  = c(total_obs, total_areas),
        `% of total` = round(c(n_hot_obs / total_obs, hot_areas / total_areas) * 100, 1),
        check.names = FALSE,
        stringsAsFactors = FALSE
      )
    }
    
    check_area_match <- function(map, data, map_id_col, data_id_col) {
      if (is.null(map) || is.null(data) || is.null(map_id_col) || is.null(data_id_col) ||
          map_id_col == "" || data_id_col == "" ||
          !(map_id_col %in% names(map)) || !(data_id_col %in% names(data))) {
        return(NULL)
      }
      map_ids  <- unique(trimws(as.character(map[[map_id_col]])))
      data_ids <- unique(trimws(as.character(data[[data_id_col]])))
      matched  <- intersect(map_ids, data_ids)
      
      list(
        n_map     = length(map_ids),
        n_data    = length(data_ids),
        n_matched = length(matched),
        pct_matched = if (length(data_ids) > 0) round(length(matched) / length(data_ids) * 100, 1) else 0,
        unmatched_data_ids = setdiff(data_ids, map_ids)
      )
    }
    
    # เรียกใช้ตรวจสอบ + แจ้งเตือน/บล็อกการไปหน้าถัดไป คืนค่า TRUE ถ้าโอเคให้ไปต่อได้, FALSE ถ้าต้องหยุด
    validate_shapefile_data_match <- function() {
      # Sample Data เป็นไฟล์ที่มาพร้อมแอปและตรวจสอบไว้แล้ว ไม่ต้องเช็คซ้ำ
      # (การเช็คนี้มีไว้สำหรับกรณีผู้ใช้อัปโหลดไฟล์เองเท่านั้น)
      if (input$data_source_type == "sample") return(TRUE)
      
      chk <- check_area_match(rv$map, rv$datosOriginal, input$columnidareainmap, input$columnidareaindata)
      if (is.null(chk)) return(TRUE)  # ยังไม่มีข้อมูลพอจะเช็ค ปล่อยผ่าน (จะถูกเช็ค null ที่อื่นอยู่แล้ว)
      
      if (chk$n_matched == 0) {
        showModal(modalDialog(
          title = "Shapefile and Data File Do Not Match",
          HTML(paste0(
            "<p>None of the area id values in your <b>shapefile</b> (", chk$n_map, " areas) match the area id values ",
            "in your <b>CSV/Excel data</b> (", chk$n_data, " areas).</p>",
            "<p>Please check that:</p>",
            "<ul><li>You selected the correct <b>area id</b> column on both the Upload Shapefile page and the Upload CSV Data File page</li>",
            "<li>The values are formatted the same way on both sides (e.g. same capitalisation, no extra spaces, same code system)</li></ul>"
          )),
          easyClose = TRUE, footer = modalButton("OK")
        ))
        return(FALSE)
      } else if (chk$pct_matched < 90) {
        showNotification(
          paste0("Warning: only ", chk$n_matched, " of ", chk$n_data, " areas (", chk$pct_matched,
                 "%) in your data were found in the shapefile. Some areas may be missing from the map or cause errors in the model. ",
                 "Please double check the 'area id' column selections if this is unexpected."),
          type = "warning", duration = 12
        )
        return(TRUE)
      }
      return(TRUE)
    }
    
    # ใช้ชื่อไฟล์ Data File ที่ผู้ใช้อัปโหลด (หรือชื่อ sample dataset ถ้าใช้ sample data) มาเป็นคำนำหน้า
    # ชื่อไฟล์ที่ดาวน์โหลดออกไป เช่น อัปโหลด "PollutionHealthData.csv" -> "PollutionHealthData_result-....csv"
    data_file_base_name <- function() {
      if (input$data_source_type == "sample") {
        switch(input$sample_dataset_choice,
               "thailand"       = "ThailandSuicideMortality",
               "pollution"      = "PollutionHealthData",
               "pollution_2007" = "PollutionHealthData2007",
               "SampleData")
      } else {
        req(input$file1)
        nm <- tools::file_path_sans_ext(input$file1$name)
        gsub("[^A-Za-z0-9_-]", "_", nm)  # กันชื่อไฟล์เดิมมีช่องว่าง/อักขระที่ใช้ในชื่อไฟล์ไม่ได้
      }
    }
    
    
    compute_overall_rr <- function(model, cov_names) {
      fx <- model$summary.fixed
      # ตัด "(Intercept)" ออก เอาไว้เฉพาะแถวของ covariate (x1, x2, ...)
      cov_rows <- rownames(fx)[rownames(fx) != "(Intercept)"]
      fx_cov <- fx[cov_rows, , drop = FALSE]
      
      out <- data.frame(
        covariate = if (!is.null(cov_names) && length(cov_names) == nrow(fx_cov)) cov_names else cov_rows,
        RR_mean   = exp(fx_cov[, "mean"]),
        RR_lower  = exp(fx_cov[, "0.025quant"]),
        RR_upper  = exp(fx_cov[, "0.975quant"]),
        stringsAsFactors = FALSE
      )
      
      # Significant = 95% CI ไม่คร่อมค่า 1 (RR = 1 คือไม่มีความสัมพันธ์)
      out$Significant <- ifelse(out$RR_lower > 1 | out$RR_upper < 1, "Yes", "No")
      
      # คำแปลผลสั้นๆ อ่านง่าย: % การเปลี่ยนแปลงความเสี่ยงต่อ 1 หน่วยที่เพิ่มขึ้นของตัวแปร (region-wide)
      # ใช้ทศนิยมแบบไดนามิก เพื่อไม่ให้ค่าที่เล็กมากๆ (เช่นข้อมูล Thailand suicide) ถูก round จนโชว์เป็น "-0.0%"
      pct_change <- (out$RR_mean - 1) * 100
      format_pct_change <- function(p, max_digits = 4) {
        if (p == 0) return("0.0")
        d <- 1
        while (d < max_digits && round(p, d) == 0) d <- d + 1
        sprintf(paste0("%.", d, "f"), p)
      }
      pct_str <- vapply(pct_change, format_pct_change, character(1))
      out$Interpretation <- ifelse(
        out$Significant == "Yes",
        ifelse(pct_change > 0,
               paste0("+", pct_str, "% risk per unit (significant)"),
               paste0(pct_str, "% risk per unit (significant)")),
        "No significant association (95% CI includes RR = 1)"
      )
      
      rownames(out) <- NULL
      out
    }
    
    # สรุปตัวชี้วัดความเหมาะสมของโมเดล (model fit) เทียบเคียงกับตาราง Results ในเปเปอร์ CARBayesST
    # (DIC, WAIC, effective no. of parameters, LMPL) รวมถึงค่า Intercept
    compute_model_fit_summary <- function(model) {
      intercept_mean <- tryCatch(model$summary.fixed["(Intercept)", "mean"], error = function(e) NA)
      lmpl_val <- tryCatch(sum(log(model$cpo$cpo), na.rm = TRUE), error = function(e) NA)
      
      data.frame(
        Metric = c("Intercept (RR)", "DIC", "WAIC", "Effective no. of parameters (pD)", "LMPL (sum log CPO)"),
        Value  = c(
          round(exp(intercept_mean), 3),
          round(model$dic$dic, 1),
          round(model$waic$waic, 1),
          round(model$dic$p.eff, 1),
          round(lmpl_val, 1)
        ),
        stringsAsFactors = FALSE
      )
    }
    
    # สรุป hyperparameter (ความแปรผันเชิงพื้นที่ / เวลา / ระหว่างจังหวัด) เทียบเคียงกับ tau2, rho ในเปเปอร์
    # และแปลงชื่อ parameter จากภายในของ INLA (เช่น "Precision for data|S|x1_id") ให้อ่านเข้าใจง่ายขึ้น
    rename_hyperpar_label <- function(raw_name, cov_names) {
      # กรณี "Precision for data|S|x{N}_id" -> ชื่อ covariate จริง (เช่น pm10 - พื้นที่)
      m <- regmatches_helper(raw_name, "^Precision for data\\|S\\|x([0-9]+)_id$")
      if (!is.null(m)) {
        n <- as.integer(m)
        cov_label <- if (!is.null(cov_names) && n <= length(cov_names)) cov_names[n] else paste0("covariate ", n)
        return(paste0(cov_label, " \u2013 area-level deviation (random slope)"))
      }
      
      if (grepl("^Precision for data\\[\\[area_id_col\\]\\] \\(iid component\\)$", raw_name)) {
        return("Area-level unstructured variation (IID)")
      }
      if (grepl("^Precision for data\\[\\[area_id_col\\]\\] \\(spatial component\\)$", raw_name)) {
        return("Area-level spatial autocorrelation (BYM / CAR)")
      }
      if (grepl("^Precision for data\\[, ?input\\|S\\|columndateindata\\]$", raw_name)) {
        return("Temporal autocorrelation (year-to-year, RW1)")
      }
      if (grepl("^Precision for province_int$", raw_name)) {
        return("Extra unstructured variation (unexplained)")
      }
      
      # ไม่ตรงกับ pattern ที่รู้จัก คืนชื่อเดิม
      raw_name
    }
    
    # helper เล็ก ๆ สำหรับดึงกลุ่ม regex กลุ่มแรก คืน NULL ถ้าไม่ match
    regmatches_helper <- function(x, pattern) {
      m <- regmatches(x, regexec(pattern, x))[[1]]
      if (length(m) < 2) return(NULL)
      m[2]
    }
    
    compute_hyperpar_summary <- function(model, cov_names = NULL) {
      hp <- model$summary.hyperpar
      if (is.null(hp) || nrow(hp) == 0) return(NULL)
      
      friendly_names <- vapply(rownames(hp), rename_hyperpar_label, character(1), cov_names = cov_names)
      
      out <- data.frame(
        Parameter = friendly_names,
        Mean      = round(hp[, "mean"], 4),
        `2.5%`    = round(hp[, "0.025quant"], 4),
        `97.5%`   = round(hp[, "0.975quant"], 4),
        check.names = FALSE,
        stringsAsFactors = FALSE
      )
      rownames(out) <- NULL
      out
    }
    
    # ====================================
    # ควบคุมการสลับปุ่ม Next
    # ====================================
    observe({
      is_ready <- !is.null(rv$map) && !is.null(rv$datosOriginal)
      
      if (is_ready) {
        # ข้อมูลครบ: ซ่อนปุ่มหลอก โชว์ปุ่มจริง
        shinyjs::hide("btn_disabled_wrapper")
        shinyjs::show("Preview_Map_Distribution")
      } else {
        # ข้อมูลไม่ครบ: โชว์ปุ่มหลอก ซ่อนปุ่มจริง
        shinyjs::show("btn_disabled_wrapper")
        shinyjs::hide("Preview_Map_Distribution")
      }
    })
    
    # ====================================
    # ควบคุมการล็อกเมนู Map Distribution และ Analysis
    # ====================================
    observe({
      target_tabs <- c("Map_Distribution", "Analysis")
      is_ready <- !is.null(rv$map) && !is.null(rv$datosOriginal)
      
      if (is_ready) {
        # ---- เมื่อข้อมูลพร้อม (ปลดล็อก) ----
        for(tab in target_tabs) {
          shinyjs::removeClass(selector = paste0("a[data-value='", tab, "']"), class = "locked-menu")
          shinyjs::runjs(sprintf("$('a[data-value=\"%s\"]').attr('data-toggle', 'tab');", tab))
        }
      } else {
        # ---- เมื่อข้อมูลยังไม่มี (ล็อก) ----
        for(tab in target_tabs) {
          shinyjs::addClass(selector = paste0("a[data-value='", tab, "']"), class = "locked-menu")
          shinyjs::runjs(sprintf("$('a[data-value=\"%s\"]').removeAttr('data-toggle');", tab))
        }
      }
    })
    
    #observe(print(input$columnexpvalueindata))
    
    # message menu
    output$messageMenu <- renderMenu({
      dropdownMenu(type = "messages", 
                   messageItem(
                     from = "Project in Github", 
                     message = "Documentation, Source, Citation",
                     icon = icon("github", style = 'color: #5c5c68;'),
                     # ใช้ JavaScript บังคับเปิดลิงก์ในแท็บใหม่ เพื่อหลบข้อจำกัด iframe ของ Hugging Face
                     href = "javascript:window.open('https://github.com/mill-ornrakorn/STEHealth-Application', '_blank');"
                   ),
                   
                   badgeStatus = NULL,
                   icon = tags$i(tags$img(src='info.png', height='16', width='16')),
                   #icon = icon("circle-info", style = 'color: #5c5c68;'),
                   headerText = "App Information"
      )
    })
    
    
    # ====================================
    # สั่งล็อกเมนู Analysis ตอนเริ่มแอป
    # ====================================
    shinyjs::addClass(selector = "a[data-value='Analysis']", class = "locked-menu")
    
    # ตรวจสอบสถานะข้อมูลเพื่อปลดล็อก
    observe({
      # ถ้ามีข้อมูลครบทั้ง แผนที่ และ ข้อมูล
      if (!is.null(rv$map) && !is.null(rv$datosOriginal)) {
        # สั่งปลดล็อก (ลบคลาสสีเทาออก)
        shinyjs::removeClass(selector = "a[data-value='Analysis']", class = "locked-menu")
      } else {
        # ถ้าข้อมูลหายไป ให้กลับมาล็อกใหม่
        shinyjs::addClass(selector = "a[data-value='Analysis']", class = "locked-menu")
      }
    })
    
    
    
    # รูป nodata สำหรับฝั่ง Shapefile
    output$status_map <- renderUI({
      if (is.null(rv$map)) { 
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
    
    
    # รูป nodata สำหรับฝั่ง CSV Data
    output$status_csv <- renderUI({
      if (is.null(rv$datosOriginal)) { 
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
      if (is.null(rv$map) & is.null(rv$datosOriginal)) { 
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
      if (is.null(rv$map) & is.null(rv$datosOriginal)) {
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
      if (is.null(rv$map) & is.null(rv$datosOriginal)) { 
        HTML("<p style='margin-top: 15%; left: 15%; position:absolute;'>
         <img src='undraw_adventure_re.svg',  height  = '450px', width = '600px'>")
      } 
    })
    
    # สร้างตัวแปรเช็กสถานะการอัปโหลดไฟล์ หรือ เลือก Sample Data
    output$filemap_uploaded <- reactive({ 
      !is.null(input$filemap) || input$data_source_type == "sample" 
    })
    outputOptions(output, "filemap_uploaded", suspendWhenHidden = FALSE)
    
    output$file1_uploaded <- reactive({ 
      !is.null(input$file1) || input$data_source_type == "sample" 
    })
    outputOptions(output, "file1_uploaded", suspendWhenHidden = FALSE)
    
    
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
    
    output$mapDisError <- renderUI({
      if (!is.null(rv$errorMessageMapDis)) {
        tags$div(
          style = "color: red; font-weight: bold; margin-top: 10px;",
          HTML(rv$errorMessageMapDis)
        )
      }
    })
    
    output$mapDisError_2 <- renderUI({
      if (!is.null(rv$errorMessageMapDis_2)) {
        tags$div(
          style = "color: red; font-weight: bold; margin-top: 10px;",
          HTML(rv$errorMessageMapDis_2)
        )
      }
    })
    
    output$clusterError <- renderUI({
      if (!is.null(rv$errorMessageCluster)) {
        tags$div(
          style = "color: red; font-weight: bold; margin-top: 10px;",
          HTML(rv$errorMessageCluster)
        )
      }
    })
    
    output$assocError <- renderUI({
      if (!is.null(rv$errorMessageAssoc)) {
        tags$div(
          style = "color: red; font-weight: bold; margin-top: 10px;",
          HTML(rv$errorMessageAssoc)
        )
      }
    })
    
    
    # ========================= Modal สำหรับตัวอย่างแปลผล ================================ 
    # ==================================== Data Dictionary (Sample Data) ==================================== 
    
    dict_thailand <- data.frame(
      Column      = c("province_id", "province", "year", "suicide", "population",
                      "expected.value", "debt", "income", "poverty", "expenditure",
                      "homicide.crime", "property.crime", "shocking.crime"),
      Role        = c("area id", "area name", "time point", "cases", "population",
                      "expected value", "covariate", "covariate", "covariate", "covariate",
                      "covariate", "covariate", "covariate"),
      Description = c(
        "Unique code identifying each of the 77 provinces.",
        "Province name (one of Thailand's 77 provinces), used as the display label on the maps.",
        "Year of observation.",
        "Number of suicide deaths recorded in the province and year, sourced from the Center for Suicide Prevention, Khon Kaen Rajanagarindra Psychiatric Hospital.",
        "Mid-year population of the province in that year, sourced from the National Statistics Office of Thailand.",
        "Pre-calculated expected number of suicide cases (E) for the province and year, used as the baseline in the Poisson model (cases ~ Poisson(E x relative risk)).",
        "Average amount of debt per household in the province, sourced from the National Statistics Office of Thailand.",
        "Average monthly income per household in the province, sourced from the National Statistics Office of Thailand.",
        "Proportion of poverty (based on household expense) in the province, sourced from the National Statistics Office of Thailand.",
        "Average monthly expenses per household in the province, sourced from the National Statistics Office of Thailand.",
        "Reported cases/arrests for homicide, bodily harm and sexual assault offences in the province, sourced from the National Statistics Office of Thailand.",
        "Reported cases/arrests for theft and robbery offences in the province, sourced from the National Statistics Office of Thailand.",
        "Reported cases/arrests for violent crime offences in the province, sourced from the National Statistics Office of Thailand."
      ),
      stringsAsFactors = FALSE
    )
    
    dict_pollution <- data.frame(
      Column      = c("IZ", "name", "year", "observed", "expected", "pm10", "jsa", "price"),
      Role        = c("area id", "area name", "time point", "cases", "population",
                      "covariate", "covariate", "covariate"),
      Description = c(
        "Unique code for each Intermediate Zone (IZ) in the Greater Glasgow and Clyde health board (271 areas).",
        "Descriptive name of the Intermediate Zone, used as the display label on the maps.",
        "Year of observation (2007-2011).",
        "Observed number of respiratory-related hospital admissions in the area and year.",
        "Expected number of hospital admissions (age/sex standardised), used in place of a raw population count.",
        "Yearly average concentration of particulate matter under 10 microns (PM10), a measure of air pollution.",
        "Proportion of the working-age population receiving Job Seekers Allowance (JSA), a deprivation indicator.",
        "Average property price in the area (hundreds of thousands), a deprivation/affluence indicator."
      ),
      stringsAsFactors = FALSE
    )
    
    output$dict_table_thailand <- renderDT({
      datatable(dict_thailand, rownames = FALSE,
                options = list(dom = "t", paging = FALSE, ordering = FALSE, scrollX = TRUE),
                class = "stripe hover")
    })
    
    output$dict_table_pollution <- renderDT({
      datatable(dict_pollution, rownames = FALSE,
                options = list(dom = "t", paging = FALSE, ordering = FALSE, scrollX = TRUE),
                class = "stripe hover")
    })
    
    observeEvent(input$view_data_dictionary, {
      showModal(
        modalDialog(
          title = HTML('<div class = "modal__header">
                          <i class="uil uil-clipboard-notes modalicon"></i>
                          <div>
                            <h4 class = "modaltitle">Sample Data Dictionary</h4>
                            <span class = "modalsubtitle">Column names and descriptions for each sample dataset.</span>
                          </div>
                        </div>
                       '),
          tabsetPanel(
            tabPanel("Thailand Suicide Mortality 2011–2021",
                     br(),
                     HTML("<p>77 provinces x 11 years (2011-2021).</p>"),
                     DTOutput("dict_table_thailand")
            ),
            tabPanel("Pollution & Health Data (CARBayesST)",
                     br(),
                     HTML("<p>271 Intermediate Zones (Greater Glasgow & Clyde) × 5 years (2007-2011). 
                          Source: <em>CARBayesST</em> R package vignette (Lee, Rushworth, Napier & Pettersson).</p>
                          <p><span class='sample-badge badge-s'>Spatial only</span> A single-year (2007-only) 
                          version of this same dataset is also available in the dropdown, for testing spatial-only 
                          models. It uses the exact same columns as below (just one year of rows instead of five) 
                          and the same GGHB.IZ shapefile.</p>"),
                     DTOutput("dict_table_pollution")
            )
          ),
          easyClose = TRUE,
          footer = modalButton("Close"),
          size = "l"
        )
      )
    })
    
    
    observeEvent(input$interpret_cluster, {
      showModal(
        modalDialog(
          title = HTML('<div class = "modal__header">
                          <i class="uil uil-clipboard-notes modalicon"></i>
                          <div>
                            <h4 class = "modaltitle">Examples of interpretation</h4>
                            <span class = "modalsubtitle">Illustrative example using the Thailand suicide mortality sample data - the same interpretation rule below applies to any dataset you load, including the Pollution &amp; Health Data samples.</span>

                          </div>
                        </div>
                        
                       '),
          tags$img(src="example_cluster_result.png",
                   class = "modal__img"),
          
          HTML("
              <div class = 'modal__body'>
                <span class = 'modal__bodytitle'>If the area has a <strong>hotspot</strong>: </br></span>
                &emsp;In Kanchanaburi, has a hotspot, meaning that Kanchanaburi has a higher number of suicides than the specified threshold (the base line of our work is defined as the average number of suicides). 
                For a different dataset (e.g. the pollution &amp; health data), the same rule applies to whichever case count column you selected - a hotspot means that area/time point has a higher case count than the baseline threshold.
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
                            <span class = "modalsubtitle">Illustrative example using the Thailand suicide mortality sample data - the same interpretation rules below apply to any dataset you load, including the Pollution &amp; Health Data samples (just replace "suicide risk" with whatever case outcome your data measures).</span>

                          </div>
                        </div>
                        
                       '),
          
          # แบบที่ 1
          tags$img(src="example_asso-risk_result_1.png",
                   class = "modal__img"),
          
          HTML("
              <div class = 'modal__body'>
                <span class = 'modal__boldbodytitle'>Type 1 </span>
                <span class = 'modal__bodytitle'>If the significance is <strong>significant</strong> and RR value is <strong> > 1</strong>: </br></span>
                &emsp;       In Lamphun, the relative risk (RR) of suicide associated with expenditure is 1.0016. This suggests that for every 1 baht (THB) increase in expenditure, 
                the suicide risk increases by 0.16%. 
                Although the increase in risk per unit is minimal, cumulative increases in expenditure could potentially contribute to a higher overall risk of suicide.
              </div>
              <hr>"),
          
          # แบบที่ 2
          tags$img(src="example_asso-risk_result_2.png",
                   class = "modal__img"),
          
          HTML("
              <div class = 'modal__body'>
                <span class = 'modal__boldbodytitle'>Type 2 </span>
                <span class = 'modal__bodytitle'>If the significance is <strong>significant</strong> and RR value is <strong> < 1</strong>: </br></span>
                &emsp;In Samut Prakan, the relative risk (RR) of suicide associated with expenditure is 0.9985. This indicates that for every 1 baht (THB) increase in expenditure, 
                the suicide risk decreases by 0.15%. While the reduction in risk per unit is minimal, 
                cumulative increases in expenditure may lead to a more noticeable overall reduction in suicide risk.
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
    
    
    # อัปเดตตัวเลือกใน Dropdown ต่างๆ ทันทีเมื่ออัปโหลดไฟล์เสร็จสิ้น
    observeEvent(rv$csvData, {
      xd <- names(rv$csvData)
      if (is.null(xd) || length(xd) == 0) return()
      xd2 <- c("-", xd)
      
      if (input$data_source_type == "sample" && input$sample_dataset_choice %in% c("pollution", "pollution_2007")) {
        # Sample Data: Pollution & Health Data (CARBayesST) - full or 2007-only, same column layout
        updateSelectInput(session, "columnidareaindata", choices = xd, selected = "IZ")
        updateSelectInput(session, "columnidareanamedata", choices = xd, selected = "name")
        updateSelectInput(session, "columndateindata", choices = xd, selected = "year")
        updateSelectInput(session, "columncasesindata", choices = xd, selected = "observed")
        updateSelectInput(session, "columnpopindata", choices = xd, selected = "expected")
        updateSelectInput(session, "columnexpvalueindata", choices = c("", xd), selected = "")
        
        updateSelectInput(session, "columncov1indata", choices = xd2, selected = "pm10")
        updateSelectInput(session, "columncov2indata", choices = xd2, selected = "jsa")
        updateSelectInput(session, "columncov3indata", choices = xd2, selected = "price")
        updateSelectInput(session, "columncov4indata", choices = xd2, selected = "-")
        updateSelectInput(session, "columncov5indata", choices = xd2, selected = "-")
        updateSelectInput(session, "columncov6indata", choices = xd2, selected = "-")
        updateSelectInput(session, "columncov7indata", choices = xd2, selected = "-")
      } else if (input$data_source_type == "sample") {
        # Sample Data: Thailand Suicide Mortality
        updateSelectInput(session, "columnidareaindata", choices = xd, selected = "province_id")
        updateSelectInput(session, "columnidareanamedata", choices = xd, selected = "province")
        updateSelectInput(session, "columndateindata", choices = xd, selected = "year")
        updateSelectInput(session, "columncasesindata", choices = xd, selected = "suicide")
        updateSelectInput(session, "columnpopindata", choices = xd, selected = "population")
        updateSelectInput(session, "columnexpvalueindata", choices = xd, selected = "expected.value")
        
        updateSelectInput(session, "columncov1indata", choices = xd2, selected = "debt")
        updateSelectInput(session, "columncov2indata", choices = xd2, selected = "income")
        updateSelectInput(session, "columncov3indata", choices = xd2, selected = "poverty")
        updateSelectInput(session, "columncov4indata", choices = xd2, selected = "expenditure")
        updateSelectInput(session, "columncov5indata", choices = xd2, selected = "homicide.crime")
        updateSelectInput(session, "columncov6indata", choices = xd2, selected = "property.crime")
        updateSelectInput(session, "columncov7indata", choices = xd2, selected = "shocking.crime")
      } else {
        # สำหรับกรณีอัปโหลดเอง
        updateSelectInput(session, "columnidareaindata", choices = c("", xd), selected = "")
        updateSelectInput(session, "columnidareanamedata", choices = c("", xd), selected = "")
        updateSelectInput(session, "columnexpvalueindata", choices = c("", xd), selected = "")
        updateSelectInput(session, "columncasesindata", choices = c("", xd), selected = "")
        updateSelectInput(session, "columnpopindata", choices = c("", xd), selected = "")
        updateSelectInput(session, "columndateindata", choices = c("", xd), selected = "")
        
        updateSelectInput(session, "columncov1indata", choices = xd2, selected = "-")
        updateSelectInput(session, "columncov2indata", choices = xd2, selected = "-")
        updateSelectInput(session, "columncov3indata", choices = xd2, selected = "-")
        updateSelectInput(session, "columncov4indata", choices = xd2, selected = "-")
        updateSelectInput(session, "columncov5indata", choices = xd2, selected = "-")
        updateSelectInput(session, "columncov6indata", choices = xd2, selected = "-")
        updateSelectInput(session, "columncov7indata", choices = xd2, selected = "-")
      }
    })
    
    # ประมวลผลสร้างคอลัมน์และเลือกคอลัมน์ให้อัตโนมัติ (Automation Section)
    observe({
      req(rv$csvData)
      df <- rv$csvData
      selected_col <- input$columnidareanamedata
      
      # ตรวจสอบความถูกต้องของคอลัมน์ Area Name
      if (!is.null(selected_col) && selected_col != "" && selected_col %in% names(df)) {
        
        # สร้างคอลัมน์ ID อัตโนมัติจาก Area Name บน Memory (ไม่ต้องอ่านไฟล์ซ้ำ)
        area_name_col <- df[[selected_col]]
        df[["__areaID_auto__"]] <- as.integer(factor(area_name_col))
        
        # ส่งค่าเข้าสู่ข้อมูลหลักที่จะใช้คำนวณหลังบ้าน
        rv$datosOriginal <- df
        
        # [จุดสำคัญ]: สั่งล็อกการเลือกค่าในช่อง Area ID ให้เป็นตัวที่สร้างขึ้นมาทันที!
        if (input$data_source_type == "upload") {
          xd_updated <- names(df)
          # ถ้าผู้ใช้เลือก area id เอง (เช่น IZ) อยู่แล้ว ไม่ต้อง override ทับ
          current_id <- isolate(input$columnidareaindata)
          if (is.null(current_id) || current_id == "" || !(current_id %in% xd_updated)) {
            updateSelectInput(session, "columnidareaindata", choices = xd_updated, selected = "__areaID_auto__")
          } else {
            updateSelectInput(session, "columnidareaindata", choices = xd_updated, selected = current_id)
          }
        }
      } else {
        rv$datosOriginal <- df
      }
    })
    
    
    # อัปเดต Radio Buttons อัตโนมัติเมื่อเลือก Sample Data
    observeEvent(list(input$data_source_type, input$sample_dataset_choice), {
      if (input$data_source_type == "sample") {
        if (input$sample_dataset_choice %in% c("pollution", "pollution_2007")) {
          # Pollution health data (full or 2007-only): not Thailand provinces, no pre-computed expected value column
          updateRadioButtons(session, "shapefile_from_thailand", selected = "no")
          updateRadioButtons(session, "Expected_Value_from_csv", selected = "no")
        } else {
          updateRadioButtons(session, "shapefile_from_thailand", selected = "yes")
          updateRadioButtons(session, "Expected_Value_from_csv", selected = "yes")
        }
      }
    }, ignoreNULL = FALSE)
    
    
    # กล่องคำอธิบายสั้นๆ ใต้ dropdown บอกว่าชุดข้อมูลที่เลือกอยู่รองรับ Spatial หรือ Spatial-Temporal
    output$sample_dataset_info <- renderUI({
      req(input$data_source_type == "sample")
      
      info <- switch(input$sample_dataset_choice,
                     "thailand" = list(
                       badge = "Spatial-Temporal", cls = "badge-st",
                       text = "77 provinces x 11 years (2011-2021). Supports both spatial-only and spatial-temporal models."
                     ),
                     "pollution" = list(
                       badge = "Spatial-Temporal", cls = "badge-st",
                       text = "271 areas x 5 years (2007-2011). Supports both spatial-only and spatial-temporal models."
                     ),
                     "pollution_2007" = list(
                       badge = "Spatial only", cls = "badge-s",
                       text = "271 areas, single year (2007) only. This dataset has no time dimension, so it is intended for testing spatial-only models (spatial-temporal models require more than one time point)."
                     ),
                     list(badge = "", cls = "", text = "")
      )
      
      div(class = "info-note", style = "margin-top: 10px;",
          HTML(paste0(
            "<i class='uil uil-info-circle'></i> ",
            if (nzchar(info$badge)) paste0("<span class='sample-badge ", info$cls, "'>", info$badge, "</span> ") else "",
            info$text
          ))
      )
    })
    
    
    
    observe({
      x <- names(rv$map)
      if (is.null(x)) {
        x <- character(0)
      }
      
      if (input$data_source_type == "sample" && length(x) > 0) {
        if (input$sample_dataset_choice %in% c("pollution", "pollution_2007")) {
          # Pollution health data sample (full or 2007-only): GGHB.IZ shapefile - match on IZ column
          updateSelectInput(session, "columnidareainmap", choices = x, selected = "IZ")
        } else {
          # **แก้ไขชื่อ "NAME_1" ให้ตรงกับชื่อคอลัมน์จังหวัดในไฟล์ gadm40_THA_1 ของคุณ**
          updateSelectInput(session, "columnidareainmap", choices = x, selected = "NAME_1")
        }
        
      } else {
        # กรณีอัปโหลดเอง ให้ default เป็นคอลัมน์แรก
        updateSelectInput(session, "columnidareainmap", choices = x, selected = head(x, 1))
      }
    })
    
    
    rv <- reactiveValues(
      overall_rr_df=NULL,
      model_fit_df=NULL,
      hyperpar_df=NULL,
      model_fixed=NULL,
      has_time_dimension=NULL,
      runtime_cluster=NULL, runtime_asso=NULL, runtime_total=NULL,  # เวลาที่ใช้คำนวณโมเดล (วินาที) เอาไปโชว์เป็น card
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
      selectstage='stageuploaddata',
      errorMessageMapDis = NULL,
      errorMessageMapDis_2 = NULL,
      errorMessageCluster = NULL,  
      errorMessageAssoc = NULL     
    )
    
    
    
    
    
    # output$uploadmapmap <- renderPlot({
    #   if (is.null(rv$map))
    #     return(NULL)
    #   plot(rv$map)
    # })
    
    output$uploadmapmap <- renderPlot({
      if (!is.null(rv$map))
        plot(sf::st_geometry(rv$map), col = "#e8e4ff", border = "#735DFB", main = NULL)
    })
    
    # ====================================
    # สรุปข้อมูลแบบง่าย อ่านเข้าใจได้เร็ว แทน summary() ดิบๆ ของ R
    # ====================================
    friendly_summary <- function(df) {
      if (is.null(df) || ncol(df) == 0) return(NULL)
      
      rows <- lapply(names(df), function(col) {
        x <- df[[col]]
        n_missing <- sum(is.na(x))
        
        if (is.numeric(x)) {
          info <- sprintf("min %s  |  mean %s  |  max %s",
                          format(round(min(x, na.rm = TRUE), 2), big.mark = ","),
                          format(round(mean(x, na.rm = TRUE), 2), big.mark = ","),
                          format(round(max(x, na.rm = TRUE), 2), big.mark = ","))
          type <- "number"
        } else {
          uq <- unique(x[!is.na(x)])
          sample_vals <- paste(utils::head(uq, 3), collapse = ", ")
          info <- sprintf("%d unique value(s)  (e.g. %s)", length(uq), sample_vals)
          type <- "text"
        }
        
        data.frame(
          Column  = col,
          Type    = type,
          Summary = info,
          Missing = n_missing,
          stringsAsFactors = FALSE
        )
      })
      
      out <- do.call(rbind, rows)
      rownames(out) <- NULL
      out
    }
    
    output$uploadmapsummary <- renderTable({
      # req(rv$map) คือการบอกว่าถ้ายังไม่มีข้อมูลไม่ต้องรันต่อ เพื่อกัน Error
      req(rv$map)
      friendly_summary(st_drop_geometry(rv$map))
    }, striped = TRUE, bordered = TRUE, spacing = "s")
    
    output$uploadmaptable  <- renderDT({
      req(rv$map)
      # ใช้ st_drop_geometry เพราะ DT ไม่สามารถแสดงคอลัมน์ที่เป็นพิกัดแผนที่ได้
      st_drop_geometry(rv$map)
    } , options = list(scrollX = TRUE, pageLength = 5))
    
    
    output$uploaddatasummary <- renderTable({
      req(rv$datosOriginal)
      friendly_summary(rv$datosOriginal)
    }, striped = TRUE, bordered = TRUE, spacing = "s")
    
    output$uploaddatatable  <- renderDT({
      req(rv$datosOriginal)
      rv$datosOriginal
    } , options = list(scrollX = TRUE, pageLength = 5))
    
    
    
    # Upload shapefile
    observe({
      if (input$data_source_type == "upload") {
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
        
        shp_file <- file.path(uploaddirectory, shpdf$name[grep("\\.shp$", shpdf$name)])
        
      } else if (input$sample_dataset_choice %in% c("pollution", "pollution_2007")) {
        # Sample Data: pollution health data (CARBayesST), full or 2007-only -> same GGHB.IZ shapefile
        shp_file <- "sample data/GGHB_IZ.shp"
      } else {
        # ถ้าผู้ใช้เลือก Sample Data (Thailand Suicide) ให้ชี้ไปที่โฟลเดอร์ตรงๆ
        shp_file <- "sample data/gadm40_THA_1.shp"
      }
      
      # โหลดแผนที่ด้วย sf (ใช้ร่วมกันทั้งแบบ Upload และ Sample)
      tryCatch({
        map <- st_read(shp_file, quiet = TRUE, options = "ENCODING=UTF-8")
        map <- st_transform(map, crs = 4326)
        rv$map <- map
      }, error = function(e) {
        showNotification(paste("Error reading shapefile:", e$message), type = "error")
      })
    })
    
    # 1. โหลดไฟล์ CSV พร้อมระบบทำความสะอาดข้อมูลอัตโนมัติ (Data Cleaning Automation)
    observe({
      if (input$data_source_type == "upload") {
        inFile <- input$file1
        if (is.null(inFile)) return(invisible())
        path <- inFile$datapath
      } else if (input$sample_dataset_choice == "pollution") {
        path <- "sample data/pollution_health_data.csv"
      } else if (input$sample_dataset_choice == "pollution_2007") {
        path <- "sample data/pollution_health_data_2007.csv"
      } else {
        path <- "sample data/suicide_th_data_sample_have_e_value.csv"
      }
      
      tryCatch({
        # อ่านไฟล์โดยแปลงช่องว่างและสัญลักษณ์แปลกๆ ให้เป็น NA ก่อน
        # รองรับทั้ง CSV และ Excel (.xlsx / .xls) โดยเช็คจากนามสกุลไฟล์
        file_ext <- tolower(tools::file_ext(path))
        if (file_ext %in% c("xlsx", "xls")) {
          df <- as.data.frame(readxl::read_excel(path))
          # แปลงค่าที่เป็น string ว่าง/สัญลักษณ์แปลก ๆ ให้เป็น NA เหมือนตอนอ่าน CSV
          df[df == "" | df == " " | df == "NA" | df == "na" | df == "-" | df == "."] <- NA
        } else {
          df <- read.csv(path, na.strings = c("", " ", "NA", "na", "-", "."))
        }
        
        # [จุดสำคัญ 1]: ตัดแถวที่เป็นค่าว่าง (NA) ทั้งบรรทัดทิ้ง (ป้องกันบรรทัดว่างท้ายไฟล์ CSV)
        df <- df[rowSums(is.na(df)) != ncol(df), ]
        
        # [จุดสำคัญ 2]: ถ้าระบบรู้แล้วว่าคอลัมน์ชื่อพื้นที่คืออะไร ให้ตัดแถวที่ไม่มีชื่อพื้นที่ (เช่น แถว Total/Summary) ทิ้งทันที
        selected_name_col <- input$columnidareanamedata
        if (!is.null(selected_name_col) && selected_name_col != "" && selected_name_col %in% names(df)) {
          df <- df[!is.na(df[[selected_name_col]]), ]
        }
        
        rv$csvData <- df
      }, error = function(e) {
        showNotification(paste("Error reading CSV:", e$message), type = "error")
      })
    })
    
    
    
    # ==================================== ปุ่ม preview map dis ==================================== 
    observeEvent(input$Preview_Map_Distribution , {
      # ย้ำเงื่อนไขอีกรอบ ป้องกันการถูกคลิกตอนที่ข้อมูลยังไม่มี
      if (is.null(rv$datosOriginal)| is.null(rv$map)) return(NULL)
      
      # 0. เช็คว่า area id ของ shapefile กับ csv ตรงกันก่อนไปหน้า Map Distribution
      if (!validate_shapefile_data_match()) return(NULL)
      
      # 1. เลื่อนไปหน้า Map Distribution ทันที
      shinyjs::runjs("$('.sidebar-menu a[data-value=Map_Distribution]').click();")
      
      # 2. จัดการข้อมูล dropdown (โค้ดเดิมของคุณ Mill)
      data <- rv$datosOriginal
      
      updateSelectInput(session, "time_point_filter", choices = data[,input$columndateindata],  selected = head(data[,input$columndateindata], 1))
      updateSelectInput(session, "time_point_filter_cluster", choices = data[,input$columndateindata],  selected = head(data[,input$columndateindata], 1))
      
    })
    
    
    
    
    
    
    
    # ==================================== ปุ่ม action input$nextpage ==================================== 
    #observeEvent(input$nextpage | input$tabs == "Analysis", {
    observeEvent(input$nextpage , {
      
      if (is.null(rv$datosOriginal) | is.null(rv$map))
        return(NULL)
      
      # เช็คว่า area id ของ shapefile กับ csv ตรงกันก่อนไปคำนวณ Cluster / Association
      if (!validate_shapefile_data_match()) return(NULL)
      
      
      if(input$tabs == "Analysis"){
        data <- rv$datosOriginal
        total_start_time <- Sys.time()  # จับเวลารวมทั้ง Cluster + Association เพราะหน้าเว็บจะไม่อัปเดตจนกว่าทั้ง 2 จะเสร็จ
        
        #updateSliderInput(session, "time_point_filter_cluster", min = min(data[,input$columndateindata]), max = max(data[,input$columndateindata]) )
        
        
        
        ######################### คำนวณ cluster ###################################
        cluster_start_time <- Sys.time()  # เริ่มจับเวลาคำนวณ Cluster Detection
        tryCatch({
          rv$errorMessageCluster <- NULL  # ล้างข้อความ Error หากไม่มีปัญหา
          
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
          # เดิม (crash ถ้า IZ เป็น text)
          # data[,input$columnidareaindata] <- as.numeric(data[,input$columnidareaindata]) # id of province 1-77
          
          # ใหม่: ถ้าแปลงเป็น numeric ไม่ได้ ให้ auto-rank แทน
          raw_id <- data[, input$columnidareaindata]
          numeric_id <- suppressWarnings(as.numeric(raw_id))
          
          if (any(is.na(numeric_id))) {
            # กรณี area id เป็น text เช่น "S02000260" → แปลงเป็น integer rank
            data[["__areaID_auto__"]] <- as.integer(factor(raw_id))
            area_id_col <- "__areaID_auto__"
          } else {
            data[, input$columnidareaindata] <- numeric_id
            area_id_col <- input$columnidareaindata
          }
          
          
          # # year data$year
          data[,input$columndateindata] <- as.numeric(data[,input$columndateindata]) # id of year 1-11 (?)
          
          # # data$province_year <- seq(1, 1064) # id of province-year interaction
          data$province_year <- seq(1, nrow(data)) # id of year 1-11 (?)
          
          # # interaction id
          province_int <- data[,input$columnidareaindata]
          year_int <- data[,input$columndateindata]
          
          # รองรับกรณีข้อมูลเป็น Spatial อย่างเดียว (มี time point แค่ค่าเดียว หรือไม่มี variation ตามเวลา)
          # ถ้ามีเวลาแค่ 1 จุด จะไม่ใส่ f(..., model = "rw1") ในสูตรโมเดล เพราะ RW1 ต้องมีอย่างน้อย 2 จุดเวลา
          has_time_dimension <- length(unique(data[,input$columndateindata])) > 1
          rv$has_time_dimension <- has_time_dimension
          
          
          
          
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
          #   f(data[[area_id_col]], model = "bym", graph = tha_adj) +
          #   f(data[,input$columndateindata], model = "rw1") +
          #   f(province_int, model = "iid")
          
          
          ####################   Cluster   #################### 
          
          
          
          if (has_time_dimension) {
            formula_1_bym_rw1_Cluter <- data[,input$columncasesindata] ~ 1 +
              f(data[[area_id_col]], model = "bym", graph = tha_adj) +
              f(data[,input$columndateindata], model = "rw1") +
              f(province_int, model = "iid")
          } else {
            formula_1_bym_rw1_Cluter <- data[,input$columncasesindata] ~ 1 +
              f(data[[area_id_col]], model = "bym", graph = tha_adj) +
              f(province_int, model = "iid")
          }
          
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
          
          data[, "hotspot label"] <- exceedance_prob > 0.95
          data[, "hotspot label"] <- ifelse(exceedance_prob > 0.95,
                                            "hotspot", "non-hotspot")
          
          rv$data <- data
          
          
          rv$model_Cluter <- model_Cluter
          
        }, error = function(e) {
          rv$errorMessageCluster <- paste(
            "An error occurred in Cluster Detection. Please check the uploaded data again.",
            "<br>Error Message: ", e$message,
            sep = ""
          )
        })
        rv$runtime_cluster <- as.numeric(difftime(Sys.time(), cluster_start_time, units = "secs"))  # เก็บเวลาที่ใช้คำนวณ
        # model2 <- rv$model
        
        print("===================== rv$errorMessageCluster =====================")
        print(rv$errorMessageCluster)
        
        
        ####################################################
        
        
        assoc_start_time <- Sys.time()  # เริ่มจับเวลาคำนวณ Association with Risk Factors
        tryCatch({
          rv$errorMessageAssoc  <- NULL  # ล้างข้อความ Error หากไม่มีปัญหา
          ####################  คำนวณ asso   #################### 
          
          
          not_empty <- function(x) x != "" & x != "-"
          
          
          x1 <- input$columncov1indata
          x2 <- input$columncov2indata
          x3 <- input$columncov3indata
          x4 <- input$columncov4indata
          x5 <- input$columncov5indata
          x6 <- input$columncov6indata
          x7 <- input$columncov7indata
          
          # ← เพิ่ม print นี้
          print(paste("DEBUG covariates:", x1, x2, x3, x4, x5, x6, x7))
          
          if (!not_empty(x1) & !not_empty(x2) & !not_empty(x3) & !not_empty(x4) & !not_empty(x5) & !not_empty(x6) & !not_empty(x7)) {
            
            print("Check: ...all null...")
            
            
            
            
            
          }else if (not_empty(x1) & !not_empty(x2) & !not_empty(x3) & !not_empty(x4) & !not_empty(x5) & !not_empty(x6) & !not_empty(x7)) {
            
            print("Check: ...1 not null...")
            x1 <- data[,input$columncov1indata]
            
            
            
            # id for association each province
            data$x1_id <- data[,input$columnidareaindata]
            
            
            if (has_time_dimension) {
              formula_1_bym_rw1 <- data[,input$columncasesindata] ~ 1 +
                # x1 +  # (fixed effect - ปิดไว้ก่อน รอปรึกษาอาจารย์ก่อน)
                f(data$x1_id, x1, model = "iid") +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(data[,input$columndateindata], model = "rw1") +
                f(province_int, model = "iid")
            } else {
              formula_1_bym_rw1 <- data[,input$columncasesindata] ~ 1 +
                # x1 +  # (fixed effect - ปิดไว้ก่อน รอปรึกษาอาจารย์ก่อน)
                f(data$x1_id, x1, model = "iid") +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(province_int, model = "iid")
            }
            
            # computing part
            model <- inla(
              formula_1_bym_rw1,
              family = "poisson",
              data = data,
              E = data[, 'expected_value'],
              control.predictor = list(compute = TRUE),
              control.compute = list(
                dic = TRUE,
                waic = TRUE,
                cpo = TRUE,
                return.marginals.predictor = TRUE))
            
            
            
            rv$data <- data
            
            
            rv$model <- model
            
            # ===== โมเดลที่ 2: Fixed-effect model (สำหรับ Overall / region-wide association) =====
            # เก็บโมเดลเดิม (random slope รายพื้นที่) ไว้ด้านบน และเพิ่มโมเดลนี้แยกต่างหากเพื่อหาค่า overall association
            # ตัด f(data$xN_id, xN, model="iid") ออก แล้วใส่ x1 เป็น fixed effect แทน
            # ส่วน f(area_id_col,"bym"), f(date,"rw1"), f(province_int,"iid") ยังคงไว้เป็น adjustment term เหมือนโมเดลเดิม
            # TODO: ยืนยันกับอาจารย์ว่าต้องตัด 3 เทอมนี้ออกด้วยหรือไม่ เพื่อให้เทียบเท่า CARBayesST ตรงๆ
            if (has_time_dimension) {
              formula_fixed_only <- data[,input$columncasesindata] ~ 1 +
                x1 +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(data[,input$columndateindata], model = "rw1") +
                f(province_int, model = "iid")
            } else {
              formula_fixed_only <- data[,input$columncasesindata] ~ 1 +
                x1 +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(province_int, model = "iid")
            }
            
            model_fixed <- inla(
              formula_fixed_only,
              family = "poisson",
              data = data,
              E = data[, 'expected_value'],
              control.predictor = list(compute = TRUE),
              control.compute = list(
                dic = TRUE,
                waic = TRUE,
                cpo = TRUE,
                return.marginals.predictor = TRUE))
            
            rv$model_fixed <- model_fixed
            
            rv$overall_rr_df <- compute_overall_rr(model_fixed, c(input$columncov1indata))
            rv$model_fit_df <- compute_model_fit_summary(model_fixed)
            rv$hyperpar_df <- compute_hyperpar_summary(model_fixed, c(input$columncov1indata))
            
            
            model2 <- rv$model
            
            # NOTE: reverted to random-slope-only RR (no fixed effect combined in). Fixed-effect version pending discussion with advisor.
            association_df <- (data.frame(
              c(exp(model2$summary.random$`data|S|x1_id`$mean))
            ) )
            
            
            colnames(association_df) <-  c(paste(input$columncov1indata,"_RR", sep=""))
            
            
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
            
            
            # ← เพิ่มก่อน rv$association_wsf_df <- association_wsf_df
            print(paste("DEBUG association_wsf_df columns:", paste(names(association_wsf_df), collapse=", ")))
            
            rv$association_wsf_df <- association_wsf_df
            
            
            
          }else if (not_empty(x1) & not_empty(x2) & !not_empty(x3) & !not_empty(x4) & !not_empty(x5) & !not_empty(x6) & !not_empty(x7)) {
            
            print("Check: ...1,2 not null...")
            x1 <- data[,input$columncov1indata]
            x2 <- data[,input$columncov2indata]
            
            
            
            # id for association each province
            data$x1_id <- data[,input$columnidareaindata]
            data$x2_id <- data[,input$columnidareaindata]
            
            
            if (has_time_dimension) {
              formula_1_bym_rw1 <- data[,input$columncasesindata] ~ 1 +
                # x1 + x2 +  # (fixed effect - ปิดไว้ก่อน รอปรึกษาอาจารย์ก่อน)
                f(data$x1_id, x1, model = "iid") +
                f(data$x2_id, x2, model = "iid") +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(data[,input$columndateindata], model = "rw1") +
                f(province_int, model = "iid")
            } else {
              formula_1_bym_rw1 <- data[,input$columncasesindata] ~ 1 +
                # x1 + x2 +  # (fixed effect - ปิดไว้ก่อน รอปรึกษาอาจารย์ก่อน)
                f(data$x1_id, x1, model = "iid") +
                f(data$x2_id, x2, model = "iid") +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(province_int, model = "iid")
            }
            
            # computing part
            model <- inla(
              formula_1_bym_rw1,
              family = "poisson",
              data = data,
              E = data[, 'expected_value'],
              control.predictor = list(compute = TRUE),
              control.compute = list(
                dic = TRUE,
                waic = TRUE,
                cpo = TRUE,
                return.marginals.predictor = TRUE))
            
            
            
            rv$model <- model
            
            # ===== โมเดลที่ 2: Fixed-effect model (สำหรับ Overall / region-wide association) =====
            # เก็บโมเดลเดิม (random slope รายพื้นที่) ไว้ด้านบน และเพิ่มโมเดลนี้แยกต่างหากเพื่อหาค่า overall association
            # ตัด f(data$xN_id, xN, model="iid") ออก แล้วใส่ x1 + x2 เป็น fixed effect แทน
            # ส่วน f(area_id_col,"bym"), f(date,"rw1"), f(province_int,"iid") ยังคงไว้เป็น adjustment term เหมือนโมเดลเดิม
            # TODO: ยืนยันกับอาจารย์ว่าต้องตัด 3 เทอมนี้ออกด้วยหรือไม่ เพื่อให้เทียบเท่า CARBayesST ตรงๆ
            if (has_time_dimension) {
              formula_fixed_only <- data[,input$columncasesindata] ~ 1 +
                x1 + x2 +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(data[,input$columndateindata], model = "rw1") +
                f(province_int, model = "iid")
            } else {
              formula_fixed_only <- data[,input$columncasesindata] ~ 1 +
                x1 + x2 +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(province_int, model = "iid")
            }
            
            model_fixed <- inla(
              formula_fixed_only,
              family = "poisson",
              data = data,
              E = data[, 'expected_value'],
              control.predictor = list(compute = TRUE),
              control.compute = list(
                dic = TRUE,
                waic = TRUE,
                cpo = TRUE,
                return.marginals.predictor = TRUE))
            
            rv$model_fixed <- model_fixed
            
            rv$overall_rr_df <- compute_overall_rr(model_fixed, c(input$columncov1indata, input$columncov2indata))
            rv$model_fit_df <- compute_model_fit_summary(model_fixed)
            rv$hyperpar_df <- compute_hyperpar_summary(model_fixed, c(input$columncov1indata, input$columncov2indata))
            
            
            model2 <- rv$model
            
            # NOTE: reverted to random-slope-only RR (no fixed effect combined in). Fixed-effect version pending discussion with advisor.
            association_df <- (data.frame(
              c(exp(model2$summary.random$`data|S|x1_id`$mean)),
              c(exp(model2$summary.random$`data|S|x2_id`$mean))
            ) )
            
            
            colnames(association_df) <-  c(paste(input$columncov1indata,"_RR", sep=""),
                                           paste(input$columncov2indata,"_RR", sep=""))
            
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
            
            # ← เพิ่มก่อน rv$association_wsf_df <- association_wsf_df
            print(paste("DEBUG association_wsf_df columns:", paste(names(association_wsf_df), collapse=", ")))
            rv$association_wsf_df <- association_wsf_df
            
            
            
          }else if (not_empty(x1) & not_empty(x2) & not_empty(x3) & !not_empty(x4) & !not_empty(x5) & !not_empty(x6) & !not_empty(x7)) {
            
            print("Check: ...1,2,3 not null...")
            x1 <- data[,input$columncov1indata]
            x2 <- data[,input$columncov2indata]
            x3 <- data[,input$columncov3indata]
            
            
            
            # id for association each province
            data$x1_id <- data[,input$columnidareaindata]
            data$x2_id <- data[,input$columnidareaindata]
            data$x3_id <- data[,input$columnidareaindata]
            
            
            if (has_time_dimension) {
              formula_1_bym_rw1 <- data[,input$columncasesindata] ~ 1 +
                # x1 + x2 + x3 +  # (fixed effect - ปิดไว้ก่อน รอปรึกษาอาจารย์ก่อน)
                f(data$x1_id, x1, model = "iid") +
                f(data$x2_id, x2, model = "iid") +
                f(data$x3_id, x3, model = "iid") +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(data[,input$columndateindata], model = "rw1") +
                f(province_int, model = "iid")
            } else {
              formula_1_bym_rw1 <- data[,input$columncasesindata] ~ 1 +
                # x1 + x2 + x3 +  # (fixed effect - ปิดไว้ก่อน รอปรึกษาอาจารย์ก่อน)
                f(data$x1_id, x1, model = "iid") +
                f(data$x2_id, x2, model = "iid") +
                f(data$x3_id, x3, model = "iid") +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(province_int, model = "iid")
            }
            
            # computing part
            model <- inla(
              formula_1_bym_rw1,
              family = "poisson",
              data = data,
              E = data[, 'expected_value'],
              control.predictor = list(compute = TRUE),
              control.compute = list(
                dic = TRUE,
                waic = TRUE,
                cpo = TRUE,
                return.marginals.predictor = TRUE))
            
            
            
            rv$model <- model
            
            # ===== โมเดลที่ 2: Fixed-effect model (สำหรับ Overall / region-wide association) =====
            # เก็บโมเดลเดิม (random slope รายพื้นที่) ไว้ด้านบน และเพิ่มโมเดลนี้แยกต่างหากเพื่อหาค่า overall association
            # ตัด f(data$xN_id, xN, model="iid") ออก แล้วใส่ x1 + x2 + x3 เป็น fixed effect แทน
            # ส่วน f(area_id_col,"bym"), f(date,"rw1"), f(province_int,"iid") ยังคงไว้เป็น adjustment term เหมือนโมเดลเดิม
            # TODO: ยืนยันกับอาจารย์ว่าต้องตัด 3 เทอมนี้ออกด้วยหรือไม่ เพื่อให้เทียบเท่า CARBayesST ตรงๆ
            if (has_time_dimension) {
              formula_fixed_only <- data[,input$columncasesindata] ~ 1 +
                x1 + x2 + x3 +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(data[,input$columndateindata], model = "rw1") +
                f(province_int, model = "iid")
            } else {
              formula_fixed_only <- data[,input$columncasesindata] ~ 1 +
                x1 + x2 + x3 +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(province_int, model = "iid")
            }
            
            model_fixed <- inla(
              formula_fixed_only,
              family = "poisson",
              data = data,
              E = data[, 'expected_value'],
              control.predictor = list(compute = TRUE),
              control.compute = list(
                dic = TRUE,
                waic = TRUE,
                cpo = TRUE,
                return.marginals.predictor = TRUE))
            
            rv$model_fixed <- model_fixed
            
            rv$overall_rr_df <- compute_overall_rr(model_fixed, c(input$columncov1indata, input$columncov2indata, input$columncov3indata))
            rv$model_fit_df <- compute_model_fit_summary(model_fixed)
            rv$hyperpar_df <- compute_hyperpar_summary(model_fixed, c(input$columncov1indata, input$columncov2indata, input$columncov3indata))
            
            
            model2 <- rv$model
            
            # NOTE: reverted to random-slope-only RR (no fixed effect combined in). Fixed-effect version pending discussion with advisor.
            association_df <- (data.frame(
              c(exp(model2$summary.random$`data|S|x1_id`$mean)),
              c(exp(model2$summary.random$`data|S|x2_id`$mean)),
              c(exp(model2$summary.random$`data|S|x3_id`$mean))
            ) )
            
            
            colnames(association_df) <-  c(paste(input$columncov1indata,"_RR", sep=""),
                                           paste(input$columncov2indata,"_RR", sep=""),
                                           paste(input$columncov3indata,"_RR", sep=""))
            
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
            
            # ← เพิ่มก่อน rv$association_wsf_df <- association_wsf_df
            print(paste("DEBUG association_wsf_df columns:", paste(names(association_wsf_df), collapse=", ")))
            rv$association_wsf_df <- association_wsf_df
            
            
            
            
          }else if (not_empty(x1) & not_empty(x2) & not_empty(x3) & not_empty(x4) & !not_empty(x5) & !not_empty(x6) & !not_empty(x7)) {
            
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
            
            
            if (has_time_dimension) {
              formula_1_bym_rw1 <- data[,input$columncasesindata] ~ 1 +
                # x1 + x2 + x3 + x4 +  # (fixed effect - ปิดไว้ก่อน รอปรึกษาอาจารย์ก่อน)
                f(data$x1_id, x1, model = "iid") +
                f(data$x2_id, x2, model = "iid") +
                f(data$x3_id, x3, model = "iid") +
                f(data$x4_id, x4, model = "iid") +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(data[,input$columndateindata], model = "rw1") +
                f(province_int, model = "iid")
            } else {
              formula_1_bym_rw1 <- data[,input$columncasesindata] ~ 1 +
                # x1 + x2 + x3 + x4 +  # (fixed effect - ปิดไว้ก่อน รอปรึกษาอาจารย์ก่อน)
                f(data$x1_id, x1, model = "iid") +
                f(data$x2_id, x2, model = "iid") +
                f(data$x3_id, x3, model = "iid") +
                f(data$x4_id, x4, model = "iid") +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(province_int, model = "iid")
            }
            
            # computing part
            model <- inla(
              formula_1_bym_rw1,
              family = "poisson",
              data = data,
              E = data[, 'expected_value'],
              control.predictor = list(compute = TRUE),
              control.compute = list(
                dic = TRUE,
                waic = TRUE,
                cpo = TRUE,
                return.marginals.predictor = TRUE))
            
            
            
            rv$model <- model
            
            # ===== โมเดลที่ 2: Fixed-effect model (สำหรับ Overall / region-wide association) =====
            # เก็บโมเดลเดิม (random slope รายพื้นที่) ไว้ด้านบน และเพิ่มโมเดลนี้แยกต่างหากเพื่อหาค่า overall association
            # ตัด f(data$xN_id, xN, model="iid") ออก แล้วใส่ x1 + x2 + x3 + x4 เป็น fixed effect แทน
            # ส่วน f(area_id_col,"bym"), f(date,"rw1"), f(province_int,"iid") ยังคงไว้เป็น adjustment term เหมือนโมเดลเดิม
            # TODO: ยืนยันกับอาจารย์ว่าต้องตัด 3 เทอมนี้ออกด้วยหรือไม่ เพื่อให้เทียบเท่า CARBayesST ตรงๆ
            if (has_time_dimension) {
              formula_fixed_only <- data[,input$columncasesindata] ~ 1 +
                x1 + x2 + x3 + x4 +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(data[,input$columndateindata], model = "rw1") +
                f(province_int, model = "iid")
            } else {
              formula_fixed_only <- data[,input$columncasesindata] ~ 1 +
                x1 + x2 + x3 + x4 +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(province_int, model = "iid")
            }
            
            model_fixed <- inla(
              formula_fixed_only,
              family = "poisson",
              data = data,
              E = data[, 'expected_value'],
              control.predictor = list(compute = TRUE),
              control.compute = list(
                dic = TRUE,
                waic = TRUE,
                cpo = TRUE,
                return.marginals.predictor = TRUE))
            
            rv$model_fixed <- model_fixed
            
            rv$overall_rr_df <- compute_overall_rr(model_fixed, c(input$columncov1indata, input$columncov2indata, input$columncov3indata, input$columncov4indata))
            rv$model_fit_df <- compute_model_fit_summary(model_fixed)
            rv$hyperpar_df <- compute_hyperpar_summary(model_fixed, c(input$columncov1indata, input$columncov2indata, input$columncov3indata, input$columncov4indata))
            
            
            model2 <- rv$model
            
            # NOTE: reverted to random-slope-only RR (no fixed effect combined in). Fixed-effect version pending discussion with advisor.
            association_df <- (data.frame(
              c(exp(model2$summary.random$`data|S|x1_id`$mean)),
              c(exp(model2$summary.random$`data|S|x2_id`$mean)),
              c(exp(model2$summary.random$`data|S|x3_id`$mean)),
              c(exp(model2$summary.random$`data|S|x4_id`$mean))
            ) )
            
            
            colnames(association_df) <-  c(paste(input$columncov1indata,"_RR", sep=""),
                                           paste(input$columncov2indata,"_RR", sep=""),
                                           paste(input$columncov3indata,"_RR", sep=""),
                                           paste(input$columncov4indata,"_RR", sep=""))
            
            
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
            
            # ← เพิ่มก่อน rv$association_wsf_df <- association_wsf_df
            print(paste("DEBUG association_wsf_df columns:", paste(names(association_wsf_df), collapse=", ")))
            rv$association_wsf_df <- association_wsf_df
            
            
          }else if (not_empty(x1) & not_empty(x2) & not_empty(x3) & not_empty(x4) & not_empty(x5) & !not_empty(x6) & !not_empty(x7)) {
            
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
            
            
            if (has_time_dimension) {
              formula_1_bym_rw1 <- data[,input$columncasesindata] ~ 1 +
                # x1 + x2 + x3 + x4 + x5 +  # (fixed effect - ปิดไว้ก่อน รอปรึกษาอาจารย์ก่อน)
                f(data$x1_id, x1, model = "iid") +
                f(data$x2_id, x2, model = "iid") +
                f(data$x3_id, x3, model = "iid") +
                f(data$x4_id, x4, model = "iid") +
                f(data$x5_id, x5, model = "iid") +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(data[,input$columndateindata], model = "rw1") +
                f(province_int, model = "iid")
            } else {
              formula_1_bym_rw1 <- data[,input$columncasesindata] ~ 1 +
                # x1 + x2 + x3 + x4 + x5 +  # (fixed effect - ปิดไว้ก่อน รอปรึกษาอาจารย์ก่อน)
                f(data$x1_id, x1, model = "iid") +
                f(data$x2_id, x2, model = "iid") +
                f(data$x3_id, x3, model = "iid") +
                f(data$x4_id, x4, model = "iid") +
                f(data$x5_id, x5, model = "iid") +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(province_int, model = "iid")
            }
            
            # computing part
            model <- inla(
              formula_1_bym_rw1,
              family = "poisson",
              data = data,
              E = data[, 'expected_value'],
              control.predictor = list(compute = TRUE),
              control.compute = list(
                dic = TRUE,
                waic = TRUE,
                cpo = TRUE,
                return.marginals.predictor = TRUE))
            
            
            rv$model <- model
            
            # ===== โมเดลที่ 2: Fixed-effect model (สำหรับ Overall / region-wide association) =====
            # เก็บโมเดลเดิม (random slope รายพื้นที่) ไว้ด้านบน และเพิ่มโมเดลนี้แยกต่างหากเพื่อหาค่า overall association
            # ตัด f(data$xN_id, xN, model="iid") ออก แล้วใส่ x1 + x2 + x3 + x4 + x5 เป็น fixed effect แทน
            # ส่วน f(area_id_col,"bym"), f(date,"rw1"), f(province_int,"iid") ยังคงไว้เป็น adjustment term เหมือนโมเดลเดิม
            # TODO: ยืนยันกับอาจารย์ว่าต้องตัด 3 เทอมนี้ออกด้วยหรือไม่ เพื่อให้เทียบเท่า CARBayesST ตรงๆ
            if (has_time_dimension) {
              formula_fixed_only <- data[,input$columncasesindata] ~ 1 +
                x1 + x2 + x3 + x4 + x5 +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(data[,input$columndateindata], model = "rw1") +
                f(province_int, model = "iid")
            } else {
              formula_fixed_only <- data[,input$columncasesindata] ~ 1 +
                x1 + x2 + x3 + x4 + x5 +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(province_int, model = "iid")
            }
            
            model_fixed <- inla(
              formula_fixed_only,
              family = "poisson",
              data = data,
              E = data[, 'expected_value'],
              control.predictor = list(compute = TRUE),
              control.compute = list(
                dic = TRUE,
                waic = TRUE,
                cpo = TRUE,
                return.marginals.predictor = TRUE))
            
            rv$model_fixed <- model_fixed
            
            rv$overall_rr_df <- compute_overall_rr(model_fixed, c(input$columncov1indata, input$columncov2indata, input$columncov3indata, input$columncov4indata, input$columncov5indata))
            rv$model_fit_df <- compute_model_fit_summary(model_fixed)
            rv$hyperpar_df <- compute_hyperpar_summary(model_fixed, c(input$columncov1indata, input$columncov2indata, input$columncov3indata, input$columncov4indata, input$columncov5indata))
            
            
            model2 <- rv$model
            
            # NOTE: reverted to random-slope-only RR (no fixed effect combined in). Fixed-effect version pending discussion with advisor.
            association_df <- (data.frame(
              c(exp(model2$summary.random$`data|S|x1_id`$mean)),
              c(exp(model2$summary.random$`data|S|x2_id`$mean)),
              c(exp(model2$summary.random$`data|S|x3_id`$mean)),
              c(exp(model2$summary.random$`data|S|x4_id`$mean)),
              c(exp(model2$summary.random$`data|S|x5_id`$mean))
            ) )
            
            
            colnames(association_df) <-  c(paste(input$columncov1indata,"_RR", sep=""),
                                           paste(input$columncov2indata,"_RR", sep=""),
                                           paste(input$columncov3indata,"_RR", sep=""),
                                           paste(input$columncov4indata,"_RR", sep=""),
                                           paste(input$columncov5indata,"_RR", sep=""))
            
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
            
            # ← เพิ่มก่อน rv$association_wsf_df <- association_wsf_df
            print(paste("DEBUG association_wsf_df columns:", paste(names(association_wsf_df), collapse=", ")))
            rv$association_wsf_df <- association_wsf_df
            
            
          }else if (not_empty(x1) & not_empty(x2) & not_empty(x3) & not_empty(x4) & not_empty(x5) & not_empty(x6) & !not_empty(x7)) {
            
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
            
            
            if (has_time_dimension) {
              formula_1_bym_rw1 <- data[,input$columncasesindata] ~ 1 +
                # x1 + x2 + x3 + x4 + x5 + x6 +  # (fixed effect - ปิดไว้ก่อน รอปรึกษาอาจารย์ก่อน)
                f(data$x1_id, x1, model = "iid") +
                f(data$x2_id, x2, model = "iid") +
                f(data$x3_id, x3, model = "iid") +
                f(data$x4_id, x4, model = "iid") +
                f(data$x5_id, x5, model = "iid") +
                f(data$x6_id, x6, model = "iid") +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(data[,input$columndateindata], model = "rw1") +
                f(province_int, model = "iid")
            } else {
              formula_1_bym_rw1 <- data[,input$columncasesindata] ~ 1 +
                # x1 + x2 + x3 + x4 + x5 + x6 +  # (fixed effect - ปิดไว้ก่อน รอปรึกษาอาจารย์ก่อน)
                f(data$x1_id, x1, model = "iid") +
                f(data$x2_id, x2, model = "iid") +
                f(data$x3_id, x3, model = "iid") +
                f(data$x4_id, x4, model = "iid") +
                f(data$x5_id, x5, model = "iid") +
                f(data$x6_id, x6, model = "iid") +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(province_int, model = "iid")
            }
            
            # computing part
            model <- inla(
              formula_1_bym_rw1,
              family = "poisson",
              data = data,
              E = data[, 'expected_value'],
              control.predictor = list(compute = TRUE),
              control.compute = list(
                dic = TRUE,
                waic = TRUE,
                cpo = TRUE,
                return.marginals.predictor = TRUE))
            
            
            rv$model <- model
            
            # ===== โมเดลที่ 2: Fixed-effect model (สำหรับ Overall / region-wide association) =====
            # เก็บโมเดลเดิม (random slope รายพื้นที่) ไว้ด้านบน และเพิ่มโมเดลนี้แยกต่างหากเพื่อหาค่า overall association
            # ตัด f(data$xN_id, xN, model="iid") ออก แล้วใส่ x1 + x2 + x3 + x4 + x5 + x6 เป็น fixed effect แทน
            # ส่วน f(area_id_col,"bym"), f(date,"rw1"), f(province_int,"iid") ยังคงไว้เป็น adjustment term เหมือนโมเดลเดิม
            # TODO: ยืนยันกับอาจารย์ว่าต้องตัด 3 เทอมนี้ออกด้วยหรือไม่ เพื่อให้เทียบเท่า CARBayesST ตรงๆ
            if (has_time_dimension) {
              formula_fixed_only <- data[,input$columncasesindata] ~ 1 +
                x1 + x2 + x3 + x4 + x5 + x6 +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(data[,input$columndateindata], model = "rw1") +
                f(province_int, model = "iid")
            } else {
              formula_fixed_only <- data[,input$columncasesindata] ~ 1 +
                x1 + x2 + x3 + x4 + x5 + x6 +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(province_int, model = "iid")
            }
            
            model_fixed <- inla(
              formula_fixed_only,
              family = "poisson",
              data = data,
              E = data[, 'expected_value'],
              control.predictor = list(compute = TRUE),
              control.compute = list(
                dic = TRUE,
                waic = TRUE,
                cpo = TRUE,
                return.marginals.predictor = TRUE))
            
            rv$model_fixed <- model_fixed
            
            rv$overall_rr_df <- compute_overall_rr(model_fixed, c(input$columncov1indata, input$columncov2indata, input$columncov3indata, input$columncov4indata, input$columncov5indata, input$columncov6indata))
            rv$model_fit_df <- compute_model_fit_summary(model_fixed)
            rv$hyperpar_df <- compute_hyperpar_summary(model_fixed, c(input$columncov1indata, input$columncov2indata, input$columncov3indata, input$columncov4indata, input$columncov5indata, input$columncov6indata))
            
            
            model2 <- rv$model
            
            # NOTE: reverted to random-slope-only RR (no fixed effect combined in). Fixed-effect version pending discussion with advisor.
            association_df <- (data.frame(
              c(exp(model2$summary.random$`data|S|x1_id`$mean)),
              c(exp(model2$summary.random$`data|S|x2_id`$mean)),
              c(exp(model2$summary.random$`data|S|x3_id`$mean)),
              c(exp(model2$summary.random$`data|S|x4_id`$mean)),
              c(exp(model2$summary.random$`data|S|x5_id`$mean)),
              c(exp(model2$summary.random$`data|S|x6_id`$mean))
            ) )
            
            
            colnames(association_df) <-  c(paste(input$columncov1indata,"_RR", sep=""),
                                           paste(input$columncov2indata,"_RR", sep=""),
                                           paste(input$columncov3indata,"_RR", sep=""),
                                           paste(input$columncov4indata,"_RR", sep=""),
                                           paste(input$columncov5indata,"_RR", sep=""),
                                           paste(input$columncov6indata,"_RR", sep=""))
            
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
            
            
            # ← เพิ่มก่อน rv$association_wsf_df <- association_wsf_df
            print(paste("DEBUG association_wsf_df columns:", paste(names(association_wsf_df), collapse=", ")))
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
            
            
            if (has_time_dimension) {
              formula_1_bym_rw1 <- data[,input$columncasesindata] ~ 1 +
                # x1 + x2 + x3 + x4 + x5 + x6 + x7 +  # (fixed effect - ปิดไว้ก่อน รอปรึกษาอาจารย์ก่อน)
                f(data$x1_id, x1, model = "iid") +
                f(data$x2_id, x2, model = "iid") +
                f(data$x3_id, x3, model = "iid") +
                f(data$x4_id, x4, model = "iid") +
                f(data$x5_id, x5, model = "iid") +
                f(data$x6_id, x6, model = "iid") +
                f(data$x7_id, x7, model = "iid") +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(data[,input$columndateindata], model = "rw1") +
                f(province_int, model = "iid")
            } else {
              formula_1_bym_rw1 <- data[,input$columncasesindata] ~ 1 +
                # x1 + x2 + x3 + x4 + x5 + x6 + x7 +  # (fixed effect - ปิดไว้ก่อน รอปรึกษาอาจารย์ก่อน)
                f(data$x1_id, x1, model = "iid") +
                f(data$x2_id, x2, model = "iid") +
                f(data$x3_id, x3, model = "iid") +
                f(data$x4_id, x4, model = "iid") +
                f(data$x5_id, x5, model = "iid") +
                f(data$x6_id, x6, model = "iid") +
                f(data$x7_id, x7, model = "iid") +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(province_int, model = "iid")
            }
            
            # computing part
            model <- inla(
              formula_1_bym_rw1,
              family = "poisson",
              data = data,
              E = data[, 'expected_value'],
              control.predictor = list(compute = TRUE),
              control.compute = list(
                dic = TRUE,
                waic = TRUE,
                cpo = TRUE,
                return.marginals.predictor = TRUE))
            
            
            
            rv$model <- model
            
            # ===== โมเดลที่ 2: Fixed-effect model (สำหรับ Overall / region-wide association) =====
            # เก็บโมเดลเดิม (random slope รายพื้นที่) ไว้ด้านบน และเพิ่มโมเดลนี้แยกต่างหากเพื่อหาค่า overall association
            # ตัด f(data$xN_id, xN, model="iid") ออก แล้วใส่ x1 + x2 + x3 + x4 + x5 + x6 + x7 เป็น fixed effect แทน
            # ส่วน f(area_id_col,"bym"), f(date,"rw1"), f(province_int,"iid") ยังคงไว้เป็น adjustment term เหมือนโมเดลเดิม
            # TODO: ยืนยันกับอาจารย์ว่าต้องตัด 3 เทอมนี้ออกด้วยหรือไม่ เพื่อให้เทียบเท่า CARBayesST ตรงๆ
            if (has_time_dimension) {
              formula_fixed_only <- data[,input$columncasesindata] ~ 1 +
                x1 + x2 + x3 + x4 + x5 + x6 + x7 +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(data[,input$columndateindata], model = "rw1") +
                f(province_int, model = "iid")
            } else {
              formula_fixed_only <- data[,input$columncasesindata] ~ 1 +
                x1 + x2 + x3 + x4 + x5 + x6 + x7 +
                f(data[[area_id_col]], model = "bym", graph = tha_adj) +
                f(province_int, model = "iid")
            }
            
            model_fixed <- inla(
              formula_fixed_only,
              family = "poisson",
              data = data,
              E = data[, 'expected_value'],
              control.predictor = list(compute = TRUE),
              control.compute = list(
                dic = TRUE,
                waic = TRUE,
                cpo = TRUE,
                return.marginals.predictor = TRUE))
            
            rv$model_fixed <- model_fixed
            
            rv$overall_rr_df <- compute_overall_rr(model_fixed, c(input$columncov1indata, input$columncov2indata, input$columncov3indata, input$columncov4indata, input$columncov5indata, input$columncov6indata, input$columncov7indata))
            rv$model_fit_df <- compute_model_fit_summary(model_fixed)
            rv$hyperpar_df <- compute_hyperpar_summary(model_fixed, c(input$columncov1indata, input$columncov2indata, input$columncov3indata, input$columncov4indata, input$columncov5indata, input$columncov6indata, input$columncov7indata))
            
            
            model2 <- rv$model
            
            # NOTE: reverted to random-slope-only RR (no fixed effect combined in). Fixed-effect version pending discussion with advisor.
            association_df <- (data.frame(
              c(exp(model2$summary.random$`data|S|x1_id`$mean)),
              c(exp(model2$summary.random$`data|S|x2_id`$mean)),
              c(exp(model2$summary.random$`data|S|x3_id`$mean)),
              c(exp(model2$summary.random$`data|S|x4_id`$mean)),
              c(exp(model2$summary.random$`data|S|x5_id`$mean)),
              c(exp(model2$summary.random$`data|S|x6_id`$mean)),
              c(exp(model2$summary.random$`data|S|x7_id`$mean))
            ) )
            
            
            
            colnames(association_df) <-  c(paste(input$columncov1indata,"_RR", sep=""),
                                           paste(input$columncov2indata,"_RR", sep=""),
                                           paste(input$columncov3indata,"_RR", sep=""),
                                           paste(input$columncov4indata,"_RR", sep=""),
                                           paste(input$columncov5indata,"_RR", sep=""),
                                           paste(input$columncov6indata,"_RR", sep=""),
                                           paste(input$columncov7indata,"_RR", sep=""))
            
            
            
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
            
            # ← เพิ่มก่อน rv$association_wsf_df <- association_wsf_df
            print(paste("DEBUG association_wsf_df columns:", paste(names(association_wsf_df), collapse=", ")))
            rv$association_wsf_df <- association_wsf_df
            
            
            
            
          } # จบ else
          
        }, error = function(e) {
          rv$errorMessageAssoc <- paste(
            "An error occurred in Association with Risk Factors. Please check the uploaded data again.",
            "<br>Error Message: ", e$message,
            sep = ""
          )
        })
        rv$runtime_asso <- as.numeric(difftime(Sys.time(), assoc_start_time, units = "secs"))  # เก็บเวลาที่ใช้คำนวณ
        rv$runtime_total <- as.numeric(difftime(Sys.time(), total_start_time, units = "secs"))  # เวลารวมทั้งหมด ตรงกับที่ผู้ใช้จับเองหลังกด Next
        # model2 <- rv$model
        
        print("===================== rv$errorMessageAssoc =====================")
        print(rv$errorMessageAssoc)
        
        
        
      }
    })
    
    # =====================================================
    
    
    
    
    # ==================================== map_distribution ==================================== 
    
    
    # ทำไม legend และค่าสีในแมพ เรียงจากมากไปน้อย
    # จาก https://stackoverflow.com/questions/40276569/reverse-order-in-r-leaflet-continuous-legend
    addLegend_decreasing <- function (map, position = c("topright", "bottomright", "bottomleft","topleft"),
                                      pal, values, na.label = "NA", bins = 7, colors, 
                                      opacity = 0.5, labels = NULL, labFormat = labelFormat(), 
                                      title = NULL, className = "info legend", layerId = NULL, 
                                      group = NULL, data = getMapData(map), decreasing = FALSE) {
      
      position <- match.arg(position)
      type <- "unknown"
      na.color <- NULL
      extra <- NULL
      if (!missing(pal)) {
        if (!missing(colors)) 
          stop("You must provide either 'pal' or 'colors' (not both)")
        if (missing(title) && inherits(values, "formula")) 
          title <- deparse(values[[2]])
        values <- evalFormula(values, data)
        type <- attr(pal, "colorType", exact = TRUE)
        args <- attr(pal, "colorArgs", exact = TRUE)
        na.color <- args$na.color
        if (!is.null(na.color) && col2rgb(na.color, alpha = TRUE)[[4]] == 
            0) {
          na.color <- NULL
        }
        if (type != "numeric" && !missing(bins)) 
          warning("'bins' is ignored because the palette type is not numeric")
        if (type == "numeric") {
          cuts <- if (length(bins) == 1) 
            pretty(values, bins)
          else bins   
          if (length(bins) > 2) 
            if (!all(abs(diff(bins, differences = 2)) <= 
                     sqrt(.Machine$double.eps))) 
              stop("The vector of breaks 'bins' must be equally spaced")
          n <- length(cuts)
          r <- range(values, na.rm = TRUE)
          cuts <- cuts[cuts >= r[1] & cuts <= r[2]]
          n <- length(cuts)
          p <- (cuts - r[1])/(r[2] - r[1])
          extra <- list(p_1 = p[1], p_n = p[n])
          p <- c("", paste0(100 * p, "%"), "")
          if (decreasing == TRUE){
            colors <- pal(rev(c(r[1], cuts, r[2])))
            labels <- rev(labFormat(type = "numeric", cuts))
          }else{
            colors <- pal(c(r[1], cuts, r[2]))
            labels <- rev(labFormat(type = "numeric", cuts))
          }
          colors <- paste(colors, p, sep = " ", collapse = ", ")
        }
        else if (type == "bin") {
          cuts <- args$bins
          n <- length(cuts)
          mids <- (cuts[-1] + cuts[-n])/2
          if (decreasing == TRUE){
            colors <- pal(rev(mids))
            labels <- rev(labFormat(type = "bin", cuts))
          }else{
            colors <- pal(mids)
            labels <- labFormat(type = "bin", cuts)
          }
        }
        else if (type == "quantile") {
          p <- args$probs
          n <- length(p)
          cuts <- quantile(values, probs = p, na.rm = TRUE)
          mids <- quantile(values, probs = (p[-1] + p[-n])/2, na.rm = TRUE)
          if (decreasing == TRUE){
            colors <- pal(rev(mids))
            labels <- rev(labFormat(type = "quantile", cuts, p))
          }else{
            colors <- pal(mids)
            labels <- labFormat(type = "quantile", cuts, p)
          }
        }
        else if (type == "factor") {
          v <- sort(unique(na.omit(values)))
          colors <- pal(v)
          labels <- labFormat(type = "factor", v)
          if (decreasing == TRUE){
            colors <- pal(rev(v))
            labels <- rev(labFormat(type = "factor", v))
          }else{
            colors <- pal(v)
            labels <- labFormat(type = "factor", v)
          }
        }
        else stop("Palette function not supported")
        if (!any(is.na(values))) 
          na.color <- NULL
      }
      else {
        if (length(colors) != length(labels)) 
          stop("'colors' and 'labels' must be of the same length")
      }
      legend <- list(colors = I(unname(colors)), labels = I(unname(labels)), 
                     na_color = na.color, na_label = na.label, opacity = opacity, 
                     position = position, type = type, title = title, extra = extra, 
                     layerId = layerId, className = className, group = group)
      invokeMethod(map, data, "addLegend", legend)
    }
    
    
    
    ###### map_distribution 1 ######### 
    # output$map_distribution <- renderLeaflet({
    #   tryCatch({
    #     rv$errorMessageMapDis <- NULL
    #     
    #     # ตรวจสอบว่า rv$datosOriginal และ rv$map มีข้อมูลหรือไม่
    #     if (is.null(rv$datosOriginal) | is.null(rv$map)) return(NULL)
    #     
    #     print("Plot: ...map distribution.1..")
    #     
    #     map <- rv$map
    #     data <- rv$datosOriginal
    #     
    #     # กรองข้อมูลตามตัวกรองที่กำหนด
    #     data <- data %>%
    #       filter(
    #         data[, input$columndateindata] %in% input$time_point_filter
    #       )
    #     
    #     print("Plot: ...กรองข้อมูล: map distribution.1..")
    #     
    #     
    #     # ตรวจสอบว่าหลังกรองข้อมูลแล้ว ยังมีข้อมูลหรือไม่
    #     # if (nrow(data) == 0) {
    #     #   showNotification("No data available after filtering", type = "error")
    #     #   return(NULL)
    #     # }
    #     
    #     datafiltered <- data
    #     ordercounties <- match(map@data[, input$columnidareainmap], datafiltered[, input$columnidareanamedata])
    #     map@data <- datafiltered[ordercounties, ]
    #     
    #     # ตรวจสอบว่า map@data มีข้อมูลหรือไม่
    #     # if (is.null(map@data) || nrow(map@data) == 0 || all(is.na(map@data[, input$columncasesindata]))) {
    #     #   showNotification("No valid data for mapping", type = "error")
    #     #   return(NULL)
    #     # }
    #     
    #     # สร้าง colorNumeric โดยจัดการ domain ที่ว่างหรือเป็น NA
    #     domain_values <- map@data[, input$columncasesindata]
    #     if (all(is.na(domain_values))) {
    #       domain_values <- c(0, 1) # ค่าเริ่มต้นหาก domain เป็น NA ทั้งหมด
    #     }
    #     
    #     pal <- colorNumeric(palette = input$color, domain = domain_values, na.color = "transparent")
    #     
    #     labels <- sprintf(
    #       "<strong> %s </strong> <br/>  %s : %s ",
    #       map@data[, input$columnidareanamedata], input$columncasesindata, map@data[, input$columncasesindata]
    #     ) %>%
    #       lapply(htmltools::HTML)
    #     
    #     print("Plot: ...แปลงข้อมูลแล้ว: map distribution.1..")
    #     
    #     # สร้างแผนที่
    #     leaflet(map) %>%
    #       addTiles() %>%
    #       addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Open Street Map") %>%
    #       addProviderTiles(providers$Esri.WorldImagery, group = "ESRI World Imagery") %>%
    #       addProviderTiles(providers$Esri.NatGeoWorldMap, group = "ESRI National Geographic World Map") %>%
    #       addProviderTiles(providers$CartoDB.Positron, group = "CartoDB Positron") %>%
    #       addPolygons(
    #         color = "grey", weight = 1,
    #         fillColor = ~pal(map@data[, input$columncasesindata]), fillOpacity = 0.7,
    #         highlightOptions = highlightOptions(weight = 4),
    #         label = labels,
    #         labelOptions = labelOptions(
    #           style = list("font-weight" = "normal", padding = "3px 8px"),
    #           textsize = "16px", direction = "auto"
    #         )
    #       ) %>%
    #       addLegend_decreasing(
    #         pal = pal, values = ~map@data[, input$columncasesindata], opacity = 0.7,
    #         title = input$columncasesindata, position = "bottomright",
    #         decreasing = TRUE
    #       ) %>%
    #       addLayersControl(
    #         baseGroups = c("Open Street Map", "ESRI World Imagery", "ESRI National Geographic World Map", "CartoDB Positron"),
    #         position = c("topleft"),
    #         options = layersControlOptions(collapsed = TRUE)
    #       ) %>%
    #       addFullscreenControl()
    #     print("Plot: ...สร้างเสร็จ: map distribution.1..")
    #     
    #   }, error = function(e) {
    #     rv$errorMessageMapDis <- paste(
    #       "An error occurred in Y Value Distribution Map.", 
    #       "<br>Please check the uploaded data again.",
    #       "<br>Error Message: ", e$message,
    #       sep = ""
    #     )
    #   })
    #   
    #   print("===================== rv$errorMessageMapDis =====================")
    #   print(rv$errorMessageMapDis)
    #   
    # })
    
    output$map_distribution <- renderLeaflet({
      
      if (is.null(rv$datosOriginal)| is.null(rv$map))
        return(NULL)
      
      print("Plot: ...map distribution.1..")
      
      map <- rv$map
      data <- rv$datosOriginal
      
      
      data <- data %>%
        filter(
          data[,input$columndateindata] %in% input$time_point_filter
          
        )
      
      
      
      # datafiltered <- data[which(data[,input$columndateindata] == input$time_point_filter), ]
      # datafiltered <- data
      # ordercounties <- match(map@data[, input$columnidareainmap], datafiltered[, input$columnidareanamedata])
      # map@data <- datafiltered[ordercounties, ]
      
      datafiltered <- data
      # Sample Data (Thailand) shapefile only has province NAME_1 (text), no numeric id that matches
      # "province_id", so keep name-based matching for it (safe: Thai province names have no duplicates).
      # For uploaded data, match by area id (unique code) to avoid problems with duplicate area names.
      match_key_data <- if (input$data_source_type == "sample" && identical(input$sample_dataset_choice, "thailand")) input$columnidareanamedata else input$columnidareaindata
      ordercounties <- match(map[[input$columnidareainmap]], datafiltered[[match_key_data]])
      
      # เก็บ geometry ไว้ก่อนเอา data มาเขียนทับ
      temp_geom <- st_geometry(map)
      map <- datafiltered[ordercounties, ]
      st_geometry(map) <- temp_geom
      
      
      # Create leaflet
      l <- leaflet(map) %>% addTiles()
      pal <- colorNumeric(palette = input$color, domain = map[[input$columncasesindata]])
      labels <- sprintf("<strong> %s </strong> <br/>  %s : %s ",
                        map[[input$columnidareanamedata]] , input$columncasesindata, map[[input$columncasesindata]]
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
          fillColor = ~ pal(map[[input$columncasesindata]]), fillOpacity = 0.7,
          highlightOptions = highlightOptions(weight = 4),
          label = labels,
          labelOptions = labelOptions(
            style = list(
              "font-weight" = "normal",
              padding = "3px 8px"
            ),
            textsize = "16px", direction = "auto"
          )
        ) %>%
        addLegend_decreasing(
          pal = pal, values = ~map[[input$columncasesindata]], opacity = 0.7,
          title = input$columncasesindata, position = "bottomright", 
          decreasing = TRUE
        ) %>%
        addLayersControl(baseGroups = c("Open Street Map", "ESRI World Imagery", "ESRI National Geographic World Map", "CartoDB Positron"
                                        #"Stamen Watercolor", "Stamen Toner"
        ),
        position = c("topleft"),
        options = layersControlOptions(collapsed =  TRUE)
        ) %>%
        addFullscreenControl()
      
      
      
    })
    
    
    
    
    ###### map_distribution 2 ######### 
    
    
    # output$map_distribution_2 <- renderLeaflet({
    #   
    #   tryCatch({
    #     rv$errorMessageMapDis_2 <- NULL
    #   if (is.null(rv$datosOriginal) | is.null(rv$map))
    #     return(NULL)
    #   
    #   print("Plot: ...map distribution.2..")
    #   
    #   
    #   map <- rv$map
    #   data <- rv$datosOriginal
    #   
    #   
    #   if(input$Expected_Value_from_csv == "yes" ){
    #     if(input$columnexpvalueindata != "" ){
    #       print("Check: ...this csv have expected value...")
    #       data['expected_value'] <- as.numeric(data[,input$columnexpvalueindata])
    #       
    #     }
    #     
    #   }else if (input$Expected_Value_from_csv == "no" ){
    #     print("Check: ...this csv doesn't have expected value...")
    #     
    #     # คิด (sum(case) / (pop))*population
    #     # sum case กับ pop ทั้งหมด เอามาหารกัน แล้วคูณด้วย pop ของจังหวัด,ปี นั้นๆ
    #     sum_case <- sum(data[,input$columncasesindata])
    #     sum_pop <- sum(data[,input$columnpopindata])
    #     
    #     divide_case_pop <- sum_case / sum_pop
    #     
    #     
    #     expected_value <- data[,input$columnpopindata] * divide_case_pop
    #     
    #     
    #     # Add a Column to a Data Frame
    #     data['expected_value'] <- expected_value
    #     
    #   }
    #   
    #   
    #   data <- data %>%
    #     filter(
    #       data[,input$columndateindata] %in% input$time_point_filter
    #     )
    #   
    #   # คำนวณค่า divisor ตามตัวเลือกของผู้ใช้และสำหรับแต่ละแถว
    #   if (input$divide_by == "columnpopindata") {
    #     data$adjusted_cases <- data[, input$columncasesindata] / data[, input$columnpopindata]
    #     
    #     print("===================== ตัวหาร columnpopindata =====================")
    #     print(data[, input$columnpopindata])
    #     
    #     
    #   } else if (input$divide_by == "expected_value") {
    #     data$adjusted_cases <- data[, input$columncasesindata] / data[, 'expected_value']
    #     
    #     print("===================== ตัวหาร expected_value =====================")
    #     print(data[, 'expected_value'])
    #   }
    #   
    #   datafiltered <- data
    #   ordercounties <- match(map@data[, input$columnidareainmap], datafiltered[, input$columnidareanamedata])
    #   map@data <- datafiltered[ordercounties, ]
    #   
    #   
    #   
    #   
    #   # print("================ datafiltered$adjusted_cases ==========================")
    #   # print(datafiltered$adjusted_cases)
    #   # 
    #   # 
    #   # 
    #   # print("================ datafiltered$adjusted_cases ==========================")
    #   # print(datafiltered$adjusted_cases)
    #   
    #   
    #   # สร้างแผนที่ leaflet
    #   l <- leaflet(map) %>% addTiles()
    #   pal <- colorNumeric(palette = input$color, domain = map@data$adjusted_cases)
    #   labels <- sprintf("<strong> %s </strong> <br/>  Adjusted Cases : %s ",
    #                     map@data[, input$columnidareanamedata], 
    #                     format(round(map@data$adjusted_cases, 5), scientific = FALSE)
    #   ) %>%
    #     lapply(htmltools::HTML)
    #   
    #   l %>%
    #     addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Open Street Map") %>%
    #     addProviderTiles(providers$Esri.WorldImagery, group = "ESRI World Imagery") %>%
    #     addProviderTiles(providers$Esri.NatGeoWorldMap, group = "ESRI National Geographic World Map") %>%
    #     addProviderTiles(providers$CartoDB.Positron, group = "CartoDB Positron") %>%
    #     addPolygons(
    #       color = "grey", weight = 1,
    #       fillColor = ~ pal(map@data$adjusted_cases), fillOpacity = 0.7,
    #       highlightOptions = highlightOptions(weight = 4),
    #       label = labels,
    #       labelOptions = labelOptions(
    #         style = list(
    #           "font-weight" = "normal",
    #           padding = "3px 8px"
    #         ),
    #         textsize = "16px", direction = "auto"
    #       )
    #     ) %>%
    #     addLegend_decreasing(
    #       pal = pal, values = ~map@data$adjusted_cases, opacity = 0.7,
    #       title = "Adjusted Cases", position = "bottomright", 
    #       decreasing = TRUE
    #     ) %>%
    #     addLayersControl(baseGroups = c("Open Street Map", "ESRI World Imagery", "ESRI National Geographic World Map", "CartoDB Positron"),
    #                      position = c("topleft"),
    #                      options = layersControlOptions(collapsed =  TRUE)
    #     ) %>%
    #     addFullscreenControl()
    #   
    #   }, error = function(e) {
    #     rv$errorMessageMapDis_2 <- paste(
    #       "An error occurred in Normalized Y Value Distribution Map.",
    #       "<br>Please check the uploaded data again.",
    #       "<br>Error Message: ", e$message,
    #       sep = ""
    #     )
    #   })
    #   
    #   print("===================== rv$errorMessageMapDis_2 =====================")
    #   print(rv$errorMessageMapDis_2)
    #   
    #   
    # })
    # 
    
    output$map_distribution_2 <- renderLeaflet({
      
      if (is.null(rv$datosOriginal) | is.null(rv$map))
        return(NULL)
      
      print("Plot: ...map distribution.2..")
      
      
      map <- rv$map
      data <- rv$datosOriginal
      
      
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
      
      
      data <- data %>%
        filter(
          data[,input$columndateindata] %in% input$time_point_filter
        )
      
      # คำนวณค่า divisor ตามตัวเลือกของผู้ใช้และสำหรับแต่ละแถว
      if (input$divide_by == "columnpopindata") {
        data$adjusted_cases <- data[, input$columncasesindata] / data[, input$columnpopindata]
        
        print("===================== ตัวหาร columnpopindata =====================")
        print(data[, input$columnpopindata])
        
        
      } else if (input$divide_by == "expected_value") {
        data$adjusted_cases <- data[, input$columncasesindata] / data[, 'expected_value']
        
        print("===================== ตัวหาร expected_value =====================")
        print(data[, 'expected_value'])
      }
      
      datafiltered <- data
      # Sample Data (Thailand) shapefile only has province NAME_1 (text), no numeric id that matches
      # "province_id", so keep name-based matching for it (safe: Thai province names have no duplicates).
      # For uploaded data, match by area id (unique code) to avoid problems with duplicate area names.
      match_key_data <- if (input$data_source_type == "sample" && identical(input$sample_dataset_choice, "thailand")) input$columnidareanamedata else input$columnidareaindata
      ordercounties <- match(map[[input$columnidareainmap]], datafiltered[[match_key_data]])
      
      # เก็บ geometry ไว้ก่อนเอา data มาเขียนทับ
      temp_geom <- st_geometry(map)
      map <- datafiltered[ordercounties, ]
      st_geometry(map) <- temp_geom
      
      
      
      
      print("================ datafiltered$adjusted_cases ==========================")
      print(datafiltered$adjusted_cases)
      
      
      
      print("================ datafiltered$adjusted_cases ==========================")
      print(datafiltered$adjusted_cases)
      
      
      # สร้างแผนที่ leaflet
      l <- leaflet(map) %>% addTiles()
      pal <- colorNumeric(palette = input$color, domain = map$adjusted_cases)
      labels <- sprintf("<strong> %s </strong> <br/>  Adjusted Cases : %s ",
                        map[[input$columnidareanamedata]], 
                        format(round(map$adjusted_cases, 5), scientific = FALSE)
      ) %>%
        lapply(htmltools::HTML)
      
      l %>%
        addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Open Street Map") %>%
        addProviderTiles(providers$Esri.WorldImagery, group = "ESRI World Imagery") %>%
        addProviderTiles(providers$Esri.NatGeoWorldMap, group = "ESRI National Geographic World Map") %>%
        addProviderTiles(providers$CartoDB.Positron, group = "CartoDB Positron") %>%
        addPolygons(
          color = "grey", weight = 1,
          fillColor = ~ pal(map$adjusted_cases), fillOpacity = 0.7,
          highlightOptions = highlightOptions(weight = 4),
          label = labels,
          labelOptions = labelOptions(
            style = list(
              "font-weight" = "normal",
              padding = "3px 8px"
            ),
            textsize = "16px", direction = "auto"
          )
        ) %>%
        addLegend_decreasing(
          pal = pal, values = ~map$adjusted_cases, opacity = 0.7,
          title = "Adjusted Cases", position = "bottomright", 
          decreasing = TRUE
        ) %>%
        addLayersControl(baseGroups = c("Open Street Map", "ESRI World Imagery", "ESRI National Geographic World Map", "CartoDB Positron"),
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
        # Sample Data (Thailand) shapefile only has province NAME_1 (text), no numeric id that matches
        # "province_id", so keep name-based matching for it (safe: Thai province names have no duplicates).
        # For uploaded data, match by area id (unique code) to avoid problems with duplicate area names.
        match_key_data <- if (input$data_source_type == "sample" && identical(input$sample_dataset_choice, "thailand")) input$columnidareanamedata else input$columnidareaindata
        ordercounties <- match(map[[input$columnidareainmap]], datafiltered[[match_key_data]])
        
        # เก็บ geometry ไว้ก่อนเอา data มาเขียนทับ
        temp_geom <- st_geometry(map)
        map <- datafiltered[ordercounties, ]
        st_geometry(map) <- temp_geom
        
        # print(map@data[, "label"])
        
        # Create leaflet c("red", "blue")
        l <- leaflet(map) %>% addTiles()
        pal <- colorFactor(palette = input$color_cluster, domain = map[["hotspot label"]],
                           levels = c("hotspot", "non-hotspot"))
        labels <- sprintf("<strong> %s </strong> <br/> hotspot label : %s ",
                          map[[input$columnidareanamedata]] ,  map[["hotspot label"]]
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
            fillColor = ~ pal(map[["hotspot label"]]), fillOpacity = 0.7,
            highlightOptions = highlightOptions(weight = 4),
            label = labels,
            labelOptions = labelOptions(
              style = list(
                "font-weight" = "normal",
                padding = "3px 8px"
              ),
              textsize = "16px", direction = "auto"
            )
          ) %>%
          addLegend(
            pal = pal, values = ~map[["hotspot label"]] , opacity = 0.7,
            title = "hotspot label", position = "bottomright"
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
    
    
    # output$map_risk_fac <- renderLeaflet({
    #   
    #   if (is.null(rv$datosOriginal) | is.null(rv$map))
    #     return(NULL)
    #   
    #   print("Plot: ...map risk factor...")
    #   
    #   map <- rv$map
    #   
    #   association_wsf_df <- rv$association_wsf_df 
    #   
    #   datafiltered <- association_wsf_df
    #   ordercounties <- match(map@data[, input$columnidareainmap], datafiltered[, input$columnidareainmap])
    #   map@data <- datafiltered[ordercounties, ]
    #   
    #   
    #   if (input$risk_factor_filter == paste(input$columncov1indata,"_RR", sep="")){
    #     sig_col <- map@data[, paste(input$columncov1indata,"_significance", sep="")]
    #     
    #   } else if (input$risk_factor_filter == paste(input$columncov2indata,"_RR", sep="")) {
    #     sig_col <- map@data[, paste(input$columncov2indata,"_significance", sep="")]
    #     
    #   } else if (input$risk_factor_filter == paste(input$columncov3indata,"_RR", sep="")) {
    #     sig_col <- map@data[, paste(input$columncov3indata,"_significance", sep="")]
    #     
    #   } else if (input$risk_factor_filter == paste(input$columncov4indata,"_RR", sep="")) {
    #     sig_col <- map@data[, paste(input$columncov4indata,"_significance", sep="")]
    #     
    #   } else if (input$risk_factor_filter == paste(input$columncov5indata,"_RR", sep="")) {
    #     sig_col <- map@data[, paste(input$columncov5indata,"_significance", sep="")]
    #     
    #   } else if (input$risk_factor_filter == paste(input$columncov6indata,"_RR", sep="")) {
    #     sig_col <- map@data[, paste(input$columncov6indata,"_significance", sep="")]
    #     
    #   } else if (input$risk_factor_filter == paste(input$columncov7indata,"_RR",sep="")) {
    #     sig_col <- map@data[, paste(input$columncov7indata,"_significance", sep="")]
    #     
    #   } 
    #   
    #   
    #   # Create leaflet
    #   l <- leaflet(map) %>% addTiles()
    #   pal <- colorNumeric(palette = input$color_asso, domain = map@data[, input$risk_factor_filter])
    #   labels <- sprintf("<strong> %s </strong> <br/>  %s : %s <br/> Significance: %s",
    #                     map@data[, input$columnidareainmap] , input$risk_factor_filter, map@data[, input$risk_factor_filter] , sig_col #paste(input$columncov1indata,"_significance", sep="")
    #   ) %>%
    #     lapply(htmltools::HTML)
    #   
    #   l %>%
    #     addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Open Street Map") %>%
    #     addProviderTiles(providers$Esri.WorldImagery, group = "ESRI World Imagery") %>%
    #     addProviderTiles(providers$Esri.NatGeoWorldMap, group = "ESRI National Geographic World Map") %>%
    #     addProviderTiles(providers$CartoDB.Positron, group = "CartoDB Positron") %>%
    #     #addProviderTiles(providers$Stamen.Watercolor, group = "Stamen Watercolor") %>%
    #     #addProviderTiles(providers$Stamen.Toner, group = "Stamen Toner") %>%
    #     
    #     addPolygons(
    #       color = "grey", weight = 1,
    #       fillColor = ~ pal(map@data[, input$risk_factor_filter]), fillOpacity = 0.7,
    #       highlightOptions = highlightOptions(weight = 4),
    #       label = labels,
    #       labelOptions = labelOptions(
    #         style = list(
    #           "font-weight" = "normal",
    #           padding = "3px 8px"
    #         ),
    #         textsize = "15px", direction = "auto"
    #       )
    #     ) %>%
    #     addLegend_decreasing(
    #       pal = pal, values = ~map@data[, input$risk_factor_filter], opacity = 0.7,
    #       title = input$risk_factor_filter, position = "bottomright",
    #       decreasing = TRUE
    #     ) %>%
    #     addLayersControl(baseGroups = c("Open Street Map", "ESRI World Imagery", "ESRI National Geographic World Map", "CartoDB Positron"
    #                                     #"Stamen Watercolor", "Stamen Toner"
    #     ),
    #     position = c("topleft"),
    #     options = layersControlOptions(collapsed =  TRUE)
    #     )%>%
    #     addFullscreenControl()
    #   
    #   
    # })
    # 
    
    
    output$model_type_badge <- renderUI({
      if (is.null(rv$has_time_dimension)) return(NULL)
      
      if (isTRUE(rv$has_time_dimension)) {
        label <- "Spatio-Temporal model"
        tip   <- "The uploaded data has more than one time point, so the model includes a temporal (RW1) random effect in addition to the spatial (BYM) random effect."
        bg    <- "#735DFB"
      } else {
        label <- "Spatial model"
        tip   <- "The uploaded data has only one time point, so the model includes only the spatial (BYM) random effect, with no temporal (RW1) term."
        bg    <- "#999999"
      }
      
      HTML(paste0(
        '<span style="display:inline-block; background:', bg, '; color:white; padding:2px 10px; ',
        'border-radius:100px; font-size:12px; vertical-align:middle;">', label, '</span>',
        '<span class="mr-tip">',
        '<i class="fa fa-info-circle mr-tip-icon"></i>',
        '<span class="mr-tip-text">', tip, '</span></span>'
      ))
    })
    
    
    # ====================================
    # ตารางแบบเรียบง่าย ไม่มีแถบสี (เพื่อไม่ให้ตีความสัดส่วนผิด เพราะค่า % มักเล็กมาก)
    # ====================================
    render_bar_table <- function(df, pct_col, bold_col = NULL) {
      dt <- datatable(
        df,
        rownames = FALSE,
        options = list(dom = "t", paging = FALSE, ordering = FALSE),
        class = "stripe hover"
      )
      
      if (!is.null(bold_col)) {
        dt <- dt %>% formatStyle(bold_col, fontWeight = "bold")
      }
      dt
    }
    
    # Cluster Detection Results section is disabled for now (UI hidden above) -
    # commenting out this server output too so it doesn't run in the background.
    # output$cluster_summary_table <- renderDT({
    #   if (is.null(rv$data)) return(NULL)
    #   df <- compute_cluster_summary(rv$data, input$columnidareaindata)
    #   if (is.null(df)) return(NULL)
    #   render_bar_table(df, "% of total", bold_col = "Metric")
    # })
    
    
    output$significance_summary_table <- renderDT({
      if (is.null(rv$association_wsf_df)) return(NULL)
      df <- compute_significance_summary(rv$association_wsf_df)
      if (is.null(df)) return(NULL)
      render_bar_table(df, "% significant", bold_col = "Risk factor")
    })
    
    
    output$overall_rr_model_line <- renderUI({
      effects_txt <- if (isTRUE(rv$has_time_dimension)) {
        "spatial &amp; temporal random effects"
      } else {
        "spatial random effects"
      }
      HTML(paste0(
        '<p style="margin:0 0 8px 0; font-size:13px; color:#666;"><strong>Model:</strong> ',
        'Fixed-effect model \u2014 one estimate for the whole region, adjusted for ', effects_txt, '.</p>'
      ))
    })
    
    
    output$overall_rr_table <- renderTable({
      if (is.null(rv$overall_rr_df)) return(NULL)
      
      df <- rv$overall_rr_df
      
      # เลือกจำนวนทศนิยมแบบไดนามิกทั้งตาราง (ใช้ค่าเดียวกันทุกแถวเพื่อให้คอลัมน์ตรงกัน)
      # เพิ่มทศนิยมขึ้นเรื่อยๆ จนกว่า lower/upper ของทุกแถวจะแยกแยะออกจากกันได้ (ไม่ round จนเท่ากันหมดเป็น 1.000)
      choose_decimals <- function(lower, upper, min_d = 3, max_d = 6) {
        d <- min_d
        while (d < max_d && any(round(lower, d) == round(upper, d))) d <- d + 1
        d
      }
      dgt <- choose_decimals(df$RR_lower, df$RR_upper)
      
      out <- data.frame(
        `Risk factor` = df$covariate,
        `RR (mean)` = formatC(df$RR_mean, format = "f", digits = dgt),
        `95% CI lower` = formatC(df$RR_lower, format = "f", digits = dgt),
        `95% CI upper` = formatC(df$RR_upper, format = "f", digits = dgt),
        `Significant` = df$Significant,
        `Interpretation` = df$Interpretation,
        check.names = FALSE
      )
      # ใส่ tooltip อธิบายวิธีคิดคอลัมน์ Interpretation และเกณฑ์ significant ไว้ที่หัวตาราง
      # (ต้องปิด sanitize เพื่อให้ HTML/tooltip แสดงผลได้)
      colnames(out)[5] <- paste0(
        'Significant <span class="mr-tip"><i class="fa fa-info mr-tip-icon"></i>',
        '<span class="mr-tip-text">Yes if the 95% CI excludes RR = 1 (i.e. RR &gt; 1 or RR &lt; 1 throughout the interval); ',
        'No if the interval still includes 1.</span></span>'
      )
      colnames(out)[6] <- paste0(
        'Interpretation <span class="mr-tip"><i class="fa fa-info mr-tip-icon"></i>',
        '<span class="mr-tip-text">Calculated as (RR mean \u2212 1) \u00d7 100%, i.e. the % change in risk per one-unit ',
        'increase in the risk factor. Only labelled "significant" when the 95% CI excludes RR = 1.</span></span>'
      )
      out
    }, striped = TRUE, bordered = TRUE, spacing = "s", sanitize.text.function = function(x) x)
    
    
    output$model_fit_table <- renderTable({
      if (is.null(rv$model_fit_df)) return(NULL)
      rv$model_fit_df
    }, striped = TRUE, bordered = TRUE, spacing = "s")
    
    
    output$hyperpar_table <- renderTable({
      if (is.null(rv$hyperpar_df)) return(NULL)
      rv$hyperpar_df
    }, striped = TRUE, bordered = TRUE, spacing = "s")
    
    
    # ชื่อแผนที่ของหน้า Cluster Detection - บอกว่าแผนที่นี้สื่อถึงอะไร (hotspot ของ case count คอลัมน์ไหน)
    # จัดรูปแบบเวลาที่ใช้คำนวณโมเดลให้อ่านง่าย (วินาที -> "Xs" หรือ "X min Y sec")
    format_runtime <- function(secs) {
      if (is.null(secs) || is.na(secs)) return(NULL)
      if (secs < 60) {
        sprintf("%.1f seconds", secs)
      } else {
        m <- floor(secs / 60)
        s <- round(secs %% 60)
        sprintf("%d min %d sec", m, s)
      }
    }
    
    # การ์ดเดียวใช้ร่วมกันทั้ง 2 หน้า ให้หน้าตาเหมือนกันทุกจุด
    # โชว์ทั้งเวลาของโมเดลนี้ และเวลารวมทั้งหมด (เพราะหน้าเว็บจะไม่อัปเดตจนกว่า Cluster+Association จะเสร็จทั้งคู่
    # ผู้ใช้ที่จับเวลาเองตั้งแต่กดปุ่ม Next จะเห็นเป็นเวลารวมนี้ ไม่ใช่แค่เวลาของโมเดลเดียว)
    runtime_card_ui <- function(secs, total_secs = NULL) {
      req(secs)
      total_html <- if (!is.null(total_secs) && !is.na(total_secs)) {
        paste0(" &nbsp;·&nbsp; Total analysis time (Cluster + Association): <strong>",
               format_runtime(total_secs), "</strong>")
      } else {
        ""
      }
      div(class = "box-white", style = "display:inline-block; padding:8px 16px; margin: 6px 0 10px 0;",
          HTML(paste0("<i class='uil uil-clock'></i> This model computed in <strong>",
                      format_runtime(secs), "</strong>", total_html))
      )
    }
    
    # Card แสดงเวลาที่ใช้คำนวณโมเดล Cluster Detection
    output$runtime_card_cluster <- renderUI({
      runtime_card_ui(rv$runtime_cluster, rv$runtime_total)
    })
    
    # Card แสดงเวลาที่ใช้คำนวณโมเดล Association with Risk Factors
    output$runtime_card_asso <- renderUI({
      runtime_card_ui(rv$runtime_asso, rv$runtime_total)
    })
    
    
    output$map_cluster_title <- renderUI({
      req(input$columncasesindata)
      HTML(paste0(
        '<h4 style="margin-bottom:2px;">Hotspot Map: ',
        '<span style="display:inline-block; background:#735DFB; color:white; padding:2px 12px; ',
        'border-radius:100px; font-size:15px; font-weight:600; vertical-align:middle;">',
        input$columncasesindata, '</span></h4>',
        '<p style="margin-top:6px; font-size:13px; color:#666;">Areas classified as a <strong>hotspot</strong> have a case count above the baseline threshold for the selected time point(s). See legend on the map for colors.</p>'
      ))
    })
    
    
    # ชื่อแผนที่ของหน้า Association with Risk Factors - บอกว่าแผนที่นี้สื่อถึงอะไร (RR ของ risk factor ไหน)
    output$map_risk_fac_title <- renderUI({
      req(input$risk_factor_filter)
      HTML(paste0(
        '<h4 style="margin-bottom:2px;">Relative Risk (RR) Map: ',
        '<span style="display:inline-block; background:#735DFB; color:white; padding:2px 12px; ',
        'border-radius:100px; font-size:15px; font-weight:600; vertical-align:middle;">',
        input$risk_factor_filter, '</span></h4>',
        '<p style="margin-top:6px; font-size:13px; color:#666;">Estimated relative risk (RR) of this risk factor for each area.</p>'
      ))
    })
    
    
    output$map_risk_fac <- renderLeaflet({
      
      if (is.null(rv$datosOriginal) | is.null(rv$map) | is.null(rv$association_wsf_df))
        return(NULL)
      
      print("Plot: ...map risk factor...")
      
      map <- rv$map
      association_wsf_df <- rv$association_wsf_df
      
      area_col <- input$columnidareainmap
      cols_to_join <- names(association_wsf_df)[!names(association_wsf_df) %in% names(map)]
      cols_to_join <- c(area_col, cols_to_join)
      map <- merge(map, association_wsf_df[, cols_to_join, drop = FALSE],
                   by = area_col, all.x = TRUE)
      
      # เพิ่มชื่อพื้นที่ (area name) เข้ามาด้วย เพราะ map เดิมมีแต่รหัสพื้นที่ (area id) จาก shapefile เท่านั้น
      match_key_data <- if (input$data_source_type == "sample" && identical(input$sample_dataset_choice, "thailand")) input$columnidareanamedata else input$columnidareaindata
      name_lookup <- unique(rv$data[, c(match_key_data, input$columnidareanamedata)])
      names(name_lookup) <- c(area_col, "area_display_name")
      map <- merge(map, name_lookup, by = area_col, all.x = TRUE)
      
      sig_col <- NULL
      
      if (input$risk_factor_filter == paste(input$columncov1indata,"_RR", sep="")){
        sig_col <- map[[paste(input$columncov1indata,"_significance", sep="")]]
        
      } else if (input$risk_factor_filter == paste(input$columncov2indata,"_RR", sep="")) {
        sig_col <- map[[paste(input$columncov2indata,"_significance", sep="")]]
        
      } else if (input$risk_factor_filter == paste(input$columncov3indata,"_RR", sep="")) {
        sig_col <- map[[paste(input$columncov3indata,"_significance", sep="")]]
        
      } else if (input$risk_factor_filter == paste(input$columncov4indata,"_RR", sep="")) {
        sig_col <- map[[paste(input$columncov4indata,"_significance", sep="")]]
        
      } else if (input$risk_factor_filter == paste(input$columncov5indata,"_RR", sep="")) {
        sig_col <- map[[paste(input$columncov5indata,"_significance", sep="")]]
        
      } else if (input$risk_factor_filter == paste(input$columncov6indata,"_RR", sep="")) {
        sig_col <- map[[paste(input$columncov6indata,"_significance", sep="")]]
        
      } else if (input$risk_factor_filter == paste(input$columncov7indata,"_RR",sep="")) {
        sig_col <- map[[paste(input$columncov7indata,"_significance", sep="")]]
      } 
      
      # Create leaflet
      l <- leaflet(map) %>% addTiles()
      pal <- colorNumeric(palette = input$color_asso, domain = map[[input$risk_factor_filter]])
      labels <- sprintf("<strong> %s </strong> <br/>  %s : %s <br/> Significance: %s",
                        map[["area_display_name"]] , input$risk_factor_filter, map[[input$risk_factor_filter]] , sig_col
      ) %>%
        lapply(htmltools::HTML)
      
      l %>%
        addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Open Street Map") %>%
        addProviderTiles(providers$Esri.WorldImagery, group = "ESRI World Imagery") %>%
        addProviderTiles(providers$Esri.NatGeoWorldMap, group = "ESRI National Geographic World Map") %>%
        addProviderTiles(providers$CartoDB.Positron, group = "CartoDB Positron") %>%
        
        addPolygons(
          color = ifelse(sig_col == "significant", "black", "grey"), 
          weight = ifelse(sig_col == "significant", 5, 1), 
          fillColor = ~ pal(map[[input$risk_factor_filter]]), 
          fillOpacity = 0.7,
          label = labels,
          labelOptions = labelOptions(
            style = list(
              "font-weight" = "normal", # ข้อความจะเป็นตัวหนา
              padding = "5px 10px" # ขนาด padding ใหญ่ขึ้น
            ),
            textsize = "16px", # ขนาดตัวอักษรใหญ่ขึ้น
            direction = "auto"
          )
        ) %>%
        addLegend_decreasing(
          pal = pal, values = ~map[[input$risk_factor_filter]], opacity = 0.7,
          title = input$risk_factor_filter, position = "bottomright",
          decreasing = TRUE
        ) %>%
        addLayersControl(baseGroups = c("Open Street Map", "ESRI World Imagery", "ESRI National Geographic World Map", "CartoDB Positron"),
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
    
    
    
    # ปุ่ม Download sample data (.csv) - โหลดไฟล์ตัวอย่างดิบ (ไม่ผ่านโมเดล) ตาม dataset ที่เลือกในการ์ด Use Sample Data
    output$download_sample_csv <- downloadHandler(
      filename = function() {
        switch(input$sample_dataset_choice,
               "pollution"      = "pollution_health_data.csv",
               "pollution_2007" = "pollution_health_data_2007.csv",
               "suicide_th_data_sample_have_e_value.csv")
      },
      content = function(file) {
        src <- switch(input$sample_dataset_choice,
                      "pollution"      = "sample data/pollution_health_data.csv",
                      "pollution_2007" = "sample data/pollution_health_data_2007.csv",
                      "sample data/suicide_th_data_sample_have_e_value.csv")
        file.copy(src, file)
      }
    )
    
    
    output$downloadData_cluster <- downloadHandler(
      filename = function() {
        paste0(data_file_base_name(), "_result-cluster-detection_", Sys.Date(), ".csv")
      },
      content = function(file) {
        write.csv(dataresult_cluster(), file)
      }
    )
    
    
    dataresult_asso_risk <- reactive({
      req(rv$association_wsf_df)
      
      not_empty <- function(x) x != "" & x != "-"
      
      covs <- list(x1 = input$columncov1indata,
                   x2 = input$columncov2indata,
                   x3 = input$columncov3indata,
                   x4 = input$columncov4indata,
                   x5 = input$columncov5indata,
                   x6 = input$columncov6indata,
                   x7 = input$columncov7indata)
      active_covs <- Filter(not_empty, unlist(covs))
      
      has_lower <- "lowerbound" %in% input$asso_select_column
      has_upper <- "upperbound" %in% input$asso_select_column
      has_sig   <- "significance" %in% input$asso_select_column
      
      area_col <- input$columnidareainmap
      df_wide <- tryCatch(sf::st_drop_geometry(rv$association_wsf_df),
                          error = function(e) as.data.frame(rv$association_wsf_df))
      
      # เพิ่มชื่อพื้นที่ (area name) เข้ามาด้วย ไม่ใช่แค่รหัสพื้นที่ (area id) เหมือนที่แก้ในแผนที่ด้านบน
      match_key_data <- if (input$data_source_type == "sample" && identical(input$sample_dataset_choice, "thailand")) input$columnidareanamedata else input$columnidareaindata
      name_lookup <- unique(rv$data[, c(match_key_data, input$columnidareanamedata)])
      names(name_lookup) <- c(area_col, "area_name")
      df_wide <- merge(df_wide, name_lookup, by = area_col, all.x = TRUE)
      
      # จัดเป็น long/tidy format: 1 แถวต่อ (พื้นที่ x risk factor) แทนที่จะเป็น 1 แถวต่อพื้นที่ 
      # แล้วมีคอลัมน์เพิ่มไปเรื่อยๆ ตามจำนวน risk factor ที่เลือก (คอลัมน์คงที่เสมอไม่ว่าจะเลือกกี่ตัวแปร)
      long_list <- lapply(active_covs, function(cov_name) {
        out <- data.frame(
          area_id     = df_wide[[area_col]],
          area_name   = df_wide[["area_name"]],
          risk_factor = cov_name,
          RR          = df_wide[[paste0(cov_name, "_RR")]],
          stringsAsFactors = FALSE
        )
        if (has_lower) out$lower_bound_95 <- df_wide[[paste0(cov_name, "_lowerbound")]]
        if (has_upper) out$upper_bound_95 <- df_wide[[paste0(cov_name, "_upperbound")]]
        if (has_sig)   out$significance   <- df_wide[[paste0(cov_name, "_significance")]]
        out
      })
      
      df_long <- do.call(rbind, long_list)
      rownames(df_long) <- NULL
      df_long
    })
    
    
    output$downloadData_asso_risk <- downloadHandler(
      filename = function() {
        paste0(data_file_base_name(), "_result-association-risk-factor_", Sys.Date(), ".csv")
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
    
  }) # end shinyApp


##------------------------------Run Shiny App--------------------------------##

shinyApp(ui = ui, server = server)