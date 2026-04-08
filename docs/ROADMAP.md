# Roadmap

## Phase 1

- make a fresh clone buildable on the web with one command
- document the minimal iOS setup clearly
- reduce manual Xcode steps
- keep the committed LAI mobile test setup reproducible for contributors

## Phase 2

- validate native inference on a real iPhone
- improve error reporting for asset loading and plugin initialization
- add token streaming or incremental UI updates
- strengthen knowledge-base retrieval from local `JSONL` facts

## Phase 3

- introduce test coverage for prompt building and service behavior
- add optional automation around model asset installation
- explore Android support or a cleaner cross-platform native abstraction
- support a more complete bilingual grounded-answer workflow

## Phase 4

- add an online fallback path when LAI answers `I don't know` / `Je ne sais pas`
- save curated fetched facts back into the local knowledge base
- expand user memory and preference learning
- explore follow-up questioning to better understand the user over time

## Help wanted

- iOS and CocoaPods/Xcode specialists
- PyTorch Mobile and model packaging contributors
- people comfortable with SentencePiece and C++ bridge code
- Ionic/Angular contributors for UX polish and maintainability
- contributors interested in local retrieval, memory, and grounded mobile assistants
