# ใช้ Shiny image ที่ pin R 4.5.1 เพื่อให้ INLA ติดตั้งได้เสถียร
FROM rocker/shiny:4.5.1

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


# ติดตั้ง INLA จากไฟล์ใน repo (server ของ INLA บล็อก install.packages จาก build server)
COPY INLA_*.tar* /tmp/
COPY install_inla.R /tmp/install_inla.R
RUN Rscript /tmp/install_inla.R

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