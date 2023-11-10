library(pdftools)
library(magick)
library(stringr)

source("build_scripts/utils.R")

extract_images <- function(pdf_path) {
  pdf_info <- pdf_info(pdf_path)
  total_slides <- pdf_info$pages
  pdf_text <- pdf_text(pdf_path)
  
  for (p in 1:total_slides) {
    
    # Get the image file name from the secret code on the slide (if present)
    image_file_name <- str_extract(pdf_text[p], "(?<=%%).*?(?=%%)")
  
    #print(image_file_name)
    
    if(!is.na(image_file_name)) {
      image <- image_read_pdf(pdf_path, pages = p )
      image_path = paste0(images_output_path, image_file_name, ".png")
      unlink(image_path)
      image_write(image, image_path)
    }
  }
}


files <- list.files(google_slides_output_path, full.names = TRUE, recursive = T)

unlink(images_output_path, recursive = TRUE)
dir.create(images_output_path)

for (file in files) {
  if(endsWith(file, ".pdf")) {
    extract_images(file)
  }
}

