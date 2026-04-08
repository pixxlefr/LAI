# Model Assets

This repository ships the current LAI mobile test assets via Git LFS.

## Why

- the model files are large
- contributors should be able to reproduce the same baseline test setup as maintainers
- Git LFS keeps large binaries manageable inside the GitHub workflow

## Included assets

The iOS native bridge expects these files, and they are now versioned in the repository:

- `lai_v3_mobile.ptl`
- `tokenizer_spm.model`
- `tokenizer_spm.json`

## Contributor setup

Install Git LFS before cloning, or run the following after cloning:

```bash
git lfs install
git lfs pull
```

The expected location is:

- `ios/App/App/Resources/`

## Recommended practice

- keep the committed test assets reproducible and stable
- use Git LFS for large future LAI model revisions
- avoid adding unrelated generated binaries to pull requests

## Attribution

When redistributing substantial parts of the repository, preserve the project attribution:

- `Pixxle SAS - LAI Project`
