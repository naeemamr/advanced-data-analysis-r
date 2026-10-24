# Workshop 1: R for Reproducible Data Analysis

**Course:** BINF 901 Advanced Data Analysis · **When:** Week 2 · **Lecture links:** Lecture 1 (measurement, DGP, sampling), Lecture 2 (EDA, missing data, transformations)

## What you will be able to do afterwards

1. Open an R project and read data with paths that work on any computer.
2. Say what one row of a dataset represents, and which maths fits each column.
3. Find missing values and explain why the *reason* they are missing matters.
4. Clean data with code, never by hand.
5. Turn text into dates and reshape data between long and wide.
6. Describe a variable with location, spread and shape, and compare groups.
7. Log-transform and standardise variables, and explain why.
8. Build and save `ggplot2` charts with code.
9. Render a Quarto report that anyone can rebuild from the raw data.

## Files in this folder

| File | What it is | Who uses it |
|---|---|---|
| `workshop-01-walkthrough.R` | The main teaching script, run line by line, with every concept explained in plain words | Live session |
| `01_clean_data.R` | The short pipeline step: raw data → clean data, with automatic checks | Everyone; called by the other files |
| `report.qmd` | A finished portfolio report built from the clean data | Example of the target deliverable |
| `exercises.qmd` | Fill-in-the-blank and written exercises | Students |
| `solutions.qmd` | Worked answers | Students, after trying |
| `glossary.md` | Every technical term → plain words → example from this dataset | Reference |

## Dataset

`data/raw/global_development_intro.csv`: 19 countries × 21 years (2000–2020) from the World Bank. Columns: GDP per capita, life expectancy, youth unemployment, internet use, population, region and income group. See `data/README.md` and `data/metadata/`.

## Before the session (students, about 20 minutes, at home)

1. Install **R** from <https://cran.r-project.org> (pick your operating system, download, run the installer, accept the defaults).
2. Install **RStudio Desktop** from <https://posit.co/download/rstudio-desktop/>.
3. Install **Quarto** from <https://quarto.org/docs/get-started/> (recent RStudio versions already include it).
4. Download this repository: on GitHub, click the green **Code** button → **Download ZIP**, then unzip it. (Or `git clone` if you use Git.)
5. Double-click `advanced-data-analysis-r.Rproj`. RStudio opens with the project folder as its home.
6. In the **Console** (bottom-left pane), type `source("scripts/setup.R")` and press Enter. Wait until it prints `Workshop 1 packages are ready.`
7. Still in the Console, type `source("workshops/workshop-01/01_clean_data.R")`. It should print `Clean data saved: 399 rows x 20 columns.`

If step 6 or 7 fails, bring the exact error message to the session.

## Session plan (3 hours)

| Time | Section in walkthrough | Activity |
|---|---|---|
| 0:00–0:15 | 0–1 | Check everyone's setup works; project folders; `here()` |
| 0:15–0:35 | 2–3 | Import; unit of analysis; measurement scales; Exercises 1–2 |
| 0:35–1:00 | 4 | Missing values and the MCAR vs MNAR simulation; Exercise 3 |
| 1:00–1:20 | 5–6 | Cleaning with the pipe; dates; Exercise 4 |
| 1:20–1:30 | | Break |
| 1:30–1:45 | 7 | Long vs wide; Exercise 5 |
| 1:45–2:15 | 8–9 | Descriptive statistics and transformations; Exercises 6–7 |
| 2:15–2:45 | 10 | ggplot2; Exercise 8 |
| 2:45–3:00 | 11 | Restart R, render `report.qmd`, discuss what makes it reproducible |

Exercises not finished in the session are homework.

## Teaching notes

- **The dataset is clean.** It has no real gaps, so Section 4 *simulates* missing data with a fixed seed. Say clearly that the simulation is a demonstration, and that real WDI downloads have many gaps.
- **Do not pool years for summary statistics.** Treating 399 country-years as 399 independent countries is the most common mistake. Section 8 uses one year (2020).
- **Not a random sample.** The SE in Section 8e shows the formula only. Connect it to Lecture 1, slide 21.
- **Common errors to expect:** `could not find function "%>%"` or `"pivot_wider"` (forgot `library(tidyverse)`); `'data/raw/...' does not exist` (project not opened via the `.Rproj`); `object 'dev' not found` (skipped a section; re-run from the top).

## Portfolio deliverable

Each student copies `report.qmd` to their own fork, changes the author, adds one new figure and one new finding of their own, and renders it. The rendered HTML plus the repository link is their Workshop 1 portfolio piece.
