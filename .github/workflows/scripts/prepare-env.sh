#!/bin/bash

FLUTTER_LOCATION=$(command -v flutter)
FLUTTER_ROOT=${FLUTTER_LOCATION:0:-12}

echo "$HOME/.pub-cache/bin" >> "$GITHUB_PATH"
echo "$FLUTTER_ROOT/.pub-cache/bin" >> "$GITHUB_PATH"
echo "$FLUTTER_ROOT/bin/cache/dart-sdk/bin" >> "$GITHUB_PATH"
