# Load libraries
library(pdftools)
library(stringr)

split_pdf <- function(pdf_path) {
  # Extract text from each page
  text_pages <- pdf_text(pdf_path)
  
  # Get the base filename without extension
  base_filename <- tools::file_path_sans_ext(basename(pdf_path))
  
  # Initialize list to store split points and filenames
  split_points <- list()
  
    # Loop over pages to find markers and extract filenames
  for (i in seq_along(text_pages)) {
    # Find markers
    markers <- str_extract_all(text_pages[i], "(?<=%!).*?(?=%!)")[[1]]
    if (length(markers) > 0) {
      #print(markers)
      # Extract filename and add to list with the page number
      filenames <- markers
      split_points <- c(split_points, setNames(list(i), filenames))
    }
  }
  
  # Now, split the PDF based on found markers
  if (length(split_points) == 0) return() # No markers found, nothing to do.
  
  start_page <- split_points[[1]] # Start with the first marker page
  for (j in 2:length(split_points)) {
    filename <- names(split_points)[j-1]
    end_page <- split_points[[j]] - 1
    output_folder <- dirname(pdf_path)
    new_filename <- paste0(base_filename, " - ", filename, ".pdf")
    pdf_subset(pdf_path, pages = start_page:end_page, output = file.path(output_folder, new_filename))
    start_page <- split_points[[j]] # Next section starts from the current marker page
  }
  
  # Handle last section if applicable
  if (start_page <= length(text_pages)) {
    filename <- names(split_points)[length(split_points)]
    new_filename <- paste0(base_filename, " - ", filename, ".pdf")
    pdf_subset(pdf_path, pages = start_page:length(text_pages), output = file.path(output_folder, new_filename))
  }
}

# Split all PDFs with markers into separate files

black_list = c("docs/google_slides/wirtschaftsinformatik/Digitization - Information Representation and Processing%%1uxnlvUs4Ik6eqZOXSicL0H2OwoqFmDLiwREq3sD1C9A%%.pdf")

files <- list.files(google_slides_output_path, full.names = TRUE, recursive = T)

#files

#pdf_path <- "docs/google_slides/wirtschaftsinformatik/SS 25 - Digitization - Information Representation and Processing%%1W6LaBFpf5N8dJDiye4yCopZzAonZj-LPMflk92uGzm4%%.pdf"
#pdf_path <- "docs/google_slides/wirtschaftsinformatik/Digitization - Information Representation and Processing%%1uxnlvUs4Ik6eqZOXSicL0H2OwoqFmDLiwREq3sD1C9A%%.pdf"


for (file in files) {
  print(file)
  if(endsWith(file, ".pdf") && !(file %in% black_list)) {
    split_pdf(file)
  }
}

