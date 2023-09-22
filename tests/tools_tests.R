# Functions to test projects
# Copyright (c) 2023, Philippe Grosjean (phgrosjean@sciviews.org) &
#   Guyliann Engels (Guyliann.Engels@umons.ac.be)


# Transformation functions ------------------------------------------------

df_structure <- function(object, ...) {
  list(
    names = names(object),
    labels = lapply(object, function(x) {
      res <- attr(x, "label")
      if (is.null(res) || is.na(res)) "" else as.character(res)
    }),
    units = lapply(object, function(x) {
      res <- attr(x, "units")
      if (is.null(res) || is.na(res)) "" else as.character(res)
    }),
    nrow = nrow(object),
    ncol = ncol(object),
    classes = sapply(object, function(x) class(x)[1]),
    nas = sapply(object, function(x) sum(is.na(x))),
    comment = comment(object)
  )
}

digest <- function(object, algo = "md5", ...) {
  digest::digest(object, algo = algo, ...)
}

# Main functions to record results ----------------------------------------

res_dir <- here::here("tests", "results")

# Read and write results
read_res <- function(name, ..., dir = res_dir,
    nthreads = parallel::detectCores(logical = FALSE)) {
  qs::qread(fs::path(dir, name), nthreads = nthreads, ...)
}

write_res <- function(object, name, ..., dir = res_dir,
    nthreads = parallel::detectCores(logical = FALSE)) {
  qs::qsave(object, file = fs::path(dir, name), nthreads = nthreads, ...)
}

# The main function to put a result in /tests/results
record_res <- function(object_name = ".Last.value", name = object_name,
    fun = NULL, ..., dir = res_dir) {
  file <- fs::path(dir, name)

  data <- get0(object_name)
  if (is.null(data))
    return(invisible(FALSE))

  if (!is.null(fun))
    data <- try(fun(data, ...), silent = TRUE)

  write_res(data, name = name, dir = dir)
  invisible(TRUE)
}

# Shortcuts
RO <- record_res

RN <- function(name, object_name = ".Last.value", fun = NULL, ...)
  record_res(object = object_name, name = name, fun = fun, ...)

RODFS <- function(object_name = ".Last.value", name = object_name,
    fun = df_structure, ...)
  record_res(object_name = object_name, name = name, fun = fun, ...)

RNDFS <- function(name, object_name = ".Last.value", fun = df_structure, ...)
  record_res(object_name = object_name, name = name, fun = fun, ...)

ROMD5 <- function(object_name = ".Last.value", name = object_name, fun = digest,
    ...)
  record_res(object_name = object_name, name = name, fun = fun, ...)

RNMD5 <- function(name, object_name = ".Last.value", fun = digest, ...)
  record_res(object_name = object_name, name = name, fun = fun, ...)


# Set and get references --------------------------------------------------

ref_dir <- here::here("tests", "reference")

# We don't use write_ref() because the mechanism is different!
make_ref <- function(name, ..., dir1 = res_dir, dir2 = ref_dir,
    nthreads = parallel::detectCores(logical = FALSE)) {
  res <- read_res(name, ..., dir = dir1, nthreads = nthreads)
  res <- qs::qserialize(res, preset = "archive")
  res <- qs::base85_encode(res)
  qs::qsave(res, file = fs::path(dir2, name), nthreads = nthreads, ...)
}

read_ref <- function(name, ..., dir = ref_dir,
    nthreads = parallel::detectCores(logical = FALSE)) {
  res <- qs::qread(fs::path(dir, name), nthreads = nthreads, ...)
  res <- qs::base85_decode(res)
  qs::qdeserialize(res)
}

set_key <- function() {
  # Try first to retrieve it from a file
  key_file <- here::here("tests/results/key")
  if (fs::file_exists(key_file))
    return(qs::qread(key_file))
  pass <- rstudioapi::askForPassword()
  if (is.null(pass)) # User cancelled
    return()
  if (digest::digest(pass) != "cfe7383614aacd5035642bf60d7d1a3e")
    stop("Invalid password")
  key <- charToRaw(pass) |> openssl::md5()
  class(key) <- c("aes", "raw")
  # Save this key
  qs::qsave(key, file = key_file)
  invisible(key)
}

make_original <- function(file, dir = ref_dir) {
  ref_file <- fs::path(dir, file)
  ref_file <- here::here(ref_file)
  file <- here::here(file)
  if (!fs::file_exists(file))
    stop("File not found")
  fs::file_copy(file, ref_file, overwrite = TRUE)
}

read_original <- function(file, dir = ref_dir) {
  ref_file <- fs::path(dir, file)
  ref_file <- here::here(ref_file)
  file <- here::here(file)
  if (!fs::file_exists(ref_file))
    stop("Reference file not found")
  fs::file_copy(ref_file, file, overwrite = TRUE)
}

make_solution <- function(file, dir = ref_dir, key = NULL) {
  ref_file <- fs::path(dir, paste0(file, ".solution"))
  ref_file <- here::here(ref_file)
  file <- here::here(file)
  if (!fs::file_exists(file))
    stop("File not found")
  if (is.null(key))
    key <- set_key()
  cyphr::encrypt_file(file, key = cyphr::key_openssl(key), dest = ref_file)
}

read_solution <- function(file, dir = ref_dir, key = NULL) {
  ref_file <- fs::path(dir, paste0(file, ".solution"))
  ref_file <- here::here(ref_file)
  file <- here::here(file)
  if (!fs::file_exists(ref_file))
    stop("Reference file not found")
  if (is.null(key))
    key <- set_key()
  cyphr::decrypt_file(ref_file, key = cyphr::key_openssl(key), dest = file)
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
is_data <- function(name, dir = "data", format = "rds", check_df = FALSE) {
  data_path <- here::here(dir, paste(name, format, sep = "."))
  res <- fs::file_exists(data_path)
  if (!res)
    return(structure(FALSE, message = paste0("The data file ", data_path,
      " is not found.")))
  res <- try(data.io::read(data_path, type = format), silent = TRUE)
  if (inherits(res, "try-error"))
    return(structure(FALSE, message = res))

  if (isTRUE(check_df) && !inherits(res, "data.frame"))
    return(structure(FALSE, message = paste0("The data file ", data_path,
      " is found but it does not contains a data frame.")))

  # Everything is OK
  TRUE
}

is_data_df <- function(name, dir = "data", format = "rds", check_df = TRUE)
  is_data(name, dir = dir, format = format, check_df = check_df)

is_identical_to_ref <- function(name, part = NULL, attr = NULL) {
  ref <- read_ref(name) # Note: generate an error if the object does not exist
  res <- read_res(name) # Idem

  if (!is.null(part)) {
    ref <- ref[[part]]
    res <- res[[part]]
  }

  if (!is.null(attr)) {
    ref <- attr(ref, attr)
    res <- attr(res, attr)
  }

  # Items cannot be NULL
  if (is.null(res) && is.null(ref))
    structure(FALSE, message = "Both res and ref are NULL")

  identical(res, ref)
}

is_equal_to_ref <- function(name, part = NULL, attr = NULL) {
  ref <- read_ref(name) # Note: generate an error if the object does not exist
  res <- read_res(name) # Idem

  if (!is.null(part)) {
    ref <- ref[[part]]
    res <- res[[part]]
  }

  if (!is.null(attr)) {
    ref <- attr(ref, attr)
    res <- attr(res, attr)
  }

  # Items cannot be NULL
  if (is.null(res) && is.null(ref))
    structure(FALSE, message = "Both res and ref are NULL")

  all.equal(res, ref)
}

has_labels_all <- function(name, part = NULL) {
  res <- read_res(name)$labels
  res <- sapply(res, nchar) > 0
  all(res, na.rm = TRUE)
}

has_labels_any <- function(name, part = NULL) {
  res <- read_res(name)$labels
  res <- sapply(res, nchar) > 0
  any(res, na.rm = TRUE)
}

has_units_all <- function(name, part = NULL) {
  res <- read_res(name)$units
  res <- sapply(res, nchar) > 0
  all(res, na.rm = TRUE)
}

has_units_any <- function(name, part = NULL) {
  res <- read_res(name)$units
  res <- sapply(res, nchar) > 0
  any(res, na.rm = TRUE)
}


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
