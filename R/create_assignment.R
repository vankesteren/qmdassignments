#' Create a new assignment file
#'
#' This will open a new document in RStudio and fill it with a template
#'
#' @export
create <- function() {
  template_path <- fs::path_join(c(fs::path_package("qmdassignments"), "assignment_template.qmd"))
  rstudio_id <- rstudioapi::documentNew(readLines(template_path), type = "rmarkdown")
}
