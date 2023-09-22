# Functions to test projects
# Copyright (c) 2023, Philippe Grosjean (phgrosjean@sciviews.org) &
#   Guyliann Engels (Guyliann.Engels@umons.ac.be)


# Transformation functions ------------------------------------------------

df_structure <- function(object, ...) {
  list(
    names = names(object),
    nrow = nrow(object),
    ncol = ncol(object),
    classes = sapply(object, function(x) class(x)[1]),
    nas = sapply(object, function(x) sum(is.na(x)))
  )
}

digest <- function(object, algo = "md5", ...) {
  digest::digest(object, algo = algo, ...)
}

# Main functions to record results ----------------------------------------

res_dir <- here::here("tests", "results")

# Read and write results
read_res <- function(name, ..., res_dir = res_dir,
    nthreads = parallel::detectCores(logical = FALSE)) {
  qs::qread(fs::path(res_dir, name), nthreads = nthreads, ...)
}

write_res <- function(object, name, ..., res_dir = res_dir,
    nthreads = parallel::detectCores(logical = FALSE)) {
  qs::qsave(object, file = fs::path(res_dir, name), nthreads = nthreads, ...)
}

# The main function to put a result in /tests/results
record_res <- function(object = ".Last.value", name = object, fun = NULL, ...,
    dir = res_dir) {
  file <- fs::path(dir, name)

  data <- get0(object)
  if (is.null(data))
    return(invisible(FALSE))

  if (!is.null(fun))
    data <- try(fun(data, ...), silent = TRUE)

  data.io::write$rds(data, file)
  invisible(TRUE)
}

# Shortcuts
RO <- record_res

RN <- function(name, object = ".Last.value", fun = NULL, ...)
  record_res(object = object, name = name, fun = fun, ...)

RODFS <- function(object = ".Last.value", name = object, fun = df_structure)
  record_res(object = object, name = name, fun = fun, ...)

RNDFS <- function(name, object = ".Last.value", fun = df_structure, ...)
  record_res(object = object, name = name, fun = fun, ...)

ROMD5 <- function(object = ".Last.value", name = object, fun = digest)
  record_res(object = object, name = name, fun = fun, ...)

RNMD5 <- function(name, object = ".Last.value", fun = digest, ...)
  record_res(object = object, name = name, fun = fun, ...)


# Set and get references --------------------------------------------------

ref_dir <- here::here("tests", "reference")

set_ref <- function(name, ..., res_dir = res_dir, ref_dir = ref_dir,
    nthreads = parallel::detectCores(logical = FALSE)) {
  res <- read_res(name, ..., dir = res_dir, nthreads = nthreads)
  res <- qs::qserialise(res, preset = "archive")
  res <- qs::base85_encode(res)
  qs::qsave(res, file = fs::path(ref_dir, name), nthreads = nthreads, ...)
}

get_ref <- function(name, ..., ref_dir = ref_dir,
    nthreads = parallel::detectCores(logical = FALSE)) {
  res <- qs::qread(fs::path(ref_dir, name), nthreads = nthreads, ...)
  res <- qs::base85_decode(res)
  qs::qdeserialize(res)
}


# Simplified test functions -----------------------------------------------

# Check if the rendered version of a Quarto or R Markdown file exists
is_rendered <- function(quarto, format = "html") {
  rendered <- sub("\\.[qR]md$", paste0(".", format), quarto)
  rendered_path <- here::here(rendered)
  fs::file_exists(rendered_path)
}

# Check if the rendered version is up-to-date
is_rendered_current <- function(quarto, format = "html") {
  rendered <- sub("\\.[qR]md$", paste0(".", format), quarto)
  quarto_path <- here::here(quarto)
  rendered_path <- here::here(rendered)
  fs::file_exists(rendered_path) &&
    file.mtime(rendered_path) >= file.mtime(quarto_path)
}

# A data file exists and contains a data.frame
is_data <- function(data, dir = "data", format = "rds", check_df = FALSE) {
  data_path <- here::here(dir, paste(data, format, sep = "."))
  res <- fs::file_exists(data_path)
  if (!res)
    return(structure(FALSE, message = "The data file ", data_path,
      " is not found."))
  res <- try(data.io::read(data_path, type = format), silent = TRUE)
  if (inherits(res, "try-error"))
    return(structure(FALSE, message = res))

  if (isTRUE(check_df) && !inherits(res, "data.frame"))
    return(structure(FALSE, message = "The data file ", data_path,
      " is found but it does not contains a data frame."))

  # Everything is OK
  TRUE
}

is_dataframe <- function(data, dir = "data", format = "rds", check_df = TRUE)
  is_data(data, dir = dir, format = format, check_df = check_df)


# Tests reporter ----------------------------------------------------------

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
