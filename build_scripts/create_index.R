path <- "docs"
files <- list.files(path, full.names = TRUE, recursive = T)
files <- files[files != "docs/index.md"]
files <- sort(files)

#files

# Create a markdown document
md_file <- paste0(path, "/index.md")
output <- c("# Content\n")

headings_dict <- c(
  static = "Static Files",
  google_documents = "Google Documents",
  google_slides = "Google Slides",
  quarto = "Quarto Documents",
  images = "Images",
  information_management = "Information Management",
  applied_analytics = "Applied Analytics",
  web_engineering = "Web Engineering",
  projekt_agrar_lebensmittel = "Projekt Agrar/Lebensmittel",
  wirtschaftsinformatik = "Wirtschaftsinformatik",
  empirisches_arbeiten = "Empirisches Arbeiten",
  data_analytics= "Data Analytics",
  digitization_and_programming = "Digitization and Programming",
  digital_lab = "Digital Lab",
  modern_data_analytics_with_r = "Modern Data Analytics with R"
)

category = ""
subcategory = ""
for (file in files) {
  
  # The parts from the filename
  parts <- unlist(strsplit(file, "/"))
  
  current_category = parts[2]
  current_subcategory = parts[3]
  
  # Check if we arrived at a new category
  if(current_category != category) {
    category = current_category
    heading_text = headings_dict[category]
    
    if(is.na(heading_text))
      heading_text = category
    
    output <- c(output, paste0("\n## ", heading_text, "\n"))
  }
  
  # Check if we arrived at a new subcategory
  if(current_subcategory != subcategory) {
    subcategory = current_subcategory
    heading_text = headings_dict[subcategory]
    
    if(is.na(heading_text))
      heading_text = subcategory
    
    # No subheader for images
    if(current_category != "images") {
      output <- c(output, paste0("\n### ", heading_text, "\n"))
    }
  }
  
  # Should be PDF of PNG image
  if(endsWith(file, ".pdf") | endsWith(file, ".png")) {
    
    file_name <- basename(file)
    
    #print(file_name)
    
    # See if there is ID in the file name ("%%ID%%)
    id <- sub(".*%%(.*)%%.*", "\\1", file_name)
    
    #print(id)
  
    file <- gsub("docs/", "", file)
    file_link <- paste0("- [", file_name, "](", file, ")")
    
    # If an ID is present in the filename
    if(id != file_name) {
      # Remove the ID suffix from the file name
      file_name <- sub("_(\\d+)\\.pdf", ".pdf", file_name)
      
      # Create link to Google Slide
      url_google = paste0("https://docs.google.com/presentation/d/", id, "/edit")
      file_link <- paste0(file_link, " {[Edit](", url_google, ")}")
    }
    
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
