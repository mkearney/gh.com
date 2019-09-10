try_null <- function(...) {
  tryCatch(
    ...,
    error = function(e) NULL
  )
}

`%||%` <- function(a, b) {
  if (is.null(a))
    b
  else
    a
}

fix_json_string <- function(x) {
  x <- sub("^[^[{]+", "", x)
  while (any(grepl("^\\[\\]|^\\{\\}", x))) {
    x <- sub("^\\[\\]|^\\{\\}", "", x)
    x <- sub("^[^[{]+", "", x)
  }
  x <- sub("[^]}]+$", "", x)
  while (any(grepl("\\[\\]$|\\{\\}$", x))) {
    x <- sub("\\[\\]$|\\{\\}$", "", x)
    x <- sub("[^]}]+$", "", x)
  }
  x
}
pbracket <- function(x) paste0("[", x, "]")

fj <- function(x, ...) {
  if (length(x) == 1) {
    fj_(x, ...)
  } else {
    dapr::lap(x, fj_, ...)
  }
}

fj_ <- function(x, ...) {
  o <- try_null(jsonlite::fromJSON(x, ...))
  o <- o %||% try_null(jsonlite::fromJSON(
    fix_json_string(x), ...))
  o %||% try_null(jsonlite::fromJSON(
    pbracket(x), ...))
}

pjchr <- function(x, ...) {
  if (length(x) == 1 && grepl("^https?://\\S+", x)) {
    x <- httr::GET(x, ...)
    x <- as.character(httr::content(x, as = "parsed"))
  }
  if (length(x) == 1) {
    x <- unlist(strsplit(as.character(x), "(?<=\\>)[ ]{0,}\n", perl = TRUE))
  }
  x <- gsub("&quot;", '"', x)
  x <- grep('":\\s{0,}\\S+', x, value = TRUE)
  if (length(x) == 0) {
    return(list())
  }
  if (length(x) == 1) {
    return(fj(x))
  }
  x <- dapr::lap(x, fj)
  if (all(lengths(x) == 0)) {
    return(list())
  }
  if (sum(lengths(x) > 0) == 1) {
    return(x[[lengths(x) > 0]])
  }
  x[lengths(x) > 0]
}

full_url <- function(x, h) {
  if (inherits(x, "xml_document")) {
    haurl(hattr(hnodes(x, paste(h, " a")), "href"), hurl(x))
  } else if (!is.character(x)) {
    stop("this should be an xml_document or character vector")
  } else {
    haurl(x, hurl(h))
  }
}

seq_range <- function(x) {
  if (length(x) == 0 || all(is.na(x))) {
    return(integer())
  }
  seq(min(x, na.rm = TRUE), max(x, na.rm = TRUE))
}

jan <- function(x) UseMethod("jan")
jan.default <- function(x) {
  names(x) <- jan(names(x))
  x
}
jan.character <- function(x) {
  janitor::make_clean_names(x)
}

