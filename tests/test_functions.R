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
