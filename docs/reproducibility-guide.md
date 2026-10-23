# Reproducibility guide

This project is meant to be run from the repository root. Follow these principles to keep the analysis reproducible:

## 1. Open the project as an RStudio project

Use the `.Rproj` file in the repository root when working in RStudio. This keeps relative paths stable and ensures a common working directory.

## 2. Use `renv`

Before running workshop code, initialize and restore package versions:

```r
renv::init()
renv::restore()
```

To record package versions after installing new packages:

```r
renv::snapshot()
```

## 3. Maintain strict data hygiene

- Always keep raw data in `data/raw/`
- Store processed data in `data/processed/`
- Use scripts to transform raw data into clean versions
- Do not overwrite raw files manually
- Document all cleaning decisions in markdown or comments

## 4. Use a consistent folder structure

Keep code organized by workflow and workshop:

- `scripts/` for shared utilities and setup files
- `workshops/` for workshop-specific materials
- `outputs/` for generated figures, tables, and reports
- `docs/` for course notes and methodological explanations

## 5. Make analysis rerunnable

Use script files or R Markdown documents that assume all required data are in the repository structure. Prefer relative paths such as:

```r
read_csv("data/raw/country_year_data.csv")
```

instead of absolute paths.

## 6. Write reproducible documentation

Each workshop should include:

- purpose and learning goals
- dataset description
- installation steps
- exercise prompts
- outputs and expected results
- interpretation notes

## 7. Keep outputs generated from code

Figures and tables should be produced by scripts or notebooks, not manually crafted. This ensures they can be regenerated with one command.

## 8. Use version control

Commit changes to scripts, data metadata, and documentation regularly. Use clear commit messages describing changes to workshop material or datasets.

## Example workflow

```r
source("scripts/setup.R")
readr::read_csv("data/raw/example_data.csv")
```

The goal is that anyone with the repository and package environment can rerun the workshop analysis from scratch.
