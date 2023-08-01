# STEHealth-Application 🌏💻

**STEHealth** (It stands for **S**patiotemporal **E**pidemiological **Health**) is a shiny application for analyzing space-time pattern, **cluster detection**, and **association with risk factors** of health outcomes, which allows users to import their own data, analyze, and visualize.

This application is part of **```Spatiotemporal analysis with application development for epidemiological study of suicide mortality: From global perspectives to a case study in Thailand 💀📝```** senior project of the Princess Srisavangavadhana College of Medicine, [Chulabhorn Royal Academy](https://www.cra.ac.th/th/home) and the Department of Computer Engineering, [King Mongkut's University of Technology Thonburi](https://www.kmutt.ac.th/en/).

<p align="center">
<img src="https://github.com/mill-ornrakorn/STEHealth-Application/blob/main/pic%20for%20readme/Poster_Project_No74_resize.png?raw=true" alt= "Poster_Project" height="600">
</p>


### 💡Feature
1. **```Upload data```** for analysis into the application for analysis.

2. **```Analysis```** for spatial and spatiotemporal epidemiological studies and **cluster detection** and **association with risk factors**

3. **```Download results```** of analysis from the application.


<p align="center">
<img src="https://github.com/mill-ornrakorn/STEHealth-Application/blob/main/pic%20for%20readme/STEHealth_gif_Cluster%20detection.gif?raw=true" alt= “STEHealth_Manual” height="400">
</br>
Cluster detection

</p>


<p align="center">
<img src="https://github.com/mill-ornrakorn/STEHealth-Application/blob/main/pic%20for%20readme/STEHealth_gif_Association%20with%20risk%20factors.gif?raw=true" alt= “STEHealth_Manual” height="400" > 
</br>
Association with risk factors
</p>


### 🔎Target users
1. **Primary:** Epidemiologists and Public health researchers
2. **Secondary:** Public health professional and Policy makers


### 📝Developer Team
1. [Papin Thanutchapat](https://github.com/Jappapin); Space-time pattern detection model and association with risk factors for suicide.
2. [Chiraphat Phoncharoenwirote](https://github.com/Chiraphatt); Insights information of spatiotemporal epidemiology of suicide mortality and association with risk factors analysis.
3. [Ornrakorn Mekchaiporn](https://github.com/mill-ornrakorn); Application design and development.


### 📚Advisor
1. **Dr. Unchalisa Taetragool**; Department of Computer Engineering, Faculty of Engineering, King Mongkut's University of Technology Thonburi
2. **Asst. Prof. Dr. Chawarat Rotejanaprasert**; Department of Tropical Hygiene, Faculty of Tropical Medicine, Mahidol University
3. **Asst. Prof. Dr. Peerut Chienwichai**; Princess Srisavangavadhana College of Medicine, Chulabhorn Royal Academy


## Installation 💻
There are three installation methods.

### **1️⃣ The first method:** STEHealthApp package 

This method is suitable for **users who already have [R](https://www.r-project.org/) and [RStudio](https://posit.co/)** and prefer not to load the .zip file, especially those who have been using RStudio for a while.

1. Install **STEHealthApp package** by running the following line of code in RStudio:
```
devtools::install_github("mill-ornrakorn/STEHealth-Application", ref="STEHealthApp")
```

2. Install **[R-INLA](https://www.r-inla.org/home) and [capture](https://github.com/dreamRs/capture) packages** by running the following line of code in RStudio:
```
install.packages("INLA",repos=c(getOption("repos"),INLA="https://inla.r-inla-download.org/R/stable"), dep=TRUE)
```
```
remotes::install_github("dreamRs/capture")
```

3. After the packages have been installed, type the following in RStudio, and the application window will appear.
```
library(STEHealthApp)
run_app()
```


### **2️⃣ The second method:** .R file Application 

This method is suitable for **users who already have [R](https://www.r-project.org/) and [RStudio](https://posit.co/)** and may use RStudio for some time.

1. Clone this repository or download this repository in [releases page](https://github.com/mill-ornrakorn/STEHealth-Application/releases) or this [link](https://drive.google.com/drive/folders/1HDIO4duSiyy8OZblIBx4-6V3PdM6kfom?usp=sharing) to download the .zip file. 

2. Extract the downloaded file.

3. Open ```runShinyApp.R``` via RStudio

4. Press ```Run App``` and wait for a moment. The program will automatically install the libraries required* by the application. (*For a list of libraries, please refer to [tools section](https://github.com/mill-ornrakorn/STEHealth-Application/tree/optional-expected-value#tools-).)


5. Now you can use the application.

<!--
Clone this repository or download this repository in [releases](https://github.com/mill-ornrakorn/STEHealth-Application/releases) and install R and R packages. Some R packages, such as [r-inla](https://www.r-inla.org/download-install) and [capture](https://github.com/dreamRs/capture), need to be manually installed by the user as they are not available on CRAN.
-->

### **3️⃣ The third method:** Portable Application (supported Windows OS only)

This method is suitable for **`users who do not have R and RStudio at all`** because in this method we have already installed them all (including R packages) in portable application.

<!-- The STEHealth Portable Application eliminates the need for users to individually install R and its packages, as these components come pre-installed. 
-->

1. Go to this [link](https://drive.google.com/drive/folders/1gKW8w891qTPaKvu2-IGe38mEXaXtG39W?usp=share_link) to download the portable application.

2. Extract the downloaded file.

3. To launch the portable application, simply execute the ```\STEHealth_Portable\dist\run.vbs``` file without the necessity to view or modify any underlying code. (Note that: If you open ```run.vbs``` and the application doesn't open or the web application is blank, please press ```run.vbs``` several times.) 

4. Now you can use the application.




## Sample Data 📁
The [sample data](https://github.com/mill-ornrakorn/STEHealth-Application/tree/main/sample%20data) used for case study in this application consists of Thailand shapefile and csv file (Suicide Mortality and Risk Factors in Thailand from 2011 to 2021)



* **Thailand shapefile** contains 4 files that cannot be missing any of them due to their references to each other: shp, dbf, shx, and prj. These Shapefiles represent **provincial boundaries (Level 1)**.

<p align="center">
<img src="https://github.com/mill-ornrakorn/STEHealth-Application/blob/main/pic%20for%20readme/th_shapfile.jpg?raw=true" alt= “Thailand_shapefile” height="400">
</br>
Thailand shapefile
</p> 



* **csv file (Suicide Mortality and Risk Factors in Thailand from 2011 to 2021)** contains the following 12 columns: 

    **1. province** refers to the administrative divisions in Thailand, of which there are a total of 77 provinces.

    **2. province_id** is the number of province starting at from 1 to 77 .

    **3. year** is the number of year from 2011 to 2021.

    **4. suicide** is the number of suicides.

    **5.Population** population in each area.

    **6-12. 7 covariates:** debt, income, poverty, expenditure, homicide crime, property crime and shocking crime.
    
<p align="center">
<img src="https://github.com/mill-ornrakorn/STEHealth-Application/blob/main/pic%20for%20readme/th_csv.jpg?raw=true" alt= “csv_file” height="300">
</br>
Suicide Mortality and Risk Factors in Thailand from 2011 to 2021
</p> 

## Manual📗
This manual includes step-by-step instructions on how to use each page of the application. [Click here to read more](https://github.com/mill-ornrakorn/STEHealth-Application/blob/feature-select-download/www/STEHealth_Application_Manual.pdf)

<p align="center">
<img src="https://github.com/mill-ornrakorn/STEHealth-Application/blob/main/pic%20for%20readme/STEHealth_Application_Manual_cover.png?raw=true" alt= “STEHealth_Manual” height="600">
</p>

<!--
## Style Guide 🎨
<p align="center">
<img src="https://github.com/mill-ornrakorn/STEHealth-Application/blob/main/pic%20for%20readme/STEHealth_styleguide.png?raw=true" alt= “STEHealth_styleguide” height="500">
</p>

[Google Chrome Portable](https://portableapps.com/apps/internet/google_chrome_portable) | Google Chrome Portable can run from a cloud folder, external drive, or local folder without installing into Windows.
-->


## Tools ⚙
|  |   |
--- | ----
**Software**   | 
[R](https://cran.r-project.org/)  | Language and environment for statistical computing and graphics
[RStudio](https://posit.co/download/rstudio-desktop/)  | Integrated development environment (IDE) for R
[R-Portable](https://sourceforge.net/projects/rportable/) | R portable configures R to work with the PortableApps framework, so that R can be ran from a thumb drive or portable hard drive without leaving artifacts on the computer
[Responsively App](https://responsively.app/) | A dev-tool that aids faster and precise responsive web development
**R packages** |
[shiny](https://cran.r-project.org/web/packages/shiny/index.html)  | Makes to build interactive web apps from R
[shinydashboard](https://cran.r-project.org/web/packages/shinydashboard/index.html)| Use with shiny to create dashboards
[shinyjs](https://cran.r-project.org/web/packages/shinyjs/index.html)| Perform common useful JavaScript operations in Shiny apps that will greatly improve the apps without having to know any JavaScript
[shinyBS](https://cran.r-project.org/web/packages/shinyBS/index.html)| Adds additional Twitter Bootstrap components to Shiny
[shinyWidgets](https://cran.r-project.org/web/packages/shinyWidgets/index.html) | Collection of custom input controls and user interface components for 'Shiny' applications. Give your applications a unique and colorful style! 
[shinydashboardPlus](https://cran.r-project.org/web/packages/shinydashboardPlus/index.html) | Extend 'shinydashboard' with 'AdminLTE2' components. 'AdminLTE2' is a free 'Bootstrap 3' dashboard template                                                                
[dplyr](https://cran.r-project.org/web/packages/dplyr/index.html)  | A fast, consistent tool for working with data frame like objects, both in memory and out of memory
[ggplot2](https://cran.r-project.org/web/packages/ggplot2/index.html)   | Creates elegant data visualisations using the grammar of graphics
[leaflet](https://cran.r-project.org/web/packages/leaflet/index.html) | Create Interactive Web Maps with the JavaScript 'Leaflet' Library
[RColorBrewer](https://cran.r-project.org/web/packages/RColorBrewer/index.html)  | Provides color schemes for maps and other graphics
[rgdal](https://cran.r-project.org/web/packages/rgdal/index.html) | Provides bindings to Frank Warmerdam's Geospatial Data Abstraction Library (GDAL)
[R-INLA](https://www.r-inla.org/download-install)  | Performs full Bayesian analysis on generalised additive mixed models using Integrated Nested Laplace Approximations
[spdep](https://cran.r-project.org/web/packages/spdep/index.html)| Spatial Dependence: Weighting Schemes, Statistics
[capture](https://github.com/dreamRs/capture) | Add a button in Shiny application or R Markdown document to take a screenshot (PNG or PDF) of a specified element.
[bsplus](https://cran.rstudio.com/web/packages/bsplus/index.html) | The Bootstrap framework lets you add some JavaScript functionality to your web site by adding attributes to your HTML tags.

### 🩹Limitations
- Application can support only English.
- Application works effectively on desktops only. We recommend using a screen size of at least 1440x900 pixels for the best viewing experience.
- The operation of the application relies on the system resources of the device it is running on.
- Installation packages must require because an application can not publish to shiny server on the [shinyapps.io](https://www.shinyapps.io/) website. However, we encountered a problem because shinyapps.io only supports packages that are located in CRAN, which is R’s central software repository supported by the R Foundation [[2]](https://cran.r-project.org/web/packages/policies.html). Unfortunately, the ```R-INLA package``` is not included in CRAN, which prevented us from deploying the app to the cloud. We explored alternative deployment options, such as deploying the app on Amazon Web Services (AWS) [[3](https://www.charlesbordet.com/en/guide-shiny-aws/) ,[4](https://towardsdatascience.com/how-to-host-a-r-shiny-app-on-aws-cloud-in-7-simple-steps-5595e7885722)] and deploying the app on Google Cloud Platform (GCP) using Docker [[5](https://anderfernandez.com/en/blog/put-shiny-app-into-production/) ,[6](https://towardsdatascience.com/dockerizing-and-deploying-a-shiny-dashboard-on-google-cloud-a990ceb3c33a)]. However, we encountered issues with some other packages. As a result, we made the decision to create a **portable application** instead.


## References📖
1. Paula Moraga (2017), SpatialEpiApp: A Shiny web application for the analysis of spatial and spatio-temporal disease data. Spatial and Spatio-temporal Epidemiology, 23:47-57 DOI: https://doi.org/10.1016/j.sste.2017.08.001

2. CRAN Repository Maintainers. (n.d.). CRAN Repository Policy. Available from: https://cran.r-project.org/web/packages/policies.html

3. Charles Bordet. The Ultimate Guide to Deploying a Shiny App on AWS. Available from: https://www.charlesbordet.com/en/guide-shiny-aws/

4. Venkat Raman. How to host an R Shiny App on AWS cloud in 7 simple steps. Available from: https://towardsdatascience.com/how-to-host-a-r-shiny-app-on-aws-cloud-in-7-simple-steps-5595e7885722

5. Ander Fernández Jauregui. How to put a Shiny app into production. Available from: https://anderfernandez.com/en/blog/put-shiny-app-into-production/

6. Peer Christensen. Dockerizing and Deploying a Shiny Dashboard on Google Cloud. Available from: https://towardsdatascience.com/dockerizing-and-deploying-a-shiny-dashboard-on-google-cloud-a990ceb3c33a

## Credits Section📄
* logo of STEHealth application was modified from <a href="https://www.canva.com/templates/EAE6wliCycg-green-tosca-simple-business-logo/">logo by Ally Hamid</a> on Canva 

* Image in Home page <a href="https://www.freepik.com/free-vector/business-landing-page-template_10263302.htm">created by pikisuperstar</a> on Freepik 

* Images in Upload Data page, Spatiotemporal Epidemiological Analysis Result page, and About Application <a href="https://undraw.co/">created by Katerina Limpitsouni</a> on undraw

* World icons in Spatiotemporal Epidemiological Analysis Result page <a href="https://www.flaticon.com/free-icons/world" title="world icons">created by Freepik</a> on Flaticon

* World map icons in Spatiotemporal Epidemiological Analysis Result page <a href="https://www.flaticon.com/free-icons/world-map" title="world map icons"> created by Freepik</a> on Flaticon

* Document icons in Spatiotemporal Epidemiological Analysis Result page <a href="https://www.flaticon.com/free-icons/document" title="document icons">created by smalllikeart</a> on Flaticon

* Manual cover in STEHealth web application was modified from <a href="https://www.canva.com/p/templates/EAE9h5vtwXM-peach-modern-minimal-annual-report-cover/">report cover by Temptackle</a> on Canva 
