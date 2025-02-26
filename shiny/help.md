<div style = "text-align: justify; margin-right: 60px; font-size: 16px">

## <span style="color:#735DFB"> **Help** </span>

<div class='box-white'>

###  **Structure**
<img width="40px" height="10px" src="Rectangle.svg">

<!--<div style = "width:40px; height:5px; background: #735DFB;"> </div>-->

<!-- ใส่ว่าเว็บมีกี่หน้า และอธิยบายแต่ละหน้าคืออะไรอย่างละเอียด -->
The application consists of eight pages:

**1.Home page**

&emsp;&emsp;The home page is the first page of the  application, explaining what this  app does. On this page, there are two buttons: "Get Started" and "How to use?". The "Get Started" button can go to the "upload data" page. The "How to use?" button can go to the "Manual" page, which explains how to use the  application in a format that is easier to understand than the "help" page and also have a demonstration of how to use  application.

**2.Upload data page**

&emsp;&emsp;The "upload data" page allows users to upload data to be analyzed. This page consists of two sections: 

**2.1 Input Data**  
&emsp;&emsp; The input data section includes sections to upload a shapefile and a csv file (health outcome) then the user has to select the columns from the dropdown menus for further analysis. 

 &emsp;&emsp; **> Shapefile**
  
  &emsp;&emsp; Thai geographic coordinates, Thai provincial boundaries data (shapefile) will be obtained from the GEO package file in the Global Administrative Region Database (GADM). Shapefile upload allows users to upload all 4 files at the same time only: 1. shp 2. dbf 3. shx and 4. prj. Then, the user has to select the area id in the dropdown which must match the area name in the csv file. 

&emsp;&emsp;**> CSV file**

&emsp;&emsp;The user can only upload one csv file, which must contain: 

&emsp;&emsp;1. area id (a number starting at 1, used to identify provinces). 

&emsp;&emsp;2. area name (name of province) 

&emsp;&emsp;3. cases (outcomes) 

&emsp;&emsp;4. time point

&emsp;&emsp;5. population


&emsp;&emsp;&emsp;&emsp; **- Select Expected Value (Optional)**

&emsp;&emsp;&emsp;&emsp; The expected value is number of outcomes in the provided area and period which may vary due to the types of diseases.

&emsp;&emsp;&emsp;&emsp; If the CSV file lacks an expected value column, the calculation will use the 'cases' and 'population' columns to derive an expected value. The expected value will be calculated using the following formula.
      
  $$\text{Expected Value} = \frac{\sum(\text{cases})}{\sum(\text{population})} \times \text{population}$$
      
&emsp;&emsp;&emsp;&emsp; If the CSV file has an expected value column, the user can choose the expected value column using a dropdown, and this value will be used in the calculation.


**2.2 Preview Input Data**

&emsp;&emsp; The preview input data section can preview input data where users uploaded all data. Once the data has been successfully uploaded, users can view the analysis results on the "spatiotemporal epidemiological analysis" page.

**3.Map Distribution**

&emsp;&emsp;The Map Distribution displays an interactive distribution map of the user uploaded shapefile and csv file on the Upload data page using case column to plot. Users can visualize and select filters including time period and color scheme.

**4.Spatiotemporal epidemiological analysis page**

&emsp;&emsp;The "spatiotemporal epidemiological analysis" page is the page that occurs result after the user has successfully uploaded the data on the "upload data" page. This page includes two taps: Cluster Detection, and Association with Risk Factors.

<!--* **Model Setting** -->

**4.1 Cluster Detection Tap**

&emsp;&emsp;Cluster detection is an important tool for identifying areas of high risk and developing hypotheses about health outcomes [[1]](https://doi.org/10.1186/1476-072X-6-13). Cluster detection used to compute probabilities that the risk in an area exceeds certain thresholds can be done using the posterior probability distributions [[2]](http://www.jstor.org/stable/3085830). This probability of exceedance can then be used to decide whether an area should be hot-spot [[3]](https://doi.org/10.1289%2Fehp.6740). The Cluster detection Tab displays a hotspot area map of the data.

  - **Details of the model**
    
    This application perform cluster detection in spatiotemporal epidemiological analysis section using Bayesian spatiotemporal model. Let $y_{it}$ be raw death counts for location $i$ and time $t$ which are a more common outcome of Bayesian disease mapping is modeled as an combination of intercept, and random effects.

    $$y_{it} \sim Poisson(E_{it}\rho_{it}), \\ log(\rho_{it}) = \alpha + \eta_{it}$$

    The space-time random effects in the model describe variation due to location and time.  The spatial effect is spatially structured effect called BYM. It is spatial effects combined unstructured spatial effect and spatially structured effect which can be expressed as;

    $$u_i |u_{-i}  \sim Normal(\mu_i + \frac{1}{N_i}\sum_{j=1}^{n} a_{ij}(u_j-\mu_j),s_{1}^{2}) + u_i\sim iid \ Normal(0,\ σ^{2})$$

    The temporal effect is structured effect called random walk prior of order 1 which can be written as;

    $$γ_t |γ_{t-1} \sim Normal(γ_{t-1},\ σ^{2}) $$

    The prior distribution of space-time interaction  depends on the spatial and temporal main effects which are assumed to interact. The model is interaction type I which unstructured spatial and temporal effects interact to each other.


**4.2 Association with Risk Factors Tap**

 &emsp;&emsp;The percentage of a health outcome expected to change as a risk factor increases one unit. When the probability is positive, it means that as the risk factor rises, so will the outcome, whereas when the probability is negative, it means that if the risk factor increases, the outcome decreases. The data are assumed to be unrelated when the probability is zero. The association Tab displays an association between risk factors and case outcomes.

&emsp;&emsp;From this analysis, the coefficient of the risk factors obtained from the fit model, which is in the log scale, must be exponentiated and minus 1 and multiplied by 100. Therefore, the value is obtained as a percent increase.

  - **Details of the model**

    Association with risk factors is performed in spatiotemporal epidemiological analysis section using Bayesian spatiotemporal model. Let  $y_{it}$ be raw death counts for location $i$ and time $t$ which are a more common outcome of Bayesian disease mapping is modeled as an combination of intercept, fixed effects (risk factors), and random effects.
    
    $$y_{it} \sim Poisson(E_{it}\rho_{it}), \\ log(\rho_{it}) = \alpha + \sum_{m}^{M} \beta_{m} \ x_{mit} + \eta_{it}$$

    The risk factor association is modeled on the multiplicative scale. Conditioned on the random effect terms and other fixed effects constant. The space-time random effects in the model describe variation due to location and time.  The details of spatial effect, temporal effect and space-time interaction in this model can be found on *"4.1 Cluster Detection Tap in Details of the model"*

**5.About application**

&emsp;&emsp; The "about application" page is a page that describes the background, purpose, developer, advisor, and references of the  application.


**6.Manual page** 

&emsp;&emsp;  The "Manual" page explains how to use the application as a pdf book.

**7.Help page**

&emsp;&emsp; The "help" page is a page that describes structure of each page, dependencies, and data used for case study of the  application.


**8.Releases page**

&emsp;&emsp;  The "Releases" page is a page that describes version history of application.

</div>


<div class='box-white'>

### **When Error Occurred ?**
<img width="40px" height="10px" src="Rectangle.svg">

If an error occurs in usage, for example:
| <div style="margin-right: 30em">Error Message</div>                                                                                | Description                                                                |
| ------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------|
| > Map display gray color | > It is caused by the user changing pages or changing taps while the application is plotting the map. The solution is to try displaying the map by filters adjusting.
| > Application crashes or analysis not working                                                                                 | > It may be because the user uploaded data that is not as specified making it unable to analyze the data.
| > Application crashes display "ERROR: out of memory"                                                                                 | > Depending on the performance of the device used, it may be because the user is using the application too quickly, for example, plotting a map too often without completing the previous plot. Try closing any other programs that not using at the moment.


</div>


<div class='box-white'>

### **Sample Data**
<img width="40px" height="10px" src="Rectangle.svg">

<!-- <img align="right" width="500px" height="420px" src="undraw_file_searching.svg" style = " margin-left: 60px;"> -->



&emsp;&emsp; The sample data used for case study in this application consists of Thailand shapefile and csv file which can be [downloaded here📑](https://drive.google.com/drive/folders/1vheBturgr3gclBq7kqp5dWouPf_C0VbQ?usp=share_link).

1. **Thailand shapefile** contains 4 files that cannot be missing any of them due to their references to each other: shp, dbf, shx, and prj. These Shapefiles represent **provincial boundaries (Level 1)**.
  <p align="center">
      <img width="60%" src="th_shapfile.jpg" alt= “Thailand_shapefile” >
      </br>
      Thailand shapefile
  </p> 
  </br>

2. **csv file** contains the following 12 columns: 

    **1. province** is the name of province which has a total of 77 provinces.

    **2. province_id** is the number of province starting at from 1 to 77 .

    **3. year** is the number of year starting at from 1 to 11.

    **4. suicide** is the number of suicides.

    **5.Population** population in each area.

    **6-12. 7 covariates:** debt, income, poverty, expenditure, homicide crime, property crime and shocking crime.

  <p align="center">
    <img width="60%" src="th_csv.jpg" alt= “csv_file”>
    </br>
    Thailand suicide mortality and risk factors 2011-2021
  </p> 
</div>


<!-- <div class='box-white'>

### **Contact us**
<img width="40px" height="10px" src="Rectangle.svg">

If you have any trouble with this  application or have any further questions or feedback, then please contact us at: ornrakorn.mek@outlook.com and we will be happy to help.

</div> -->

</div>