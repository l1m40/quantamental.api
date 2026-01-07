#' Assets endpoints
#'
#' @noRd
assets_api <- function() {
  pr() |>
    pr_get("/", function() {
      quantamental.data::get_ontology()$assets
    })
}
