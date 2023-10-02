# Folders

`quarto/`: Contains all documents that are written in Quarto. All files ending in `.qmd` within this folder will be rendered by `render_and_copy_quarto.R` when building the project.

`docs/`: This is the output folder for all rendered and downloaded material. This is where the websites looks for content.

`build_scripts/`: This folder contains the single R-scripts that are bundled by `build.R`. The scripts are self-contained and can be executed separately.

# Adding a Google Slide or Google Doc.

To add a Google Slide document, open the `google_slides.yaml` and add the documents ID from the URL. When building, a listed documents will be fetched via their ID and downloaded as PDF.

The same is true for Google Docs, but here the file is `google_docs.yaml`.