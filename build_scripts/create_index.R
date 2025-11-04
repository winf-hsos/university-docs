# Build a Markdown/HTML index with images (4 per row via HTML table)
# Works on GitHub Pages without extra CSS. Images open in a new tab.

path <- "docs"
files <- list.files(path, full.names = TRUE, recursive = TRUE)
files <- files[files != file.path(path, "index.md")]
files <- sort(files)

md_file <- file.path(path, "index.md")
output <- c("# Content\n")

headings_dict <- c(
  artificial_intelligence = "Artificial Intelligence",
  static = "Static Files",
  google_documents = "Google Documents",
  google_slides = "Google Slides",
  quarto = "Quarto Documents",
  images = "Images",
  information_management = "Information Management",
  applied_analytics = "Applied Analytics",
  web_engineering = "Web Engineering",
  projekt_agrar_lebensmittel = "Projekt Agrar/Lebensmittel",
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

# ---------- Helpers ----------
is_image <- function(x) {
  ext <- tolower(tools::file_ext(x))
  ext %in% c("png", "jpg", "jpeg", "gif", "webp", "svg")
}
is_supported_file <- function(x) {
  grepl("\\.(pdf|png|jpg|jpeg|gif|webp|svg)$", tolower(x))
}
looks_like_file <- function(x) {
  # true wenn es wie "name.ext" aussieht
  grepl("\\.[A-Za-z0-9]{2,4}$", x)
}

# Table state
table_open <- FALSE
row_open <- FALSE
cells_in_row <- 0

open_table <- function() {
  if (!table_open) {
    output <<- c(output, "<table><tbody>")
    table_open <<- TRUE
    row_open <<- FALSE
    cells_in_row <<- 0
  }
}
start_row <- function() {
  if (!row_open) {
    output <<- c(output, "<tr>")
    row_open <<- TRUE
    cells_in_row <<- 0
  }
}
close_row <- function() {
  if (row_open) {
    output <<- c(output, "</tr>")
    row_open <<- FALSE
    cells_in_row <<- 0
  }
}
close_table <- function() {
  if (table_open) {
    if (row_open) close_row()
    output <<- c(output, "</tbody></table>\n")
    table_open <<- FALSE
  }
}

add_image_cell <- function(img_src, alt_txt) {
  open_table()
  start_row()
  cell <- sprintf(
    "<td style=\"vertical-align:top; width:25%%; padding:6px;\"><a href=\"%s\" target=\"_blank\" rel=\"noopener\"><img src=\"%s\" alt=\"%s\" style=\"max-width:100%%; height:auto;\" loading=\"lazy\" /></a></td>",
    img_src, img_src, alt_txt
  )
  output <<- c(output, cell)
  cells_in_row <<- cells_in_row + 1
  if (cells_in_row == 4) close_row()  # neue Zeile beim nächsten Bild
}

# Nur DANN Tabellen flushen, wenn wir wirklich eine Überschrift schreiben
write_category_heading <- function(key) {
  close_table()
  heading_text <- headings_dict[key]
  if (is.na(heading_text)) heading_text <- key
  output <<- c(output, paste0("\n## ", heading_text, "\n"))
}
write_subcategory_heading <- function(parent_category, key) {
  # Bei category == "images" nur dann Subheader, wenn key KEIN Dateiname ist
  if (parent_category == "images" && looks_like_file(key)) return(invisible(NULL))
  close_table()
  if (nzchar(key)) {
    heading_text <- headings_dict[key]
    if (is.na(heading_text)) heading_text <- key
    output <<- c(output, paste0("\n### ", heading_text, "\n"))
  }
}
write_subsubcategory_heading <- function(key) {
  if (!nzchar(key)) return(invisible(NULL))
  close_table()
  heading_text <- headings_dict[key]
  if (is.na(heading_text)) heading_text <- key
  output <<- c(output, paste0("\n#### ", heading_text, "\n"))
}
# ---------- /Helpers ----------

for (file in files) {
  parts <- unlist(strsplit(file, "/"))
  current_category        <- if (length(parts) >= 2) parts[2] else ""
  current_subcategory     <- if (length(parts) >= 3) parts[3] else ""
  current_subsubcategory  <- if (length(parts) >= 4) parts[4] else ""
  
  # Wenn subsubcategory wie Datei aussieht, ignorieren (kein Heading)
  if (is.na(current_subsubcategory) || looks_like_file(current_subsubcategory)) {
    current_subsubcategory <- ""
  }
  
  # --- Category-Wechsel ---
  if (current_category != category) {
    category <- current_category
    subcategory <- ""
    subsubcategory <- ""
    write_category_heading(category)
  }
  
  # --- Subcategory-Wechsel ---
  # Bei category=="images": viele Dateien liegen direkt darunter -> parts[3] ist Dateiname.
  # Also NUR Heading + Flush, wenn es KEIN Dateiname ist.
  if (current_subcategory != subcategory) {
    # Entscheiden, ob wir wirklich einen Subheader schreiben
    should_write_sub <- nzchar(current_subcategory) &&
      !looks_like_file(current_subcategory) &&
      !(category == "images" && looks_like_file(current_subcategory))
    if (should_write_sub && category != "images") {
      write_subcategory_heading(category, current_subcategory)
      subsubcategory <- ""
      subcategory <- current_subcategory
    } else if (should_write_sub && category == "images") {
      # images/<folder>/<file> → Folder-Heading erlaubt
      write_subcategory_heading(category, current_subcategory)
      subsubcategory <- ""
      subcategory <- current_subcategory
    } else {
      # Subcategory ist eigentl. Dateiname → nicht setzen, damit kein ständiger „Wechsel“ erkannt wird
      # (wichtig für images/<datei.png>)
      # subcategory bleibt wie sie ist.
    }
  }
  
  # --- Subsubcategory-Wechsel (nur wenn kein Dateiname) ---
  if (nzchar(current_subsubcategory) && current_subsubcategory != subsubcategory) {
    write_subsubcategory_heading(current_subsubcategory)
    subsubcategory <- current_subsubcategory
  }
  
  # --- Dateien verarbeiten ---
  if (is_supported_file(file)) {
    # optionale %%ID%% extrahieren
    id <- if (grepl("%%.*%%", file)) sub(".*%%(.*)%%.*", "\\1", file) else ""
    
    # %%...%% aus Dateinamen entfernen (no-op falls nicht vorhanden)
    file_renamed <- sub("%%.*%%", "", file)
    try(silent = TRUE, file.rename(file, file_renamed))
    
    file_name <- basename(file_renamed)
    rel_file  <- gsub("^docs/", "", file_renamed)
    
    if (is_image(rel_file)) {
      # Bilder inline: 4 pro Zeile, Tabelle NICHT bei jedem Bild schließen
      alt_txt <- tools::file_path_sans_ext(file_name)
      add_image_cell(rel_file, alt_txt)
    } else {
      # PDFs als Liste; vor Liste ggf. offene Tabelle schließen
      close_table()
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

# Am Ende evtl. offene Tabelle schließen
close_table()

# Schreiben (UTF-8)
writeLines(enc2utf8(output), md_file)
