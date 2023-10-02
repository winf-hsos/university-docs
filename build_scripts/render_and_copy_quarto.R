library(quarto)

# Render and copy course material ####
qmd_list <- list.files("quarto", ".qmd", full.names = TRUE, recursive = TRUE)
quarto_render(qmd_list, output_format = "pdf")


# Get all PDF files
pdf_list <- list.files("quarto", ".pdf", full.names = TRUE, recursive = TRUE)
pdf_dest_list <- gsub("quarto/", "docs/quarto/", pdf_list)

# Create directories for modules
unlink("docs/quarto", recursive = TRUE)
dir.create("docs/quarto")
dir.create("docs/quarto/web-engineering")
dir.create("docs/quarto/information-management")

# Copy PDF files
file.copy(pdf_list, pdf_dest_list, overwrite = TRUE)
