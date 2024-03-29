#' Extract canopy from voxel space.
#'
#' @docType methods
#' @rdname canopy
#'
#' @description Extract canopy from [`VoxelSpace-class`] object.
#' The canopy layer is the set of highest voxels with number of hits greater
#' than a user-defined threshold.
#'
#' ## Minimum number of hits/echos
#'
#' Minimum number of hits is set by default to one, meaning that a single echo
#' in a voxel is enough to consider that there is some vegetation. Increasing
#' this threshold will tend to lower the canopy level or introduce some gaps (
#' i-j-cells with no vegetation). This `hit.min` filter is stronger than
#' [butterfly()] since is does not discriminate isolated voxels.
#' A reasonable value for `hit.min` cannot be suggested ad-hoc since it
#' strongly depends on sampling intensity. Removing butterflies prior to
#' extracting canopy is advisable.
#'
#' ## Gaps
#'
#' For a VoxelSpace with fully defined ground level (see [ground()]),
#' missing canopy cells can be interpreted as gaps. Conversely if both ground
#' and canopy are missing for a i-j-cell, then it is inconclusive.
#'
#' ## Above/below canopy
#'
#' Function `aboveCanopy` returns voxel index above canopy level (excluded).
#' Function `belowCanopy` returns voxel index below canopy level (included).
#'
#' ## Canopy Height Model
#'
#' Function `canopyHeight` returns ground distance at canopy level, including
#' gaps.
#'
#' @return [`data.table::data.table-class`] object with voxel index either
#' below canopy, canopy level or above canopy
#'
#' @param vxsp a [`VoxelSpace-class`] object.
#' @param hit.min a positive integer, minimum number of hit/echo in a voxel
#' to consider it contains vegetation.
#' @param ... additional parameters which will be passed to `canopy` function.
#' So far only `hit.min` parameter.
#'
#' @seealso [butterfly()], [ground()]
#'
#' @examples
#' vxsp <- readVoxelSpace(system.file("extdata", "tls_sample.vox", package = "AMAPVox"))
#' cnp <- canopy(vxsp)
#' acnp <- aboveCanopy(vxsp)
#' bcnp <- belowCanopy(vxsp)
#' # canopy layer included in below canopy subset
#' all(bcnp[cnp, on=list(i, j, k)] == cnp) # TRUE expected
#  # extract ground distance from canopy voxels
#' vxsp@data[cnp, list(i, j, ground_distance), on=list(i, j, k)]
#'
#' @export
canopy <- function(vxsp, hit.min = 1) {

  # must be a voxel space
  stopifnot(is.VoxelSpace(vxsp))

  # nbSampling and nbEchos variables required
  stopifnot("nbEchos" %in% names(vxsp))

  # extract highest voxel with minimum hits count
  nbEchos <- i <- j <- k <- NULL # trick to avoid notes in R CMD check
  vxsp@data[nbEchos >= hit.min, list(i, j, k)][, list(k=max(k)), by=list(i, j)]
}

#' @rdname canopy
#' @export
belowCanopy <- function(vxsp, ...) {

  k.cnp <- i <- j <- k <- NULL # trick to avoid notes in R CMD check

  # create a i, j, k, k.cnp data.table
  vx <- merge(vxsp@data[, list(i, j, k)], canopy(vxsp, ...),
              by = c("i", "j"), suffixes = c("", ".cnp"))
  # extract i, j, k voxels for k <= k.cnp
  vx[k <= k.cnp, list(i, j, k)]
}

#' @rdname canopy
#' @export
aboveCanopy <- function(vxsp, ...) {

  k.cnp <- i <- j <- k <- NULL # trick to avoid notes in R CMD check

  # create a i, j, k, k.cnp data.table
  vx <- merge(vxsp@data[, list(i, j, k)], canopy(vxsp, ...),
              by = c("i", "j"), suffixes = c("", ".cnp"))
  # extract i, j, k voxels for k > k.cnp
  vx[k > k.cnp, list(i, j, k)]
}

#' @rdname canopy
#' @export
canopyHeight <- function(vxsp, ...) {

  # get ground
  ground <- ground(vxsp)

  # get canopy
  canopy <- canopy(vxsp, ...)

  # canopy height model
  i <- j <- k <- ground_distance <- NULL # trick to avoid "no visible binding" note
  chm <- merge(vxsp@data[canopy,
                         list(i, j, ground_distance),
                         on=list(i, j, k)],
               vxsp@data[ground[!canopy, on=list(i, j, k)],
                         list(i, j, ground_distance),
                         on=list(i, j, k)],
               all = TRUE)
  data.table::setnames(chm, "ground_distance", "canopy_height")

  return ( chm )
}
