library(pdftools)
library(magick)
library(stringr)

source("build_scripts/utils.R")

extract_images <- function(pdf_path) {

  # Get PDF information and text content
  pdf_info <- pdf_info(pdf_path)
  total_slides <- pdf_info$pages
  pdf_text <- pdf_text(pdf_path)
  
  # Vector to hold pages that will be kept (i.e., without the skip marker)
  pages_to_keep <- c()
  
  for (p in 1:total_slides) {
    slide_text <- pdf_text[p]
    
    # Extract image if a secret code is found (regardless of skip marker)
    image_file_name <- str_extract(slide_text, "(?<=%%).*?(?=%%)")
    if (!is.na(image_file_name)) {
      message(paste("Extracting image for slide", p, "with name:", image_file_name))
      image <- image_read_pdf(pdf_path, pages = p)
      image_path <- paste0(images_output_path, image_file_name, ".png")
      unlink(image_path)
      image_write(image, image_path)
    }
    
    # Check for the skip marker on the slide
    if (grepl("<<skip>>", slide_text)) {
      message(paste("Slide", p, "will be removed from the PDF due to <<skip>> marker."))
      next  # Do not add this slide to pages_to_keep
    }
    
    # Add slide to pages_to_keep if no skip marker is present
    pages_to_keep <- c(pages_to_keep, p)
  }
  
  # Create a temporary PDF with only the kept slides
  temp_pdf_path <- tempfile(fileext = ".pdf")
  pdf_subset(pdf_path, pages = pages_to_keep, output = temp_pdf_path)
  
  # Overwrite the original PDF with the new PDF
  file.copy(temp_pdf_path, pdf_path, overwrite = TRUE)
  file.remove(temp_pdf_path)
  
  message("Original PDF has been overwritten with the modified slides.")
}

files <- list.files(google_slides_output_path, full.names = TRUE, recursive = T)

unlink(images_output_path, recursive = TRUE)
dir.create(images_output_path)

for (file in files) {
  if(endsWith(file, ".pdf")) {
    extract_images(file)
  }
}

