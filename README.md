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



### 📝Developer Team
1. [Papin Thanutchapat](https://github.com/Jappapin); Space-time pattern detection model and association with risk factors for suicide.
2. [Chiraphat Phoncharoenwirote](https://github.com/Chiraphatt); Insights information of spatiotemporal epidemiology of suicide mortality and association with risk factors analysis.
3. [Ornrakorn Mekchaiporn](https://github.com/mill-ornrakorn); Application design and development.


### 📚Advisor
1. **Dr. Unchalisa Taetragool**; Department of Computer Engineering, Faculty of Engineering, King Mongkut's University of Technology Thonburi
2. **Asst. Prof. Dr. Chawarat Rotejanaprasert**; Department of Tropical Hygiene, Faculty of Tropical Medicine, Mahidol University
3. **Asst. Prof. Dr. Peerut Chienwichai**; Princess Srisavangavadhana College of Medicine, Chulabhorn Royal Academy


## Installation 💻
There are two installation methods.

**The first method:** Clone this repository 

Clone this repository and install R and R packages. Some R packages, such as [r-inla](https://www.r-inla.org/download-install) and [capture](https://github.com/dreamRs/capture), need to be manually installed by the user as they are not available on CRAN.
 

**The second method:** Portable Application (supported Windows OS only)

The STEHealth Portable Application eliminates the need for users to individually install R and its packages, as these components come pre-installed. 

1. Go to this [link](https://drive.google.com/drive/folders/1gKW8w891qTPaKvu2-IGe38mEXaXtG39W?usp=share_link) to download the portable application.
2. Extract the downloaded file.
3. To launch the portable application, simply execute the ```\STEHealth_Portable\dist\run.vbs``` file without the necessity to view or modify any underlying code. (Note that: If you open "run.vbs" and the application doesn't open or the web application is blank, please press "run.vbs" several times.) 
4. Now you can use the application.




## Sample Data 📁
The sample data used for case study in this application consists of Thailand shapefile and csv file (Thai suicide mortality and risk factors 2011-2021)



* **Thailand shapefile** contains 4 files that cannot be missing any of them due to their references to each other: shp, dbf, shx, and prj. These Shapefiles represent **provincial boundaries (Level 1)**.

<p align="center">
<img src="https://github.com/mill-ornrakorn/STEHealth-Application/blob/main/www/th_shapfile.jpg?raw=true" alt= “Thailand_shapefile” height="400">
</br>
Thailand shapefile
</p> 



* **csv file (Thailand suicide mortality and risk factors 2011-2021)** contains the following 12 columns: 

    **1. province** is the name of province which has a total of 77 provinces.

    **2. province_id** is the number of province starting at from 1 to 77 .

    **3. year** is the number of year starting at from 1 to 11.

    **4. suicide** is the number of suicides.

    **5.Population** population in each area.

    **6-12. 7 covariates:** debt, income, poverty, expenditure, homicide crime, property crime and shocking crime.
    
<p align="center">
<img src="https://github.com/mill-ornrakorn/STEHealth-Application/blob/main/www/th_csv.jpg?raw=true" alt= “csv_file” height="300">
</br>
Thailand suicide mortality and risk factors 2011-2021
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

-->


## Tools ⚙
|  |   |
--- | ----
**Software**   | 
[R](https://cran.r-project.org/)  | Language and environment for statistical computing and graphics
[R-Portable](https://sourceforge.net/projects/rportable/) | R portable configures R to work with the PortableApps framework, so that R can be ran from a thumb drive or portable hard drive without leaving artifacts on the computer.
[Google Chrome Portable](https://portableapps.com/apps/internet/google_chrome_portable) | Google Chrome Portable can run from a cloud folder, external drive, or local folder without installing into Windows.
**R packages** |
[shiny](https://cran.r-project.org/web/packages/shiny/index.html)  | Makes to build interactive web apps from R
[shinydashboard](https://cran.r-project.org/web/packages/shinydashboard/index.html)| Use with shiny to create dashboards
[shinyjs](https://cran.r-project.org/web/packages/shinyjs/index.html)| Perform common useful JavaScript operations in Shiny apps that will greatly improve the apps without having to know any JavaScript
[shinyBS](https://cran.r-project.org/web/packages/shinyjs/index.html)| Adds additional Twitter Bootstrap components to Shiny
[shinyWidgets](https://cran.r-project.org/web/packages/shinyWidgets/index.html) | Collection of custom input controls and user interface components for 'Shiny' applications. Give your applications a unique and colorful style! 
[shinydashboardPlus](https://cran.r-project.org/web/packages/shinydashboardPlus/index.html) | Extend 'shinydashboard' with 'AdminLTE2' components. 'AdminLTE2' is a free 'Bootstrap 3' dashboard template                                                                
[dplyr](https://cran.r-project.org/web/packages/shinyjs/index.html)  | A fast, consistent tool for working with data frame like objects, both in memory and out of memory
[ggplot2](https://cran.r-project.org/web/packages/shinyjs/index.html)   | Creates elegant data visualisations using the grammar of graphics
[leaflet](https://cran.r-project.org/web/packages/shinyjs/index.html) | Create Interactive Web Maps with the JavaScript 'Leaflet' Library
[RColorBrewer](https://cran.r-project.org/web/packages/shinyjs/index.html)  | Provides color schemes for maps and other graphics
[rgdal](https://cran.r-project.org/web/packages/shinyjs/index.html) | Provides bindings to Frank Warmerdam's Geospatial Data Abstraction Library (GDAL)
[R-INLA](https://cran.r-project.org/web/packages/shinyjs/index.html)  | Performs full Bayesian analysis on generalised additive mixed models using Integrated Nested Laplace Approximations
[spdep](https://cran.r-project.org/web/packages/spdep/index.html)| Spatial Dependence: Weighting Schemes, Statistics
[capture](https://github.com/dreamRs/capture) | Add a button in Shiny application or R Markdown document to take a screenshot (PNG or PDF) of a specified element.
[bsplus](https://cran.rstudio.com/web/packages/bsplus/index.html) | The Bootstrap framework lets you add some JavaScript functionality to your web site by adding attributes to your HTML tags.

### 🩹Limitations
- Application can support only English.
- Application works effectively on desktops only. We recommend using a screen size of at least 1440x900 pixels for the best viewing experience.
- The operation of the application relies on the system resources of the device it is running on.
- Installation packages must require because an application can not publish to shiny server on the [shinyapps.io](https://www.shinyapps.io/) website. However, we encountered a problem because shinyapps.io only supports packages that are located in CRAN, which is R’s central software repository supported by the R Foundation [[2]](https://cran.r-project.org/web/packages/policies.html). Unfortunately, the ```R-INLA package``` is not included in CRAN, which prevented us from deploying the app to the cloud.

## References📖
1. Paula Moraga (2017), SpatialEpiApp: A Shiny web application for the analysis of spatial and spatio-temporal disease data. Spatial and Spatio-temporal Epidemiology, 23:47-57 DOI: https://doi.org/10.1016/j.sste.2017.08.001

2. CRAN Repository Maintainers. (n.d.). CRAN Repository Policy. Retrieved from R-Packages website: https://cran.r-project.org/web/packages/policies.html

## Credits Section📄
* logo of STEHealth application was modified from <a href="https://www.canva.com/templates/EAE6wliCycg-green-tosca-simple-business-logo/">logo by Ally Hamid</a> on Canva 

* Image in Home page <a href="https://www.freepik.com/free-vector/business-landing-page-template_10263302.htm">created by pikisuperstar</a> on Freepik 

* Images in Upload Data page, Spatiotemporal Epidemiological Analysis Result page, and About Application <a href="https://undraw.co/">created by Katerina Limpitsouni</a> on undraw

* World icons in Spatiotemporal Epidemiological Analysis Result page <a href="https://www.flaticon.com/free-icons/world" title="world icons">created by Freepik</a> on Flaticon

* World map icons in Spatiotemporal Epidemiological Analysis Result page <a href="https://www.flaticon.com/free-icons/world-map" title="world map icons"> created by Freepik</a> on Flaticon

* Document icons in Spatiotemporal Epidemiological Analysis Result page <a href="https://www.flaticon.com/free-icons/document" title="document icons">created by smalllikeart</a> on Flaticon

* Manual cover in STEHealth web application was modified from <a href="https://www.canva.com/p/templates/EAE9h5vtwXM-peach-modern-minimal-annual-report-cover/">report cover by Temptackle</a> on Canva 
