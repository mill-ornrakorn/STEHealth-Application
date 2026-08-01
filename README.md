# STEHealth-Application 🌏💻

**STEHealth** (It stands for **S**patiotemporal **E**pidemiological **Health**) is a shiny application for analyzing space-time pattern, **cluster detection**, and **association with risk factors** of health outcomes, which allows users to import their own data, analyze, and visualize.

This application is part of **```Spatiotemporal analysis with application development for epidemiological study of suicide mortality: From global perspectives to a case study in Thailand 💀📝```** senior project of the Princess Srisavangavadhana Faculty of Medicine, [Chulabhorn Royal Academy](https://www.cra.ac.th/en/home) and the Department of Computer Engineering, [King Mongkut's University of Technology Thonburi](https://www.kmutt.ac.th/en/).

<p align="center">
<img src="https://github.com/mill-ornrakorn/STEHealth-Application/blob/main/pic%20for%20readme/Poster_Project_No74_resize.png?raw=true" alt= "Poster_Project" height="600">
</p>


### 💡Feature
1. **```Upload data```** for analysis into the application — supports both **CSV and Excel (.xlsx/.xls)** files, or get started instantly with **built-in sample datasets** (Pollution & Health datasets from the CARBayesST R package).

2. **```Analysis```** for spatial and spatiotemporal epidemiological studies, including **cluster detection** and **association with risk factors** — the latter reports both the **area-level relative risk** (how the effect varies by area) and the **Overall (region-wide) relative risk**, estimated as a fixed effect and directly comparable to region-wide results reported in reference papers such as CARBayesST.

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

Deploying STEHealth to the cloud involved addressing complex dependency challenges between modern R spatial packages and the `R-INLA` computational engine. We achieved a high-performance, stable cloud deployment on **Hugging Face Spaces** using the following updated strategy:

*   **Modern Docker Infrastructure:** We utilized the latest `rocker/shiny` base image, transitioning to **R 4.5+** and **Ubuntu 24.04 (Noble)**. This ensures access to the latest security patches and high-performance system libraries.
*   **Next-Generation Spatial Stack:** We migrated from legacy libraries (like `rgdal`) to the modern **`sf` (Simple Features)** and **`spdep`** stack. By leveraging dynamic package management instead of time-locked snapshots, the application stays compatible with current geospatial standards.
*   **Optimized Model Integration:** To maintain peak analytical accuracy, we integrate the **`R-INLA` Testing Build**, specifically configured to remain compatible with advanced R environments. This bypasses traditional `GLIBC` and shared library conflicts (e.g., `libproj`) common in complex epidemiological modeling.
*   **Containerized Portability:** The entire environment is encapsulated in a custom Docker container, exposing **Port 7860** for seamless integration with Hugging Face's infrastructure, ensuring that the local development environment perfectly matches the cloud production state.


## Sample Data 📁
The application includes **three ready-to-use sample datasets**, selectable directly in the app via the **Use Sample Data** dropdown on the Upload Data page — no need to download or upload anything to try the application. Each is labelled with a badge showing whether it supports **Spatial-Temporal** or **Spatial** models, and comes with a **View Data Dictionary** button describing its columns. The raw files are also available for download, both via the **Download sample data (.csv)** button in-app and here on [GitHub](https://github.com/mill-ornrakorn/STEHealth-Application/tree/main/shiny/sample%20data):

### 1. Thailand Suicide Mortality 2011-2021 (used for case study in this project)
Consists of a Thailand shapefile and a csv file (Suicide Mortality and Risk Factors in Thailand from 2011 to 2021).

### 2. Pollution & Health Data 2007-2011 (from the CARBayesST R package)
Covers the Greater Glasgow and Clyde health board in Scotland (271 Intermediate Zones). Contains `pm10`, `jsa` (Job Seekers Allowance proportion), and `price` (average property price) as covariates, with respiratory hospital admissions as the outcome. Supports **Spatial-Temporal** models (2007-2011).

### 3. Pollution & Health Data, 2007 Only
The same dataset and shapefile as above, filtered to a single year (2007). Since it has no time dimension, this dataset is intended for testing the **Spatial** model.

## Manual📗
🚧 Note: The manual is currently under revision to reflect the latest updates and the new Cloud Deployment on Hugging Face Spaces.

This manual includes step-by-step instructions on how to use each page of the application. [Click here to read more](https://canva.link/yk8vjfdonxnxu0o)

<p align="center">
  <a href="https://canva.link/yk8vjfdonxnxu0o" target="_blank">
    <img src="https://github.com/mill-ornrakorn/STEHealth-Application/blob/main/pic%20for%20readme/STEHealth_Application_Manual_cover.png?raw=true" alt="STEHealth_Manual" height="600" style="cursor: pointer;">
  </a>
</p>


### Deployment & Infrastructure
| | |
| --- | --- |
| [Hugging Face Spaces](https://huggingface.co/spaces) | Cloud platform for hosting the machine learning and Shiny web application. |
| [Docker](https://www.docker.com/) | Containerization technology used to create a reproducible environment and manage complex spatial/system dependencies. |

### Software & R Packages
| | |
| --- | --- |
| [R](https://cran.r-project.org/) | Language and environment for statistical computing and graphics (Version 4.5+, see Deployment Architecture above). |
| [shiny](https://cran.r-project.org/web/packages/shiny/index.html) | Makes it easy to build interactive web apps straight from R. |
| [shinydashboard](https://cran.r-project.org/web/packages/shinydashboard/index.html)| Use with Shiny to create dashboards. |
| [shinydashboardPlus](https://cran.r-project.org/web/packages/shinydashboardPlus/index.html)| Extend `shinydashboard` with `AdminLTE2` components. |
| [shinyjs](https://cran.r-project.org/web/packages/shinyjs/index.html)| Perform common JavaScript operations in Shiny apps. |
| [shinyBS](https://cran.r-project.org/web/packages/shinyBS/index.html)| Adds additional Twitter Bootstrap components to Shiny. |
| [shinyWidgets](https://cran.r-project.org/web/packages/shinyWidgets/index.html) | Collection of custom input controls and UI components for Shiny applications. |
| [bsplus](https://cran.rstudio.com/web/packages/bsplus/index.html) | Adds Bootstrap-powered JavaScript functionality (e.g. tooltips, popovers) to Shiny apps. |
| [dplyr](https://cran.r-project.org/web/packages/dplyr/index.html) | A fast, consistent tool for working with data frame-like objects. |
| [ggplot2](https://cran.r-project.org/web/packages/ggplot2/index.html) | Creates elegant data visualisations using the grammar of graphics. |
| [leaflet](https://cran.r-project.org/web/packages/leaflet/index.html) | Create Interactive Web Maps with the JavaScript 'Leaflet' Library. |
| [leaflet.extras](https://cran.r-project.org/web/packages/leaflet.extras/index.html) | Adds extra functionality to `leaflet` via additional Leaflet plugins. |
| [RColorBrewer](https://cran.r-project.org/web/packages/RColorBrewer/index.html) | Provides color schemes for maps and other graphics. |
| [sf](https://cran.r-project.org/web/packages/sf/index.html) | Simple Features: modern support for spatial vector data, used for shapefile handling (replaces the legacy `rgdal`). |
| [spdep](https://cran.r-project.org/web/packages/spdep/index.html)| Spatial Dependence: Weighting Schemes, Statistics. |
| [R-INLA](https://www.r-inla.org/download-install) | Performs full Bayesian analysis on generalised additive mixed models using Integrated Nested Laplace Approximations. The app uses the **Testing Build**, kept compatible with the modern R/Ubuntu environment described above (see Deployment Architecture). |
| [readxl](https://cran.r-project.org/web/packages/readxl/index.html) | Reads Excel (.xls/.xlsx) files, used for the Excel upload option on the Upload Data page. |
| [DT](https://cran.r-project.org/web/packages/DT/index.html) | Renders interactive data tables (e.g. the area-level significance table on the Association with Risk Factors tab). |
| [capture](https://github.com/dreamRs/capture) | Add a button in Shiny application to take a screenshot of a specified element. |


### 🩹Limitations
- **Auto-Sleep Mode:** The application may enter sleep mode after 48 hours of inactivity to save resources. It will automatically wake up and restart upon your next visit, which might take 1-2 minutes to load.
- The application supports only English.
- Recommended screen size is at least 1440x900 pixels for the best viewing experience on desktop browsers.



## References📖
1. Moraga, P. (2017). SpatialEpiApp: A Shiny web application for the analysis of spatial and spatio-temporal disease data. Spatial and Spatio-temporal Epidemiology, 23, 47–57. https://doi.org/10.1016/j.sste.2017.08.001

2. Lee, D., Rushworth, A., & Napier, G. (2018). Spatio-Temporal Areal Unit Modeling in R with Conditional Autoregressive Priors Using the CARBayesST Package. Journal of Statistical Software, 84(9), 1–39. https://doi.org/10.18637/jss.v084.i09

<!-- อ้างอิงรูปแบบ APA 7th --> 

## Credits Section📄
* logo of STEHealth application was modified from <a href="https://www.canva.com/templates/EAE6wliCycg-green-tosca-simple-business-logo/">logo by Ally Hamid</a> on Canva 

* Image in Home page <a href="https://www.freepik.com/free-vector/business-landing-page-template_10263302.htm">created by pikisuperstar</a> on Freepik 

* Images in Upload Data page, Spatiotemporal Epidemiological Analysis Result page, and About Application <a href="https://undraw.co/">created by Katerina Limpitsouni</a> on undraw

* World icons in Spatiotemporal Epidemiological Analysis Result page <a href="https://www.flaticon.com/free-icons/world" title="world icons">created by Freepik</a> on Flaticon

* World map icons in Spatiotemporal Epidemiological Analysis Result page <a href="https://www.flaticon.com/free-icons/world-map" title="world map icons"> created by Freepik</a> on Flaticon

* Document icons in Spatiotemporal Epidemiological Analysis Result page <a href="https://www.flaticon.com/free-icons/document" title="document icons">created by smalllikeart</a> on Flaticon

* Manual cover in STEHealth web application was modified from <a href="https://www.canva.com/p/templates/EAE9h5vtwXM-peach-modern-minimal-annual-report-cover/">report cover by Temptackle</a> on Canva