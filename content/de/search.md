---
title: "Suche"
toc: false
draft: false
hide_meta: true
disable_search_index: true
rss: false
---

<link href="../../pagefind/pagefind-ui.css" rel="stylesheet">
<script src="../../pagefind/pagefind-ui.js"></script>
<div id="search"></div>
<script>
    window.addEventListener('DOMContentLoaded', (event) => {
        new PagefindUI({
            element: "#search",
            showSubResults: true,
            autofocus: true,
            translations: {
                placeholder: "Suche",
                zero_results: "Keine Ergebnisse für [SEARCH_TERM]"
            },
        });
        const root = document.querySelector('#search');
        if (!root) return;
        const applyTheme = (theme) => {
            if (theme === 'dark') {
                root.style.setProperty('--pagefind-ui-primary', '#00ff9c');
                root.style.setProperty('--pagefind-ui-text', '#f5f5f5');
                root.style.setProperty('--pagefind-ui-background', '#181818');
            } else {
                root.style.setProperty('--pagefind-ui-primary', '#0066cc');
                root.style.setProperty('--pagefind-ui-text', '#222222');
                root.style.setProperty('--pagefind-ui-background', '#ffffff');
            }
        };
        // Initial check
        const htmlClass = document.documentElement.classList.contains('dark') ? 'dark' : 'light';
        applyTheme(htmlClass);
        // Observe class changes on <html>
        const observer = new MutationObserver(() => {
            const currentTheme = document.documentElement.classList.contains('dark') ? 'dark' : 'light';
            applyTheme(currentTheme);
        });
        observer.observe(document.documentElement, { attributes: true, attributeFilter: ['class'] });
    });
</script>
