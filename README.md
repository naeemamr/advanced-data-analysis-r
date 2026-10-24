# Advanced Data Analysis in R for Econometrics and Data Science

This repository is designed for advanced data analysis training in R for master's students in econometrics and data science. It focuses on reproducible workflows, clear project structure, and workshop-based learning using real-world economic and social datasets.

## Repository goals

- Teach reproducible data analysis in R using a consistent project structure
- Combine econometrics, multivariate methods, panel/time-series analysis, and text analysis
- Use realistic datasets from international development, macroeconomic, firm, and text corpora
- Make the course easy to run locally and in collaborative learning environments

## Workshop overview

| Workshop | Title | Core topic | Dataset |
| --- | --- | --- | --- |
| 1 | R for Reproducible Data Analysis | Project structure, import, cleaning, reshaping, dates, missing values, descriptive stats, ggplot2, transformations, documentation, reproducible workflow | World Bank WDI: 19 countries × 2000–2020 (`data/raw/global_development_intro.csv`) |
| 2 | Regression Diagnostics & Multivariate Methods in R | OLS diagnostics, robust SEs, VIF, transformations, PCA/EFA workflow, scree/loadings/scores, optional clustering | Country-context dataset; Global Findex; Polish Companies Bankruptcy dataset |
| 3 | Panel & Time-Series Analysis in R | Panel declaration, pooled/FE/RE, clustered SEs, stationarity tests, ACF/PACF, ARIMA/ARDL, VAR/IRF | WDI/Gapminder panel; IMF/FRED/CBE macro series |
| 4 | Quantitative Text Analysis in R | quanteda corpus workflow, tokenization, DFM, TF-IDF, dictionary scoring, classifier evaluation, optional topic/embedding demo | BIS central bank speeches subset |

## Repository structure

```text
advanced-data-analysis-r/
├── advanced-data-analysis-r.Rproj   <- double-click this to open the project
├── README.md
├── DESCRIPTION
├── .Rprofile
├── .gitignore
├── data/
│   ├── README.md
│   ├── raw/                  original data, never edited (committed)
│   ├── processed/            rebuilt by scripts, one subfolder per workshop (not committed)
│   └── metadata/             codebooks and data dictionaries, one subfolder per workshop
├── docs/
│   └── reproducibility-guide.md
├── scripts/
│   ├── setup.R               installs packages per workshop
│   └── helpers/
│       └── project_helpers.R
├── workshops/
│   ├── workshop-01/
│   │   ├── README.md                   objectives, setup, session plan
│   │   ├── workshop-01-walkthrough.R   main teaching script
│   │   ├── 01_clean_data.R             pipeline: raw -> clean
│   │   ├── report.qmd                  portfolio report (Quarto)
│   │   ├── exercises.qmd
│   │   ├── solutions.qmd
│   │   └── glossary.md
│   ├── workshop-02/
│   ├── workshop-03/
│   └── workshop-04/
└── outputs/                  figures, tables, reports (rebuilt by code)
```

## Getting started

1. Install R, RStudio and Quarto (links in `workshops/workshop-01/README.md`).
2. Double-click `advanced-data-analysis-r.Rproj` to open the project in RStudio.
3. In the Console, install the packages for the current workshop:

```r
source("scripts/setup.R")   # Workshop 1 packages
# setup_workshop(2)         # later workshops add their own packages
```

4. Build the clean data from the Console:

```r
source("workshops/workshop-01/01_clean_data.R")
```

5. Render the Workshop 1 report: open `workshops/workshop-01/report.qmd` in RStudio and click **Render** (blue arrow above the editor). Or, in RStudio's **Terminal** tab (next to Console):

```bash
quarto render workshops/workshop-01/report.qmd
```

6. Optional, for exact package versions across machines: `renv::init()` once, then `renv::snapshot()` after installing packages.

## How we write R

All scripts follow one structure and style (the R version of "Pythonic"). Two-page reference: [`docs/r-style-guide.pdf`](docs/r-style-guide.pdf), built from `docs/r-style-guide.qmd`.

## Reproducibility principles

This repository follows a reproducible workflow:

- use a project-based directory structure
- separate raw and processed data
- do not change original data files in place
- document decisions in code comments and markdown files
- version control data definitions and scripts
- track package versions with `renv`
- generate outputs and figures from scripts rather than manually editing them

## Course materials

Each workshop is designed to be self-contained and reusable. Materials may include:

- workshop readme and objectives
- exercises and solution files
- data dictionaries and metadata notes
- scripts for visualizations and diagnostics
- reproducible code examples

## Recommended package stack

Core packages may include:

- `tidyverse`
- `readr`, `dplyr`, `tidyr`, `lubridate`, `stringr`, `forcats`
- `ggplot2`
- `broom`
- `car`
- `sandwich`
- `lmtest`
- `plm`
- `fixest`
- `forecast`
- `vars`
- `quanteda`
- `tidytext`
- `factoextra`
- `FactoMineR`
- `cluster`
- `renv`
- `quarto`

## License

This project is licensed under the MIT License.

## Contact

For course materials or repository updates, please use this repository's issue tracker or maintain the workshop notes directly in the project.
