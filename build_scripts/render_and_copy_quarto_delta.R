library(quarto)  # Load the quarto package if not already loaded

# Define the directory where you want to search for ".qmd" files
base_directory <- "quarto"

# List all ".qmd" files in the directory and its subdirectories
qmd_files <- list.files(base_directory, pattern = "\\.qmd$", recursive = TRUE, full.names = TRUE)

# Remove files in "bundle" directory, will be rendered manually at the end
qmd_files <- qmd_files[!grepl("bundle", qmd_files)]

# Iterate through the list of ".qmd" files
for (qmd_file in qmd_files) {
  # Construct the corresponding ".pdf" file path
  pdf_file <- sub("\\.qmd$", ".pdf", qmd_file)
  
  # Check if the ".pdf" file exists or if it doesn't exist
  if (!file.exists(pdf_file) || file.info(qmd_file)$mtime > file.info(pdf_file)$mtime) {
    # Execute the "render_quarto()" function with the ".qmd" file
    cat("Start rendering: ", qmd_file, "\n")
    quarto_render(qmd_file, output_format = "pdf", quiet = TRUE)
    cat("Finished rendering: ", qmd_file, "\n")
  }
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
dir.create("docs/quarto/digitization_and_programming/script")
dir.create("docs/quarto/digitization_and_programming/script/book")
dir.create("docs/quarto/digitization_and_programming/exercises")
dir.create("docs/quarto/digitization_and_programming/programming_exercises")

dir.create("docs/quarto/big_data_analytics")

# Copy PDF files
file.copy(pdf_list, pdf_dest_list, overwrite = TRUE)

# Render "Digitalisierung und Programmierung" Buch (TODO: Entferne manuelles Rendering)
cat("Rendering book as HTML and PDF\n")

current_wd <- getwd()
setwd("quarto/digitization_and_programming/script/bundle/")
quarto_render(quiet = FALSE, as_job = FALSE)
setwd(current_wd)

cat("Copy book files, HTML and PDF")
file.copy("quarto/digitization_and_programming/script/bundle/book", "docs/quarto/digitization_and_programming/script", overwrite = TRUE, recursive = TRUE)
