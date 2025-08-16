---
title: Web Components & Shadow DOM
summary: A shallow dive into web components & the shadow DOM
date: 2025-08-10T16:37:19+02:00
draft: true
math: true
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

HTML (Hyper Text Markup Language) is written and looks similar to the markup language XML but is designed to display data and information on the web using a specific subset of tags (e.g. lists, headings, text, inputs) in a specific structure.
The styling of the described elements is specified via the style sheet language CSS (Cascading Style Sheets) while dynamic scripting is specified via the scripting language JavaScript.

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Tab Title</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <h1>Page Title</h1>
  <p>Page text</p>
  <script src="scripts.js"></script>
</body>
</html>
```

A web browser is interpreting the given documents using the DOM (Document Object Model) where every element is an object/tree-node and then renders it to the user (taking into account default/external style rules):

![HTML website document: Example with a parsed DOM tree](../../images/web_components/dom_visualization.svg)

## HTTP

These files are normally transfered via a TCP (Transmission Control Protocol) connection using a plaintext protocol called HTTP (Hypertext Transfer Protocol).

A simple HTTP request contains just the host/domain name of the server that hosts the website/resources (e.g. `anonymerniklasistanonym.github.io`), the type (`GET`, fetch resource $x$), the path (`/ShallowDiveBlog/`) and the version (`HTTP/2`):

```http
GET /ShallowDiveBlog/ HTTP/2
Host: anonymerniklasistanonym.github.io
```

HTTP supports headers that make it easy to extend it over time without needing to update the protocol.
Usually a lot of optional headers are added that help the server but they can ignore most of them like:

- `User-Agent`: Client software that is making the request
- `Accept`: Client supported content types
- `Accept-Language`: Client preferred language
- `Accept-Encoding`: Client supported compression methods
- `DNT`: *Do Not Track*
- `If-Modified-Since`: Only send the payload if it was modified since that date
- `If-None-Match`: Only send the payload if the content has changed from the last response (`ETag`)

```http
GET /ShallowDiveBlog/ HTTP/2
Host: anonymerniklasistanonym.github.io
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:142.0) Gecko/20100101 Firefox/142.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate, br, zstd
DNT: 1
Connection: keep-alive
Upgrade-Insecure-Requests: 1
Sec-Fetch-Dest: document
Sec-Fetch-Mode: navigate
Sec-Fetch-Site: cross-site
Sec-Fetch-User: ?1
If-Modified-Since: Mon, 18 Aug 2025 04:52:00 GMT
If-None-Match: W/"68a2b170-2597"
Priority: u=0, i
TE: trailers
```

A response looks pretty similar containing the version (`HTTP/2`), the status code (`200` *Ok*/`304` *Not Modified*) and the payload:

```http
HTTP/2 200

<!doctype html>… (the RAW html text after a newline)
(when it's a binary file like an image it's encoded in base64)
```

If the server determined thanks to e.g. `If-Modified-Since` or `If-None-Match` that the resource (e.g. `index.html`) has not changed it can just anser with no payload and the status that it wasn't modified:

```http
HTTP/2 304
```

Usually a lot of optional headers are added to the response too:

- `date`: Timestamp when the response was generated
- `via`: Shows that the response passed through a proxy or cache
- `cache-control`: [Caching] Cache is fresh for $600\text{s} = 10\text{min}$
- `etag`: [Caching] Current content ID that can be included in the next client request
- `expires`: [Caching] Timestamp at which the resource is considered stale
- `age`: Seconds the response has been in a cache
- `x-cache`: HIT when it was served from a cache, otherwise from the origin server (`cache-hits` indicates how often this cache was served)

```http
HTTP/2 304
date: Wed, 27 Aug 2025 10:29:00 GMT
via: 1.1 varnish
cache-control: max-age=600
etag: W/"68a2b170-2597"
expires: Wed, 27 Aug 2025 10:38:47 GMT
age: 12
x-served-by: cache-muc13971-MUC
x-cache: HIT
x-cache-hits: 3
x-timer: S1756290540.400048,VS0,VE0
vary: Accept-Encoding
x-fastly-request-id: 80927b2dc1f9e4157cbb5363cd854b12a23c0854
X-Firefox-Spdy: h2
```

In the case that a binary file like an image is being requested the raw bytes are being sent in combination with the a `Content-Type` attribute:

```http
HTTP/2 200
Content-Type: image/png

<binary data of PNG image>
```

There is no link between two requests being successively carried out on the same connection (stateless).

> One small note is that each line is actually separated using `\r\n` because of historic reasons.
> Meaning a response actually looks like this:
>
> ```http
> HTTP/1.1 200 OK\r\n
> Date: Sat, 09 Oct 2010 14:28:02 GMT\r\n
> Server: Apache\r\n
> Last-Modified: Tue, 01 Dec 2009 20:18:22 GMT\r\n
> ETag: "51142bc1-7449-479b075b2891b"\r\n
> Accept-Ranges: bytes\r\n
> Content-Length: 29769\r\n
> Content-Type: text/html\r\n
> \r\n
> <!doctype html>… (here come the 29769 bytes of the requested web page)
> ```
>
> In the case that no body is sent (e.g. `304` Not Modified) an empty line must still be added:
>
> ```http
> HTTP/1.1 304 Not Modified\r\n
> Date: Sat, 09 Oct 2010 14:28:02 GMT\r\n
> Server: Apache\r\n
> ETag: "51142bc1-7449-479b075b2891b"\r\n
> \r\n
> ```

### TCP `Connection`

In early versions of HTTP, each resource was fetched over its own TCP connection, which is expensive because establishing a connection requires a 3-way handshake.

With the HTTP header `Connection: keep-alive` (or using `Transfer-Encoding: chunked`), a client can signal that an established connection should be reused for multiple sequential requests.
To indicate where each response ends, a `Content-Length: $BYTE_COUNT` header is often provided.
Even with `keep-alive`, `HTTP/1.1` still usually requires browsers to open multiple TCP connections to the same server, because a request cannot be sent on a connection until the previous response has been fully received.

`HTTP/2` optimizes this by reusing a single TCP connection and introducing multiplexed streams.
Each request/response is assigned a separate stream, allowing multiple requests to be sent and responses to be received concurrently over the same connection.
This eliminates the need for multiple connections for parallel requests.

Implementing `HTTP/2` is more complex, which is why many servers and clients still rely on `HTTP/1.1`.

There is also `HTTP/3` which uses the transport layer network protocol `QUIC` (*Quick UDP Internet Connections*) that uses a multiplexed UDP connection instead of TCP for better performance (faster connection establishment through less round trips).

{{< readmore url="../computer-networks" text="Read more about TCP and computer networks" >}}

### `HTTPS` (`TLS`, *Transport Layer Security*)

To prevent eavesdropping,`HTTPS` (and `QUIC`, which integrates `TLS` directly) establishes a symmetric encryption key after an initial handshake.
From that point, all HTTP requests and responses are encrypted while being transmitted, protecting both headers and body from being read or tampered with in transit.

## Same-Origin/Cross-Origin

For browsers 2 URLs are considered same-origin if they share:

1. Protocol (http vs https) **and**
2. Host (example.com) **and**
3. Port (80, 443, etc.)

*(otherwise they are cross-origin)*

**Why does this exist?**

- A website often contains content from many different websites at once (e.g. JS libraries)
- Without restrictions, a loaded script could read information like cookies, localStorage, or session tokens

**SPO (Same-Origin Policy)**:

Automatically blocks requests across different origins for security reasons.

**CORS (Cross-Origin Resource Sharing)**:

Without CORS, browsers enforce the SPO.
CORS headers tell the browser whether to allow or block requests based on .

TODO

**CSP (Content Security Policy)**:

TODO

**Where can you enable/find this behaviour?**

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
  sandbox
  ></iframe>
```

<iframe
  src="https://example.org"
  title="iframe Example 1"
  width="100%"
  height="420px"
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
