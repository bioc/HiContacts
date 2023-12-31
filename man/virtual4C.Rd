% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/4C.R
\name{virtual4C}
\alias{virtual4C}
\title{Computing virtual 4C profiles}
\usage{
virtual4C(x, viewpoint, use.scores = "balanced")
}
\arguments{
\item{x}{a \code{HiCExperiment} object}

\item{viewpoint}{viewpoint, defined as a GRanges}

\item{use.scores}{use.scores}
}
\value{
A tibble with the contact frequency of the viewpoint, per bin
along the imported genomic range.
}
\description{
From a (m)cool pre-imported in memory, computes a 4C profile
using a user-specified \code{viewpoint}.
}
\examples{
library(HiContacts)
contacts_yeast <- contacts_yeast()
v4C <- virtual4C(contacts_yeast, GenomicRanges::GRanges('II:490001-510000'))
v4C
}
