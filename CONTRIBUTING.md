# Contributing

Thanks for considering a contribution to LAI.

## Before you start

- Read the current project status in `docs/STATUS.md`.
- Check the roadmap in `docs/ROADMAP.md`.
- Open an issue first for large changes or architectural shifts.

## Local setup

```bash
nvm use
npm ci
npm run build
```

For web-only changes:

```bash
npm start
```

For iOS work, follow `docs/SETUP.md`.

## Development guidelines

- Keep the web app buildable with `npm run build`.
- Prefer small pull requests with clear scope.
- Add or update documentation when behavior changes.
- If you touch the native iOS integration, explain how you validated it.

## Please do not commit

- model weights or tokenizer binaries
- `node_modules/`
- `www/`
- CocoaPods dependencies in `ios/App/Pods/`
- local third-party clones in `vendor/`

## Pull request checklist

- the change is described clearly
- local build still works
- docs were updated if setup or behavior changed
- large assets were not added to the repository

