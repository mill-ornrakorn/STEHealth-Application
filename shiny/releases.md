<div style = "text-align: justify; margin-right: 60px; font-size: 16px">

## <span style="color:#735DFB"> **Releases** </span>

### **Version History**
<img width="40px" height="10px" src="Rectangle.svg">

<div class='box-white'>

- #### version 2.1
    ##### 18 July 2026
    - On the Upload Data page:
        - Added support for uploading data files in Excel (.xlsx/.xls) format, in addition to CSV.
        - Added a **Data Summary** table shown after uploading the shapefile and the data file.
        - Changed **Use Sample Data** into a dropdown with three ready-to-use sample datasets: Thailand Suicide Mortality 2011-2021, Pollution & Health Data 2007-2011 (from the CARBayesST R package), and Pollution & Health Data 2007 Only (for testing spatial-only models). Each dataset is labelled with a badge showing whether it supports Spatial-Temporal or Spatial-only models.
        - Added a **View Data Dictionary** button describing the columns of each sample dataset.
        - Added a **Download sample data (.csv)** button.
        - Moved the "area id" and "area name" dropdowns onto the same row for easier comparison.
    - On the Spatiotemporal Epidemiological Analysis page:
        - The application now automatically detects whether the uploaded data has more than one time point, and fits a **Spatial-Temporal model** or a **Spatial model** (spatial-only) accordingly, shown as a badge above the Model Results.
        - Added a **Model Results** section with a significance summary table (number of areas with a statistically significant local deviation, per risk factor).
        - Added a title above the Cluster Detection map.
        - On the Association with Risk Factors tab: added a title above the map showing which risk factor is displayed, and a legend explaining that a thick black outline marks a statistically significant area.
        - Fixed the map tooltip on the Association with Risk Factors tab, which was showing the area's raw id/code instead of its name.
        - Changed the downloadable result file on the Association with Risk Factors tab to a long/tidy format (one row per area per risk factor, with a constant set of columns regardless of how many risk factors are selected), and added the area name column.
        - Downloaded result files (Cluster Detection and Association with Risk Factors) are now named after the uploaded data file (or the sample dataset name), instead of a generic file name.
        - Updated the "Examples of Interpretation" pop-ups to clarify that the example shown uses the Thailand sample data, but the same interpretation rules apply to any dataset.
    - On the Help page:
        - Updated the description of the Association with Risk Factors model to reflect the relative risk (RR) and area-specific random slope approach.
        - Updated the Sample Data section to describe all three sample datasets.
        - Genericized the Shapefile/CSV file requirements, which are no longer Thailand-specific.


- #### version 2.0
    ##### 3 May 2026
    *This entry consolidates development from 28 April to 26 June 2026.* This version marks the application's transition from a desktop/portable R app to a fully hosted **cloud web application**, deployed via Docker on Hugging Face Spaces - the first time this project has been reachable as a regular website rather than a program run locally.
    - Added a **Dockerfile** to containerize the application (based on the rocker/shiny image, with R-INLA and the required geospatial system libraries installed at build time), enabling deployment to Hugging Face Spaces.
    - Migrated shapefile handling from the deprecated `rgdal` package to `sf` (`st_read`/`st_transform`), and added the `readxl`, `plotly`, and `DT` packages.
    - Removed the old desktop launcher script (`runShinyApp.R`) and standardized the application on a single `app.R` file, as expected by Shiny Server/cloud hosting.
    - Introduced a **Data Source** option on the Upload Data page, letting users choose between uploading their own shapefile/CSV or using **built-in sample data**, with column defaults filled in automatically for the sample dataset.
    - Added **menu locking**: sidebar navigation is greyed out and disabled until both the shapefile and data file have been successfully loaded, to prevent users from reaching a results page before an analysis is possible.
    - Reworked the Upload Data page into a clearer step-by-step layout (Data Source, Upload Shapefile, Upload CSV Data File), with inline tooltips/help popovers and a styled "Next" button that only activates once the data is ready.
    - Fixed data-joining bugs on the Association with Risk Factors tab, where map attributes were not always joined to the underlying data correctly.
    - Updated the README and in-app links (Manual, sample data download) to describe the new cloud deployment, replacing the old local/portable installation instructions.

</div>

<div class='box-white'>

- #### version 1.3.2
    ##### 24 February 2025
    - Fixed a bug on the Map Distribution page that caused incorrect data visualization.
    - Updated the About WebApp page with improved content clarity, refined descriptions, and enhanced readability to better communicate the purpose and functionality of the application.


- #### version 1.3.1
    ##### 23 January 2025
    - Added new error messages for plotting the map.
    

- #### version 1.3
    ##### 20 January 2025
    - On the Map Distribution Page:
        - Added a second map named Normalized Y Value Distribution Map to display data adjusted by user selection (e.g., population or expected value).
        - Edited the legend in all map plots.
        
    - On the Spatiotemporal Epidemiological Analysis Page, in the Association with Risk Factors Tab:
        - Changed the calculation method from percentage increase to relative risk (RR).
        - Highlighted areas with significant values on the map.
        - Edited the legend in all map plots.
        - Edited examples of interpretation.
        
    - On the Manual Page:
        - Edited the application Manual.


- #### version 1.2 
    ##### 29 July 2023
    - Added dropdown to select an expected value for data that contains this value.
    - Added new installation methods.
    - Edited details in application.
    - Edited the application manual.
    


- #### version 1.1 
    ##### 17 May 2023
    This version according to **the test task** and **the usability test** from 20 people (Group of people with experience in public health and group of people with experience in non-health (IT related)):
    - Added tooltip at dropdown in 'Upload Data' page.
    - Added calculate expected value.
    - Added 'fullscreen' button in all map.
    - Added select column to download option in 'Association with Risk Factors' tap.
    - Added download map option by pressing 'screenshot map' button.
    - Added 'Releases' page.
    - Added details about analysis in 'Upload Data' page.
    - Added details about in 'Manual' page.
    - Added details of model in 'Help' page.
    - Added examples of interpretation on 'Spatiotemporal Epidemiological Analysis' page.
    - Fixed manual is not displayed.
    - Changed UI style.
    - Changed the 'time period' filter from slider to dropdown.
    - Changed button and title color on these pages: Map Distribution and Spatiotemporal Epidemiological Analysis.
    - Edited the application manual.
    - Edited the variable name on 'Association with Risk Factors' tap from 'percent_increase_riskfactor' is 'riskfactor_percent_increase'. According to the usability test, some users are unable to choose their preferred risk factor. Because on the screen of variable names, not all of them are visible, only the word front.
    - Fixed bug of 'Download results' on 'Association with Risk Factors' tap that cannot be downloaded if less than 7 covariates are included.

- #### version 1.0  
    ##### 27 March 2023
    This version is **initial release**.

</div>