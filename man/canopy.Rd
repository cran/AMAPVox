% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Canopy.R
\docType{methods}
\name{canopy}
\alias{canopy}
\alias{belowCanopy}
\alias{aboveCanopy}
\alias{canopyHeight}
\title{Extract canopy from voxel space.}
\usage{
canopy(vxsp, hit.min = 1)

belowCanopy(vxsp, ...)

aboveCanopy(vxsp, ...)

canopyHeight(vxsp, ...)
}
\arguments{
\item{vxsp}{a \code{\linkS4class{VoxelSpace}} object.}

\item{hit.min}{a positive integer, minimum number of hit/echo in a voxel
to consider it contains vegetation.}

\item{...}{additional parameters which will be passed to \code{canopy} function.
So far only \code{hit.min} parameter.}
}
\value{
\code{\link[data.table:data.table-class]{data.table::data.table}} object with voxel index either
below canopy, canopy level or above canopy
}
\description{
Extract canopy from \code{\linkS4class{VoxelSpace}} object.
The canopy layer is the set of highest voxels with number of hits greater
than a user-defined threshold.
\subsection{Minimum number of hits/echos}{

Minimum number of hits is set by default to one, meaning that a single echo
in a voxel is enough to consider that there is some vegetation. Increasing
this threshold will tend to lower the canopy level or introduce some gaps (
i-j-cells with no vegetation). This \code{hit.min} filter is stronger than
\code{\link[=butterfly]{butterfly()}} since is does not discriminate isolated voxels.
A reasonable value for \code{hit.min} cannot be suggested ad-hoc since it
strongly depends on sampling intensity. Removing butterflies prior to
extracting canopy is advisable.
}

\subsection{Gaps}{

For a VoxelSpace with fully defined ground level (see \code{\link[=ground]{ground()}}),
missing canopy cells can be interpreted as gaps. Conversely if both ground
and canopy are missing for a i-j-cell, then it is inconclusive.
}

\subsection{Above/below canopy}{

Function \code{aboveCanopy} returns voxel index above canopy level (excluded).
Function \code{belowCanopy} returns voxel index below canopy level (included).
}

\subsection{Canopy Height Model}{

Function \code{canopyHeight} returns ground distance at canopy level, including
gaps.
}
}
\examples{
vxsp <- readVoxelSpace(system.file("extdata", "tls_sample.vox", package = "AMAPVox"))
cnp <- canopy(vxsp)
acnp <- aboveCanopy(vxsp)
bcnp <- belowCanopy(vxsp)
# canopy layer included in below canopy subset
all(bcnp[cnp, on=list(i, j, k)] == cnp) # TRUE expected
vxsp@data[cnp, list(i, j, ground_distance), on=list(i, j, k)]

}
\seealso{
\code{\link[=butterfly]{butterfly()}}, \code{\link[=ground]{ground()}}
}
