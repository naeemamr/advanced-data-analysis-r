# Shared project setup

This script installs and loads the primary packages used across the workshop sequence.

```r
# Install missing packages if needed
required_packages <- c(
  "tidyverse",
  "readr",
  "dplyr",
  "tidyr",
  "lubridate",
  "ggplot2",
  "broom",
  "car",
  "sandwich",
  "lmtest",
  "plm",
  "fixest",
  "forecast",
  "vars",
  "quanteda",
  "tidytext",
  "factoextra",
  "FactoMineR",
  "cluster",
  "renv"
)

missing_packages <- setdiff(required_packages, rownames(installed.packages()))

if (length(missing_packages) > 0) {
  install.packages(missing_packages, repos = "https://cloud.r-project.org")
}

invisible(lapply(required_packages, library, character.only = TRUE))

message("Workshop dependencies loaded successfully.")
```
