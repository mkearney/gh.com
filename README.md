
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gh.com

<!-- badges: start -->

<!-- badges: end -->

The goal of gh.com is to …

## Installation

You can install the development version of gh.com from
[Github](https://github.com) with:

``` r
remotes::install_github("mkearney/gh.com")
```

## Example

Get the first two pages of search results for repos matching the query
“rstats”

``` r
## load package
library(gh.com)

## scrape first five pages
rstats <- scrape_github("rstats", pages = 5)

## view results
rstats
#> # A tibble: 60 x 12
#>    id    repo  url   description language stars license topics datetime            query position
#>    <chr> <chr> <chr> <chr>       <chr>    <int> <chr>   <list> <dttm>              <chr>    <dbl>
#>  1 1576… spit… http… rStats      JavaScr…   201 MIT li… <chr … 2018-06-04 20:37:22 rsta…        1
#>  2 4123… Roma… http… A curated … R          137 <NA>    <chr … 2017-11-02 09:19:37 rsta…        2
#>  3 1470… rstu… http… List of co… <NA>       324 <NA>    <chr … 2019-05-10 00:39:41 rsta…        3
#>  4 3390… Kagg… http… Kaggle R d… R           99 Apache… <chr … 2019-06-24 19:40:34 rsta…        4
#>  5 7124… hann… http… Rstats cli… R           21 <NA>    <chr … 2019-03-25 15:33:28 rsta…        5
#>  6 8220… hrbr… http… #rstats gi… HTML        39 <NA>    <chr … 2017-03-03 23:20:54 rsta…        6
#>  7 1928… Plan… http… [UNMAINTAI… C++         58 GPL-2.… <chr … 2016-01-23 05:14:09 rsta…        7
#>  8 7935… cjmi… http… "Introduct… R            3 <NA>    <chr … 2017-02-01 13:46:54 rsta…        8
#>  9 2387… nico… http… Examples o… HTML        23 MIT li… <chr … 2016-01-18 23:58:43 rsta…        9
#> 10 1236… nort… http… #rstats da… R           13 GPL-2.… <chr … 2018-08-19 15:08:44 rsta…       10
#> # … with 50 more rows, and 1 more variable: originating_url <chr>
```
