path <- "docs"
files <- list.files(path, full.names = TRUE, recursive = T)
files <- files[files != "docs/index.md"]
files <- sort(files)

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

# Buffer für Bilder (max 3 pro Reihe)
image_buffer <- c()

for (file in files) {
  parts <- unlist(strsplit(file, "/"))
  current_category = parts[2]
  current_subcategory = parts[3]
  current_subsubcategory = parts[4]
  
  if(is.na(current_subsubcategory)) current_subsubcategory = ""
  if(grepl("\\..{3}$", current_subsubcategory)) current_subsubcategory = ""
  
  # Kategorie
  if(current_category != category) {
    category = current_category
    heading_text = headings_dict[category]
    if(is.na(heading_text)) heading_text = category
    output <- c(output, paste0("\n## ", heading_text, "\n"))
  }
  
  # Subkategorie
  if(current_subcategory != subcategory) {
    subcategory = current_subcategory
    heading_text = headings_dict[subcategory]
    if(is.na(heading_text)) heading_text = subcategory
    if(current_category != "images") {
      output <- c(output, paste0("\n### ", heading_text, "\n"))
    }
  }
  
  # Sub-Subkategorie
  if(current_subsubcategory != "" && current_subsubcategory != subsubcategory) {
    subsubcategory = current_subsubcategory
    heading_text = headings_dict[subsubcategory]
    if(is.na(heading_text)) heading_text = subsubcategory
    output <- c(output, paste0("\n#### ", heading_text, "\n"))
  }
  
  # PDF oder PNG
  if(endsWith(file, ".pdf") | endsWith(file, ".png")) {
    if (grepl("%%.*%%", file)) {
      id <- sub(".*%%(.*)%%.*", "\\1", file)
    } else {
      id <- ""
    }
    
    file_renamed <- sub("%%.*%%", "", file)
    success <- file.rename(file, file_renamed)
    file_name <- basename(file_renamed)
    file <- gsub("docs/", "", file_renamed)
    
    if(endsWith(file, ".png")) {
      # Für PNG → Bild inline einfügen
      img_tag <- paste0("![](", file, "){width=30% style='display:inline-block; margin:5px;'}")
      image_buffer <- c(image_buffer, img_tag)
      
      # Wenn 3 gesammelt → Zeile ausgeben
      if(length(image_buffer) == 3) {
        row <- paste(image_buffer, collapse=" ")
        output <- c(output, row, "\n")
        image_buffer <- c()
      }
    } else {
      # Für PDF → Link
      file_link <- paste0("- [", file_name, "](", file, ")")
      if(id != "") {
        placeholder <- ifelse(category == "google_slides", "presentation", "document")
        url_google <- paste0("https://docs.google.com/", placeholder, "/d/", id, "/edit")
        file_link <- paste0(file_link, " [[Edit](", url_google, ")]")
      }
      output <- c(output, file_link)
    }
  }
}

# Restbilder (falls <3)
if(length(image_buffer) > 0) {
  row <- paste(image_buffer, collapse=" ")
  output <- c(output, row, "\n")
}

# Markdown schreiben
writeLines(enc2utf8(output), md_file)
