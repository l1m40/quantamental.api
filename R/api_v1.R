#' API v1 router
#'
#' @noRd
api_v1 <- function() {
  pr() |>
    pr_mount("/assets", assets_api()) |>
    pr_mount("/fundamentals", fundamentals_api())
}
