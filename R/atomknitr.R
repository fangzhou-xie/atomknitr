#' Custom Knit function for Atom
#'
#' @export
atomknitr <- function(inputFile, encoding) {

  rmd <- readLines(inputFile)

  # read yaml header from rmd file and append them into the output file
  yaml <- rmd[grep("---", rmd)[1]: grep("---", rmd)[2]]

  # write out to a temp file
  ofile <- rmarkdown::render(inputFile, output_dir = "../_posts", encoding=encoding, envir=new.env())

  ofile <- file.path("../_posts", paste0(tools::file_path_sans_ext(basename(inputFile)), ".html"))
  html <- readLines(ofile)
  html <- append(yaml, html)
  writeLines(html, ofile)
}
