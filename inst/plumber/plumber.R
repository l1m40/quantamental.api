

if(F){

  # Reinstall the DAL when code changes
  renv::install("l1m40/quantamental.data")
  # update renv.lock with all packages used in this project
  renv::snapshot()


  devtools::document()
  # devtools::load_all()

  plumber::plumb("inst/plumber/plumber.R")$run(port = 8000)





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






#* Get asset fundamentals
#*
#* @param asset_input Asset identifier (repeatable)
# @param start_date Start date (YYYY-MM-DD)
# @param end_date End date (YYYY-MM-DD)
# @param frequency annual or quarterly
#*
#* @get /v1/fundamentals
#* @serializer json
function(req, res, asset_input) {
  stopifnot(!missing(asset_input))
  quantamental.data::read_asset_fundamentals(asset_input)
}


#* Get asset fundamentals
#*
#* @param asset_input Ticker
#*
#* @get /v1/fundamentals.csv
#* @serializer csv
function(req, res, asset_input) {
  stopifnot(!missing(asset_input))
  quantamental.data::read_asset_fundamentals(asset_input)
}








