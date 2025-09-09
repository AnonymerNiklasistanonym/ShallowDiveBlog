#!/usr/bin/env bash
set -e

rm -rf venv_python
python -m venv venv_python
source venv_python/bin/activate
pip install git-big-picture

rm -rf git-demo
mkdir git-demo
cd git-demo
git init -b main
echo "Initial file" > file.txt
git add file.txt
git commit -m "Initial commit on main"
git checkout -b feature
echo "Feature work" > feature.txt
git add feature.txt
git commit -m "Add feature work"
git checkout main
echo "More work on main" >> file.txt
git add file.txt
git commit -m "Update file.txt on main"
git merge feature --no-ff -m "Merge feature branch into main"

cd ..
git-big-picture --all --commit-messages --branches -f svg -o our-project.svg git-demo
git-big-picture --help
