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
  exercises = "Übungsaufgaben",
  script = "Skript",
  programming = "Programmierung",
  programming_exercises = "Programmierübungen",
  big_data_analytics = "Big Data Analytics",
  abschlussarbeiten = "Abschlussarbeiten"
)

category = ""
subcategory = ""
subsubcategory = ""

#print(files)

for (file in files) {
  
  #file = files[16]
  
  # The parts from the filename
  parts <- unlist(strsplit(file, "/"))
  
  current_category = parts[2]
  current_subcategory = parts[3]
  current_subsubcategory = parts[4]
  
  # Check if subsubcategory is NA
  if(is.na(current_subsubcategory)) {
    current_subsubcategory = ""
  }
  
  # Check if subsubcategory is valid; it may not contain a file-ending with the pattern ".xxx"
  if(grepl("\\..{3}$", current_subsubcategory)) {
    current_subsubcategory = ""
  }
  
  
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
  
  # Check if we arrived at a new subsubcategory
  print(file)
  print(current_subsubcategory)
  print(subsubcategory)
  if(current_subsubcategory != "" && current_subsubcategory != subsubcategory) {
    subsubcategory = current_subsubcategory
    heading_text = headings_dict[subsubcategory]
    
    if(is.na(heading_text))
      heading_text = subsubcategory
    
    output <- c(output, paste0("\n#### ", heading_text, "\n"))
  }
  
  # Should be PDF of PNG image
  if(endsWith(file, ".pdf") | endsWith(file, ".png")) {
    
    # Check if the filename contains the %% pattern
    if (grepl("%%.*%%", file)) {
      # Extract the ID if the pattern exists
      id <- sub(".*%%(.*)%%.*", "\\1", file)
    } else {
      # Set id to an empty string if no pattern is found
      id <- ""
    }
   
    # Remove the ID suffix from the file name
    file_renamed <- sub("%%.*%%", "", file)
    
    # Rename the file
    success <- file.rename(file, file_renamed)
    
    file_name <- basename(file_renamed)
    
    #print(file_name)
    #print(id)

    file <- gsub("docs/", "", file_renamed)
    file_link <- paste0("- [", file_name, "](", file, ")")
    
    # If an ID is present in the filename
    if(id != "") {
      # Create link to Google Slide
      #print(category)
      
      if(category == "google_slides") {
        placeholder = "presentation"
      }
      else {
        placeholder = "document"
      }
      url_google = paste0("https://docs.google.com/", placeholder, "/d/", id, "/edit")
      file_link <- paste0(file_link, " [[Edit](", url_google, ")]")
    }
    
    output <- c(output, file_link)
  }
  
}

#output

# Write the markdown document
writeLines(enc2utf8(output), md_file)


# Replace 'your_file.pdf' with the path to your PDF file
#pdf_file <- "docs/quarto/web-engineering/exercise-personal-website-html.pdf"
#pdf_file <- "docs/google_slides/Information Management  - Course Logistics.pdf"

# Extract metadata
#pdf_info <- pdf_info(pdf_file)

# Print metadata
#print(pdf_info)
