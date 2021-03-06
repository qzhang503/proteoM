% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ms2_a1_vnl0_fnl1.R
\name{add_hexcodes_fnl2}
\alias{add_hexcodes_fnl2}
\title{Adds hex codes (with variable NLs).}
\usage{
add_hexcodes_fnl2(ms2ions, vmods_combi, len, mod_indexes = NULL)
}
\arguments{
\item{ms2ions}{A series of MS2 ions with masses.}

\item{vmods_combi}{Lists of variable modifications.}

\item{len}{The number of amino acid residues for the sequence indicated in
\code{ms2ions}.}

\item{mod_indexes}{Integer; the indexes of fixed and/or variable
modifications.}
}
\description{
To indicate the variable modifications of an amino acid sequence.
}
