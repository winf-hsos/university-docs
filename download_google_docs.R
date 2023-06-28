# Download and save Google Docs from google_docs.yaml ####
library(httr)
library(pdftools)

library(yaml)
docs_yaml <- read_yaml("google_docs.yaml")

unlink("public/google_docs/*.pdf")

for (i in 1:length(docs_yaml$docs)) { 
  
  # Save temporary
  url <- paste0("https://docs.google.com/document/d/", docs_yaml$docs[i], "/export?format=pdf")
  
  print(url)
  
  doc <- GET(url, write_disk("public/google_docs/tmp.pdf", overwrite=TRUE))
  
  # Rename
  doc_infos <- pdf_info("public/google_docs/tmp.pdf")
  doc_title <- doc_infos$keys$Title
  
  file.rename("public/google_docs/tmp.pdf", paste0("public/google_docs/", doc_title, ".pdf"))
}
