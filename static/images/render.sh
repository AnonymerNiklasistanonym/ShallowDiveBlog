#!/bin/bash

# Check if svgo command is available
if ! command -v svgo &> /dev/null
then
    echo "svgo could not be found. Please install it or add it to your PATH."
    exit 1
fi

# Check if plantuml command is available
if ! command -v plantuml &> /dev/null
then
    echo "plantuml could not be found. Please install it or add it to your PATH."
else
    # Find all .puml files recursively and generate SVGs
    find . -type f -name "*.puml" | while read -r file; do
        echo "Processing $file..."
        plantuml -tsvg "$file"
        svgo "${file%.puml}.svg" -o "${file%.puml}.svg"
    done
fi

# Check if mermaid-cli command is available
if ! command -v mmdc &> /dev/null
then
    echo "mermaid-cli could not be found. Please install it or add it to your PATH."
else
    # Find all .mmd files recursively and generate SVGs
    find . -type f -name "*.mmd" | while read -r file; do
        echo "Processing $file..."
        mmdc -i "$file" -o "${file%.mmd}.svg"
        svgo "${file%.mmd}.svg" -o "${file%.mmd}.svg"
    done
fi

# Check if graphviz command is available
if ! command -v dot &> /dev/null
then
    echo "graphviz could not be found. Please install it or add it to your PATH."
else
    # Find all .mmd files recursively and generate SVGs
    find . -type f -name "*.dot" | while read -r file; do
        echo "Processing $file..."
        dot -Tsvg "$file" -o "${file%.dot}.svg"
        svgo "${file%.dot}.svg" -o "${file%.dot}.svg"
    done
fi
