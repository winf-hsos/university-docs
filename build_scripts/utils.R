library(fs)

# Constants
google_slides_output_path <- "docs/google_slides/"
images_output_path <- "docs/images/"


recreate_output_directory <- function (output_path) {
  if (dir_exists(output_path)) {
    #dir_delete(output_path)
    unlink(output_path, recursive = TRUE, force = TRUE)
  }
  dir_create(output_path)
}