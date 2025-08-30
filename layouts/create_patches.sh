#!/usr/bin/env bash

version="v1.20.0"
repo="hugo-sid/hugo-blog-awesome"
file_dir="layouts"
files=(
  "_default/rss.xml"
  "_default/single.html"
  "partials/helpers/katex.html"
  "partials/meta/post.html"
)

for file in "${files[@]}"; do
  filename=$(basename "$file_dir/$file")
  dirpath=$(dirname "$file")

  # Save current directory
  orig_dir=$(pwd)

  # Change to the directory where the local file lives
  cd "$dirpath" || { echo "Directory $dirpath not found"; exit 1; }

  # Get last commit date from GitHub API (ISO 8601 format)
  commit_date=$(curl -s "https://api.github.com/repos/${repo}/commits?path=${file_dir}/${file}&sha=${version}" | jq -r '.[0].commit.author.date')
  if [ -z "$commit_date" ] || [ "$commit_date" = "null" ]; then
    echo "Failed to get commit date for $file_dir/$file"
    continue
  fi
  echo "Last commit date for $file_dir/$file: $commit_date"

  # Download original file and set file timestamp to commit date
  curl -s -o "${filename}.original" "https://raw.githubusercontent.com/${repo}/refs/tags/${version}/${file_dir}/${file}"
  touch -d "$commit_date" "${filename}.original"

  diff -u "${filename}.original" "$filename" > "$(dirname "$filename")/.$(basename "$filename").patch"
  rm "${filename}.original"

  # Return to original directory
  cd "$orig_dir" || exit 1
done
