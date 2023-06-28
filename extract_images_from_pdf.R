library(pdftools)
library(magick)

pdf_path <- "docs/google_slides/LiFi-Project - Program's Anatomy.pdf"
pdf_info <- pdf_info(pdf_path)

# Extract the total number of pages/slides
total_slides <- pdf_info$pages

for (p in 1:total_slides) {

  image <- image_read_pdf(pdf_path, pages = p )
  image_path = paste0("docs/images/img_", p, ".png")
  unlink(image_path)
  image_write(image, image_path)
}