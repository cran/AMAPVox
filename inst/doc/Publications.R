## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, echo=FALSE--------------------------------------------------------
# libraries RefManageR
require("RefManageR", quietly = TRUE)  

## ----echo=FALSE, eval=TRUE, results='asis'------------------------------------
bib <- RefManageR::ReadBib("rsc/amapvox-bibtex.bib")
RefManageR::NoCite(bib, "*")
RefManageR::PrintBibliography(bib, .opts = list(style = "text", sorting = "ydnt"))

