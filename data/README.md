# Data folder

This folder stores the project datasets and associated metadata.

## Structure

```text
data/
├── README.md
├── raw/
├── processed/
└── metadata/
```

## Raw data

Place original datasets in `data/raw/` without modifying them.

## Processed data

Save cleaned, reshaped, merged, and derived datasets in `data/processed/`.

## Metadata

Add dataset dictionaries, variable descriptions, and source notes in `data/metadata/`.

## Recommended principles

- preserve raw files as provided by source
- write reproducible cleaning scripts
- add a data dictionary for each dataset
- keep variable naming consistent across workshops
