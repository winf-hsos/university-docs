library(pdftools)
library(magick)
library(stringr)

extract_images <- function(pdf_path) {
  pdf_info <- pdf_info(pdf_path)
  total_slides <- pdf_info$pages
  
  pdf_text <- pdf_text(pdf_path)
  
  #print(pdf_text)
  
  for (p in 1:total_slides) {
    
    # Get the image file name from the secret code on the slide (if present)
    image_file_name <- str_extract(pdf_text[p], "(?<=%%).*?(?=%%)")
    
    #print(image_file_name)
    
    if(!is.na(image_file_name)) {
      image <- image_read_pdf(pdf_path, pages = p )
      image_path = paste0("docs/images/", image_file_name, ".png")
      unlink(image_path)
      image_write(image, image_path)
    }
  }
}

path <- "docs/google_slides"
files <- list.files(path, full.names = TRUE, recursive = T)
#files

unlink("docs/images", recursive = TRUE)
dir.create("docs/images")

for (file in files) {
  if(endsWith(file, ".pdf")) {
    extract_images(file)
  }
  
}

