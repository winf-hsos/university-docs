library(quarto)  # Load the quarto package if not already loaded

# Define the directory where you want to search for ".qmd" files
base_directory <- "quarto"

# List all ".qmd" files in the directory and its subdirectories
qmd_files <- list.files(base_directory, pattern = "\\.qmd$", recursive = TRUE, full.names = TRUE)


# Iterate through the list of ".qmd" files
for (qmd_file in qmd_files) {
  # Construct the corresponding ".pdf" file path
  pdf_file <- sub("\\.qmd$", ".pdf", qmd_file)
  
  # Execute the "render_quarto()" function with the ".qmd" file
  cat("Start rendering: ", qmd_file, "\n")
  quarto_render(qmd_file, output_format = "pdf", quiet = TRUE)
  cat("Finished rendering: ", qmd_file, "\n")

}

cat("Done with rendering Quarto files!\n")
cat("Copying PDF files to output foleder\n")

# Get all PDF files
pdf_list <- list.files("quarto", ".pdf", full.names = TRUE, recursive = TRUE)
pdf_dest_list <- gsub("quarto/", "docs/quarto/", pdf_list)

# Create directories for modules
unlink("docs/quarto", recursive = TRUE)
dir.create("docs/quarto")
dir.create("docs/quarto/web_engineering")
dir.create("docs/quarto/information_management")
dir.create("docs/quarto/applied_analytics")
dir.create("docs/quarto/data_analytics")
dir.create("docs/quarto/digitization_and_programming")

# Copy PDF files
file.copy(pdf_list, pdf_dest_list, overwrite = TRUE)
