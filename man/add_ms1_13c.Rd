% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ms1_precursors.R
\name{add_ms1_13c}
\alias{add_ms1_13c}
\title{Adds Carbon-13 masses.}
\usage{
add_ms1_13c(peps, n_13c = 1L, max_mass = 4500L)
}
\arguments{
\item{peps}{A named vector of peptide sequences. Sequences in names and
masses in values.}

\item{n_13c}{A non-negative integer; the maximum number of 13C off-sets for
consideration in MS1 masses. The default is 0 with no off-sets.
Peak-pickings by various MGF conversion tools may have attempted to adjust
precursor masses to the corresponding mono-isotopic masses in isotope
envelopes. Nevertheless, by setting \code{n_13c = 1}, some increases in the
number of PSMs may be readily achieved at a relatively small cost of search
time.}

\item{max_mass}{A positive integer; the maximum precursor mass for
interrogation. The default is 4500.}
}
\description{
Adds Carbon-13 masses.
}
