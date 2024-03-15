## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE---------------------------------------------------------------
#  # install "remotes" package if not already installed
#  if (!any(grepl("remotes", rownames(installed.packages())))) install.packages("remotes")
#  # install latest stable version from source
#  remotes::install_github('umr-amap/AMAPVox')

## ----setup--------------------------------------------------------------------
# load AMAPVox package
library(AMAPVox)

## ----eval=FALSE---------------------------------------------------------------
#  AMAPVox::run()

## ----eval=FALSE---------------------------------------------------------------
#  ? AMAPVox::run # section "Java 1.8 64-Bit with JavaFX"

## ----eval=FALSE---------------------------------------------------------------
#  AMAPVox::getRemoteVersions()

## ----eval=FALSE---------------------------------------------------------------
#  AMAPVox::installVersion("1.7.6")
#  # install and run specific version
#  AMAPVox::run("1.6.4", check.update = FALSE)

## ----eval=FALSE---------------------------------------------------------------
#  AMAPVox::getLocalVersions()

## ----eval=FALSE---------------------------------------------------------------
#  AMAPVox::removeVersion("1.7.6")

