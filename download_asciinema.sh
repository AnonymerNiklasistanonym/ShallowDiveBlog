#!/usr/bin/env bash
set -e

# Uncomment to see executed commands
#set -x

ASCIINEMA_VERSION="3.10.0"
ZIP_URL="https://github.com/asciinema/asciinema-player/releases/download/v$ASCIINEMA_VERSION/asciinema-player.css"
JS_URL="https://github.com/asciinema/asciinema-player/releases/download/v$ASCIINEMA_VERSION/asciinema-player.min.js"

# Target directories
CSS_DIR="assets/css/asciinema"
JS_DIR="assets/js/asciinema"
CWD=$(pwd)

rm -f "$CSS_DIR/asciinema-player.css" "$JS_DIR/asciinema-player.min.js"

# Exit here if you want only cleanup
#exit 1

mkdir -p "$CSS_DIR" "$JS_DIR"

TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"
curl -LO "$ZIP_URL"
curl -LO "$JS_URL"

# Copy files
cp asciinema-player.css "$CWD/$CSS_DIR/"
cp asciinema-player.min.js "$CWD/$JS_DIR/"

# Clean up
cd -
rm -rf "$TMP_DIR"
