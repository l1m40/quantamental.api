

if(F){


  devtools::document()
  devtools::load_all()

  plumber::plumb("inst/plumber/plumber.R")$run(port = 8000)




}


library(plumber)
library(quantamental.data)

pr() |>
  pr_get("/health", function() {
    list(status = "ok")
  }) |>
  pr_mount("/v1", api_v1())
