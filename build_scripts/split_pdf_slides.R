# Load libraries
library(pdftools)
library(stringr)


split_pdf <- function(pdf_path) {
  # Extract text from each page
  text_pages <- pdf_text(pdf_path)
  
  # Initialize list to store split points and filenames
  split_points <- list()
  
  # Loop over pages to find markers and extract filenames
  for (i in seq_along(text_pages)) {
    # Find markers
    markers <- str_extract_all(text_pages[i], "%!.*?!%")[[1]]
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
      pdf_subset(pdf_path, pages = start_page:end_page, output = paste0(filename, ".pdf"))
    }
    start_page <- split_points[[filename]] + 1
  }
  
  # Check if there are pages after the last marker
  if (start_page <= length(text_pages)) {
    pdf_subset(pdf_path, pages = start_page:length(text_pages), output = "remaining_pages.pdf")
  }
}

# Example usage
split_pdf("path_to_your_pdf.pdf")
