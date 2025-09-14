#!/usr/bin/env bash
set -e

# Uncomment to see executed commands
#set -x

KATEX_VERSION="0.16.22"
ZIP_URL="https://github.com/KaTeX/KaTeX/releases/download/v$KATEX_VERSION/katex.zip"

# Target directories
CSS_DIR="static/css/katex"
JS_DIR="assets/js/katex"
FONTS_DIR="$CSS_DIR/fonts"
CWD=$(pwd)

rm -rf "$FONTS_DIR"
rm -f "$CSS_DIR/katex.min.css" "$JS_DIR/auto-render.min.js" "$JS_DIR/katex.min.js"

# Exit to delete all katex files
#exit 1

mkdir -p "$CSS_DIR" "$JS_DIR" "$FONTS_DIR"

TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"
curl -LO "$ZIP_URL"
unzip katex.zip

# Copy files
cp katex/katex.min.css "$CWD/$CSS_DIR/"
cp katex/katex.min.js "$CWD/$JS_DIR/"
cp katex/contrib/auto-render.min.js "$CWD/$JS_DIR/"
cp -r katex/fonts/* "$CWD/$FONTS_DIR/"

# Clean up
cd -
rm -rf "$TMP_DIR"
