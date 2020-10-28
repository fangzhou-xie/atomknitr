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

  # remove auto-generated title and date from html file
  # these info has been captured by the yaml
  titleid <- grep("<h1 class=\"title.*?\">.*?</h1>", html)
  dateid <- grep("<h4 class=\"date\">.*?</h4>", html)
  html[titleid] <- paste0("<!-- ", html[titleid], " -->")
  html[dateid] <- paste0("<!-- ", html[dateid], " -->")

  # for some reason, the output will have duplicate elements
  # we need to manipulate the html content to remove them
  pids <- grep("<p>.*?</p>", html)
  html <- html[-pids[1:(length(pids)/2)]]

  # append yaml headers on the top
  html <- append(yaml, html)
  writeLines(html, ofile)
}
