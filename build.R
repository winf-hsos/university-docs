source("build_scripts/utils.R")

if (exists("build_steps")) {
  cat("Running defined build steps only.\n")
  run_all <- FALSE
} else {
  cat("Running all build steps\n")
  build_steps <- c("static_files", "google_slides", "google_docs", "quarto", "extract_images", "create_index", "push")
  recreate_output_directory("docs/")
  run_all <- TRUE
}

# Static Files
if("static_files" %in% build_steps) {
  source("build_scripts/copy_static_files.R")
}

# Docs
if("google_docs" %in% build_steps) {
  source("build_scripts/download_google_docs.R")
}

# Slides
if("google_slides" %in% build_steps) {
  source("build_scripts/download_google_slides.R")
}

# Images from Slides
if("extract_images" %in% build_steps) {
  source("build_scripts/extract_images_from_pdf.R")
}

# Split slides 
if("google_slides" %in% build_steps) {
  source("build_scripts/split_pdf_slides.R")
}

# Quarto
if("quarto" %in% build_steps) {
  source("build_scripts/render_and_copy_quarto_delta.R")
}

if("create_index" %in% build_steps) {
  source("build_scripts/create_index.R")
}

# Push
if("push" %in% build_steps) {
  source("build_scripts/push.R")
}

if(run_all == TRUE) {
  rm(build_steps)
}

cat("Done: https://winf-hsos.github.io/university-docs/\n")