# Download and save Google Docs from google_docs.yaml ####
library(httr)
library(pdftools)

library(yaml)
docs_yaml <- read_yaml("google_slides.yaml")

for (module_name in names(docs_yaml$slides)) {
  module_path = paste0("docs/google_slides/", module_name)
  
  unlink(module_path, recursive = TRUE)
  
  # Access the list of IDs for the current module
  ids <- docs_yaml$slides[[module_name]]
  
  dir.create(module_path)
  
  # Iterate through the slides IDs within the current module
  for (id in ids) {
    
    # Save temporary
    url <- paste0("https://docs.google.com/presentation/d/", id, "/export?format=pdf")
    doc <- GET(url, write_disk("docs/google_slides/tmp.pdf", overwrite=TRUE))
    
    # Rename
    doc_infos <- pdf_info("docs/google_slides/tmp.pdf")
    doc_title <- doc_infos$keys$Title
    
    new_file_name = paste0(module_path, "/", doc_title, ".pdf")
    file.rename("docs/google_slides/tmp.pdf", new_file_name)
  }
}