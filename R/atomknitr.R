#' Custom Knit function for Atom
#'
#' @export
atomknitr <- function(inputFile, encoding) {

  # inputFile <- "2020-10-28-atom-rmd.rmd"
  rmd <- readLines(inputFile)

  # read yaml header from rmd file and append them into the output file
  yaml <- rmd[grep("---", rmd)[1]: grep("---", rmd)[2]]
  rmdcontent <- rmd[-(grep("---", rmd)[1]: grep("---", rmd)[2])]
  # font style config
  style <- unlist(strsplit("<style type=\"text/css\">\n  body{\n  font-size: 13pt;\n}\n</style>", "\n"),
                  use.names = F)
  bib <- c("bibliography:", "  - \"`r system('kpsewhich ~/Zotero/Library.bib', intern=TRUE)`\"")
  yaml <- append(yaml, bib, after=grep("---", rmd)[2]-1)
  yaml_style <- append(yaml, style)
  rmd_style <- append(yaml_style, rmdcontent)

  # write out to a temp file
  tmpfile <- file.path(tempdir(), basename(inputFile))
  writeLines(rmd_style, tmpfile)
  ofile <- rmarkdown::render(tmpfile, output_dir = "../_posts", encoding=encoding, envir=new.env())

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
  # html <- html[-pids[1:(length(pids)/2)]]

  # append yaml headers on the top
  html <- append(yaml, html)
  writeLines(html, ofile)
}

#' Custom Knit function for VS Code
#'
#' @export
vscodeknitr <- function(inputFile, encoding, output_dir = "./_posts") {

  # inputFile <- "2020-10-28-atom-rmd.rmd"
  rmd <- readLines(inputFile)

  # read yaml header from rmd file and append them into the output file
  yaml <- rmd[grep("---", rmd)[1]:grep("---", rmd)[2]]
  rmdcontent <- rmd[-(grep("---", rmd)[1]:grep("---", rmd)[2])]
  # font style config
  style <- unlist(strsplit("<style type=\"text/css\">\n  body{\n  font-size: 13pt;\n}\n</style>", "\n"),
                  use.names = F)
  bib <- c("bibliography:", "  - \"`r system('kpsewhich ~/Zotero/Library.bib', intern=TRUE)`\"")
  yaml <- append(yaml, bib, after = grep("---", rmd)[2] - 1)
  yaml_style <- append(yaml, style)
  rmd_style <- append(yaml_style, rmdcontent)

  # write out to a temp file
  tmpfile <- file.path(tempdir(), basename(inputFile))
  writeLines(rmd_style, tmpfile)
  ofile <- rmarkdown::render(tmpfile, output_dir = output_dir, encoding = encoding, envir = new.env())

  ofile <- file.path(output_dir, paste0(tools::file_path_sans_ext(basename(inputFile)), ".html"))
  # file.copy(tmpfile, ofile, overwrite = T)
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
  # html <- html[-pids[1:(length(pids)/2)]]

  # append yaml headers on the top
  html <- append(yaml, html)
  writeLines(html, ofile)
}
