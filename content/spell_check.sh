#!/usr/bin/env bash

ASPELL=${ASPELL:-aspell}
ASPELL_ARGS_LANG_EN="--lang=en --master=en_US"
ASPELL_ARGS_LANG_DE="--lang=de --master=de_DE"

ASPELL_COMMON_ARGS=(--mode=markdown --encoding=utf-8 --add-html-skip)

declare -A DIR_LANGS=(
  [en]="$ASPELL_ARGS_LANG_EN"
  [de]="$ASPELL_ARGS_LANG_DE"
)

for dir in "${!DIR_LANGS[@]}"; do
  echo "===== Checking directory: $dir ====="

  # Each language gets its own spelling dir
  lang_spelling_dir="$dir/.spelling"
  mkdir -p "$lang_spelling_dir"

  # Recursively check all Markdown files
  find "$dir" -type f -name '*.md' -exec bash -c '
    file="$0"
    echo "→ Check: $file"
    '"$ASPELL"' '"${ASPELL_COMMON_ARGS[*]}"' '"${DIR_LANGS[$dir]}"' --home-dir="'"$lang_spelling_dir"'" check "$file"
  ' {} \;

done
