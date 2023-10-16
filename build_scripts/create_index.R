path <- "docs"
files <- list.files(path, full.names = TRUE, recursive = T)
files <- sort(files)

#files

# Create a markdown document
md_file <- paste0(path, "index.md")
output <- c("# Content\n")

headings_dict <- c(
  google_docs = "Google Documents",
  google_slides = "Google Slides",
  quarto = "Quarto Documents"
)

category = ""
for (file in files) {
  
  parts <- unlist(strsplit(file, "/"))
  
  current_category = parts[2]
  if(current_category != category) {
    category = current_category
    heading_text = headings_dict[category]
    
    if(is.na(heading_text))
      heading_text = category
    
    output <- c(output, paste0("## ", heading_text, "\n"))
  }
  
  if(endsWith(file, ".pdf") | endsWith(file, ".png")) {
    file_name <- basename(file)
    file <- gsub("docs//", "", file)
    file_link <- paste0("- [", file_name, "](", file, ")")
    output <- c(output, file_link)
  }
  
}

#output

# Write the markdown document
writeLines(output, md_file)


# Replace 'your_file.pdf' with the path to your PDF file
#pdf_file <- "docs/quarto/web-engineering/exercise-personal-website-html.pdf"
#pdf_file <- "docs/google_slides/Information Management  - Course Logistics.pdf"

# Extract metadata
#pdf_info <- pdf_info(pdf_file)

# Print metadata
#print(pdf_info)
