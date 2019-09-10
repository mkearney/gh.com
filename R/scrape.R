
#' Scrape github.com
#'
#' Returns tibble of search results
#'
#' @param query Search query to perform on github.com
#' @param pages Max number of pages, defaults to all.
#' @return Search results in the form of a tibble data frame where each row
#'   corresponds to a search result and the columns contain information about
#'   the matching repo (id, name, url, description, language, stars, license,
#'   topics
#' @import lop
#' @export
scrape_github <- function(query, pages = NULL) {
  ## prep and validate parameters
  if (is.null(pages)) {
    max_pages <- Inf
  } else {
    max_pages <- pages
  }
  assert_that(
    is.character(query),
    length(query) == 1L
  )
  assert_that(
    is.numeric(max_pages),
    length(max_pages) == 1L
  )
  query <- utils::URLencode(query)

  ## read first page
  p <- 1L
  p1url <- glu("https://github.com/search?p={p}&q={query}&type=Repositories")
  p1 <- hread(p1url)

  ## look up how many pages of total search results
  pages <- unique(full_url(p1, ".paginate-container"))
  tfse::regmatches_first(pages, "(?<=p=)\\d+") %>%
    as.numeric() %>%
    seq_range() %>%
    utils::head(max_pages) %>%
    list(p = .) %>%
    glud(sub("(?<==)\\d+", "{p}", pages[1], perl = TRUE)) %>%
    unique() ->
    pages

  ## if there's only one page, set pages to an empty character
  if (length(pages) == 0 || (length(pages) == 1 && pages == "NA")) {
    pages <- character()
  }

  ## read source code of all result pages (re-read p1 b/c issues with ptr)
  h <- dapr::lap(c(p1url, pages), ~ try_null(hread(.x)))
  h <- h[lengths(h) > 0]

  ## extract node-related data
  h %>%
    dapr::lap(hnodes, ".repo-list-item") %>%
    dapr::lap(~ dapr::lap(.x, li_data) %>% brows()) %>%
    brows() ->
    d

  ## extract JSON-stored data
  h %>%
    dapr::lap(json_results) %>%
    brows() ->
    j

  ## combine and rearrange columns
  bcols(d, j) %>%
    sel(id, repo, url:datetime, query, position, originating_url)
}

#' Scrape rstudio theme repos on github.com
#'
#' Returns tibble of rstudio theme search results
#'
#' @return A tibble of results from search designed to find rstudio themes
#' @export
scrape_rstudio_themes <- function() {
  query <- '"rstudio themes" OR "R Studio themes" OR "rstudio theme" OR "R Studio theme" OR "theme for rstudio"'
  scrape_github(query)
}

json_results <- function(x) {
  x %>%
    hnodes(".repo-list-item") %>%
    hnodes("h3 a.v-align-middle") %>%
    hattr("data-hydro-click") %>%
    dapr::lap(pjchr) %>%
    dapr::lap(~ jan(as_tbl(as.list(unlist(.x))))) %>%
    brows() %>%
    `names<-`(gsub("payload_|result_", "", names(.))) %>%
    mut(position = (as.integer(page_number) - 1) * as.integer(per_page) + as.integer(position)) %>%
    sel(id, position, query, originating_url)
}

li_data <- function(x) {
  lcsfun <- function(x) if (length(x) == 2) x[1] %>% htext(trim = TRUE) else NA_character_
  tbl(repo = x %>%
      hnode("h3 a") %>%
      htext(),
    url = x %>%
      hnode("h3 a") %>%
      hattr("href") %>%
      haurl(hurl(x)),
    description = x %>%
      hnode("div p") %>%
      htext(trim = TRUE),
    language = x %>%
      hnode(xpath = "*//span//span[@itemprop='programmingLanguage']") %>%
      htext(),
    stars = x %>%
      hnode(".text-right a.muted-link") %>%
      htext(trim = TRUE) %>%
      ifelse(is.na(.) | . %in% c("", "NA", " "), '0', .) %>%
      {suppressWarnings(as.integer(.))},
    license = x %>%
      hnode(".d-flex.flex-wrap") %>%
      hnodes("p") %>%
      lcsfun(),
    topics = x %>%
      hnode(".topics-row-container") %>%
      hnodes("a") %>%
      htext(trim = TRUE) %>%
      list(),
    datetime = x %>%
      hnode("relative-time") %>%
      hattr("datetime") %>%
      sub("T", " ", .) %>%
      as.POSIXct(),
  )
}
