generate_formats_list <- function(
  x = as.POSIXct(1136239445.987654, origin = "1970-01-01", tz = "MST"),
  include_unusual = TRUE,
  include_decimal_seconds = TRUE
) {
  strfmts <- c(
    "a", "A", "b", "B", "c", "C", "d", "D", "e", "F",
    "g", "G", "h", "H", "I", "j", "m", "M", "p", "P",
    "r", "R", "S", "T", "u", "U", "V", "w", "W",
    "x", "X", "y", "Y", "z", "Z",
    if (include_decimal_seconds) paste0("OS", 1:6)
  )
  if (include_unusual) {
    strfmts <- c(
      strfmts,
      "k", "l", "s", "+",
      paste0("O", c("d", "H", "I", "m", "M", "U", "V", "w", "W", "y")),
      paste0("E", c("c", "C", "y", "Y", "x", "X"))
    )
  }
  strfmts <- paste0("%", strfmts)

  out <- vapply(strfmts, strftime, character(1), x = x, tz = attributes(x)$tzone)
  out[names(out) != unname(out)]
}

order_formats_list <- function(fmts = generate_formats_list(...), ...) {
  fmts <- fmts[order(nchar(fmts), decreasing = TRUE)]

  # OS1-6 need to come first to beat %T
  fmts <- fmts[c(intersect(names(fmts), paste0("%OS", 1:6)),
                 setdiff(names(fmts), paste0("%OS", 1:6)))]
  # some things should go to the end
  fmts <- fmts[c(setdiff(names(fmts), c("%u", "%W", "%V", "%G", "%g")),
                 intersect(names(fmts), c("%u", "%W", "%V", "%G", "%g")))]

  fmts
}

guess_format <- function(
  text,
  dt = as.POSIXct(1136239445.987654, origin = "1970-01-01", tz = "MST"),
  frontpad_single_digits = TRUE
) {
  fmts <- order_formats_list(x = dt)

  if (frontpad_single_digits) {
    text <- frontpad_single_digits(text)
  }

  out <- text
  for (i in seq_along(fmts)) {
    out <- gsub(fmts[i], names(fmts)[i], out, perl = TRUE)
  }
  out
}

remove_stftime_formats <- function(x) {
  fmts <- names(generate_formats_list())
  for (fmt in fmts) {
    x <- gsub(fmt, strrep("_", nchar(fmt)), x, fixed = TRUE)
  }
  x
}

frontpad_single_digits <- function(x) {
  while (TRUE) {
    # cat("\n", x, sep = "")
    x_new <- sub("(^|[^ /.;:-] |[/.;:-])(\\d)([^0-9]|$)", "\\1 \\2\\3", x)
    if (x_new == x) {
      break
    } else {
      x <- x_new
    }
  }
  x
}
