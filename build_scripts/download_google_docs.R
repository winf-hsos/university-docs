# Download and save Google Docs from google_docs.yaml ####
library(httr)
library(pdftools)

source("build_scripts/utils.R")
output_path <- "docs/google_documents/"
recreate_output_directory(output_path)

library(yaml)
docs_yaml <- read_yaml("google_docs.yaml")

for (module_name in names(docs_yaml$docs)) {
  module_path = paste0(output_path, module_name)
  
  unlink(module_path, recursive = TRUE)
  
  # Access the list of IDs for the current module
  ids <- docs_yaml$docs[[module_name]]
  
  dir.create(module_path)
  
  # Iterate through the slides IDs within the current module
  for (id in ids) {
    
    # Save temporary
    url <- paste0("https://docs.google.com/document/d/", id, "/export?format=pdf")
    cat(url, "\n")
    doc <- GET(url, write_disk(paste0(output_path,"tmp.pdf"), overwrite=TRUE))
    
    # Rename
    doc_infos <- pdf_info(paste0(output_path,"tmp.pdf"))
    
    # Add the ID in the file name (remove later when creating the index)
    doc_title <- paste0(doc_infos$keys$Title, "%%", id, "%%")
    
    #doc_title <- doc_infos$keys$Title
    
    new_file_name = paste0(module_path, "/", doc_title, ".pdf")
    file.rename(paste0(output_path,"tmp.pdf"), new_file_name)
  }
}

cat("Done with Google Docs\n")
