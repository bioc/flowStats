% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/warpSet.R
\name{warpSet}
\alias{warpSet}
\alias{warpSetNCDF}
\alias{warpSetGS}
\alias{warpSetNCDFLowMem}
\alias{warpSet.cytoset}
\title{Normalization based on landmark registration}
\usage{
warpSet(x, ...)

\method{warpSet}{cytoset}(
  x,
  stains,
  grouping = NULL,
  subsample = NULL,
  peakNr = NULL,
  clipRange = 0.01,
  nbreaks = 11,
  fres,
  bwFac = 2,
  warpFuns = FALSE,
  target = NULL,
  chunksize = 10,
  ...
)
}
\arguments{
\item{x}{A \code{\link[flowCore:flowSet-class]{flowSet}}.}

\item{\dots}{Further arguments that are passed on to
\code{landmarkreg}.}

\item{stains}{A character vector of flow parameters in \code{x} to be
normalized.}

\item{grouping}{A character indicating one of the phenotypic
variables in the \code{phenoData} slot of \code{x} used as a grouping
factor. The within-group and between-group variance is computed and
a warning is issued in case the latter is bigger than the former,
indicating the likely removal of signal by the normalization
procedure.
\code{\link[fda]{landmarkreg}}.}

\item{subsample}{Numeric. Reduce the number of events in each \code{flowSet}
by sub sampling for all density estimation steps and the calculation
of the warping functions. This can increase computation time for
large data sets, however it might reduce the accuracy of the density
estimates. To be used with care.}

\item{peakNr}{Numeric scalar. Force a fixed number of peaks to use
for the normalization.}

\item{clipRange}{Only use peaks within a clipped data
range. Essentially, the number indicates the percent of clipping on
both sides of the data range, e.g. \code{min(x) - 0.01 *
diff(range(x))}.}

\item{nbreaks}{The number of spline sections used to approximate the
data. Higher values produce more accurate results, however this
comes with the cost of increaseqd computing times. For most data,
the default setting is good enough.}

\item{fres}{A named list of \code{filterResultList} objects. This can
be used to speed up the process since the \code{curv1Filter} step
can take quite some time.}

\item{bwFac}{Numeric of lenght 1 used to set the bandwidth factor by
\code{\link{curv1Filter}} for smoothing of the density estimate.}

\item{warpFuns}{Logical indcating whether to return the normalized
\code{flowSet} or a list of warping functions.}

\item{target}{Character vector specifying the target sample to which other samples in the \code{flowSet} should be normalized. If \code{NULL}, then the mean of the peaks is used.}

\item{chunksize}{an \code{integer}. For a memory-efficient implementation of normalization, \code{chunksize} can be set  to perform normalization on chunks of the data of size \code{chunksize}}
}
\value{
The normalized \code{flowSet} if \code{warpFuns} is \code{FALSE},
otherwise a list of warping functions. Additional inforamtion is
attached as the \code{warping} attribute to the \code{flowSet} in form
of a list.
}
\description{
This function will perform a normalization of flow cytometry
data based on warping functions computed on high-density region
landmarks for individual flow channels.
}
\details{
Normalization is achived by first identifying high-density regions
(landmarks) for each \code{\link[flowCore:flowFrame-class]{flowFrame}}
in the \code{flowSet} for a single channel and subsequently by
computing warping functions for each \code{flowFrame} that best align
these landmarks. This is based on the algorithm implemented in the
\code{landmarkreg} function in the \code{\link[fda:fda-package]{fda}}
package. An intermediate step classifies the high-density regions, see
\code{\link{landmarkMatrix}} for details.

Please note that this normalization is on a channel-by-channel
basis. Multiple channels are normalized in a loop.
}
\note{
We currently use a patched fda version.
}
\examples{
\dontrun{
library(flowCore)
data(ITN)
dat <- transform(ITN, "CD4"=asinh(CD4), "CD3"=asinh(CD3), "CD8"=asinh(CD8))
lg <- lymphGate(dat, channels=c("CD3", "SSC"), preselection="CD4",scale=1.5)
dat <- Subset(dat, lg)
datr <- warpSet(dat, "CD8", grouping="GroupID")
if(require(flowViz)){
  d1 <- densityplot(~CD8, dat, main="original", filter=curv1Filter("CD8"))
  d2 <- densityplot(~CD8, datr, main="normalized", filter=curv1Filter("CD8"))
  plot(d1, split=c(1,1,2,1))
  plot(d2, split=c(2,1,2,1), newpage=FALSE)
}
}
}
\references{
J.O. Ramsay and B.W. Silverman: Applied Functional Data Analysis,
Springer 2002
}
\seealso{
\code{\link[flowStats:curv1Filter-class]{curv1Filter}}
\code{\link{landmarkMatrix}}
}
\author{
Florian Hahne
}
