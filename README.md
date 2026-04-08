# LAI

LAI is an experimental Ionic Angular + Capacitor application that aims to run a custom LAI language model locally on iPhone.

Light Artificial Intelligence (LAI) allows it to operate locally from an iPhone with a new operating architecture designed to consume less RAM, with the aim of making it work locally on mobile devices such as smartphones, smart glasses, smart necklaces, and more.

## Philosophy

LAI is built around a simple direction: bring useful artificial intelligence closer to the user by making local execution possible on lightweight personal devices.

The long-term goal of the project is to explore an operating architecture that can run efficiently with lower RAM usage while remaining practical for mobile-first hardware. The iPhone is the current target, but the vision extends to other compact devices including smartphones, smart glasses, smart necklaces, and similar form factors.

This repository is part of that effort: a practical experimentation ground for local inference, lightweight mobile integration, and a chat-based user experience around the LAI model.

## LAI Concept

LAI V3 is a lightweight bilingual causal language model developed by the Pixxle / LAI team for local inference.

The intended product target is an offline mobile assistant that can:

- handle short conversations in French and English
- answer grounded factual questions from injected facts
- prefer `I don't know` or `Je ne sais pas` when the relevant facts are not available

The core idea behind LAI is not to push all intelligence into a very large model running entirely from raw parameters. Instead, the project aims to combine:

- a lightweight conversational model for natural French and English dialogue
- a structured local knowledge base stored in `JSONL`
- local retrieval so the assistant can look up relevant facts before answering

This design is intended to reduce RAM pressure on mobile devices while still allowing useful, natural, and context-aware responses.

## Intended Operating Architecture

The planned LAI behavior is:

1. the user asks a question in French or English
2. LAI searches its local knowledge base
3. LAI answers naturally from the retrieved facts
4. if the information is missing, LAI should prefer `I don't know` or `Je ne sais pas`

The longer-term product concept goes further:

- when LAI does not know the answer, it should be able to search online, retrieve the missing information, answer the user, and then save useful facts back into its knowledge base
- LAI should progressively learn about its user over time, remember useful preferences or personal context, and sometimes ask follow-up questions to better understand the user

In other words, the model is meant to be both:

- a natural bilingual conversation layer
- a local knowledge-grounded assistant that becomes more useful over time

Some parts of that product vision are already reflected in the repository structure, but the full end-to-end behavior is not yet implemented.

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
- early groundwork for a knowledge-grounded local assistant architecture
- Capacitor plugin contract in `src/app/services/lai.plugin.ts`
- iOS native integration code in `ios/App/App/`
- the current LAI mobile test model in `ios/App/App/Resources/`
- setup and status documentation in `docs/`

## What is not included

- a one-click model download pipeline
- validated Android support
- full automated tests for the native stack
- the full planned online fallback and long-term user-learning loop

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
