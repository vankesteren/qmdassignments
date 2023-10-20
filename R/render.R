#' Render assignment file
#'
#' This function renders an assignment .qmd to html in two ways:
#' one with only the questions, or/and one which also includes the
#' solutions.
#'
#' @param questions <bool> whether to render the questions
#' @param answers <bool> whether to render the solutions
#' @param append_hash <bool> whether to append a hash to the solutions file.
#' See details.
#'
#' @details
#' The hash can be useful if you host both the questions and
#' solutions on a single webserver, and you want the students
#' to not be able to view the answers before you choose to make
#' them available via a link.
#'
#' @export
render <- function(questions = TRUE, solutions = TRUE, append_hash = TRUE) {

  # get path to currently open document
  rstudio_id <- rstudioapi::documentId(allowConsole = FALSE)
  qmd_path <- fs::path(tryCatch(
    expr = rstudioapi::documentPath(id = rstudio_id),
    error = \(e) cli::cli_abort("Save your current file as .qmd before rendering!")
  ))

  # make sure file is qmd
  if (tolower(fs::path_ext(qmd_path)) != "qmd")
    cli::cli_abort("Open a .qmd file and then run render_assignment().")

  # setwd ugliness because quarto only accepts relative paths in output_file
  oldwd <- getwd()
  on.exit(setwd(oldwd))
  setwd(fs::path_dir(qmd_path))

  if (questions) {
    cli::cli_alert_info("Rendering assignment file without questions...")
    out_path <-
      qmd_path |>
      fs::path_file() |>
      fs::path_ext_set("html")

    quarto::quarto_render(
      input          = qmd_path,
      output_format  = "html",
      output_file    = out_path,
      execute        = TRUE,
      execute_dir    = fs::path_dir(qmd_path),
      execute_params = list(answers = "false")
    )
  }

  if (solutions) {
    cli::cli_inform("Rendering solutions file...")
    hash <- if (append_hash)
      paste0("_", substr(cli::hash_md5(rnorm(1)), 1, 6))
    else ""

    sol_path <-
      qmd_path |>
      fs::path_file() |>
      fs::path_ext_remove() |>
      paste0("_answers", hash) |>
      fs::path_ext_set("html")

    quarto::quarto_render(
      input          = qmd_path,
      output_format  = "html",
      output_file    = sol_path,
      execute        = TRUE,
      execute_dir    = fs::path_dir(qmd_path),
      execute_params = list(answers = "true")
    )
  }
}

