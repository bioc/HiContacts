% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotting.R
\name{plotSaddle}
\alias{plotSaddle}
\title{Plotting saddle plots}
\usage{
plotSaddle(
  x,
  nbins = 50,
  limits = c(-1, 1),
  plotBins = FALSE,
  BPPARAM = BiocParallel::bpparam()
)
}
\arguments{
\item{x}{a HiCExperiment object with a stored \code{eigens} metadata}

\item{nbins}{Number of bins to use to discretize the eigenvectors}

\item{limits}{limits for color map being used}

\item{plotBins}{Whether to plot the distribution of bins on top of the plot}

\item{BPPARAM}{a BiocParallel registered method}
}
\value{
ggplot
}
\description{
Plotting saddle plots
}
