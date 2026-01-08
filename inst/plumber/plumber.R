

if(F){

  # Reinstall the DAL when code changes
  renv::install("l1m40/quantamental.data")
  # update renv.lock with all packages used in this project
  renv::snapshot()


  # Init from local environment
  devtools::document()
  # devtools::load_all()
  # api_key_local_bypass <- 'not'

  plumber::plumb("inst/plumber/plumber.R")$run(port = 8000)





  quantamental.data::get_data_mart_path()

  Sys.setenv(DURIN_DATA = "/Users/belter/Projects/gaivota/data")


}

# inst/plumber/plumber.R

library(plumber)
library(quantamental.data)






# ---- API key authentication filter ----
#* @filter auth
function(req, res) {
  # Allow unauthenticated health checks
  if (identical(req$PATH_INFO, "/health")) {
    return(forward())
  }
  api_key_required <- Sys.getenv("QUANTAMENTAL_API_KEY", unset = NA)
  if (is.na(api_key_required) || api_key_required == "") {
    res$status <- 500
    return(list(error = "API key not configured on server"))
  }
  api_key_provided <- req$HTTP_X_API_KEY
  if (exists("api_key_local_bypass")) { api_key_provided <- api_key_required ; warning("API key bypass") }
  if (is.null(api_key_provided) || api_key_provided != api_key_required) {
    res$status <- 401
    return(list(error = "Unauthorized"))
  }
  forward()
}











#* Health check
#* @get /health
function() {
  list(status = "ok", authentication="other endpoints by API-Key")
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








