cat("Copy static files!\n")

# Define the directory where you want to search for static files
base_directory <- "static"

# List all files in the directory and its subdirectories
static_files <- list.files(base_directory, recursive = TRUE, full.names = TRUE)

# Delete subdirectory "docs/static" if it exists
if (dir.exists("docs/static")) {
  unlink("docs/static", recursive = TRUE)
}

# Create a subdirectory in the "docs" directory named "static"
# Overwrite all contents if the directory exists
dir.create("docs/static", recursive = TRUE, showWarnings = FALSE)

for (static_file in static_files) {
  
  destination <- paste0("docs/", static_file)
  
  # Check if destination exists and create if not
  if (!dir.exists(dirname(destination))) {
    dir.create(dirname(destination), recursive = TRUE, showWarnings = FALSE)
  }

  # Copy the file to the "docs" directory
  file.copy(static_file, destination, overwrite = TRUE)
}
