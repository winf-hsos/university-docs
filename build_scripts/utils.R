library(fs)

recreate_ouput_directory <- function (subpath) {
  if (dir_exists(output_path)) {
    dir_delete(output_path)
  }
  dir_create(output_path)
}