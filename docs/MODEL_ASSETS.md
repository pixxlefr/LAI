# Model Assets

This repository does not ship the LAI model weights by default.

## Why

- the model files are large
- redistribution rights may differ from the source code license
- contributors should be able to work on the app without cloning large binaries

## Expected local assets

The iOS native bridge expects these files to be available locally:

- `lai_v3_mobile.ptl`
- `tokenizer_spm.model`
- `tokenizer_spm.json`

## Recommended practice

- keep model assets out of git
- document where maintainers can obtain them privately
- avoid committing generated or proprietary binaries to pull requests

## Future improvement

A contributor-friendly asset bootstrap flow would be a great addition to this repository.

