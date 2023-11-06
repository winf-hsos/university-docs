# Create output directory
library(fs)
output_path <- "docs"
if (dir_exists(output_path)) {
  dir_delete(output_path)
}
dir_create(output_path)

if (exists("build_steps")) {
  print("Running defined build steps only.")
} else {
  print("Running all build steps")
  build_steps <- c("google_slides", "google_docs", "quarto", "extract_images", "create_index", "push")
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

# Quarto
if("quarto" %in% build_steps) {
  source("build_scripts/render_and_copy_quarto.R")
}

if("create_index" %in% build_steps) {
  source("build_scripts/create_index.R")
}

# Push
if("push" %in% build_steps) {
  source("build_scripts/push.R")
}

print("Done: https://winf-hsos.github.io/university-docs/")