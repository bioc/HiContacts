% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotting.R
\name{plot4C}
\alias{plot4C}
\title{Plotting virtual 4C profiles}
\usage{
plot4C(x, mapping = ggplot2::aes(x = center, y = score, col = seqnames))
}
\arguments{
\item{x}{GRanges, generally the output of \code{virtual4C()}}

\item{mapping}{aes to pass on to ggplot2 (default:
\code{ggplot2::aes(x = center, y = score, col = seqnames)})}
}
\value{
ggplot
}
\description{
Plotting virtual 4C profiles
}
\examples{
contacts_yeast <- contacts_yeast()
v4C <- virtual4C(contacts_yeast, GenomicRanges::GRanges('II:490001-510000'))
plot4C(v4C)
}
