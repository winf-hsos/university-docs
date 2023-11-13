library(fs)

# Constants
google_slides_output_path <- "docs/google_slides/"
images_output_path <- "docs/images/"


recreate_ouput_directory <- function (output_path) {
  if (dir_exists(output_path)) {
    dir_delete(output_path)
  }
  dir_create(output_path)
}