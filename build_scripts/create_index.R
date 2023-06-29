path <- "docs/"
files <- list.files(path, full.names = TRUE, recursive = T)

# Create a markdown document
md_file <- paste0(path, "index.md")
output <- c("# Content\n")

for (file in files) {
  if(endsWith(file, ".pdf") | endsWith(file, ".png")) {
    file_name <- basename(file)
    file <- gsub("docs//", "", file)
    file_link <- paste0("- [", file_name, "](", file, ")")
    output <- c(output, file_link)
  }
  
}

output

# Write the markdown document
writeLines(output, md_file)