# iOS Setup

This document describes the current iOS setup for contributors.

## Prerequisites

- Node 20 or Node 22
- Xcode and Xcode Command Line Tools
- CocoaPods
- CMake for the local SentencePiece build

## 1. Install web dependencies

```bash
cd <repo-root>
nvm use
npm ci
npm run build
```

## 2. Sync Capacitor

The repository already contains the iOS project under `ios/`.

If you changed the web app:

```bash
npx cap sync ios
```

If you ever regenerate the iOS platform from scratch, use the native files in `native/ios/` as a reference backup.

## 3. Install CocoaPods dependencies

```bash
cd ios/App
pod install
```

Then always open:

```bash
open App.xcworkspace
```

## 4. Register the plugin

The repository already contains `ios/App/App/Plugins.swift` and the plugin registration call.

If you regenerate the iOS project manually, make sure `LaiModelPlugin` is registered there.

## 5. Provide model assets locally

The repository now includes these files via Git LFS:

- `lai_v3_mobile.ptl`
- `tokenizer_spm.model`
- `tokenizer_spm.json`

After cloning, run:

```bash
git lfs install
git lfs pull
```

See `docs/MODEL_ASSETS.md` for the repository policy around large binaries.

## 6. LibTorch Lite

`ios/App/Podfile` already includes:

```ruby
pod 'LibTorch-Lite', '~> 2.0'
```

No additional manual import is needed from Swift. The repository uses Objective-C++ wrappers around LibTorch headers.

## 7. SentencePiece

The project currently relies on a local SentencePiece static library and header.

### Build SentencePiece for iPhone device

```bash
cd <repo-root>
mkdir -p vendor
cd vendor
git clone https://github.com/google/sentencepiece.git
cd sentencepiece

cmake -S . -B build-ios -G Xcode \
  -DCMAKE_TOOLCHAIN_FILE=cmake/ios.toolchain.cmake \
  -DPLATFORM=OS64 \
  -DDEPLOYMENT_TARGET=13.0 \
  -DBUILD_SHARED_LIBS=OFF \
  -DSPM_ENABLE_SHARED=OFF \
  -DSPM_BUILD_TEST=OFF

cmake --build build-ios --config Release
find build-ios -name "libsentencepiece.a"
```

### Add SentencePiece to Xcode

1. Add `libsentencepiece.a` to `Link Binary With Libraries`.
2. Add `sentencepiece_processor.h` to the `App` target.
3. If Xcode cannot find the header, add this path in `Header Search Paths`:

```text
$(PROJECT_DIR)/../../vendor/sentencepiece/src
```

The current bridge file is `ios/App/App/SentencePieceWrapper.mm`.

## 8. Bridging Header

The repository already includes:

- `ios/App/App/App-Bridging-Header.h`

It should contain:

```objc
#import "SentencePieceWrapper.h"
#import "TorchModule.h"
#import "TorchTensor.h"
```

In Xcode Build Settings, make sure `Objective-C Bridging Header` points to:

```text
App/App-Bridging-Header.h
```

## 9. Current caveats

- the native iOS path is still experimental
- the current mobile test assets are bundled via Git LFS
- fresh-clone iOS validation still needs more community testing
