#!/usr/bin/env bash

set -e

# Array of C source files
SRC_FILES=(
  "demo.c"
  "null_termination.c"
  "pointer.c"
  "arrays.c"
  "unicode.c"
)

for SRC in "${SRC_FILES[@]}"; do
  # Strip extension and use as output binary name
  OUT="${SRC%.*}"
  LOG="${OUT}.log"

  echo "Compiling $SRC to $OUT..."
  gcc "$SRC" -o "$OUT"

  echo "Running $OUT... (output saved to $LOG)"
  ./"$OUT" > "$LOG" 2>&1
  rm "$OUT"

  echo "Done with $SRC. See $LOG for output."
  echo "------------------------------"
done
