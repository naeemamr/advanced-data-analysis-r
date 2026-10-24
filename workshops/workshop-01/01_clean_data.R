# =============================================================================
# Workshop 1 - Pipeline step 1: clean the raw data
#
# What this script does, in one sentence:
#   It reads the untouched raw file, applies every cleaning decision as code,
#   checks the result, and saves a clean copy in data/processed/workshop-01/.
#
# Input : data/raw/global_development_intro.csv          (never modified)
# Output: data/processed/workshop-01/global_development_clean.csv    (rebuilt every run)
#         data/processed/workshop-01/global_development_clean.rds    (same data, keeps factor order)
#
# Run it: open the project (.Rproj), then in the console type
#   source("workshops/workshop-01/01_clean_data.R")
# =============================================================================

library(tidyverse)   # data tools: readr, dplyr, tidyr, stringr, forcats, lubridate, ggplot2
library(here)        # builds file paths that start at the project folder

# ---- 1. Import -------------------------------------------------------------
raw <- read_csv(
  here("data", "raw", "global_development_intro.csv"),
  show_col_types = FALSE
)

# ---- 2. Clean --------------------------------------------------------------
clean <- raw |>
  # 2a. Drop the column that is 100% empty.
  select(-status) |>

  # 2b. Rename columns so they match the codebook and are self-explanatory.
  rename(
    country_code = iso3c,
    last_updated = lastupdated,
    income_group = income,
    lending_type = lending
  ) |>

  mutate(
    # 2c. Short names for charts (the official name is kept in `country`).
    country_short = case_match(
      country,
      "Egypt, Arab Rep." ~ "Egypt",
      "Korea, Rep."      ~ "South Korea",
      "Viet Nam"         ~ "Vietnam",
      .default = country
    ),

    # 2d. Dates: text -> real Date, and a Date version of the year.
    last_updated = ymd(last_updated),
    year_date    = make_date(year, 1, 1),

    # 2e. Categories: nominal -> factor, ordinal -> ORDERED factor.
    region       = factor(region),
    lending_type = factor(lending_type),
    income_group = factor(
      income_group,
      levels  = c("Lower middle income", "Upper middle income", "High income"),
      ordered = TRUE
    ),

    # 2f. Transformations for strongly skewed variables.
    log_gdp_per_capita = log(gdp_per_capita_ppp),
    log_population     = log(population)
  ) |>

  # 2g. Growth needs the previous year of the SAME country.
  group_by(country) |>
  arrange(year, .by_group = TRUE) |>
  mutate(gdp_growth_pct = 100 * (gdp_per_capita_ppp / lag(gdp_per_capita_ppp) - 1)) |>
  ungroup() |>

  # 2h. A tidy column order: identifiers first, then measures, then extras.
  relocate(country, country_short, country_code, year, year_date,
           region, income_group, lending_type)

# ---- 3. Check --------------------------------------------------------------
# stopifnot() stops the script with an error if any statement is FALSE.
# A silent pass means the data are what we think they are.
stopifnot(
  "one row per country-year"     = !any(duplicated(clean[c("country_code", "year")])),
  "balanced: 21 years each"      = all(count(clean, country)$n == 21),
  "internet use is a percentage" = all(between(clean$internet_use, 0, 100)),
  "youth unemployment is a %"    = all(between(clean$youth_unemployment, 0, 100)),
  "life expectancy is plausible" = all(between(clean$life_expectancy, 30, 95)),
  "income order kept"            = is.ordered(clean$income_group),
  "no unexpected missing values" = sum(is.na(clean)) == 19   # = first-year growth only
)

# ---- 4. Save ---------------------------------------------------------------
dir.create(here("data", "processed", "workshop-01"), showWarnings = FALSE, recursive = TRUE)
write_csv(clean, here("data", "processed", "workshop-01", "global_development_clean.csv"))
saveRDS(clean,   here("data", "processed", "workshop-01", "global_development_clean.rds"))

message("Clean data saved: ", nrow(clean), " rows x ", ncol(clean), " columns.")
