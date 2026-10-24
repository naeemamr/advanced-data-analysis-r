# Workshop 1 glossary: jargon → plain words → our data

Each term: the scientific word, what it means in everyday language, and where you meet it in the Global Development dataset.

## Data and measurement (Lecture 1)

| Term | In plain words | In our data |
|------------------------|------------------------|------------------------|
| **Unit of analysis** | The thing one row is about. | One country in one year (Ghana, 2012). |
| **Observation** | One row. | Ghana, 2012, with all its numbers. |
| **Variable** | One column; something that can differ between rows. | `life_expectancy`. |
| **Panel data** | The same units measured repeatedly over time. | 19 countries × 21 years. |
| **Balanced panel** | Every unit has every time period. | All 19 countries have all years 2000–2020. |
| **Cross-section** | Many units at one moment. | All 19 countries in 2020 only. |
| **Time series** | One unit over many moments. | Egypt, 2000–2020 only. |
| **Nominal** | Categories with no order. | `region`, `lending_type`. |
| **Ordinal** | Categories with an order, but uneven gaps. | `income_group`: lower middle \< upper middle \< high. |
| **Interval** | Equal steps, but zero is not "nothing". | `year`. |
| **Ratio** | Equal steps and a true zero. | `population`, `internet_use`. |
| **Proxy** | A measurable stand-in for something we cannot measure directly. | Internet use as a stand-in for "digital access". |
| **Data-generating process (DGP)** | The real-world process that produced the numbers. | ILO surveys + model → youth unemployment figure. |
| **Modelled estimate** | A number computed by a model, not counted directly. | `youth_unemployment` (ILO). |
| **Sampling frame** | The list of units that could have ended up in the data. | Only these 19 hand-picked countries. |
| **Representative** | The sample looks like the population we care about. | Not the case: no low-income countries are included. |

## Missing data

| Term | In plain words | In our data |
|------------------------|------------------------|------------------------|
| **NA** | R's mark for "no value here". | `status` is NA in every row. |
| **MCAR** (missing completely at random) | Gaps happen by pure luck. | Simulated: 5 random countries hidden. Average barely moves. |
| **MAR** (missing at random) | Gaps depend on something else we *did* record. | E.g. figures missing more often for one region. |
| **MNAR** (missing not at random) | Gaps depend on the missing value itself. | Simulated: the 5 lowest internet figures hidden. Average jumps from 71.8 to 81.0. |
| **Bias** | An error that always points the same way. | The MNAR average is too high every time. |

## Describing data (Lecture 1, slides 9–11)

| Term | In plain words | In our data |
|------------------------|------------------------|------------------------|
| **Mean** | Add up, divide by how many. | Average internet use, 2020: 71.8%. |
| **Median** | The middle value after sorting. | Median internet use, 2000: 2.8% (mean: 9.8%). |
| **Standard deviation (SD)** | Typical distance of a value from the mean, in the same units. | How far countries' life expectancy typically is from the average. |
| **IQR** | The width of the middle half of the data. | The box in a box plot. |
| **Coefficient of variation (CV)** | SD ÷ mean: spread relative to size. | Compare spread of dollars and years fairly. |
| **Skewness** | How lopsided a distribution is. | GDP has a long right tail (a few very rich countries). |
| **Outlier** | A value far away from the rest. | South Africa's youth unemployment (\~60%). |
| **Standard error (SE)** | How much an *average* would wobble across different random samples. | SD ÷ √19, valid only if the 19 were random. |

## Transformations

| Term | In plain words | In our data |
|------------------------|------------------------|------------------------|
| **Log transformation** | Measure in "times bigger" instead of "dollars more". | `log_gdp_per_capita`: \$1k→\$10k is the same step as \$10k→\$100k. |
| **Standardisation / z-score** | How many SDs above or below average. | South Africa youth unemployment 2020: z ≈ +2.7. |
| **Growth rate** | \% change from last period. | `gdp_growth_pct`, computed within each country. |
| **Index (base year = 100)** | Rescale so every series starts at 100. | GDP index, 2000 = 100. |
| **Lag** | The value from the previous period. | Last year's GDP, for the same country. |

## Data wrangling and R

| Term | In plain words | In our data |
|------------------------|------------------------|------------------------|
| **Tidy data** | One variable per column, one observation per row. | The clean dataset. |
| **Long format** | Many rows, few columns. | One row per country-year. |
| **Wide format** | Few rows, many columns. | One row per country, one column per year. |
| **Pivot** | Switch between long and wide. | `pivot_wider()`, `pivot_longer()`. |
| **Factor** | R's type for a category. | `region`. |
| **Ordered factor** | A category type that knows its order. | `income_group`. |
| **Pipe `|>`** | "And then". | `dev |> filter(...) |> summarise(...)`. |
| **Relative path** | Directions starting from the project folder. | `here("data", "raw", "...csv")`. |
| **Reproducible** | Someone else gets the same results from your files without your help. | Restart R, render `report.qmd`, same output. |
| **Seed** | A starting number that makes "random" draws repeat exactly. | `set.seed(901)` in the missing-data simulation. |
