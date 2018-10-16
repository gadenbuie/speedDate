
<!-- README.md is generated from README.Rmd. Please edit that file -->

# speedDate

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

speedDate makes it easy to get date format strings for use with
`strftime()`.

## Installation

You can install the released version of speedDate from GitHub with:

``` r
devtools::install_github("gadenbuie/speedDate")
```

## Example

Does formatting a timestamp into a character string always start with a
long scroll through `?strftime` to look up the correct format tokens?
Now you can get those tokens faster and move on with your day.

The **speedDate** RStudio addin gives you a date

    Monday January  2, 15:04:05.987653 2006 -0700

and asks you to write it in text in the desired format. So you enter…

    On 01.02.2006 at 15:04

…and the addin immediately gives you the format you want\!

    "On %m.%d.%Y at %R"

-----

Inspired by [go’s time parsing](https://golang.org/pkg/time/#Parse).
