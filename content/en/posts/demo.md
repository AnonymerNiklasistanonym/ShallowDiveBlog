---
title: Demo Post [en-us]
summary: Demo description
author: Custom Author
date: 2025-08-10
lastmod: 2025-09-07
slug: demo-custom-slug
tags:
  - Demo
categories:
  - Demo
draft: false
math: true
asciinema: true
---

This is a sample blog post to test the *Hugo Blog Awesome* theme.

## Headings (starting at level 2)

### Heading Level 3

#### Heading Level 4

##### Heading Level 5

## Text

**Bold**, *Italic*, ***Both***, ~Striked~

[Inline links](#text)

References: {{< ref "posts/demo.md" >}}

> You can link to:
>
> - sections of a page by literally using the unique heading text (e.g. [`#text`](#text))
> - other posts
>   - using their custom slug (e.g. [`../demo-custom-slug`](../demo-custom-slug))
>
>     ```yaml
>     slug: demo-custom-slug
>     ```
>
>   - using the filenames without the `.md` ending if no custom slug was specified (e.g. [`../about`](../about))
>
>     > It's also possible to get the url of a post using `{{</* ref "posts/demo.md" */>}}` or `{{</* relref "posts/demo.md" */>}}` (this creates `{{< ref "posts/demo.md" >}}` or `{{< relref "posts/demo.md" >}}`)
> - combine both (e.g. [`../demo-custom-slug#text`](../demo-custom-slug#text))

## Lists

### Unordered Lists

- a
- b
  - c
- d

### Ordered Lists

1. First
2. Second
   1. Second First
      - Mixing possible
3. Third

## Quotes

> Quote

But quotes can also be nested:

> Nested
>
> > Quotes
>
> are also possible

## Code

`Inline Code (no syntax highlighting)`

```sh
echo "Code block"
# Supports Language Syntax Highlighting for most languages
# Math does not work in comments! ($1 + 1 = 2$)
```

> It's also possible to include code from a file in the `static` directory:
>
> ```md
> {{</* include_code file="examples/hello_world.c" lang="c" */>}}
> ```

{{< include_code file="examples/hello_world.c" lang="c" >}}

(Cannot be indented and does not support math rendering)

## Math

> If the following line is in the header KaTeX is added and enables the following blocks to be rendered to good locking equations:
>
> ```yaml
> math: true
> ```
>
> - Inline: `$...$`
>
> - Bigger (displaystyle): `$$...$$`
>
> - Multiline and bigger:
>
>   ```md
>   {{</* mathblock */>}}
>   ...
>   {{</* /mathblock */>}}
>   ```

Inline: $\sum_{k=1}^{n} k = \frac{n(n+1)}{2}$

Big: $$\sum_{k=1}^{n} k = \frac{n(n+1)}{2}$$

Big multiline block:

{{< mathblock >}}
\begin{aligned}
\sum_{k=1}^{n} k &= 1 + 2 + 3 + \cdots + n \\
                 &= \frac{n(n+1)}{2}
\end{aligned}
{{< /mathblock >}}

Big multiline block (numerated):

{{< mathblock >}}
\begin{align}
f(x) &= x^2 + 2x + 1 \\
     &= (x+1)^{\textcolor{red}2}
\end{align}
{{< /mathblock >}}

Continues numeration across page:

{{< mathblock >}}
\begin{align}
1 + 1 = 2
\end{align}
{{< /mathblock >}}

## Images

> Images placed into `static/images/article or category/.../image.svg` can be refrenced:
>
> - As-is: `../../images/examples/stars.svg`
> - As figure (subtitle, custom width/height: `{{</* figure src="../../images/examples/stars.svg" alt="Stars Example Image" title="Star Example Image Title" width=50%" */>}}`
>
> (in this case for the file `static/images/examples/stars.svg`)

![Stars Example Image](../../images/examples/stars.svg)

{{< figure src="../../images/examples/stars.svg" alt="Stars Example Image" title="Star Example Image Title" width=50%" >}}

## Tables

| **heading** (*entered*) | **columns...** |
| --- | --- |
| **rows...** (*aligned*) | content |

(can be indented)

## Notes

{{< note >}}
This is a custom note!
{{< /note >}}

## Terminal Recordings (Asciinema)

> Asciinema recordings stored in `static/.../recording.cast` can be referenced when enabled in the header:
>
> ```yaml
> asciinema: true
> ```
>
> ```md
> {{</* asciinema file="code/examples/cowsay.cast" autoplay="true" loop="true" cols="60" rows="10" */>}}
> ```
>
> (in this case for the file `static/code/examples/cowsay.cast`)

{{< asciinema file="code/examples/cowsay.cast"  autoplay="true" loop="true" cols="60" rows="10" >}}

## Other

### Page information

> All page header values can be gotten using the following shortcode:
>
> ```md
> {{</* param "author" */>}}
> ```

| Attribute | Value |
| --- | --- |
| `author` | {{< param "author" >}} |
| `title` | {{< param "title" >}} |
| `date` | {{< param "date" >}} |
| `lastmod` | {{< param "lastmod" >}} |
| `slug` | {{< param "slug" >}} |
| `tags` | {{< param "tags" >}} |
| `categories` | {{< param "categories" >}} |
| `math` | {{< param "math" >}} |
| `asciinema` | {{< param "asciinema" >}} |
| `...` | ... |
