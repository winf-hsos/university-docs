# Download and save Google Docs from google_docs.yaml ####
library(httr)
library(pdftools)

library(yaml)
docs_yaml <- read_yaml("google_slides.yaml")

unlink("docs/google_slides/*.pdf")

for (i in 1:length(docs_yaml$slides)) { 
  
  # Save temporary
  url <- paste0("https://docs.google.com/presentation/d/", docs_yaml$slides[i], "/export?format=pdf")
  
  print(url)
  
  doc <- GET(url, write_disk("docs/google_slides/tmp.pdf", overwrite=TRUE))
  
  # Rename
  doc_infos <- pdf_info("docs/google_slides/tmp.pdf")
  doc_title <- doc_infos$keys$Title
  
  file.rename("docs/google_slides/tmp.pdf", paste0("docs/google_slides/", doc_title, ".pdf"))
}
