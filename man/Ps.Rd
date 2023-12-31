% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllGenerics.R, R/Ps.R
\name{distanceLaw}
\alias{distanceLaw}
\alias{Ps}
\alias{distanceLaw,GInteractions,missing-method}
\alias{distanceLaw,HiCExperiment,missing-method}
\alias{distanceLaw,PairsFile,missing-method}
\alias{distanceLaw,PairsFile,GRanges-method}
\alias{localDistanceLaw}
\alias{distanceLaw,HiCExperiment,GRanges-method}
\title{Compute the law of distance-dependent contact frequency, a.k.a. P(s)}
\usage{
distanceLaw(x, coords, ...)

\S4method{distanceLaw}{GInteractions,missing}(x, by_chr = FALSE)

\S4method{distanceLaw}{HiCExperiment,missing}(
  x,
  by_chr = FALSE,
  filtered_chr = c("XII", "chrXII", "chr12", "12", "Mito", "MT", "chrM")
)

\S4method{distanceLaw}{PairsFile,missing}(
  x,
  by_chr = FALSE,
  filtered_chr = c("XII", "chrXII", "chr12", "12", "Mito", "MT", "chrM"),
  chunk_size = 1e+05
)

\S4method{distanceLaw}{HiCExperiment,GRanges}(x, coords, chunk_size = 1e+05)

\S4method{distanceLaw}{PairsFile,GRanges}(x, coords, chunk_size = 1e+05)

localDistanceLaw(x, coords = coords)
}
\arguments{
\item{x}{A \code{HiCExperiment} object}

\item{coords}{GRanges to specify which genomic loci to use when computing P(s)}

\item{...}{Arguments passed to corresponding method}

\item{by_chr}{by_chr}

\item{filtered_chr}{filtered_chr}

\item{chunk_size}{For pairs files which do not fit in memory, pick a number
of pairs to parse by chunks (1e7 should be a good compromise)}
}
\value{
a tibble
}
\description{
P(s) will be approximated if no pairs are provided, or the exact P(s)
will be computed if a \code{.pairs} file is added to the \code{HiCExperiment} object
using \code{pairsFile(x) <- "..."}.
}
\examples{
contacts_yeast <- contacts_yeast()
ps <- distanceLaw(contacts_yeast)
ps
local_ps <- localDistanceLaw(
    contacts_yeast,
    GenomicRanges::GRanges(
        c("telomere" = "II:1-20000", "arm" = "II:300001-700000")
    )
)
local_ps
}
