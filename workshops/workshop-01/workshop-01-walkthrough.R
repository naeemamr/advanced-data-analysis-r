# =============================================================================
#  WORKSHOP 1 — R FOR REPRODUCIBLE DATA ANALYSIS
#  BINF 901 Advanced Data Analysis · GIU · Winter 2026
#
#  Dataset : 19 countries × 21 years (2000–2020) of World Bank indicators
#  Lecture links: Lecture 1 (measurement, DGP, sampling) and Lecture 2 (EDA)
# =============================================================================
#
#  HOW TO USE THIS SCRIPT
#  ----------------------
#  * Run ONE line at a time: put the cursor on a line and press
#      Windows/Linux: Ctrl + Enter        Mac: Cmd + Return
#    The result appears in the Console pane (bottom-left in RStudio).
#  * Lines starting with # are comments. R ignores them; they are for humans.
#  * Each section has a title like "# ---- 3. ... ----". In RStudio, open the
#    outline with Ctrl + Shift + O (Mac: Cmd + Shift + O) to jump between them.
#  * When you see "JARGON / PLAIN / EXAMPLE", the scientific word comes first,
#    then what it means in everyday words, then where it shows up in our data.
#
# =============================================================================


# ---- 0. Packages ------------------------------------------------------------
# A package is a box of extra functions someone else wrote. We install a
# package once per computer, and load it with library() every session.
#
# Only run this line if R says "there is no package called ...":
# install.packages(c("tidyverse", "here"))

library(tidyverse)   # a family of packages for reading, cleaning and plotting
library(here)        # finds files starting from the project folder


# ---- 1. The project and its folders -----------------------------------------
# JARGON  : "working directory" and "relative path"
# PLAIN   : the folder R is currently standing in, and directions to a file
#           that start from that folder instead of from your C: drive.
# EXAMPLE : "data/raw/global_development_intro.csv" works on every laptop;
#           "C:/Users/Sara/Desktop/data.csv" works only on Sara's laptop.
#
# here() always starts from the folder containing the .Rproj file, so the
# same code runs on everyone's computer. Try it:
here()
here("data", "raw", "global_development_intro.csv")

# Our folder rules (look at them in the Files pane, bottom-right):
#   data/raw/        the original file. We NEVER edit it.
#   data/processed/  cleaned data, created by code (one subfolder per workshop).
#   outputs/         figures and tables, created by code.
#   workshops/       the scripts and reports.


# ---- 2. Import the data and take a first look -------------------------------
dev_raw <- read_csv(here("data", "raw", "global_development_intro.csv"))

# The arrow <- means "store the result under this name". dev_raw now appears
# in the Environment pane (top-right).

dim(dev_raw)        # rows, columns  -> 399 rows, 16 columns
glimpse(dev_raw)    # every column, its type, and its first values
head(dev_raw, 3)    # first three rows

# What does ONE row represent?
# JARGON  : "unit of analysis"
# PLAIN   : the thing each row is about.
# EXAMPLE : here one row = one country in one year, e.g. Brazil in 2000.
count(dev_raw, country)   # 19 countries, each appears 21 times
range(dev_raw$year)       # 2000 to 2020

# JARGON  : "panel data" (Lecture 1, slide 6)
# PLAIN   : the same units measured again and again over time.
# EXAMPLE : Egypt in 2000, Egypt in 2001, ... Egypt in 2020, and the same
#           for 18 other countries. 19 × 21 = 399 rows.
# WHY IT MATTERS: Egypt-2005 and Egypt-2006 are not independent; they are
#           the same country one year apart. Many statistics assume rows are
#           independent, so we have to keep this in mind (Workshop 3).


# ---- 3. What kind of data is each column? -----------------------------------
# JARGON  : "measurement scale": nominal, ordinal, interval, ratio
#           (Lecture 1, slide 5)
# PLAIN   : what kind of maths makes sense for the column.
#
#   nominal  = names only, no order          region, country, lending
#   ordinal  = categories WITH an order      income group (lower < upper < high)
#   interval = equal steps, no true zero     year (year 0 is not "no time")
#   ratio    = equal steps AND a true zero   GDP, population, internet use
#
# EXAMPLE OF A MISTAKE: if we coded regions as 1, 2, 3 ... and took the mean,
# R would happily give an answer like 3.4. It means nothing: there is no
# region "three point four". The computer does not know; you must.

distinct(dev_raw, income)    # 3 income groups, which have a natural order
distinct(dev_raw, region)    # 7 regions, which have no order

# The codebook (data/metadata/workshop-01/global_development_codebook.pdf) also tells us
# HOW each number was produced. Read the "Observed / Modelled / Estimated"
# column. Youth unemployment is a MODELLED estimate by the ILO, not a count.
#
# JARGON  : "data-generating process" (DGP) (Lecture 1, slide 7)
# PLAIN   : the real-world process that produced the numbers we see.
# EXAMPLE : a youth unemployment figure for Nigeria comes out of an ILO model
#           built on surveys, which miss informal workers. The number is a
#           measurement of unemployment, not unemployment itself.


# ---- 4. Missing values ------------------------------------------------------
# In R, a missing value is written NA ("not available").
# colSums(is.na(...)) counts the NAs in every column.
colSums(is.na(dev_raw))

# Result: only `status` has NAs, and it is 100% NA (399 out of 399).
# An empty column carries no information, so we will drop it in Section 5.
#
# This dataset is unusually complete. Real WDI downloads usually have gaps,
# especially for poorer countries and early years. So we SIMULATE missing
# data to see why the reason for missingness matters (Lecture 2 theme).
#
# JARGON  : MCAR = "missing completely at random"
# PLAIN   : the gaps happen by pure luck, like a coffee spill on random pages.
#
# JARGON  : MNAR = "missing not at random"
# PLAIN   : whether a value is missing depends on the value itself.
# EXAMPLE : countries with LOW internet use are the ones least likely to run
#           an internet survey, so their numbers are the ones that go missing.

internet_2020 <- dev_raw |> filter(year == 2020) |> pull(internet_use)

set.seed(901)  # makes the "random" draws identical every time we run it

# MCAR: hide 5 of the 19 values chosen completely at random
mcar <- internet_2020
mcar[sample(19, 5)] <- NA

# MNAR: hide the 5 LOWEST values (the countries least likely to report)
mnar <- internet_2020
mnar[order(internet_2020)[1:5]] <- NA

tibble(
  version           = c("true (no missing)", "MCAR (random gaps)", "MNAR (lowest hidden)"),
  mean_internet_use = c(mean(internet_2020),
                        mean(mcar, na.rm = TRUE),   # na.rm = TRUE: skip the NAs
                        mean(mnar, na.rm = TRUE))
)
# The MNAR mean is clearly too high. Dropping the missing rows did not just
# lose data, it gave a WRONG answer. That is BIAS (Lecture 1, slide 33):
# the error points the same way every time, and more data does not fix it.
#
# Note: mean(mcar) without na.rm = TRUE returns NA. Try it:
mean(mcar)


# ---- 5. Cleaning -------------------------------------------------------------
# Cleaning = turning the raw file into a version that is correct, consistent,
# and easy to work with. Every decision is written as code, so anyone can see
# it and repeat it. The raw file is never touched.
#
# The pipe |> means "and then". Read the block below out loud as:
# take dev_raw, AND THEN drop status, AND THEN rename columns, AND THEN ...

dev <- dev_raw |>
  select(-status) |>                       # drop the 100%-empty column
  rename(
    country_code = iso3c,                  # match the name in the codebook
    last_updated = lastupdated,
    income_group = income,
    lending_type = lending
  ) |>
  mutate(
    # Short names for charts. The official name stays in `country`.
    country_short = case_match(
      country,
      "Egypt, Arab Rep." ~ "Egypt",
      "Korea, Rep."      ~ "South Korea",
      "Viet Nam"         ~ "Vietnam",
      .default = country
    ),
    # A "factor" is R's word for a categorical (nominal) variable.
    region       = factor(region),
    lending_type = factor(lending_type),
    # An ORDERED factor is an ordinal variable: we tell R the correct order.
    income_group = factor(
      income_group,
      levels  = c("Lower middle income", "Upper middle income", "High income"),
      ordered = TRUE
    )
  )

levels(dev$income_group)   # R now knows the order
glimpse(dev)

# Sanity checks: does the data look like what the codebook promises?
# Each line should print TRUE.
all(between(dev$internet_use, 0, 100))          # a percentage stays in 0–100
all(between(dev$life_expectancy, 30, 95))       # plausible human lifespans
!any(duplicated(dev[c("country_code", "year")])) # no country-year appears twice


# ---- 6. Dates ----------------------------------------------------------------
# last_updated was read as TEXT ("chr"). Text cannot be subtracted or sorted
# as time. ymd() = "year-month-day" turns text into a real Date.
class(dev$last_updated)            # "character"

dev <- dev |>
  mutate(
    last_updated = ymd(last_updated),
    year_date    = make_date(year, 1, 1)   # 2005 -> 2005-01-01
  )

class(dev$last_updated)            # "Date"

# Now we can do arithmetic with time. How old is this data download?
today() - max(dev$last_updated)    # number of days since the last update

# Extracting parts of a date:
month(dev$last_updated[1], label = TRUE)   # which month
wday(dev$last_updated[1], label = TRUE)    # which weekday

# Why make year_date? Charts and time-series tools (Workshop 3) understand
# real dates better than plain whole numbers.


# ---- 7. Reshaping: long and wide ---------------------------------------------
# JARGON  : "long" vs "wide" format; "tidy data"
# PLAIN   : long = one row per country-year (what we have now).
#           wide = one row per country, one column per year (like Excel).
# Tidy data = each variable is a column, each observation is a row, each
#             value is a cell. ggplot2 and models expect long/tidy data.

# Long -> wide: a country × year table of internet use (good for reading)
internet_wide <- dev |>
  select(country_short, year, internet_use) |>
  pivot_wider(names_from = year, values_from = internet_use)

internet_wide          # 19 rows, 1 name column + 21 year columns

# Wide -> long: back again (good for plotting and modelling)
internet_long <- internet_wide |>
  pivot_longer(cols = -country_short, names_to = "year", values_to = "internet_use") |>
  mutate(year = as.integer(year))   # column names are text, turn them back into numbers

internet_long

# A second, very useful reshape: stack the five indicators on top of each
# other, so ONE plot can show them all in small panels (Section 10).
dev_indicators_long <- dev |>
  select(country_short, year, gdp_per_capita_ppp, life_expectancy,
         youth_unemployment, internet_use, population) |>
  pivot_longer(cols = gdp_per_capita_ppp:population,
               names_to = "indicator", values_to = "value")

dev_indicators_long    # 399 × 5 = 1,995 rows


# ---- 8. Descriptive statistics -----------------------------------------------
# We describe ONE year at a time (2020). Pooling all years would count
# Egypt 21 times as if it were 21 different countries.
dev_2020 <- dev |> filter(year == 2020)

# 8a. LOCATION: where is the "typical" value? (Lecture 1, slide 9)
dev_2020 |>
  summarise(
    mean_gdp   = mean(gdp_per_capita_ppp),
    median_gdp = median(gdp_per_capita_ppp)
  )
# JARGON  : mean vs median
# PLAIN   : mean = add up and divide; median = the middle value when sorted.
# EXAMPLE : if one billionaire walks into a café, the MEAN income in the
#           room shoots up; the MEDIAN barely moves. The mean is pulled by
#           extreme values, the median is not.

# 8b. DISPERSION: how spread out are the values? (Lecture 1, slide 10)
dev_2020 |>
  summarise(
    sd_gdp  = sd(gdp_per_capita_ppp),                       # standard deviation
    iqr_gdp = IQR(gdp_per_capita_ppp),                      # middle 50% range
    cv_gdp  = sd(gdp_per_capita_ppp) / mean(gdp_per_capita_ppp)  # relative spread
  )
# JARGON  : standard deviation (SD)
# PLAIN   : the typical distance of a value from the mean, in the same units.
# EXAMPLE : an SD of about $20,000 means countries are typically about
#           $20,000 away from the average income.
#
# JARGON  : coefficient of variation (CV)
# PLAIN   : SD divided by the mean, so spreads can be compared across
#           variables measured in different units (dollars vs years).

# 8c. SHAPE: is the distribution lopsided? (Lecture 1, slide 11)
# Skewness = average of the cubed z-scores. 0 = symmetric, > 0 = long right tail.
skewness <- function(x) mean(((x - mean(x)) / sd(x))^3)

dev_2020 |>
  summarise(across(c(gdp_per_capita_ppp, population, life_expectancy,
                     youth_unemployment, internet_use), skewness))
# Population is extremely right-skewed: China and India are far above the rest.

# 8d. BY GROUP: group_by() + summarise() = a summary per category
dev_2020 |>
  group_by(income_group) |>
  summarise(
    countries          = n(),
    median_gdp         = median(gdp_per_capita_ppp),
    median_life_exp    = median(life_expectancy),
    median_internet    = median(internet_use),
    median_youth_unemp = median(youth_unemployment)
  )

# 8e. SD vs SE (Lecture 1, slide 25)
# JARGON  : standard error (SE) = SD / square root of n
# PLAIN   : SD describes how much COUNTRIES differ from each other.
#           SE describes how much the AVERAGE would change if we had drawn a
#           different random sample of countries.
# EXAMPLE : ask 5 random friends their height, average it, then ask 5 others.
#           The two averages differ a little: that wobble is the SE.
dev_2020 |>
  summarise(
    mean_life = mean(life_expectancy),
    sd_life   = sd(life_expectancy),
    se_life   = sd(life_expectancy) / sqrt(n())
  )
# CAUTION (Lecture 1, slide 21): our 19 countries were CHOSEN, not randomly
# sampled. The SE formula assumes random sampling, so here it shows the
# mechanics only. It does not tell us anything about "all countries".


# ---- 9. Transformations -------------------------------------------------------
# A transformation creates a new column from an existing one.

dev <- dev |>
  mutate(
    # 9a. LOG: squeezes big numbers together and spreads small ones apart.
    #     Useful for right-skewed money and population data.
    #     Plain example: on a log scale, going from $1,000 to $10,000 is the
    #     same distance as going from $10,000 to $100,000 (both ×10).
    log_gdp_per_capita = log(gdp_per_capita_ppp),
    log_population     = log(population)
  ) |>
  group_by(year) |>
  mutate(
    # 9b. Z-SCORE (standardisation, Lecture 1, slide 19):
    #     how many SDs above or below the average country THAT YEAR.
    #     Plain example: z = +2 means "far above the average", z = 0 means "average".
    life_exp_z = (life_expectancy - mean(life_expectancy)) / sd(life_expectancy)
  ) |>
  group_by(country) |>
  arrange(year, .by_group = TRUE) |>
  mutate(
    # 9c. GROWTH RATE: % change from LAST year of the SAME country.
    #     lag() = "the value one row above". group_by(country) makes sure we
    #     never compare Brazil 2000 with China 2020.
    gdp_growth_pct = 100 * (gdp_per_capita_ppp / lag(gdp_per_capita_ppp) - 1),
    # 9d. INDEX: every country starts at 100 in 2000, so growth paths compare
    #     fairly even when income LEVELS are very different.
    gdp_index_2000 = 100 * gdp_per_capita_ppp / first(gdp_per_capita_ppp)
  ) |>
  ungroup()

# The skewness of log GDP is much closer to 0 than raw GDP:
dev |> filter(year == 2020) |>
  summarise(raw_gdp = skewness(gdp_per_capita_ppp), log_gdp = skewness(log_gdp_per_capita))

# Every country's FIRST year has no previous year, so its growth is NA.
# That is 19 NAs, and they are correct, not an error.
sum(is.na(dev$gdp_growth_pct))

# Which countries grew most from 2000 to 2020?
dev |> filter(year == 2020) |>
  arrange(desc(gdp_index_2000)) |>
  select(country_short, gdp_index_2000)


# ---- 10. Visualisation with ggplot2 -------------------------------------------
# ggplot2 builds a chart in layers, joined with +
#   ggplot(data, aes(x = ..., y = ...))   which data, which columns go where
#   + geom_...()                          what shape to draw (points, lines, bars)
#   + labs()                              titles and axis labels
# "aes" = aesthetics = the mapping from columns to what you see.

theme_set(theme_minimal(base_size = 12))   # one clean style for every chart

# 10a. HISTOGRAM: the shape of one variable
p_hist <- ggplot(dev_2020, aes(x = gdp_per_capita_ppp)) +
  geom_histogram(bins = 8, fill = "steelblue", colour = "white") +
  labs(title = "GDP per capita is right-skewed (2020)",
       x = "GDP per capita, PPP (constant 2017 int. $)", y = "Number of countries")
p_hist

# 10b. LINE CHART: change over time, one line per country
p_lines <- ggplot(dev, aes(x = year_date, y = internet_use, group = country_short)) +
  geom_line(colour = "grey70") +
  geom_line(data = filter(dev, country_short %in% c("Egypt", "Nigeria", "South Korea")),
            aes(colour = country_short), linewidth = 1.2) +
  labs(title = "Internet use rose everywhere, from very different starting points",
       x = NULL, y = "Internet users (% of population)", colour = NULL)
p_lines

# 10c. SCATTER PLOT: the relationship between two variables
# Log x-axis, because GDP is skewed (Section 9a).
p_scatter <- ggplot(dev_2020, aes(x = gdp_per_capita_ppp, y = life_expectancy)) +
  geom_point(aes(colour = income_group, size = population), alpha = 0.8) +
  geom_text(aes(label = country_short), size = 3, vjust = -1.2) +
  scale_x_log10(labels = scales::label_dollar(accuracy = 1),
                expand = expansion(mult = 0.08)) +
  scale_y_continuous(expand = expansion(mult = c(0.05, 0.12))) +
  scale_size_area(max_size = 12, guide = "none") +
  labs(title = "Richer countries live longer (2020)",
       subtitle = "Point size = population. X axis on a log scale.",
       x = "GDP per capita, PPP (log scale)", y = "Life expectancy (years)",
       colour = "Income group")
p_scatter
# CAUTION: this shows ASSOCIATION, not cause. Rich countries also have more
# doctors, cleaner water, more schooling... (Lecture 1, "Design problem").

# 10d. BOX PLOT: compare a distribution across groups
p_box <- ggplot(dev, aes(x = income_group, y = youth_unemployment)) +
  geom_boxplot(fill = "grey90") +
  geom_jitter(width = 0.15, alpha = 0.3, size = 1) +
  labs(title = "Youth unemployment by income group, all years",
       x = NULL, y = "Youth unemployment (% of youth labour force)")
p_box
# How to read a box: the line in the middle is the median, the box is the
# middle 50% (the IQR), and the whiskers reach to typical extremes.

# 10e. SMALL MULTIPLES: all indicators at once, using the long data from 7
p_facets <- dev_indicators_long |>
  group_by(year, indicator) |>
  summarise(median_value = median(value), .groups = "drop") |>
  ggplot(aes(x = year, y = median_value)) +
  geom_line(linewidth = 1) +
  facet_wrap(~ indicator, scales = "free_y") +   # one panel per indicator
  labs(title = "Median across the 19 countries, 2000-2020", x = NULL, y = NULL)
p_facets

# Save figures with code, never by right-click "Save image".
# Then anyone can regenerate the exact same file.
# bg = "white" stops the background from being transparent (it looks black
# in some image viewers).
dir.create(here("outputs", "figures"), recursive = TRUE, showWarnings = FALSE)
ggsave(here("outputs", "figures", "w1_scatter_gdp_life.png"), p_scatter,
       width = 8, height = 5, dpi = 300, bg = "white")
ggsave(here("outputs", "figures", "w1_internet_lines.png"), p_lines,
       width = 8, height = 5, dpi = 300, bg = "white")


# ---- 11. Save the clean data and make it reproducible -------------------------
# The cleaning steps above (sections 5, 6, 9) are collected in ONE short script:
#   workshops/workshop-01/01_clean_data.R
# Running it rebuilds data/processed/workshop-01/ from data/raw/ every time.
source(here("workshops", "workshop-01", "01_clean_data.R"))

# JARGON  : "reproducible"
# PLAIN   : someone else, with your folder and no help from you, gets the
#           exact same numbers and charts.
# THE TEST: Session > Restart R (Ctrl + Shift + F10), then run this whole file
#           with Source (Ctrl + Shift + S). If it finishes without errors,
#           it is reproducible on your machine.
#
# Record which R and package versions produced these results:
sessionInfo()

# For other machines, renv records exact package versions (see README):
#   renv::init()      # once per project
#   renv::snapshot()  # after installing packages
#   renv::restore()   # on a new computer, installs the same versions

# =============================================================================
#  RECAP: one sentence per idea
#  1. Unit of analysis: know what one row is (here a country-year).
#  2. Measurement scale: decides which maths is meaningful.
#  3. Missing values: WHY they are missing matters more than HOW MANY.
#  4. Raw data is never edited; every fix is code.
#  5. Long data for analysis, wide data for reading.
#  6. Mean vs median: report both when data are skewed.
#  7. SD describes the data; SE describes uncertainty about an average.
#  8. Log and z-score transformations make skewed or differently scaled
#     variables comparable.
#  9. Figures and tables are created by code, so they can be rebuilt.
# =============================================================================
