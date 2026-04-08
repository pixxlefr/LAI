# LAI

LAI is an experimental Ionic Angular + Capacitor application that aims to run a custom LAI language model locally on iPhone.

Light Artificial Intelligence (LAI) allows it to operate locally from an iPhone with a new operating architecture designed to consume less RAM, with the aim of making it work locally on mobile devices such as smartphones, smart glasses, smart necklaces, and more.

## Philosophy

LAI is built around a simple direction: bring useful artificial intelligence closer to the user by making local execution possible on lightweight personal devices.

The long-term goal of the project is to explore an operating architecture that can run efficiently with lower RAM usage while remaining practical for mobile-first hardware. The iPhone is the current target, but the vision extends to other compact devices including smartphones, smart glasses, smart necklaces, and similar form factors.

This repository is part of that effort: a practical experimentation ground for local inference, lightweight mobile integration, and a chat-based user experience around the LAI model.

The repository currently focuses on three things:

- a simple chat UI built with Ionic Angular
- prompt building and lightweight local memory on the web side
- an iOS native bridge for PyTorch Mobile and SentencePiece

## Current status

- The web app builds successfully with `npm run build`.
- The iOS project is present in the repository and can be opened in Xcode.
- The native LAI integration is still experimental and has not yet been fully validated end-to-end on a real device.
- The current mobile test model and tokenizer are included in the repository via Git LFS so contributors can reproduce the same baseline setup.

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
- the current LAI mobile test model in `ios/App/App/Resources/`
- setup and status documentation in `docs/`

## What is not included

- a one-click model download pipeline
- validated Android support
- full automated tests for the native stack

## Quick start

Use Node 20 or Node 22.

Install Git LFS once on your machine, then make sure the model artifacts are pulled after cloning.

```bash
cd <repo-root>
git lfs install
git lfs pull
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
- packaging strategy for distributing future LAI model revisions
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

The current LAI mobile test artifacts are included in this repository via Git LFS to help contributors reproduce the same test setup. Please preserve the repository attribution and license notices when redistributing substantial parts of this project.
