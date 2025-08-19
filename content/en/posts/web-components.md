---
title: Web Components & Shadow DOM
summary: A shallow dive into web components & the shadow DOM
date: 2025-08-10T16:37:19+02:00
draft: true
tags:
  - HTML
  - DOM
  - Web Components
  - Iframe
  - Same-Origin
categories:
  - Software
  - Informatics
---

## DOM/HTML

TODO

## Same-Origin/Cross-Origin

2 URLs are considered same-origin if they share:

1. Protocol (http vs https) **and**
2. Host (example.com) **and**
3. Port (80, 443, etc.)

Why does this exist?

- A website often contains content from many different websites at once (e.g. JS libraries)
- Without restrictions, a loaded script could read information like cookies, localStorage, or session tokens

Where can you enable/find this behaviour?

- Fetching: JavaScript requests to URLs are blocked by default if the origin is different, unless the server sends CORS headers

  TODO CORS headers

- Resource includes in `<head>`: For example scripts loaded from other origins run but cannot read the DOM or variables from the page that loaded them if Content Security Policy (CSP) or cross-origin restrictions are applied

  ```html
  <!-- ... -->
  <head>
    <!-- ... -->
    <script src="https://cdn.example.com/lib.js" crossorigin="anonymous"></script>
  <head>
  <!-- ... -->
  ```

  TODO Extent, examples

- `<iframes>`: Parent ↔ iframe DOM access is restricted by same-origin (so malicious `<iframes>` cannot directly access the parent DOM)

## `<iframe>`

With an `<iframe>` HTML element you can add an isolated separate HTML page into an existing HTML page:

```html
<iframe
  src="https://example.org"
  title="iframe Example 1"
  width="100%"
  height="420px"
  style="border: 1px solid #ccc;"
  sandbox
  ></iframe>
```

<iframe
  src="https://example.org"
  title="iframe Example 1"
  width="100%"
  height="420px"
  style="border: 1px solid #ccc;"
  sandbox
  ></iframe>

Just like the original page the `<iframe>` has its own:

- window
- document
- history
- event loop
- URL
- navigation
- cookies

CSS, JS, and DOM inside the iframe do not leak into the parent.
When indexed by e.g. Google the content of the `<iframe>` is normally ignored.

### `<iframe>`-parent Communication

- Message exchange is always allowed (even for cross-origin)

  ```js
  // Parent:
  document.getElementById("iframeID");
  iframe.contentWindow.postMessage("increment", "*");
  // Iframe:
  window.addEventListener("message", (e) => {
    if (e.data === "increment") {/* ... */}
  });
  ```

  ```js
  // Iframe:
  window.parent.postMessage("hello", "*");
  // Parent:
  window.addEventListener("message", (e) => {
    if (e.data === "hello") {/* ... */}
  });
  ```

- **Sandbox restrictions**
  - `<iframe>` cannot directly access parent DOM
  - (not) `allow-scripts`: `<iframe>` cannot run JavaScript at all

    ```html
    <iframe
      /* ... */
      sandbox
    ></iframe>
    ```

  - (not) `allow-same-origin` (and same origin): parent cannot directly access `<iframe>` DOM

    ```html
    <iframe
      /* ... */
      sandbox="allow-scripts"
    ></iframe>
    ```

- **Direct (DOM) Access (same-origin only)**
  - Parent → `<iframe>`: When no sandbox restrictions or `allow-same-origin`
  - `<iframe>` → Parent: When no sandbox restrictions

In the case that the `<iframe>` and the original page are from the same origin they can interact with each other:

{{< include_code file="static/html/iframe_counter.html" lang="html" >}}

```html
<iframe
  id="iframeCounter"
  title="iframe Example counter"
  src="../../html/iframe_counter.html"
  width="100%"
  height="200px"
  style="border: 1px solid #ccc;"
></iframe>
<button
  id="increment"
  style="font-size: 1rem; padding: 0.5rem 1rem;"
  >
  Increment iframe via post message (original page)
</button>
<button
  id="edit"
  style="font-size: 1rem; padding: 0.5rem 1rem;"
  >
  Edit DOM directly of iframe (original page)
</button>
<script>
  const increment = document.getElementById("increment");
  const edit = document.getElementById("edit");
  increment.addEventListener("click", () => {
    const iframe = document.getElementById("iframeCounter");
    iframe.contentWindow.postMessage("increment", "*");
  });
  edit.addEventListener("click", () => {
    const iframe = document.getElementById("iframeCounter");
    const buttons = iframe.contentWindow.document.querySelectorAll("button");
      const originalColors = Array.from(buttons).map(b => b.style.backgroundColor);
      // Make buttons red
      buttons.forEach(b => b.style.backgroundColor = "red");
      // Reset after 2 seconds
      setTimeout(() => {
        buttons.forEach((b, i) => b.style.backgroundColor = originalColors[i]);
      }, 500);
  });
  window.addEventListener("message", (e) => {
    if (e.data === "hello") {
      increase();
    }
  });
</script>
```

- `<iframe>` scripts are being run
- message exchange is possible (both directions)
- direct DOM access is possible (both directions)
  - only possible from `<iframe>` to access parent DOM when it's the same origin!

<iframe
  id="iframeCounter"
  title="iframe Example counter"
  src="../../html/iframe_counter.html"
  width="100%"
  height="260px"
  style="border: 1px solid #ccc;"
></iframe>
<button
  id="increment"
  style="font-size: 1rem; padding: 0.5rem 1rem; margin: 1rem;"
  >
  Post message (parent -> iframe)
</button>
<button
  id="edit"
  style="font-size: 1rem; padding: 0.5rem 1rem; margin: 1rem;"
  >
  Edit DOM directly (parent -> iframe)
</button>
<script>
  const increment = document.getElementById("increment");
  const edit = document.getElementById("edit");
  increment.addEventListener("click", () => {
    const iframe = document.getElementById("iframeCounter");
    iframe.contentWindow.postMessage("increment", "*");
  });
  edit.addEventListener("click", () => {
    const iframe = document.getElementById("iframeCounter");
    const buttons = iframe.contentWindow.document.querySelectorAll("button");
      const originalColors = Array.from(buttons).map(b => b.style.backgroundColor);
      // Make buttons red
      buttons.forEach(b => b.style.backgroundColor = "red");
      // Reset after 2 seconds
      setTimeout(() => {
        buttons.forEach((b, i) => b.style.backgroundColor = originalColors[i]);
      }, 500);
  });
  window.addEventListener("message", (e) => {
    if (e.data === "hello") {
      alert(`Message from iframe: ${e.data}`)
    }
  });
</script>

Using sandboxing JS scripts can be isolated and even stopped from being run altogether:

> If no sandboxing argument is added everything is allowed e.g.:
>
> ```html
> <iframe
>   /* ... */
>   sandbox="allow-scripts same-origin"
> ></iframe>
> ```

If nothing is in the argument, everything is blocked:

```html
<iframe
  /* ... */
  sandbox
></iframe>
```

- `<iframe>` scripts are not possible
  - thus message exchange/direct DOM access not possible
- direct DOM access is also not possible for the parent

<iframe
  id="iframeCounterSandbox"
  title="iframe Example counter"
  src="../../html/iframe_counter.html"
  width="100%"
  height="260px"
  style="border: 1px solid #ccc;"
  sandbox
></iframe>
<button
  id="incrementSandbox"
  style="font-size: 1rem; padding: 0.5rem 1rem; margin: 1rem;"
  >
  Post message (parent -> iframe)
</button>
<button
  id="editSandbox"
  style="font-size: 1rem; padding: 0.5rem 1rem; margin: 1rem;"
  >
  Edit DOM directly (parent -> iframe)
</button>
<script>
  const incrementSandbox = document.getElementById("incrementSandbox");
  const editSandbox = document.getElementById("editSandbox");
  incrementSandbox.addEventListener("click", () => {
    const iframe = document.getElementById("iframeCounterSandbox");
    iframe.contentWindow.postMessage("increment", "*");
  });
  editSandbox.addEventListener("click", () => {
    const iframe = document.getElementById("iframeCounterSandbox");
    const buttons = iframe.contentWindow.document.querySelectorAll("button");
      const originalColors = Array.from(buttons).map(b => b.style.backgroundColor);
      // Make buttons red
      buttons.forEach(b => b.style.backgroundColor = "red");
      // Reset after 2 seconds
      setTimeout(() => {
        buttons.forEach((b, i) => b.style.backgroundColor = originalColors[i]);
      }, 500);
  });
</script>

Or it's possible to just make them behave isolated (e.g. cross-origin default behaviour):

```html
<iframe
  /* ... */
  sandbox="allow-scripts"
></iframe>
```

- `<iframe>` scripts run
  - alerts are not possible
- message exchange possible
- direct DOM access is not possible (both directions)

<iframe
  id="iframeCounterSandboxAllowScripts"
  title="iframe Example counter"
  src="../../html/iframe_counter.html"
  width="100%"
  height="260px"
  style="border: 1px solid #ccc;"
  sandbox="allow-scripts"
></iframe>
<button
  id="incrementSandboxAllowScripts"
  style="font-size: 1rem; padding: 0.5rem 1rem; margin: 1rem;"
  >
  Post message (parent -> iframe)
</button>
<button
  id="editSandboxAllowScripts"
  style="font-size: 1rem; padding: 0.5rem 1rem; margin: 1rem;"
  >
  Edit DOM directly (parent -> iframe)
</button>
<script>
  const incrementSandboxAllowScripts = document.getElementById("incrementSandboxAllowScripts");
  const editSandboxAllowScripts = document.getElementById("editSandboxAllowScripts");
  incrementSandboxAllowScripts.addEventListener("click", () => {
    const iframe = document.getElementById("iframeCounterSandboxAllowScripts");
    iframe.contentWindow.postMessage("increment", "*");
  });
  editSandboxAllowScripts.addEventListener("click", () => {
    const iframe = document.getElementById("iframeCounterSandboxAllowScripts");
    const buttons = iframe.contentWindow.document.querySelectorAll("button");
      const originalColors = Array.from(buttons).map(b => b.style.backgroundColor);
      // Make buttons red
      buttons.forEach(b => b.style.backgroundColor = "red");
      // Reset after 2 seconds
      setTimeout(() => {
        buttons.forEach((b, i) => b.style.backgroundColor = originalColors[i]);
      }, 500);
  });
</script>

```html
<iframe
  /* ... */
  sandbox="allow-same-origin"
></iframe>
```

- `<iframe>` scripts are not possible
  - thus message exchange/direct DOM access not possible
- direct DOM access is possible from the parent to the `<iframe>`

<iframe
  id="iframeCounterSandboxAllowSameOrigin"
  title="iframe Example counter"
  src="../../html/iframe_counter.html"
  width="100%"
  height="260px"
  style="border: 1px solid #ccc;"
  sandbox="allow-same-origin"
></iframe>
<button
  id="incrementSandboxAllowSameOrigin"
  style="font-size: 1rem; padding: 0.5rem 1rem; margin: 1rem;"
  >
  Post message (parent -> iframe)
</button>
<button
  id="editSandboxAllowSameOrigin"
  style="font-size: 1rem; padding: 0.5rem 1rem; margin: 1rem;"
  >
  Edit DOM directly (parent -> iframe)
</button>
<script>
  const incrementSandboxAllowSameOrigin = document.getElementById("incrementSandboxAllowSameOrigin");
  const editSandboxAllowSameOrigin = document.getElementById("editSandboxAllowSameOrigin");
  incrementSandboxAllowSameOrigin.addEventListener("click", () => {
    const iframe = document.getElementById("iframeCounterSandboxAllowSameOrigin");
    iframe.contentWindow.postMessage("increment", "*");
  });
  editSandboxAllowSameOrigin.addEventListener("click", () => {
    const iframe = document.getElementById("iframeCounterSandboxAllowSameOrigin");
    const buttons = iframe.contentWindow.document.querySelectorAll("button");
    const originalColors = Array.from(buttons).map(b => b.style.backgroundColor);
    // Make buttons red
    buttons.forEach(b => b.style.backgroundColor = "red");
    // Reset after 2 seconds
    setTimeout(() => {
      buttons.forEach((b, i) => b.style.backgroundColor = originalColors[i]);
    }, 500);
  });
</script>

## Shadow DOM

TODO

## Web Components

TODO
