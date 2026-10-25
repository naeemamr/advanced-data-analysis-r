# =============================================================================
# scripts/setup.R
# Installs (only if missing) and loads the packages a workshop needs.
#
# How to use it, from the R console, with the project open:
#   source("scripts/setup.R")          # installs Workshop 1 packages only
#   setup_workshop(2)                  # later: adds Workshop 2 packages
#
# Why per-workshop lists? Installing 20 packages on day one is the most common
# reason beginners give up. Workshop 1 needs only 2
# =============================================================================

workshop_packages <- list(
  `1` = c("tidyverse", "here"),
  `2` = c("broom", "car", "sandwich", "lmtest", "factoextra", "FactoMineR", "cluster"),
  `3` = c("plm", "fixest", "forecast", "vars"),
  `4` = c("quanteda", "tidytext")
)

# Quarto rendering of .qmd files needs these two as well.
reporting_packages <- c("knitr", "rmarkdown")

setup_workshop <- function(workshop = 1) {
  needed  <- unique(c(unlist(workshop_packages[as.character(seq_len(workshop))]),
                      reporting_packages))
  missing <- setdiff(needed, rownames(installed.packages()))

  if (length(missing) > 0) {
    message("Installing: ", paste(missing, collapse = ", "))
    install.packages(missing, repos = "https://cloud.r-project.org")
  }

  invisible(lapply(workshop_packages[[as.character(workshop)]], library,
                   character.only = TRUE))
  message("Workshop ", workshop, " packages are ready.")
}

setup_workshop(1)
