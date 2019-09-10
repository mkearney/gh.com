## xml2 shortcuts
hread   <- xml2::read_html
hxurl   <- xml2::xml_url
haurl   <- xml2::url_absolute
hlst    <- xml2::as_list

## rvest shortcuts
hnode   <- rvest::html_node
hnodes  <- rvest::html_nodes
htext   <- rvest::html_text
hattr   <- rvest::html_attr
hattrs  <- rvest::html_attrs
htable  <- rvest::html_table

## glue shortcut
glu     <- glue::glue
glud    <- glue::glue_data

## tibble shortcuts
tbl     <- tibble::tibble
as_tbl  <- tibble::as_tibble

## dplyr shortcuts
brows   <- dplyr::bind_rows
bcols   <- dplyr::bind_cols
gby     <- dplyr::group_by
ung     <- dplyr::ungroup
mut     <- dplyr::mutate
mut_if  <- dplyr::mutate_if
mut_all <- dplyr::mutate_all
sms     <- dplyr::summarise
sms_if  <- dplyr::summarise_if
sms_all <- dplyr::summarise_all
sel     <- dplyr::select
sel_if  <- dplyr::select_if
fil     <- dplyr::filter
arr     <- dplyr::arrange
dsc     <- dplyr::desc
pul     <- dplyr::pull
