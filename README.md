# STEHealth-Application 🌏💻

**STEHealth** (It stands for **S**patiotemporal **E**pidemiological **Health**) is a shiny application for analyzing space-time pattern, **cluster detection**, and **association with risk factors** of health outcomes, which allows users to import their own data, analyze, and visualize.

This application is part of **```Spatiotemporal analysis with application development for epidemiological study of suicide mortality: From global perspectives to a case study in Thailand 💀📝```** senior project of the Princess Srisavangavadhana Faculty of Medicine, [Chulabhorn Royal Academy](https://www.cra.ac.th/en/home) and the Department of Computer Engineering, [King Mongkut's University of Technology Thonburi](https://www.kmutt.ac.th/en/).

<p align="center">
<img src="https://github.com/mill-ornrakorn/STEHealth-Application/blob/main/pic%20for%20readme/Poster_Project_No74_resize.png?raw=true" alt= "Poster_Project" height="600">
</p>


### 💡Feature
1. **```Upload data```** for analysis into the application.

2. **```Analysis```** for spatial and spatiotemporal epidemiological studies, including **cluster detection** and **association with risk factors**.

3. **```Download results```** of the analysis directly from the application.



<p align="center">
<img src="https://github.com/mill-ornrakorn/STEHealth-Application/blob/main/pic%20for%20readme/STEHealth_gif_Cluster%20detection1-2.gif?raw=true" alt= “STEHealth_Manual” height="400">
</br>
Cluster detection

</p>


<p align="center">
<img src="https://github.com/mill-ornrakorn/STEHealth-Application/blob/main/pic%20for%20readme/STEHealth_gif_Association%20with%20risk%20factors1-2.gif?raw=true" alt= “STEHealth_Manual” height="400" > 
</br>
Association with risk factors
</p>


### 🔎Target users
1. **Primary:** Epidemiologists and Public health researchers
2. **Secondary:** Public health professionals and Policy makers


### 📝Developer Team
1. [Papin Thanutchapat](https://github.com/Jappapin); Space-time pattern detection model and association with risk factors for suicide.
2. [Chiraphat Phoncharoenwirote](https://github.com/Chiraphatt); Insights information of spatiotemporal epidemiology of suicide mortality and association with risk factors analysis.
3. [Ornrakorn Mekchaiporn](https://github.com/mill-ornrakorn); Application design and development.


### 📚Advisor
1. **Dr. Unchalisa Taetragool**; Department of Computer Engineering, Faculty of Engineering, King Mongkut's University of Technology Thonburi
2. **Asst. Prof. Dr. Chawarat Rotejanaprasert**; Department of Tropical Hygiene, Faculty of Tropical Medicine, Mahidol University
3. **Asst. Prof. Dr. Peerut Chienwichai**; Princess Srisavangavadhana College of Medicine, Chulabhorn Royal Academy


## Usage & Access 💻

STEHealth Application is fully deployed on the cloud via **Hugging Face Spaces**. **No installation is required.** You can access and use the application directly through your web browser from any device.

👉 **[Launch STEHealth Application Here](https://mmillorkrn-stehealth-application.hf.space)**



## Deployment Architecture 🚀

Deploying STEHealth to the cloud involved solving complex dependency challenges between R spatial packages and the `R-INLA` model. We achieved a stable cloud deployment on **Hugging Face Spaces** using the following strategy:
* **Docker Containerization:** We built a custom environment using `rocker/shiny:4.2.2` as the base image to ensure OS-level stability.
* **Time-Locked Repository:** We utilized a Posit Package Manager snapshot from **March 1, 2023**, to successfully install classic spatial libraries (`rgdal`, `spdep`) without C++ compilation errors.
* **Model Versioning:** We locked `R-INLA` to version `22.05.07` to maintain compatibility with the system environment and completely bypass `GLIBC` issues found in newer versions.


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
🚧 Note: The manual is currently under revision to reflect the latest updates and the new Cloud Deployment on Hugging Face Spaces.

This manual includes step-by-step instructions on how to use each page of the application. [Click here to read more](https://github.com/mill-ornrakorn/STEHealth-Application/blob/main/shiny/www/STEHealth_Application_Manual.pdf)

<p align="center">
<img src="https://github.com/mill-ornrakorn/STEHealth-Application/blob/main/pic%20for%20readme/STEHealth_Application_Manual_cover.png?raw=true" alt= “STEHealth_Manual” height="600">
</p>



### Deployment & Infrastructure
| | |
| --- | --- |
| [Hugging Face Spaces](https://huggingface.co/spaces) | Cloud platform for hosting the machine learning and Shiny web application. |
| [Docker](https://www.docker.com/) | Containerization technology used to create a reproducible environment and manage complex spatial/system dependencies. |
| [Posit Package Manager](https://packagemanager.posit.co/) | Time-locked repository snapshot (March 1, 2023) used for stable installation of classic spatial libraries (`rgdal`, `spdep`). |

### Software & R Packages
| | |
| --- | --- |
| [R](https://cran.r-project.org/) | Language and environment for statistical computing and graphics (Version 4.2.2). |
| [shiny](https://cran.r-project.org/web/packages/shiny/index.html) | Makes it easy to build interactive web apps straight from R. |
| [shinydashboard](https://cran.r-project.org/web/packages/shinydashboard/index.html)| Use with Shiny to create dashboards. |
| [shinyjs](https://cran.r-project.org/web/packages/shinyjs/index.html)| Perform common JavaScript operations in Shiny apps. |
| [leaflet](https://cran.r-project.org/web/packages/leaflet/index.html) | Create Interactive Web Maps with the JavaScript 'Leaflet' Library. |
| [R-INLA](https://www.r-inla.org/download-install) | Performs full Bayesian analysis on generalised additive mixed models using Integrated Nested Laplace Approximations (Version 22.05.07). |
| [rgdal](https://cran.r-project.org/web/packages/rgdal/index.html) | Provides bindings to Geospatial Data Abstraction Library (GDAL). |
| [spdep](https://cran.r-project.org/web/packages/spdep/index.html)| Spatial Dependence: Weighting Schemes, Statistics. |
| [capture](https://github.com/dreamRs/capture) | Add a button in Shiny application to take a screenshot of a specified element. |


### 🩹Limitations
- **Auto-Sleep Mode:** The application may enter sleep mode after 48 hours of inactivity to save resources. It will automatically wake up and restart upon your next visit, which might take 1-2 minutes to load.
- The application supports only English.
- Recommended screen size is at least 1440x900 pixels for the best viewing experience on desktop browsers.



## References📖
1. Paula Moraga (2017), SpatialEpiApp: A Shiny web application for the analysis of spatial and spatio-temporal disease data. Spatial and Spatio-temporal Epidemiology, 23:47-57 DOI: https://doi.org/10.1016/j.sste.2017.08.001


## Credits Section📄
* logo of STEHealth application was modified from <a href="https://www.canva.com/templates/EAE6wliCycg-green-tosca-simple-business-logo/">logo by Ally Hamid</a> on Canva 

* Image in Home page <a href="https://www.freepik.com/free-vector/business-landing-page-template_10263302.htm">created by pikisuperstar</a> on Freepik 

* Images in Upload Data page, Spatiotemporal Epidemiological Analysis Result page, and About Application <a href="https://undraw.co/">created by Katerina Limpitsouni</a> on undraw

* World icons in Spatiotemporal Epidemiological Analysis Result page <a href="https://www.flaticon.com/free-icons/world" title="world icons">created by Freepik</a> on Flaticon

* World map icons in Spatiotemporal Epidemiological Analysis Result page <a href="https://www.flaticon.com/free-icons/world-map" title="world map icons"> created by Freepik</a> on Flaticon

* Document icons in Spatiotemporal Epidemiological Analysis Result page <a href="https://www.flaticon.com/free-icons/document" title="document icons">created by smalllikeart</a> on Flaticon

* Manual cover in STEHealth web application was modified from <a href="https://www.canva.com/p/templates/EAE9h5vtwXM-peach-modern-minimal-annual-report-cover/">report cover by Temptackle</a> on Canva 
