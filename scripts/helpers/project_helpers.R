# Shared helpers for workshop scripts.
#
# All paths are built with here::here(), which always starts from the folder
# that contains the .Rproj file. This matters because Quarto runs each .qmd
# from the .qmd's own folder; a plain "data/raw/..." path would break there.
# it's useful trust me

project_root <- function() {
  here::here()
}

data_path <- function(type = c("raw", "processed", "metadata"), file = NULL) {
  type <- match.arg(type)
  base <- here::here("data", type)
  if (!dir.exists(base)) dir.create(base, recursive = TRUE, showWarnings = FALSE)
  if (is.null(file)) base else file.path(base, file)
}

output_path <- function(folder = c("figures", "tables", "reports"), file = NULL) {
  folder <- match.arg(folder)
  base <- here::here("outputs", folder)
  if (!dir.exists(base)) dir.create(base, recursive = TRUE, showWarnings = FALSE)
  if (is.null(file)) base else file.path(base, file)
}
