

if(F){


  devtools::document()
  # devtools::load_all()

  plumber::plumb("inst/plumber/plumber.R")$run(port = 8000)




  renv::install("l1m40/quantamental.data")

  quantamental.data::get_data_mart_path()

  Sys.setenv(DURIN_DATA = "/Users/belter/Projects/gaivota/data")


}

# inst/plumber/plumber.R

library(plumber)
library(quantamental.data)

#* Health check
#* @get /health
function() {
  list(status = "ok", path=quantamental.data::get_data_root_path())
}

#* List assets
#* @get /v1/assets
function() {
  quantamental.data::get_ontology()$assets
}
