f <- list.files("/tmp", pattern = "^INLA_.*[.]tar", full.names = TRUE)[1]
if (is.na(f)) stop("INLA tarball not found in /tmp")
message("Installing INLA from: ", f)

# อ่าน dependency (Depends + Imports) จาก DESCRIPTION ในไฟล์ แล้วติดตั้งจาก CRAN
d <- tempfile(); dir.create(d)
untar(f, exdir = d)
desc <- list.files(d, pattern = "^DESCRIPTION$", recursive = TRUE, full.names = TRUE)[1]
dcf <- read.dcf(desc, fields = c("Depends", "Imports"))
deps <- unlist(strsplit(paste(na.omit(as.vector(dcf)), collapse = ","), ","))
deps <- trimws(sub("\\(.*\\)", "", gsub("\n", " ", deps)))
deps <- setdiff(deps[nzchar(deps)],
                c("R", rownames(installed.packages(priority = "base"))))
message("Installing dependencies: ", paste(deps, collapse = ", "))
install.packages(deps)

# ติดตั้ง INLA จากไฟล์โดยตรง
install.packages(f, repos = NULL, type = "source")

if (!requireNamespace("INLA", quietly = TRUE)) stop("Failed to install INLA! Build stopped.")
message("INLA installed: ", as.character(packageVersion("INLA")))