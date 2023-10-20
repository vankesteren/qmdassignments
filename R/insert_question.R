#' Add a question to the current qmd file
#'
#' @param insert whether to insert or print the question
#'
#' @export
question <- function(insert = TRUE) {
  # First, get the rstudio context
  context <- rstudioapi::getSourceEditorContext()

  # Then, get the content before the cursor
  start_row <- context$selection[[1]]$range$start[1]
  start_col <- context$selection[[1]]$range$start[2]
  content <- context$contents[1:start_row]
  content[start_row] <- substr(content[start_row], 1, start_col)

  # Then, get the next question number
  re <- "\\:{3}[ ]*\\{\\.callout\\-tip icon\\=false\\}\\n+\\#\\#"
  res <- gregexec(re, paste(content, collapse = "\n"))
  number <- if(res[[1]][1] == -1) 1 else length(res[[1]]) + 1

  # Then, compile the snippet
  prefix <- "::: {.callout-tip icon=false}\n## "
  midfix <- ". Perform a certain task\n\nHint: use R code to do this!\n\n```{r}\n#| label: q"
  suffix <- "\n#| include: !expr params\\$answers\n#| eval: !expr params\\$answers\n# R code here\n```\n:::"
  snippet <- paste0(prefix, number, midfix, number, suffix)

  if (!insert) return(snippet)

  # Then add the question at the cursor location
  rstudioapi::insertText(
    location = context$selection[[1]]$range,
    text = snippet,
    id = context$id
  )
}
