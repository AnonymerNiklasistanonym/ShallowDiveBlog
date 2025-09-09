#!/usr/bin/env bash
set -e

# Clean up any old test repo
rm -rf mailmap-demo
mkdir mailmap-demo && cd mailmap-demo
git init

# Create a file to commit
echo "hello" > file.txt
git add file.txt

# Commit 1: main identity
GIT_AUTHOR_NAME="John Doe" \
GIT_AUTHOR_EMAIL="john.doe@example.com" \
GIT_COMMITTER_NAME="John Doe" \
GIT_COMMITTER_EMAIL="john.doe@example.com" \
git commit -m "Initial commit"

# Commit 2: same name, different email
echo "line 2" >> file.txt
git add file.txt
GIT_AUTHOR_NAME="John Doe" \
GIT_AUTHOR_EMAIL="jdoe123@oldmail.com" \
GIT_COMMITTER_NAME="John Doe" \
GIT_COMMITTER_EMAIL="jdoe123@oldmail.com" \
git commit -m "Commit with different email"

# Commit 3: different name + different email
echo "line 3" >> file.txt
git add file.txt
GIT_AUTHOR_NAME="Jane Smith" \
GIT_AUTHOR_EMAIL="jsmith@anothermail.com" \
GIT_COMMITTER_NAME="Jane Smith" \
GIT_COMMITTER_EMAIL="jsmith@anothermail.com" \
git commit -m "Commit with different name and email"

# Commit 4: different name only
echo "line 4" >> file.txt
git add file.txt
GIT_AUTHOR_NAME="Jonathon D." \
GIT_AUTHOR_EMAIL="john.doe@example.com" \
GIT_COMMITTER_NAME="Jonathon D." \
GIT_COMMITTER_EMAIL="john.doe@example.com" \
git commit -m "Commit with different name only"

# Show authors without mailmap
echo "=== WITHOUT .mailmap ==="
git log

# Create .mailmap
cat > .mailmap <<EOF
# Same name, different email
John Doe <john.doe@example.com> <jdoe123@oldmail.com>

# Different name + different email
John Doe <john.doe@example.com> Jane Smith <jsmith@anothermail.com>

# Different name only
John Doe <john.doe@example.com> Jonathon D.
EOF

# Show authors with mailmap
echo ""
echo "=== WITH .mailmap ==="
git log
