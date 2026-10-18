
# สรุปลำดับงาน: หาไฟล์ → แตกไฟล์เพื่ออ่านรายการ dependency → ติดตั้ง dependency จาก CRAN → ติดตั้ง INLA จากไฟล์ → ตรวจว่าใช้งานได้


# ----  ส่วนที่ 1: หาไฟล์ INLA ----

# หาไฟล์ใน /tmp ที่ชื่อขึ้นต้นด้วย INLA_ และมี .tar (ครอบคลุมทั้ง .tar และ .tar.gz) เป็นไฟล์ที่
# Dockerfile COPY มาไว้ แล้วเก็บ path เต็มของไฟล์แรกที่เจอไว้ในตัวแปร f
f <- list.files("/tmp", pattern = "^INLA_.*[.]tar", full.names = TRUE)[1]


if (is.na(f)) stop("INLA tarball not found in /tmp")
# ถ้าไม่เจอไฟล์เลย f จะเป็น NA สคริปต์จะหยุดพร้อมข้อความชัดเจน แทนที่จะพังด้วย error ที่อ่านยากในภายหลัง

message("Installing INLA from: ", f)
# พิมพ์ชื่อไฟล์ที่ใช้ลงใน log เพื่อตรวจสอบย้อนหลังได้ว่าติดตั้งเวอร์ชันไหน


# ---- ส่วนที่ 2: หา dependency ของ INLA ----
# อ่าน dependency (Depends + Imports) จาก DESCRIPTION ในไฟล์ แล้วติดตั้งจาก CRAN

d <- tempfile(); dir.create(d)
untar(f, exdir = d)
# สร้างโฟลเดอร์ชั่วคราว แล้วแตกไฟล์ tarball ลงไป เพื่อให้เปิดอ่านไฟล์ DESCRIPTION ข้างในได้

desc <- list.files(d, pattern = "^DESCRIPTION$", recursive = TRUE, full.names = TRUE)[1]
# หาไฟล์ DESCRIPTION ในโฟลเดอร์ที่แตกออกมา ไฟล์นี้บอกว่าแพ็กเกจต้องใช้แพ็กเกจอื่นอะไรบ้าง

dcf <- read.dcf(desc, fields = c("Depends", "Imports"))
# อ่านเฉพาะช่อง Depends และ Imports ซึ่งเป็น dependency ที่จำเป็น (ไม่อ่าน Suggests ที่เป็นแพ็กเกจเสริม
# เพราะรอบก่อนที่ใช้ dependencies = TRUE ไปดึง INLAspacetime มาแล้วพัง)


deps <- unlist(strsplit(paste(na.omit(as.vector(dcf)), collapse = ","), ","))
# รวมข้อความสองช่องเข้าด้วยกัน แล้วแยกเป็นรายชื่อแพ็กเกจทีละตัวโดยใช้เครื่องหมายจุลภาค

deps <- trimws(sub("\\(.*\\)", "", gsub("\n", " ", deps)))
# ทำความสะอาดรายชื่อ ลบการขึ้นบรรทัดใหม่ ลบเงื่อนไขเวอร์ชันในวงเล็บ เช่น Matrix (>= 1.0)
# ให้เหลือแค่ Matrix และตัดช่องว่างหัวท้าย

deps <- setdiff(deps[nzchar(deps)],
                c("R", rownames(installed.packages(priority = "base"))))
# เอารายชื่อที่ว่างออก แล้วตัด R กับแพ็กเกจพื้นฐานที่มากับ R อยู่แล้ว (เช่น stats, utils, methods) ออก
# เพราะติดตั้งจาก CRAN ไม่ได้และไม่จำเป็น


message("Installing dependencies: ", paste(deps, collapse = ", "))
install.packages(deps)
# พิมพ์รายชื่อลง log แล้วติดตั้งทั้งหมดจาก CRAN (ตรงนี้ใช้ binary snapshot จาก p3m.dev ที่ตั้งไว้ใน base image จึงเร็ว)


# ---- ส่วนที่ 3: ติดตั้ง INLA และตรวจผล ----


install.packages(f, repos = NULL, type = "source")
# ติดตั้ง INLA จากไฟล์โดยตรง repos = NULL หมายถึงไม่ต้องไปโหลดจาก repository ใดๆ
# และ type = "source" ให้ใช้ R CMD INSTALL กับไฟล์นี้เลย ซึ่งต่างจาก remotes::install_local ที่พยายาม build ก่อนจนพัง


if (!requireNamespace("INLA", quietly = TRUE)) stop("Failed to install INLA! Build stopped.")
# ตรวจว่า INLA โหลดใช้งานได้จริงไหม ถ้าไม่ได้ให้หยุดทันทีเพื่อให้ Docker build ล้มเหลว (ดีกว่าปล่อยให้ build ผ่านแล้วแอปพังตอนรัน)


message("INLA installed: ", as.character(packageVersion("INLA")))
# พิมพ์เวอร์ชัน INLA ที่ติดตั้งสำเร็จลง log เพื่อยืนยันว่าเป็นเวอร์ชันที่ต้องการ