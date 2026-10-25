# Reproducibility guide

This project is meant to be run from the repository root. Follow these principles to keep the analysis reproducible:

## 1. Open the project as an RStudio project

Use the `.Rproj` file in the repository root when working in RStudio. This keeps relative paths stable and ensures a common working directory.

## 2. Use `renv`

`renv` records the exact package versions in a file called `renv.lock`.

- The **instructor**, once, after the packages work: `renv::init()` then `renv::snapshot()`, and commits `renv.lock`.
- A **student** with a fresh copy that already contains `renv.lock`: `renv::restore()` (do **not** run `renv::init()` first).

To record package versions after installing new packages:

```r
renv::snapshot()
```

## 3. Maintain strict data hygiene

- Always keep raw data in `data/raw/`
- Store processed data in `data/processed/workshop-0X/`
- Use scripts to transform raw data into clean versions
- Do not overwrite raw files manually
- Document all cleaning decisions in markdown or comments

## 4. Use a consistent folder structure

Keep code organized by workflow and workshop:

- `scripts/` for shared utilities and setup files
- `workshops/` for workshop-specific materials
- `outputs/` for generated figures, tables, and reports
- `docs/` for course notes and methodological explanations

## 5. Make analysis re-runnable

Use scripts or Quarto documents that assume all required data are in the repository structure. Build paths with `here()`, which always starts from the folder containing the `.Rproj` file:

```r
read_csv(here::here("data", "raw", "global_development_intro.csv"))
```

Never use absolute paths such as `C:/Users/...`. Plain relative paths such as `"data/raw/..."` also break inside Quarto, because Quarto runs each `.qmd` from that file's own folder.

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
source("workshops/workshop-01/01_clean_data.R")
```

The goal is that anyone with the repository and package environment can rerun the workshop analysis from scratch.
