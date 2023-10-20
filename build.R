# Docs
source("build_scripts/download_google_docs.R")

# Slides
source("build_scripts/download_google_slides.R")
source("build_scripts/extract_images_from_pdf.R")

# Quarto
source("build_scripts/render_and_copy_quarto.R")

source("build_scripts/create_index.R")

# Push
source("build_scripts/push.R")

print("Done: https://winf-hsos.github.io/university-docs/")