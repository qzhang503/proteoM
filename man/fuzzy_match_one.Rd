% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ms2_base.R
\name{fuzzy_match_one}
\alias{fuzzy_match_one}
\title{Fuzzy matches with a +/-1 window.}
\usage{
fuzzy_match_one(x, y)
}
\arguments{
\item{x}{A vector to be matched.}

\item{y}{A vector to be matched against.}
}
\description{
Not used but called the codes inside directly.
}
\examples{
ans1 <- fuzzy_match_one(c(74953, 74955), rep(74954, 2))
ans2 <- fuzzy_match_one(c(74953, 74955), 74954)

stopifnot(identical(ans1, ans2))
stopifnot(ans1 == c(TRUE, TRUE))
}
