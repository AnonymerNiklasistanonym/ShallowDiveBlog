---
title: Git
summary: A shallow dive into how Git works and how to use it
date: 2025-09-09
lastmod: 2025-09-09
draft: false
tags:
  - Git
  - Version Control
  - VCS
categories:
  - Software
  - Informatics
---

A lot of the following information is derived from the [*Pro Git Book* by Scott Chacon and Ben Straub](https://git-scm.com/book/en/).

## The idea behind Git/version control

With a VCS (Version Control System) you can keep track of changes over time which for example allows you to revert a file back to a previous state (e.g. using a database that stores the files history).
With CVCSs (Centralized VCS), meaning a centralized server hosting such a database, collaboration is possible.
This however makes this server a massive risk for downtime, data loss, etc.

By making the database distributed in DVCSs (Distributed VCS) the issue with a single point of failure can be mitigated by switching to a workflow where every clone is a full backup.
Now users can make locally any change they want to do and then synchronize all of the changes at once with the centralized server.
This gives a DVCS like Git huge advantages over a CVCS:

- If the centralized server dies/corrupts there are lots of backups
- Multiple servers can exist (e.g. one main server and then one for a small team that is only synchronized from time to time)
- If there is no internet users can still make changes and it's much faster since only the synchronization step requires waiting for the server

There are some disadvantages of being distributed though like:

- A higher complexity:
  - Collaboration requires more effort by the users to synchronize their changes often and solve conflicts
- A large storage for the database (backup can get big over time)
  - Users must be mindful what files they upload since for example binary files (images, videos) require a lot of space

### Location

Git stores all the *database* information in a hidden Git directory called `.git`:

```sh
# Enable Git Version Control in the current directory:
git init
# Initialized empty Git repository in .../.git/
```

The current directory is now version controlled by Git and called a **repository**.

## Basics

### Snapshots/Commits

Instead of tracking file changes (also called delta-based changes) Git stores snapshots of the whole repository.
These snapshots are called **commit**s.
Every commit (with all its files, author, title) is checksummed (currently per default with SHA-1) and contains the checksum of the previous (**parent**) commit so that its impossible to change the history without Git noticing it.

### Staging

If you want to add a new commit with file changes there are 3 states you need to know:

![Git staging states and their relationships](../../images/git/git_states.svg)

1. Working Directory [WIP] (sometimes also called *Working Tree*):

   - The current file state on your PC: **Untracked (new), Modified (previously added), Ignored (see .gitignore) files**
   - Edit your files however you want

   For example add a text file with the content `hello world`:

   ```sh
   echo "hello world" > hello_world.txt
   ```

   - To see what *untracked/modified files* have changes compared to the parent commit (or files in the *Staging Area*) use the following command:

     ```sh
     git status
     # ...
     #
     # Untracked files:
     #   (use "git add <file>..." to include in what will be committed)
     #         hello_world.txt
     #
     # nothing added to commit but untracked files present (use "git add" to track)
     ```

     To see the content that was changed compared to the *Staging Area* you can use the following command:

     ```sh
     git diff
     # ...
     # +++ b/hello_world.txt
     # ...
     # +hello world
     ```

2. Staging Area/`index` [Buffer/Cache for next commit]:

   - Contains manually added file changes that should be part of the next commit: **Staged files**
   - To stage a file (*add it to the Staging Area*) use the following command:

     ```sh
     git add hello_world.txt
     git status
     # ...
     #
     # Changes to be committed:
     #   (use "git rm --cached <file>..." to unstage)
     #         new file:   hello_world.txt
     ```

     As noted with `rm --cached` instead of `add` the file can be unstaged (*removed from the Staging Area*).

     To see the content that was changed and staged compared to the parent commit you can use the following command:

     ```sh
     echo "bye world" >> hello_world.txt
     git add hello_world.txt
     git diff --staged
     # diff --git a/hello_world.txt b/hello_world.txt
     # index 3b18e51..6e4156a 100644
     # --- a/hello_world.txt
     # +++ b/hello_world.txt
     # @@ -1 +1,2 @@
     # hello world
     # +bye world
     ```

3. Repository

   - "The database" that contains all commits
   - To create a commit that contains all staged file changes run the following command:

     ```sh
     git commit -m "Commit Message"
     # [... e6ef28a] Commit Message
     #  1 file changed, 1 insertion(+)
     #  create mode 100644 hello_world.txt
     ```

     This signs the commit with a user name and email that can be set using the following commands:

     ```sh
     git config user.name "Your Name"
     git config user.email "your.email@example.com"
     ```

   - To see the whole commit history run the following command:

     ```sh
     git log
     # commit e6ef28ac7902f7019c1bd47415d0cbf2afc12aba (HEAD -> master)
     # Author: Your Name <your.email@example.com>
     # Date:   Tue Sep 9 15:36:36 2025 +0200
     #
     #     Commit Message
     ```

     Adding the option `--stat` adds what files were changed at the bottom and `-p` adds additionally the content that was changed:

     ```sh
     git log -p
     # commit e6ef28ac7902f7019c1bd47415d0cbf2afc12aba (HEAD -> master)
     # Author: Your Name <your.email@example.com>
     # Date:   Tue Sep 9 15:36:36 2025 +0200
     #
     #     Commit Message
     #
     # diff --git a/hello_world.txt b/hello_world.txt
     # new file mode 100644
     # index 0000000..3b18e51
     # --- /dev/null
     # +++ b/hello_world.txt
     # @@ -0,0 +1 @@
     # +hello world
     ```

   - To undo a commit and put all changes back into the Staging Area you can run the following command:

     ```sh
     git reset --soft HEAD~1
     ```

     {{< note type="warning" >}}This can be problematic when the commit was already synchronized since it alters the repository history!{{< /note >}}

#### Amending

It is possible to update the last commit retroactively:

```sh
# Add current staged files and change the commit message
git commit --amend
```

```sh
# Change the author of the last commit
git commit --amend --author="Author Name <email@address.com>"
```

{{< note type="warning" >}}This can be problematic when the commit was already synchronized since it alters the repository history!{{< /note >}}

#### `.gitignore`

With a `.gitignore` text file you can specify files that you do not want to accidentally add to a commit.
This usually means files:

- Added by a package manager (`node_modules`)
- Build artifacts (`build`, `out.exe`)
- Caches (`__pycache__`)
- Secret environment variables/keys (`.env`)

This can be done by just writing the path that should be ignored into a new line.

```gitignore
# Exclude directories
node_modules
build
out.exe
__pycache__
# Exclude files
.env
```

Some glob modifiers work for e.g. blocking all files of a specific format, with a `!` at the start an exception is also be possible to the previously specified block rules:

```gitignore
# Exclude files with regex
*.pdf
# Exception: Keep file README.pdf
!README.pdf

# Complex regex to ignore PDF files like 'exercise_blatt_01.pdf'
*_blatt_[0-9][0-9].pdf
```

#### 3rd party features

##### Multiple authors (co-authors)

One practice [used by GitHub](https://docs.github.com/en/pull-requests/committing-changes-to-your-project/creating-and-editing-commits/creating-a-commit-with-multiple-authors) is to add a newline at the end of the commit message and then list the co-authors:

```git
Title

Co-authored-by: NAME <NAME@EXAMPLE.COM>
Co-authored-by: ANOTHER-NAME <ANOTHER-NAME@EXAMPLE.COM>
```

Git itself doesn't care about this but popular platforms parse this information.

##### Reference Issues or Pull/Merge requests

To reference issues add the number leading with a `#` in the description of the commit.
To reference merge requests on GitLab add the number leading with a `!` in the description of the commit.
On GitHub everything uses the leading `#` since pull requests and issues have a shared increasing number.

```git
Title

Fix login bug (#42)
Update README with installation steps (!15) [only on GitLab]
```

### References (`ref`s)

A reference `ref` is a name that points to a commit (using it's unique hash).

#### Branch

A branch is a movable `ref` to a commit.
It represents a line of development in the repository.

Examples: `main`, `feature-add-x`

```sh
# git checkout ...
# Create & Switch to branch
git switch -c feature-add-x
# Switch
git switch feature-add-x
# Delete
git branch -d feature-add-x
```

#### Tag

A tag is a fixed `ref` to a commit.
It represents a fixed time in development in the repository.

Examples: `v1.0.0`, `v1.0.1b`

```sh
# git checkout ...
# Create
git tag v1.0.0
# Delete
git tag -d v1.0.0
```

#### Branch Visualization

```sh
# Current branch
git log --graph --decorate --oneline
# All branches
git log --graph --decorate --oneline --all
```

```git
 0be79cb (origin/post-tla-plus, post-tla-plus) WIP
| * d1da289 (origin/post-math-basics, post-math-basics) WIP
|/
| * 1c4f291 (HEAD -> post-computer-networks, origin/post-computer-networks) WIP
|/
| * d0c3ae1 (origin/post-web-components, post-web-components) WIP
|/
| * ddddd93 (origin/post-container, post-container) WIP
|/
| * 671116a (origin/post-git, post-git) WIP
|/
* c81e775 (origin/main, origin/HEAD, main) Fix indentation and mathblocks in c-strings post
* 8a07d89 Fix displayed file path for included code file
* ca34657 Use CSS variables instead of multiple sections and magic numbers
* 69558ba Update custom shortcodes with error messages
* 4fbf9a4 Add a custom note and extend the demo page with all integrated features
* e79b7d8 Add support for (aligned) math blocks
* cb61b19 Add simple readmore shortcut to reference other articles
```

### Remotes

#### Push/Delete branches/tags from remote

#### `.gitattributes`

### Merging

#### Merge/Pull Requests

### Rebasing

### Stashing

Instead of creating a new branch it's also possible to push the current staged **and modified** files to *the stash*:

![Git staging states and their relationships extended with a stash](../../images/git/git_states_with_stash.svg)

```sh
git stash push -m "message"
# It's possible to only stash staged files by adding '--staged'
git stash push -m "message (only staged)" --staged
```

All stashes are stored in a stack that can be inspected with the following commands:

```sh
# See all stashes
git stash list
# See a specific change (use -p to see the content changes)
# [stash@{n}] can be removed if the latest stash should be used
git stash show [stash@{n}] -p
```

Then at a later time it is possible to get the staged files back to the staging area:

```sh
git stash apply [stash@{n}]
# This does not remove it from the stash stack, but the following command does
git stash pop [stash@{n}]
```

The stash can also be deleted:

```sh
git stash drop [stash@{n}]
# Delete all stashes
git stash clear
```

{{< note >}}
Internally all stashes are stored as commits on a *branch* called `refs/stash`.

Running `git stash push -m "message"` can create up to 3 separate commits because it stores the following 3 states:

1. WIP commit (can be disabled when `--staged` is used): The modified tracked files (*Working Directory*)
2. Index commit: The staged changes (*Staging Area*)
3. Untracked commit (optional, only created when `--include-untracked` is used): Ignored changes

```sh
touch hi
touch hello
git add hello
echo "change" >> README.md
git stash --include-untracked
# Creates 3 commits since i have an untracked file, a modified tracked file
# and a staged file
git log -g stash
# commit c0ea738d5db52f7bfc806c60e97b37c2ba21dc2c (refs/stash)
# Reflog: stash@{0} (User <email@gmail.com>)
# Reflog message: WIP on post-git: 58d6534 WIP
# Merge: 58d6534 8b53fcb b58cba5
# Author: User <email@gmail.com>
# Date:   Wed Sep 10 15:32:03 2025 +0200
#
#     WIP on post-git: 58d6534 WIP
```

Meaning Git stored on top of the stash stack `stash@{0}` represented by the *branch* `refs/stash` the staged changes.
Additionally reading the line `Merge: 58d6534 8b53fcb b58cba5` it stored that I was on `58d6534` (the current commit) when I stashed.
And inspecting the other 2 commits it also stored the `index` in `8b53fcb` and the `untracked files` in `b58cba5` (but only because I used `--include-untracked`).

  ```sh
  # commit c0ea738d5db52f7bfc806c60e97b37c2ba21dc2c (refs/stash)
  # Merge: 58d6534 8b53fcb b58cba5
  # ...
  #     WIP on post-git: 58d6534 WIP
  #
  #  content/en/posts/git.md | 2 +-
  #  static/code/git/hello   | 0
  git show --stat 58d6534
  # commit 58d6534bf83cec802d61a3b147ab9e3c9f467463 (HEAD -> post-git, origin/post-git)
  # ...
  #     WIP
  git show --stat 8b53fcb
  # commit 8b53fcbe6c0b2903dc1034d2593da62c3ef0e381
  # ...
  #     index on post-git: 58d6534 WIP
  #
  #  static/code/git/hello | 0
  #  1 file changed, 0 insertions(+), 0 deletions(-)
  git show --stat b58cba5
  # commit b58cba5f1d18583a4b6803a96350d28cef91d8c8
  # ...
  #     untracked files on post-git: 58d6534 WIP
  #
  #  static/code/git/hi | 0
  #  1 file changed, 0 insertions(+), 0 deletions(-)
  ```

{{< /note >}}

### Cherry Picking

Instead of merging a whole branch it is possible to cherry pick one or more commits and directly apply these patches to the current branch:

```sh
# Apply a specific commit from another branch
git cherry-pick abc123
```

This should only be done for like backporting/security patches or other edge cases since it copies the original commit, alters it and thus results in duplication and a loss of a clear history.

## Other

### Remote Interaction via SSH

SSH (and HTTPS) are secure cryptographic network protocols that encrypt communication between two computers (the local computer and the (`git`) server in this case).
SSH (Secure Shell) is a public-key cryptography protocol that ensures no one can alter or spy on the data during the transfer.

**How does the public-key cryptography work?**

You generate a key pair on your computer:

- **Private key** (Key): stays on your computer (secret)
  - Can decrypt encrypted messages
- **Public key** (Lock): share with another computer (e.g. GitLab)
  - Can encrypt messages

When the computers (client = local machine, server = `git` server) connect:

- When the connection starts, the client sends a list of **public key** identifiers it has available for the listed user
  - `git clone git@gitl...` resolves to the user `git`
  - the server checks its authorized keys for that user
  - for each matching key, the server sends a challenge to the client to sign (the client picks the correct private key to respond to the challenge)
- The server sends a challenge (*prove client identity*)
  - e.g. it encrypts a random string of bytes with the **public key**
- The client (the SSH agent on your local machine) sends back a signature (*produce valid signature*)
  - it uses the **private key** to decrypt the encrypted message
  - it creates a digital signature (e.g. using RSA) that can only be created with:
    - the **private key**
    - the decrypted challenge
- The server verifies the signature (*check signature validity*)
  - to do that it's using the **public key**

**Advantages**:

- Authenticate securely to remote servers (like a GitLab instance)
- No user name/password required

#### Generate SSH private/public key

Generate the following files:

- `~/.ssh/hdm_gitlab_2025summer` (private key)
- `~/.ssh/hdm_gitlab_2025summer_delete.pub` (public key)

```sh
# Generate the following files
cd ~/.ssh/
ssh-keygen -t rsa -b 2048 -C "hdm_gitlab_2025summer"
# Generating public/private rsa key pair.
# Enter file in which to save the key (~/.ssh/id_rsa): hdm_gitlab_2025summer_delete
# Enter passphrase (empty for no passphrase):
# Your identification has been saved in hdm_gitlab_2025summer
# Your public key has been saved in hdm_gitlab_2025summer.pub
# The key fingerprint is:
# ...
# The key's randomart image is:
# +---[RSA 2048]----+
# |              ...|
# +----[SHA256]-----+
```

#### SSH configuration for hostname

Create a file that will use the specific private key for a specific hostname:

`~/.ssh/config`:

```text
Host gitlab.mi.hdm-stuttgart.de
  HostName gitlab.mi.hdm-stuttgart.de
  User git
  IdentityFile ~/.ssh/hdm_gitlab_2025summer
```

#### Add SSH key to `ssh-agent`

```sh
# Start the ssh-agent
ssh-agent -s
# Add your SSH private key to the ssh-agent
ssh-add ~/.ssh/hdm_gitlab_2025summer
# Identity added: ~/.ssh/hdm_gitlab_2025summer (hdm_gitlab_2025summer)
```

Remove them again:

```sh
ssh-add -d ~/.ssh/gitlab_2025
```

#### Add public key to `git` instance

1. Copy the public key:

   ```sh
   cat ~/.ssh/hdm_gitlab_2025summer.pub
   ```

2. Go to your `git` instance and upload the public key

   1. e.g. GitLab instance: `https://gitlab.mi.hdm-stuttgart.de`
   2. Navigate to: User icon → `Preferences`→ `SSH Keys`
   3. Paste the copied key into the text box
   4. Set a **title** (e.g., `2025 Summer`) and an optional expiration date
   5. Click **Add key**

#### Git repository clone

```sh
# Replace USERNAME and REPO-NAME with your actual GitLab username and project repo name.
git clone git@gitlab.mi.hdm-stuttgart.de:USERNAME/REPO-NAME.git
```

{{< note >}}
Don't forget to specify the correct git user name and password via `git config` afterwards
{{< /note >}}

### Commit Signing via GPG

GPG (GNU Privacy Guard) lets you cryptographically sign your commits and tags, proving that you really made those changes.
Others can verify your signature using your public GPG key, helping to establish a chain of trust in the project.
GPG keys are more secure than passwords and can be revoked if compromised.

While GPG can also do symmetric/asymmetric encryption, in the `git` related context it's only using a local private key to create a digital signature which can be verified with a public-key.
The commit content is sent **unencrypted** with this signature.

#### Create GPG key

{{< note >}}

Install `gpg` on Windows:

```powershell
winget install -e --id GnuPG.GnuPG
# requires terminal restart
```

{{< /note >}}

```sh
gpg --full-generate-key
# gpg (GnuPG) 2.4.7; Copyright (C) 2024 g10 Code GmbH
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.
#
# Please select what kind of key you want:
#    (1) RSA and RSA
#    (2) DSA and Elgamal
#    (3) DSA (sign only)
#    (4) RSA (sign only)
#    (9) ECC (sign and encrypt) *default*
#   (10) ECC (sign only)
#   (14) Existing key from card
# Your selection? 1
# RSA keys may be between 1024 and 4096 bits long.
# What keysize do you want? (3072) 4096
# Please specify how long the key should be valid.
#          0 = key does not expire
#       <n>  = key expires in n days
#       <n>w = key expires in n weeks
#       <n>m = key expires in n months
#       <n>y = key expires in n years
# Key is valid for? (0) 6m
# GnuPG needs to construct a user ID to identify your key.
# Real name: Your Name
# Email address: id@hdm-stuttgart.de
# Comment: hdm_gitlab_2025summer_gpg_desktop
# You selected this USER-ID:
#     "Your Name (hdm_git...) <id@hdm-stuttgart.de>"
# Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
# > Enter Passphrase
# gpg: directory '~/.gnupg/openpgp-revocs.d' created
# gpg: revocation certificate stored as '~/.gnupg/openpgp-revocs.d/....rev'
# public and secret key created and signed.
#
# pub   rsa4096 2025-05-16 [SC] [expires: 2025-11-12]
#       2E...
# uid                      Your Name (hdm_git...) <id@hdm-stuttgart.de>
# sub   rsa4096 2025-05-16 [E] [expires: 2025-11-12]
```

List all GPG keys:

```sh
gpg --list-secret-keys --keyid-format LONG
# gpg: checking the trustdb
# gpg: marginals needed: 3  completes needed: 1  trust model: pgp
# gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
# gpg: next trustdb check due at 2025-11-12
# ~/.gnupg/pubring.kbx
# -------------------------------
# sec   rsa4096/ABCDEF1234567890 2025-05-16 [SC] [expires: 2025-11-12]
#       2E...ABCDEF1234567890
# uid                 [ultimate] Your Name (hdm_git...) <id@hdm-stuttgart.de>
# ssb   rsa4096/21... 2025-05-16 [E] [expires: 2025-11-12]
```

- Where `ABCDEF1234567890` is the key ID

#### Add GPG key to `git` instance

1. Copy the public key:

   ```sh
   gpg --armor --export ABCDEF1234567890
   ```

2. Go to your `git` instance and upload the public key:

   1. e.g. GitLab instance: `https://gitlab.mi.hdm-stuttgart.de`
   2. Navigate to: User icon → `Preferences`→ `GPG Keys`
   3. Paste the copied key into the text box
   4. Click **Add key**

#### Git repository configuration

```sh
# Register key
git config user.signingkey ABCDEF1234567890
# Enable automatic commit signing
git config commit.gpgSign true
```

{{< note >}}

On Windows it might be necessary to additionally register the installed `gpg.exe` to the repository if you get the error that the private key cannot be found:

```powershell
git config gpg.program 'C:\Program Files (x86)\GnuPG\bin\gpg.exe'
```

{{< /note >}}

### `.mailmap`

Using a `.mailmap` file in the top level of the repository authors with different names/emails can be visually merged into one when looking at the logs.

For example it can happen quite often that a user like `John Doe <john.doe@example.com>`:

- Makes a commit with a different Email address: `John Doe <jdoe123@oldmail.com>`
- Makes a commit with a different name: `Jonathon D. <john.doe@example.com>`
- Makes a commit with a different Email address and name: `Jane Smith <jsmith@anothermail.com>`)

The file has the following format:

```mailmap
# Main entry first, different entry second

# Different email only
John Doe <john.doe@example.com> <jdoe123@oldmail.com>
# Different name only
John Doe <john.doe@example.com> Jonathon D.
# Different name + different email
John Doe <john.doe@example.com> Jane Smith <jsmith@anothermail.com>
```

Without `.mailmap` file:

```git
commit b0e8c9a93b585a16183cc5170ed1cfde4809e681 (HEAD -> master)
Author: Jonathon D. <john.doe@example.com>
Date:   Tue Sep 9 16:29:12 2025 +0200

    Commit with different name only

commit be350068a904976e93ac5b3eeace9b557db8329a
Author: Jane Smith <jsmith@anothermail.com>
Date:   Tue Sep 9 16:29:12 2025 +0200

    Commit with different name and email

commit 7ea97f543e9a7ba18f52ff41c23236a700f47eb7
Author: John Doe <jdoe123@oldmail.com>
Date:   Tue Sep 9 16:29:12 2025 +0200

    Commit with different email

commit d06e4dd7f89bd82d138311d24d46ba9babc9309e
Author: John Doe <john.doe@example.com>
...
```

With `.mailmap` file:

```git
commit b0e8c9a93b585a16183cc5170ed1cfde4809e681 (HEAD -> master)
Author: John Doe <john.doe@example.com>
Date:   Tue Sep 9 16:29:12 2025 +0200

    Commit with different name only

commit be350068a904976e93ac5b3eeace9b557db8329a
Author: John Doe <john.doe@example.com>
Date:   Tue Sep 9 16:29:12 2025 +0200

    Commit with different name and email

commit 7ea97f543e9a7ba18f52ff41c23236a700f47eb7
Author: John Doe <john.doe@example.com>
Date:   Tue Sep 9 16:29:12 2025 +0200

    Commit with different email

commit d06e4dd7f89bd82d138311d24d46ba9babc9309e
Author: John Doe <john.doe@example.com>
...
```

## Git Submodules

### Git Hooks

### Git LFS

## Under the hood

What is stored in the database?

***TODO:*** Maybe move that up if it makes logical sense.

### Files

**System**:

```sh
# A text file containing global configuration information
cat ~/.gitconfig
# [user]
#         name = GlobalDefaultName
#         email = global.default@email.com
```

**Local**:

```sh
ls -a .git
# .  ..  COMMIT_EDITMSG  config  description  FETCH_HEAD  HEAD
# hooks  index  info  logs  objects  ORIG_HEAD  packed-refs  refs
```

- `COMMIT_EDITMSG`:

  A text file that contains the text that should be used as commit message (when not using the `-m` command).
  In case of merges a file called `MERGE_MSG` can be created that behaves similarly.

- `config`:

  ```sh
  # A text file containing local configuration information
  cat .git/config
  # > fundamental git settings
  # > (e.g. `filemode` means it tracks the file permission bits)
  # [core]
  #         repositoryformatversion = 0
  #         filemode = true
  #         bare = false
  #         logallrefupdates = true
  # > local user name/email (overrides global config)
  # > set them using 'git config user.name "Name"'
  # [user]
  #         name = LocalName
  #         email = local@email.com
  # > defines remote repositories
  # [remote "origin"]
  #         url = git@github.com:AnonymerNiklasistanonym/ShallowDiveBlog.git
  #         fetch = +refs/heads/*:refs/remotes/origin/*
  # > defines tracking branches (which remote branch your local branch follows)
  # [branch "main"]
  #         remote = origin
  #         merge = refs/heads/main
  # > submodules (if the repo has submodules)
  # [submodule "libfoo"]
  #         path = libfoo
  #         url = https://github.com/example/libfoo.git
  ```

  Other `core` settings can for example also be `core.hooksPath` which means that instead of `.git/hooks` Git will look in the `hooksPath` referenced directory for hooks.

- `description`: Originally this text file should contain a repository description but nowadays its virtually useless

  ```sh
  cat .git/description
  # Unnamed repository; edit this file 'description' to name the repository.
  ```

- `FETCH_HEAD` (Records what was fetched from a remote):

  ```sh
  # <commit-hash (fetched from remote)> <status (can be empty)> <branch info>
  cat .git/FETCH_HEAD
  # be9ce77...                 branch 'main' of github.com:USER/REPO
  # 3e028f2...  not-for-merge  branch 'old' of github.com:USER/REPO
  ```

  (`not-for-merge` declares that when Git fetches a branch there shouldn't be an automatic merge in case of conflicts)

- `HEAD` (What your working directory is currently pointing at):

  ```sh
  # Attached HEAD: Pointing to your local branch main (the latest commit on it)
  cat .git/HEAD
  # ref: refs/heads/main
  ```

  ```sh
  # Detached HEAD: Pointing to a specific commit in the history
  cat .git/HEAD
  # be9ce77a8795ee162f896f996963b7f348211272
  ```

- `hooks` (Directory that contains all supported hooks and examples for them):

  ```sh
  ls -a ../../../.git/hooks/
  # .  ..  applypatch-msg.sample  commit-msg.sample  fsmonitor-watchman.sample
  # post-update.sample  pre-applypatch.sample  pre-commit.sample
  # pre-merge-commit.sample  pre-push.sample  prepare-commit-msg.sample
  # pre-rebase.sample  pre-receive.sample  push-to-checkout.sample
  # sendemail-validate.sample  update.sample
  ```

  Each `.sample` file is a bash script that contains an example (removing the `.sample` enables it).
  For `pre-commit` this can for example be a simple script that checks if `make` runs without issues:

  ```sh
  #!/bin/sh

  # Run make, abort commit if it fails
  make
  if [ $? -ne 0 ]; then
      echo "make failed. Commit aborted."
      exit 1
  fi

  # Not really necessary, 0 is the default return value
  exit 0
  ```

  Git will trigger this script when a commit is being started (`git commit`).
  If the script does not return `0` the commit process is aborted by Git.
  This can make sure that a commit that breaks the build process never happens.

  {{< note >}}In case `core.hooksPath` is set this directory will be ignored in favor of that one.{{< /note >}}

- `index`: Snapshot of files staged for commit (Staging Area)
- `info`: Local metadata/rules

  ```sh
  ls -a .git/info
  # .  ..  exclude
  ```

  `exclude` is pretty much a secret `.gitignore` text file.

- `logs`: Stores reflogs (history of updates to `HEAD` and branches) to recover lost commits

  ```sh
  cat .git/logs/refs/heads/main
  # 0000000000000000000000000000000000000000 a0263e03aeaf61bd176cea00bedfb6ecb9ddfefa User <email@gmail.com> 1737401966 +0100    clone: from github.com:User/Repo.git
  # a0263e03aeaf61bd176cea00bedfb6ecb9ddfefa 899bde2cc4a0c4fe7cb8b0c641c65269c523ff52 User <email@gmail.com> 1737409227 +0100    commit: WIP Add PWA features part 1
  # 899bde2cc4a0c4fe7cb8b0c641c65269c523ff52 c7d5300f56e25698a18d3330dc83ea0b73b75836 User <email@gmail.com> 1737409354 +0100    commit (amend): WIP Add PWA features part 1
  # c7d5300f56e25698a18d3330dc83ea0b73b75836 13b6be893a770936c3a012a55485991d0a12be93 User <email@gmail.com> 1737411556 +0100    commit (amend): Add PWA features
  # 13b6be893a770936c3a012a55485991d0a12be93 e0a9a6acce1752980d30634454ac7731b782d9d5 User <email@gmail.com> 1737411955 +0100    commit (amend): Add PWA features
  # e0a9a6acce1752980d30634454ac7731b782d9d5 d14935c0daf170910ad8dc80ef9c3cecfe9ed3da User <email@gmail.com> 1737473077 +0100    commit: Add local storage support for Stopwatch instance
  # d14935c0daf170910ad8dc80ef9c3cecfe9ed3da a566d594a729b900cf7a5ea0ba126330c268612d User <email@gmail.com> 1737473379 +0100    commit (amend): Add local storage support for Stopwatch instance
  # a566d594a729b900cf7a5ea0ba126330c268612d 60d9486c825a644febe309806003497f05af3aa7 User <email@gmail.com> 1737474318 +0100    commit: Add support for service worker update dialog after version changes
  # ...
  ```

- `objects`: Stores all Git objects (commits, trees, blobs, tags) using their SHA hashes

  ```sh
  ls .git/info
  # 00  01  13  1d  1f  22  29  2a  34  3a  3c  4d  56  58  59  5e  60
  # 64  67  71  79  7e  7f  82  89  8d  8e  8f  99  9d  a2  a4  a5  af
  # b4  be  c7  c9  ca  cb  cc  ce  d1  e0  e2  e5  ea  eb  f1  f5  f6
  # fa  info  pack
  ```

- `ORIG_HEAD`: A reference to the previous state of `HEAD`, e.g. to undo a merge or rebase
- `packed-refs`: A file that stores all `refs` (branches/tags) in a compressed form for faster reading in repositories with a massive amounts of `refs`
- `refs`:

  ```sh
  ls .git/refs
  # heads  remotes  stash  tags
  ls .git/refs/heads
  # main  branch-a  branch-b
  cat .git/refs/heads/main
  # > Commit that references the latest commit of the branch
  # 3e028f2224efc7d929e188a2025d09c19fba42ae
  ls .git/refs/remotes/origin/
  # HEAD  main  branch-a  branch-b
  cat .git/refs/remotes/origin/main
  # > Commit that references the latest fetched commit of the remote branch
  # 3e028f2224efc7d929e188a2025d09c19fba42ae
  cat .git/refs/remotes/origin/HEAD
  # > This means that the remote declares it's main branch as the default branch
  # ref: refs/remotes/origin/main
  cat .git/refs/stash
  # > Internally stored latest commit of a stash
  # 6316e4970895b260b23ed85726ddd6b24ec03b0e
  ls .git/refs/tags
  # > All tags that have been created
  # v1.1.3  v1.1.4  v1.1.5
  cat .git/refs/tags/v1.1.3
  # > Commit that references the commit that represents this tag
  # > (often used for versions)
  # a4b1cb1a3b5b6ec2b94749e649e1ad248fac9d62
  ```
