# Project Status

## Snapshot

LAI is currently an experimental repository for a local-on-device iPhone assistant built with Ionic Angular, Capacitor, and a custom PyTorch Mobile integration.

LAI V3 is intended to be a lightweight bilingual local assistant that can converse in French and English, answer from grounded facts, and fall back to `I don't know` / `Je ne sais pas` when the required knowledge is not available.

## What currently works

- web app build with `npm run build`
- chat-style Ionic Angular UI
- prompt formatting and lightweight local memory in the web layer
- Capacitor plugin contract for LAI inference
- committed iOS project skeleton with native bridge files
- bundled mobile test model and tokenizer assets via Git LFS

## Product concept

The intended LAI architecture combines:

- a lightweight bilingual causal language model
- a local knowledge base stored in `JSONL`
- retrieval before response generation

The goal is to keep the conversational model small enough for local mobile inference while relying on structured facts to answer naturally without needing a constant internet connection.

## What is still unstable

- end-to-end native inference on a physical iPhone
- SentencePiece packaging and reproducible setup for contributors
- native build verification after a fresh clone
- contributor-friendly asset onboarding

## What is planned but not complete

- robust knowledge-base retrieval wired into the full native path
- online fallback when LAI does not know the answer
- saving useful fetched knowledge back into the local knowledge base
- richer long-term user memory and preference learning
- follow-up questioning to understand the user better over time

## Contribution priorities

- stabilize iOS setup from a clean checkout
- validate and improve the ObjC++ bridge for LibTorch Lite
- simplify SentencePiece integration
- improve developer documentation and troubleshooting
