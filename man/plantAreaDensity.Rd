% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PlantArea.R
\docType{methods}
\name{plantAreaDensity}
\alias{plantAreaDensity}
\title{Plant Area Density (PAD)}
\usage{
plantAreaDensity(
  vxsp,
  vx,
  lad = "spherical",
  angle.name = "angleMean",
  variable.name = c("transmittance", "attenuation_FPL_unbiasedMLE",
    "attenuation_PPL_MLE"),
  pad.max = 5,
  pulse.min = 5,
  ...
)
}
\arguments{
\item{vxsp}{a \code{\linkS4class{VoxelSpace}} object.}

\item{vx}{a subset of voxel index. A data.table with \verb{i, j, k} columns.
Missing parameter means whole voxel space.}

\item{lad}{the name of the probability density function of the leaf angle
distribution. One of \code{AMAPVox:::leafAngleDistribution}.}

\item{angle.name}{the name of the mean angle variable in the VoxelSpace
object.}

\item{variable.name}{the name of the transmittance/attenuation variables in
the VoxelSpace object. Transmittance variables are expected to start with
"tra" and attenuation variables with "att".}

\item{pad.max}{a float, the maximal PAD value}

\item{pulse.min}{an integer, the minimal number of pulses in a voxel for
computing the PAD. PAD set to NA otherwise.}

\item{...}{additional parameters which will be passed to the leaf angle
distribution functions. Details in \code{\link[=computeG]{computeG()}}.}
}
\value{
A voxel space object with the requested PAD variables.
}
\description{
Computes Plant Area Density either from transmittance or
attenuation coefficient estimates.
Details of calculation and underlying assumptions can be found online at
\doi{10.23708/1AJNMP}.
PAD is defind as the plant area per unit volume
( PAD plant area / voxel volume = m^2 / m^3).
}
\examples{
# load a voxel file
vxsp <- readVoxelSpace(system.file("extdata", "tls_sample.vox", package = "AMAPVox"))
# compute PAD
pad <- plantAreaDensity(vxsp, variable.name = "attenuation_PPL_MLE")
# merge pad variables into voxel space
vxsp@data <- merge(vxsp@data, pad, by = c("i", "j", "k"))
grep("^pad", names(vxsp), value = TRUE) # print PAD variables in vxsp
# PAD on a subset
pad.i2j3 <- plantAreaDensity(vxsp, vxsp@data[i ==2 & j==3, .(i, j, k)])
pad.i2j3[["ground_distance"]] <- vxsp@data[i ==2 & j==3]$ground_distance
\dontrun{
# plot vertical profile
library(ggplot2)
# meld data.table (wide-to-long reshaping)
pad <- data.table::melt(pad.i2j3,
  id.vars = "ground_distance",
  measure.vars = c("pad_transmittance", "pad_attenuation_FPL_unbiasedMLE",
    "pad_attenuation_PPL_MLE"))
ggplot(data = pad, aes(x=value, y=ground_distance, color=variable)) +
  geom_path() + geom_point()
}
}
\references{
VINCENT, Gregoire; PIMONT, François; VERLEY, Philippe, 2021,
"A note on PAD/LAD estimators implemented in AMAPVox 1.7",
\doi{10.23708/1AJNMP}, DataSuds, V1
}
\seealso{
\code{\link[=computeG]{computeG()}}
}
