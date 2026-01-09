

if(F){

  # Reinstall the DAL when code changes
  renv::install("l1m40/quantamental.data")
  # update renv.lock with all packages used in this project
  renv::snapshot()


  # Init from local environment
  devtools::document()
  # devtools::load_all()
  # api_key_local_bypass <- 'not'
  # raise the service
  plumber::plumb("inst/plumber/plumber.R")$run(port = 8000)
  # test the service with authentication
  # $ curl -H "X-API-Key: local-test-key" http://localhost:8000/v1/assets


  quantamental.data::read_ontology() |> summary()


  quantamental.data::get_data_mart_path()




}

# inst/plumber/plumber.R

#* @apiTitle Quantamental Data API
#* @apiDescription Quantamental Data API
#* @apiVersion v0

library(plumber)
# library(quantamental.data)






# ---- API key authentication filter ----
#* @filter auth
function(req, res) {
  # Allow unauthenticated health checks
  if (identical(req$PATH_INFO, "/health")) {
    return(forward())
  }
  # Workaround for Google Sheets
  if (identical(req$PATH_INFO, "/v1/fundamentals.auth")) {
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
  quantamental.data::read_ontology()$assets
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
#* Get asset fundamentals
#*
#* @param asset_input Ticker
#* @param auth Authentication workaround
#*
#* @get /v1/fundamentals.auth
#* @serializer csv
function(req, res, asset_input, auth) {
  stopifnot(!missing(asset_input))
  stopifnot(!missing(auth))
  stopifnot(auth=="quantamental")
  quantamental.data::read_asset_fundamentals(asset_input)
}








