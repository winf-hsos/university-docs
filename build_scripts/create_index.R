path <- "docs"
files <- list.files(path, full.names = TRUE, recursive = T)
files <- files[files != "docs/index.md"]
files <- sort(files)

#files

# Create a markdown document
md_file <- paste0(path, "/index.md")
output <- c("# Content\n")

headings_dict <- c(
  google_documents = "Google Documents",
  google_slides = "Google Slides",
  quarto = "Quarto Documents",
  images = "Images",
  information_management = "Information Management",
  applied_analytics = "Applied Analytics",
  web_engineering = "Web Engineering",
  projekt_agrar_lebensmittel = "Projekt Agrar/Lebensmittel",
  wirtschaftsinformatik = "Wirtschaftsinformatik"
)

category = ""
subcategory = ""
for (file in files) {
  
  parts <- unlist(strsplit(file, "/"))
  
  current_category = parts[2]
  current_subcategory = parts[3]
  
  if(current_category != category) {
    category = current_category
    heading_text = headings_dict[category]
    
    if(is.na(heading_text))
      heading_text = category
    
    output <- c(output, paste0("\n## ", heading_text, "\n"))
  }
  
  if(current_subcategory != subcategory) {
    subcategory = current_subcategory
    heading_text = headings_dict[subcategory]
    
    if(is.na(heading_text))
      heading_text = subcategory
    
    output <- c(output, paste0("\n### ", heading_text, "\n"))
  }
  
  if(endsWith(file, ".pdf") | endsWith(file, ".png")) {
    file_name <- basename(file)
    file <- gsub("docs/", "", file)
    
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
