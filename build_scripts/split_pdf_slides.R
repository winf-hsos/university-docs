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
      # Extract filename and add to list with the page number
      filenames <- str_replace_all(markers, "%!|%!", "")
      split_points <- c(split_points, setNames(list(i), filenames))
    }
  }
  
  print(split_points)
  
  # Now, split the PDF based on found markers
  start_page <- 1
  for (filename in names(split_points)) {
    end_page <- split_points[[filename]] - 1
    if (start_page <= end_page) {
      output_folder <- dirname(pdf_path)
      new_filename <- paste0(base_filename, " - ", filename, ".pdf")
      pdf_subset(pdf_path, pages = start_page:end_page, output = file.path(output_folder, paste0(new_filename)))
    }
    start_page <- split_points[[filename]] + 1
  }
  
}

# Example usage
split_pdf("docs/google_slides/wirtschaftsinformatik/Digitization - Information Representation and Processing.pdf")
