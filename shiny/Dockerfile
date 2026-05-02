# ใช้ image ล่าสุดของ Shiny (Ubuntu 24.04 / R 4.4+)
FROM rocker/shiny:latest

# ติดตั้ง System Dependencies ที่จำเป็น
RUN apt-get update && apt-get install -y \
    cmake \
    libabsl-dev \
    libudunits2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

# ติดตั้งแพ็กเกจพื้นฐานจาก CRAN
RUN R -e "install.packages('remotes'); \
    install.packages(c('shiny', 'shinydashboard', 'shinyjs', 'shinyBS', 'leaflet', 'dplyr', 'ggplot2', 'RColorBrewer', 'shinyWidgets', 'shinydashboardPlus', 'sf', 'spdep', 'leaflet.extras', 'bsplus', 'markdown', 'readxl', 'plotly', 'DT'))"

# ติดตั้ง INLA (อัปเดตเป็น testing repo สำหรับ R เวอร์ชันใหม่ และเขียนตัวดัก Error)
RUN R -e "install.packages('INLA', repos=c(INLA='https://inla.r-inla-download.org/R/testing', getOption('repos')), dependencies=TRUE); \
    if (!requireNamespace('INLA', quietly = TRUE)) stop('❌ Failed to install INLA! Build stopped.')"

RUN chmod -R 755 /usr/local/lib/R/site-library/INLA || true

# ติดตั้งแพ็กเกจ capture
RUN R -e "remotes::install_github('dreamRs/capture')"

WORKDIR /app
COPY . /app

# ตั้งค่า User สำหรับ Hugging Face
RUN useradd -m -u 1000 user
RUN chown -R user:user /app
USER user

EXPOSE 7860
CMD ["R", "-e", "shiny::runApp('/app/app.R', host = '0.0.0.0', port = 7860)"]