# LAI

LAI is an experimental Ionic Angular + Capacitor application that aims to run a custom LAI language model locally on iPhone.

The repository currently focuses on three things:

- a simple chat UI built with Ionic Angular
- prompt building and lightweight local memory on the web side
- an iOS native bridge for PyTorch Mobile and SentencePiece

## Current status

- The web app builds successfully with `npm run build`.
- The iOS project is present in the repository and can be opened in Xcode.
- The native LAI integration is still experimental and has not yet been fully validated end-to-end on a real device.
- Model weights are intentionally not bundled in this repository.

This project is now being opened to the community to improve the iOS integration, developer experience, and packaging story.

## Attribution

Please preserve the copyright notice and MIT license text when redistributing or integrating substantial parts of this project.

Preferred attribution:

- `Pixxle SAS - LAI Project`

## What is included

- Ionic Angular app scaffold in `src/`
- sample chat interface
- prompt builder and small sample knowledge base
- Capacitor plugin contract in `src/app/services/lai.plugin.ts`
- iOS native integration code in `ios/App/App/`
- setup and status documentation in `docs/`

## What is not included

- proprietary or large LAI model assets
- a one-click model download pipeline
- validated Android support
- full automated tests for the native stack

## Quick start

Use Node 20 or Node 22.

```bash
cd <repo-root>
nvm use
npm ci
npm run build
```

For local web development:

```bash
cd <repo-root>
npm start
```

## iOS setup

See:

- [docs/SETUP.md](docs/SETUP.md)
- [docs/MODEL_ASSETS.md](docs/MODEL_ASSETS.md)
- [docs/STATUS.md](docs/STATUS.md)

## Repository layout

- `src/`: Ionic Angular application
- `ios/`: Capacitor iOS project and native bridge code
- `native/`: backup/reference native files for manual regeneration
- `docs/`: contributor-facing documentation

## Help wanted

The highest-impact contribution areas right now are:

- end-to-end iPhone validation for the native inference path
- cleanup and stabilization of the SentencePiece integration
- packaging of model assets without committing large binaries
- streaming generation UX and better error handling
- tests and CI around the current web app behavior

See the roadmap:

- [docs/ROADMAP.md](docs/ROADMAP.md)

## Contributing

Please read:

- [CONTRIBUTING.md](CONTRIBUTING.md)
- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)
- [SECURITY.md](SECURITY.md)
- [docs/PUBLISHING.md](docs/PUBLISHING.md)

## License

The source code in this repository is released under the MIT license.

Pretrained model weights, tokenizer binaries, and other large assets are not bundled by default and are not automatically covered by this repository license unless explicitly stated.
