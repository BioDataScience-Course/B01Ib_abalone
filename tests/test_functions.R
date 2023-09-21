check_object <- function(object = ".Last.value", name = object, fun = NULL, ...) {

  file <- paste0('tests/results/', name, ".rds")

  data <- get0(object)
  if (is.null(data))
    return(invisible(FALSE))

  if (!missing(fun))
    data <- try(fun(data, ...), silent = TRUE)

  data.io::write$rds(data, file)

  invisible(TRUE)
}

df_structure <- function(object) {
  list(
    names = names(object),
    nrow = nrow(object),
    ncol = ncol(object),
    classes = sapply(object, function(x) class(x)[1]),
    nas = sapply(object, function(x) sum(is.na(x)))
  )
}

read_res <- function(name, ...) {
  file <- paste0("../results/", name, ".rds")
  if (fs::file_exists(file)) {
    data.io::read$rds(file, ...)
  } else {
    NULL
  }
}

read_tpl <- function(name, ...) {
  file <- paste0("../templates/", name, ".rds")
  data.io::read$rds(file)
}

digest <- function(object) {
  digest::digest(object)
}

sddReporter <- testthat::LocationReporter

sddReporter$public_methods$start_test <- function(context, test) {
  self$cat_line("  ", cli::symbol$bullet, " ", test)
}

sddReporter$public_methods$end_test <- function(context, test) {
  cli::cat_rule()
}

sddReporter$public_methods$add_result <- function(context, test, result) {
  status <- expectation_type(result)
  status_fr <- switch(status,
    success = "réussi",
    failure = "échec",
    error = "erreur",
    skip = "ignoré",
    warning = "avis")
  if (status == "error" || status == "failure") {
    self$cat_line("    ", cli::col_red(cli::symbol$cross), " ",
      expectation_location(result), " [", status_fr, "]")
  } else if (status == "avis") {
    self$cat_line("    ", cli::col_yellow(cli::symbol$warning), " ",
      expectation_location(result), " [", status_fr, "]")
  } else if (status == "skip") {
    self$cat_line("    ", cli::col_cyan(cli::symbol$info), " ",
      expectation_location(result), " [", status_fr, "]")
  } else {# success
    self$cat_line("    ", cli::col_green(cli::symbol$tick), " ",
      expectation_location(result), " [", status_fr, "]")
  }
}

sddReporter$public_methods$start_file <- function(name) {
  name <- sub("test-([0-9]+)", "Fichier \\1 : ", name)
  name <- sub("\\.R$", "", name)
  name <- gsub("__", "/", name)
  name <- paste0("\n", cli::symbol$pointer, " ", name)
  self$cat_line(cli::col_cyan(name))
}
