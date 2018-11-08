FROM rocker/geospatial:latest
MAINTAINER "Ben Best" ben@ecoquants.com

## install extra packages 
RUN install2.r --error \
  ## [Error when trying to install shiny · Issue #2039 · rstudio/shiny](https://github.com/rstudio/shiny/issues/2039)
  Rcpp \
  httpuv \
  shiny \
  ## for github.com/ecoquants/nrel-uses:app
  here \
  glue \
  fs \
  leaflet \
  shinydashboard

## add Shiny, per https://github.com/rocker-org/rocker/issues/235#issuecomment-299036810
RUN export ADD=shiny && bash /etc/cont-init.d/add