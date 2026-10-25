# Data folder

```text
data/
├── raw/          original files, never edited by hand (committed to Git)
├── processed/    cleaned files, rebuilt by scripts (NOT committed)
│   └── workshop-01/
└── metadata/     codebooks and data dictionaries (committed)
    └── workshop-01/
```

Each workshop gets its own subfolder inside `processed/` and `metadata/`.

**VI Rule:** nothing in `raw/` is ever changed. If something needs fixing, the fix is written as code in a cleaning script, so anyone can see and repeat it.

## Datasets

### `raw/global_development_intro.csv` (Workshop 1)

| Item | Value |
|---|---|
| Original file name | `Global_Development_Intro_1.csv` |
| Source | World Bank World Development Indicators (WDI) download, last updated 2026-07-13 |
| Rows | 399 = 19 countries × 21 years (2000–2020) |
| Columns | 16 |
| Unit of analysis | one country in one year (a **country-year**) |
| Structure | balanced panel: every country has all 21 years |
| SHA-256 | `fe028163abe1b0ded8e2e143574094779b93abf6eb18d9bce58f3dc832312829` |

Metadata:

- `metadata/workshop-01/global_development_codebook.pdf`: the official codebook (covers 9 of the 16 columns).
- `metadata/workshop-01/global_development_dictionary.csv`: a full dictionary of all 16 columns, with measurement scale and every cleaning decision.

### Known differences between the codebook and the CSV

1. The codebook calls the ISO code `country_code`; the CSV calls it `iso3c`. The cleaning script renames it to `country_code`.
2. Seven CSV columns are not in the codebook: `status`, `lastupdated`, `capital`, `longitude`, `latitude`, `income`, `lending`. They come from the World Bank API download. They are documented in the dictionary instead.
3. `status` is completely empty and is dropped.
4. `income` is today's World Bank income group, repeated for every year. It is **not** the group the country was in during year 2000.

### Important limitation (links to Lecture 1, "Sampling frame")

The 19 countries were **chosen**, not randomly sampled. Results describe these 19 countries only. They are not an estimate for "the world".
