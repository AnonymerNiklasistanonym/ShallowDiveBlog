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

```sh
# Only the first time
mkdir -p content/en
mkdir -p content/en/posts
# Create new article file (in 'content/en/posts')
hugo new en/posts/my-new-post.md
# Create bew content file (in 'content/en')
hugo new en/about.md
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
