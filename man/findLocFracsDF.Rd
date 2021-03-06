% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scores.R
\name{findLocFracsDF}
\alias{findLocFracsDF}
\title{Finds the localization fractions of STY.}
\usage{
findLocFracsDF(df, locmod_indexes = NULL)
}
\arguments{
\item{df}{A data frame containing columns \code{pep_ivmod2} and
\code{pep_ms2_ideltas.}.}

\item{locmod_indexes}{A vector to the modification indexes.}
}
\description{
Counting statistics.
}
\examples{
locmod_indexes <- c("8", "9", "a")
df <- data.frame(pep_ivmod2 = c("0080000", "0009000"), pep_ms2_ideltas. = NA)
df$pep_ms2_ideltas.[1] <- list(c(1,2,3,4,5,6,8,9,10,11,12,13,14))
df$pep_ms2_ideltas.[2] <- list(c(1,2,3,4,5,6,8,9,10,12,13,14))
ans <- findLocFracsDF(df, locmod_indexes)

# Variable Acetyl (K) and fixed TMT6plex (K)
locmod_indexes <- "4"
df <- data.frame(pep_ivmod2 = c("04000000", "00000000"), pep_ms2_ideltas. = NA)
df$pep_ms2_ideltas.[1] <- list(c(2,5,6,7,9,11,14,15,16))
df$pep_ms2_ideltas.[2] <- list(c(1,2,5,6,7,9,11,14))
ans <- findLocFracsDF(df, locmod_indexes)

df <- data.frame(pep_ivmod2 = c("0004000", "4000000"), pep_ms2_ideltas. = NA)
df$pep_ms2_ideltas.[1] <- list(c(2,3,4,5,6,8,10,11,12,14))
df$pep_ms2_ideltas.[2] <- list(c(4,5,6,8,10,14))
ans <- findLocFracsDF(df, locmod_indexes)

df <- data.frame(pep_ivmod2 = c("00040402", "00040204", "00020202"), pep_ms2_ideltas. = NA)
df$pep_ms2_ideltas.[1] <- list(c(1,4,6,7,9,10,11,12,15,16))
df$pep_ms2_ideltas.[2] <- list(c(1,4,11,12,15,16))
df$pep_ms2_ideltas.[3] <- list(c(1,4,11,12,15,16))
ans <- findLocFracsDF(df, locmod_indexes)

locmod_indexes <- c("2", "4")
df <- data.frame(pep_ivmod2 = c("0004004000402", "0002004000402", "0004004000204"), pep_ms2_ideltas. = NA)
df$pep_ms2_ideltas.[1] <- list(c(1,3,4,5,6,7,8,10,14,15,16,17,18,19))
df$pep_ms2_ideltas.[2] <- list(c(4,5,6,7,8,10,14,15,16,17,18,19))
df$pep_ms2_ideltas.[3] <- list(c(1,3,4,5,6,7,8,10,14,16,17,18,19))
ans <- findLocFracsDF(df, locmod_indexes)
}
