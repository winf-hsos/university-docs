# Build a Markdown/HTML index with images (3 per row via HTML table)
# Works reliably on GitHub Pages without custom CSS

path <- "docs"
files <- list.files(path, full.names = TRUE, recursive = TRUE)
files <- files[files != file.path(path, "index.md")]
files <- sort(files)

md_file <- file.path(path, "index.md")
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
  data_analytics = "Data Analytics",
  digitization_and_programming = "Digitization and Programming",
  digital_lab = "Digital Lab",
  exercises = "Übungsaufgaben",
  script = "Skript",
  programming = "Programmierung",
  programming_exercises = "Programmierübungen",
  big_data_analytics = "Big Data Analytics",
  abschlussarbeiten = "Abschlussarbeiten"
)

category <- ""
subcategory <- ""
subsubcategory <- ""

# Helper: detect image files
is_image <- function(x) {
  ext <- tolower(tools::file_ext(x))
  ext %in% c("png", "jpg", "jpeg", "gif", "webp", "svg")
}

# Track state
table_open <- FALSE
cells_in_row <- 0

open_table <- function() {
  if (!table_open) {
    output <<- c(output, "<table><tbody><tr>")
    table_open <<- TRUE
    cells_in_row <<- 0
  }
}

close_table <- function() {
  if (table_open) {
    if (cells_in_row > 0) {
      output <<- c(output, "</tr>")
    }
    output <<- c(output, "</tbody></table>\n")
    table_open <<- FALSE
    cells_in_row <<- 0
  }
}

add_image_cell <- function(img_src, alt_txt) {
  # Each cell: 25% width (4 pro Reihe)
  cell <- sprintf(
    "<td style=\"vertical-align:top; width:25%%; padding:6px;\"><a href=\"%s\" target=\"_blank\" rel=\"noopener\"><img src=\"%s\" alt=\"%s\" style=\"max-width:100%%; height:auto;\" /></a></td>",
    img_src, img_src, alt_txt
  )
  output <<- c(output, cell)
  cells_in_row <<- cells_in_row + 1
  
  if (cells_in_row == 4) {
    output <<- c(output, "</tr><tr>")
    cells_in_row <<- 0
  }
}

flush_before_heading <- function() {
  close_table()
}

for (file in files) {
  parts <- unlist(strsplit(file, "/"))
  current_category       <- if (length(parts) >= 2) parts[2] else ""
  current_subcategory    <- if (length(parts) >= 3) parts[3] else ""
  current_subsubcategory <- if (length(parts) >= 4) parts[4] else ""
  
  if (is.na(current_subsubcategory) || grepl("\\..{3,4}$", current_subsubcategory)) {
    current_subsubcategory <- ""
  }
  
  # New category
  if (current_category != category) {
    flush_before_heading()
    category <- current_category
    heading_text <- headings_dict[category]
    if (is.na(heading_text)) heading_text <- category
    output <- c(output, paste0("\n## ", heading_text, "\n"))
    subcategory <- ""
    subsubcategory <- ""
  }
  
  # New subcategory
  if (current_subcategory != subcategory) {
    flush_before_heading()
    subcategory <- current_subcategory
    heading_text <- headings_dict[subcategory]
    if (is.na(heading_text)) heading_text <- subcategory
    if (category != "images" && nzchar(subcategory)) {
      output <- c(output, paste0("\n### ", heading_text, "\n"))
    }
    subsubcategory <- ""
  }
  
  # New sub-subcategory
  if (nzchar(current_subsubcategory) && current_subsubcategory != subsubcategory) {
    flush_before_heading()
    subsubcategory <- current_subsubcategory
    heading_text <- headings_dict[subsubcategory]
    if (is.na(heading_text)) heading_text <- subsubcategory
    output <- c(output, paste0("\n#### ", heading_text, "\n"))
  }
  
  # Process supported files
  if (grepl("\\.(pdf|png|jpg|jpeg|gif|webp|svg)$", tolower(file))) {
    
    # Extract optional %%ID%%
    id <- if (grepl("%%.*%%", file)) sub(".*%%(.*)%%.*", "\\1", file) else ""
    
    # Remove %%...%% from filename on disk
    file_renamed <- sub("%%.*%%", "", file)
    try(silent = TRUE, file.rename(file, file_renamed))
    
    file_name <- basename(file_renamed)
    rel_file  <- gsub("^docs/", "", file_renamed)
    
    if (is_image(rel_file)) {
      # Ensure table exists and a row is started
      open_table()
      if (cells_in_row == 0) start_row()
      
      alt_txt <- tools::file_path_sans_ext(file_name)
      add_image_cell(rel_file, alt_txt)
      
    } else {
      # PDFs as links
      close_table()  # make sure table doesn't interleave with list
      file_link <- paste0("- [", file_name, "](", rel_file, ")")
      if (nzchar(id)) {
        placeholder <- ifelse(category == "google_slides", "presentation", "document")
        url_google  <- paste0("https://docs.google.com/", placeholder, "/d/", id, "/edit")
        file_link   <- paste0(file_link, " [[Edit](", url_google, ")]")
      }
      output <- c(output, file_link)
    }
  }
}

# Close any open image table
close_table()

# Write out
writeLines(enc2utf8(output), md_file)
