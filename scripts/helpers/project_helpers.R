# Shared helpers for workshop scripts

project_root <- function() {
  normalizePath(".")
}

data_path <- function(type = c("raw", "processed", "metadata"), file = NULL) {
  type <- match.arg(type)
  base <- file.path(project_root(), "data", type)
  if (!is.null(file)) {
    file.path(base, file)
  } else {
    base
  }
}

output_path <- function(folder = "figures", file = NULL) {
  base <- file.path(project_root(), "outputs", folder)
  if (!dir.exists(base)) dir.create(base, recursive = TRUE, showWarnings = FALSE)
  if (!is.null(file)) {
    file.path(base, file)
  } else {
    base
  }
}
