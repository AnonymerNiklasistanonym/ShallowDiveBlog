# ShallowDiveBlog

This repository contains Markdown articles that are automatically rendered into a static HTML blog using Jenkins and a static site generator (Hugo in this setup).

## Structure

- `content/`: blog articles and other content (Markdown)
  - `lang_code`: language specific content
    - global pages: like `about.html`, `search.html`
    - posts in `posts` directory: like `posts/demo.html`
- `i18n/full_language_code`: Internationalization
  - Use `{{ i18n "category" }}`/`{{ i18n "category" 2 }}` in layout files deriving information form e.g. `i18n/en-us.yaml` and `i18n/de-de.yaml`:

    ```yaml
    category:
      one: "Category"
      other: "Categories"
    ```

    (can only be used in layout files)

- `layouts/_default`: Hugo default layouts
  - `.html` files with `go` logic to determine HTML output (mostly using theme defaults but some overrides for e.g. last update, author name, tags, ...)
- `themes/`: Hugo themes (empty because the theme is installed with `hugo mod` defined in `go.mod`/`go.sum`)
- `hugo.toml`: Hugo configuration file

## Setup

### Local

1. Install [`hugo`](https://gohugo.io/) to convert Markdown into HTML

   ```sh
   sudo pacman -S hugo
   ```

2. Run `hugo` for a live preview in the browser:

   ```sh
   hugo server -D
   ```

3. Create static build in the `public` directory:

   ```sh
   hugo --cleanDestinationDir
   # Minified output
   hugo --minify --cleanDestinationDir
   ```

4. Create search index in the `public/pagefind` directory by scanning the `public` directory:

   ```sh
   sudo pacman -S nodejs npm
   # Move tags directory temporarily out of public so that it isn't indexed
   mv public/tags/ tags/
   npx -y pagefind --site public
   mv tags/ public/tags/
   ```

### Original Setup

```sh
sudo pacman -S go
hugo new site ShallowDiveBlog
cd ShallowDiveBlog
hugo mod init github.com/yourusername/your-repo
hugo mod get github.com/hugo-sid/hugo-blog-awesome
```

Now add the following lines to the `hugo.toml`:

```yaml
theme = "github.com/hugo-sid/hugo-blog-awesome"

[module]
  [[module.imports]]
    path = "github.com/hugo-sid/hugo-blog-awesome"
```

With the following addition multiple languages are supported:

```yaml
############################## English language ################################
[Languages.en-us]
  languageName = "English"
  languageCode = "en-us"
  contentDir = "content/en"
  weight = 1

  [Languages.en-us.menu]
  [[Languages.en-us.menu.main]]
    pageRef="/"
    name = 'Home'
    url = '/'
    weight = 10
  [[Languages.en-us.menu.main]]
    pageRef="posts"
    name = 'Posts'
    url = '/posts/'
    weight = 20
  [[Languages.en-us.menu.main]]
    pageRef="about"
    name = 'About'
    url = '/about/'
    weight = 30

############################## German language ################################
[Languages.de-de]
  languageName = "English"
  languageCode = "de-de"
  contentDir = "content/de"
  weight = 1

  [Languages.de-de.menu]
  [[Languages.de-de.menu.main]]
    pageRef="/"
    name = 'Home'
    url = '/'
    weight = 10
  [[Languages.de-de.menu.main]]
    pageRef="posts"
    name = 'Posts'
    url = '/posts/'
    weight = 20
  [[Languages.de-de.menu.main]]
    pageRef="about"
    name = 'Über'
    url = '/about/'
    weight = 30
```

## Add posts

Using the following command automatically creates an empty draft following the specification in [`assets/default.md`](assets/default.md):

```sh
# Create new article file (in 'content/en/posts')
hugo new posts/new-post.md
# Create new content file (in 'content/en')
hugo new about.md
# Other languages
hugo new ../de/posts/new-post.md
hugo new ../de/about.md
```

Make sure that if the post is finished to change the metadata to `draft: false` for it to be listed on deployment:

```markdown
---
title: "Demo"
date: 2025-08-10
draft: false
---

Test
```

### Important YAML options

- `title`: Name of the post
- `author`: Name of the author (only needs to be set if it's different to the global author)
- `date`: The date of the release
- `lastmod`: The date of the last update
- `draft`: `false`/`true` (set `true` if it should be published)
- `math`: `false`/`true` (set `true` if it should automatically render math sections like $1+1=2$)
- `toc`: `false`/`true` (set `false` if table of contents for a post should be hidden)
- `summary`: The content that should be displayed in the RSS feed
- `slug`: A custom URL slug for the page
- `tags`: A list of tags which are indexed across all pages
- `categories`: A list of categories which are indexed across all pages
- `disable_search_index`: `false`/`true` (set `true` if it should not be indexed using `pagefind`)

### Custom YAML options

- `hide_meta`: `false`/`true` (set `true` if it should hide the page metadata like date and author)
- `rss`: `false`/`true` (set `false` if it should be hidden from the CSS feed like the about page)

## `git` structure

- `main`: Everything across articles like shortcodes, image generation, documentation, ...
- `post-$title`: A branch for a article/post that is currently in the works that is based on a version of the `main` branch:

  ```sh
  git switch main

  # Optional to update main
  git pull origin

  # Create new branch for post
  git switch -c post-example-title
  ```

  To update/rebase this branch to the latest changes on `main`:

  ```sh
  # Optional to update main
  git switch main
  git pull origin

  git switch -c post-example-title
  git rebase main
  ```
