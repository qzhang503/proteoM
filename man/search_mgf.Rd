% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ms2_base.R
\name{search_mgf}
\alias{search_mgf}
\title{Matches by indexes}
\usage{
search_mgf(
  expt_mass_ms1,
  expt_moverz_ms2,
  theomasses_bf_ms1,
  theomasses_cr_ms1,
  theomasses_af_ms1,
  theos_bf_ms2,
  theos_cr_ms2,
  theos_af_ms2,
  minn_ms2 = 6L,
  ppm_ms1 = 20L,
  ppm_ms2 = 25L,
  min_ms2mass = 115L
)
}
\arguments{
\item{expt_mass_ms1}{Numeric; the experimental MS1 mass.}

\item{expt_moverz_ms2}{A numeric list; the experimental MS2 m/z's.}

\item{theomasses_bf_ms1}{Numeric vector; the theoretical MS1 masses at the
preceding \code{-1} frame.}

\item{theomasses_cr_ms1}{Numeric vector; the theoretical MS1 masses at the
current frame.}

\item{theomasses_af_ms1}{Numeric vector; the theoretical MS1 masses at the
following \code{+1} frame.}

\item{theos_bf_ms2}{Numeric vector; the theoretical MS2 m/z's at the
preceding \code{-1} frame.}

\item{theos_cr_ms2}{Numeric vector; the theoretical MS2 m/z's at the current
frame.}

\item{theos_af_ms2}{Numeric vector; the theoretical MS2 m/z's at the
following \code{+1} frame.}

\item{minn_ms2}{A positive integer; the minimum number of matched MS2 ions
for consideration as a hit. The default is 6. Counts of secondary ions,
e.g. b0, b* etc., are not part of the threshold.}

\item{ppm_ms1}{A positive integer; the mass tolerance of MS1 species. The
default is 20.}

\item{ppm_ms2}{A positive integer; the mass tolerance of MS2 species. The
default is 25.}

\item{min_ms2mass}{A positive integer; the minimum MS2 mass for
interrogation. The default is 110.}
}
\description{
Matches by indexes
}
\examples{
\donttest{
expt_ms2 <-
  c(1628,3179,7677,9129,13950,14640,18571,19201,19205,19830,19833,20454,
    20457,21030,21073,21077,21687,24644,25232,37146,42042,43910,43920,44811,
    44824,45298,47494,55080,55901,56677,59014,66693,72396,72402,72720,73043,
    82411,91067,91838,93101,95572,98301,98665,100270,102081,102305,102744,106013,
    107998,108102,113713,113898,115045,115140,117669,119131,120730,123859,124029,124200,
    126199,126208,126610,126693,126775,128157,129447,129603,132396,135402,135475,138158,
    140397,141566,141634,141702,142183,142580,144189,147799,147926,148678,148860,149911,
    149973,153047,155607,158520,158631,162612,162717,163346,169537,170401,171249,171344,
    178012,178620,181980,188455)

theo_ms2 <-
  c(-26231,62754,105787,129278,151731,161552,174924,184489,196534,204867,212917,219771,
    236270,106013,129447,148679,163242,178619,187776,197630,203310,212976,219825,227451,
    234026,237018)
cr <- which(expt_ms2 \%fin\% theo_ms2)
pr <- which((expt_ms2-1) \%fin\% theo_ms2)
af <- which((expt_ms2+1) \%fin\% theo_ms2)
c(cr, pr, af)

}
}
