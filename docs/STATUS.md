# Project Status

## Snapshot

LAI is currently an experimental repository for a local-on-device iPhone assistant built with Ionic Angular, Capacitor, and a custom PyTorch Mobile integration.

## What currently works

- web app build with `npm run build`
- chat-style Ionic Angular UI
- prompt formatting and lightweight local memory in the web layer
- Capacitor plugin contract for LAI inference
- committed iOS project skeleton with native bridge files

## What is still unstable

- end-to-end native inference on a physical iPhone
- SentencePiece packaging and reproducible setup for contributors
- native build verification after a fresh clone
- contributor-friendly asset onboarding

## Contribution priorities

- stabilize iOS setup from a clean checkout
- validate and improve the ObjC++ bridge for LibTorch Lite
- simplify SentencePiece integration
- improve developer documentation and troubleshooting

