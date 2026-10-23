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
| 1 | R for Reproducible Data Analysis | Project structure, import, cleaning, reshaping, dates, missing values, descriptive stats, ggplot2, transformations, documentation, reproducible workflow | Gapminder/WDI-style country-year dataset |
| 2 | Regression Diagnostics & Multivariate Methods in R | OLS diagnostics, robust SEs, VIF, transformations, PCA/EFA workflow, scree/loadings/scores, optional clustering | Country-context dataset; Global Findex; Polish Companies Bankruptcy dataset |
| 3 | Panel & Time-Series Analysis in R | Panel declaration, pooled/FE/RE, clustered SEs, stationarity tests, ACF/PACF, ARIMA/ARDL, VAR/IRF | WDI/Gapminder panel; IMF/FRED/CBE macro series |
| 4 | Quantitative Text Analysis in R | quanteda corpus workflow, tokenization, DFM, TF-IDF, dictionary scoring, classifier evaluation, optional topic/embedding demo | BIS central bank speeches subset |

## Repository structure

```text
advanced-data-analysis-r/
├── README.md
├── .gitignore
├── .Rprofile
├── DESCRIPTION
├── renv.lock.example
├── data/
│   ├── README.md
│   ├── raw/
│   ├── processed/
│   └── metadata/
├── docs/
│   └── reproducibility-guide.md
├── scripts/
│   ├── setup.R
│   └── helpers/
│       └── project_helpers.R
├── workshops/
│   ├── workshop-01/
│   │   ├── README.md
│   │   ├── exercises.Rmd
│   │   └── solutions.Rmd
│   ├── workshop-02/
│   │   ├── README.md
│   │   ├── exercises.Rmd
│   │   └── solutions.Rmd
│   ├── workshop-03/
│   │   ├── README.md
│   │   ├── exercises.Rmd
│   │   └── solutions.Rmd
│   └── workshop-04/
│       ├── README.md
│       ├── exercises.Rmd
│       └── solutions.Rmd
├── outputs/
│   ├── figures/
│   ├── tables/
│   └── reports/
└── .Rproj.user/
```

## Getting started

1. Open the project in RStudio as an R project.
2. Install the required R packages:

```r
source("scripts/setup.R")
```

3. Use `renv` for package reproducibility:

```r
renv::init()
renv::snapshot()
```

4. Keep all raw datasets in `data/raw/` and all derived datasets in `data/processed/`.
5. Write scripts and notebooks that can be rerun from the project root.

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
