document.addEventListener('DOMContentLoaded', () => {
    const root = document.querySelector('#search');
    if (!root) return;

    new PagefindUI({
        element: '#search',
        showSubResults: true,
        autofocus: true
    });

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

    // Initial theme check
    const htmlClass = document.documentElement.classList.contains('dark') ? 'dark' : 'light';
    applyTheme(htmlClass);

    // Observe <html> class changes
    const observer = new MutationObserver(() => {
        const currentTheme = document.documentElement.classList.contains('dark') ? 'dark' : 'light';
        applyTheme(currentTheme);
    });
    observer.observe(document.documentElement, { attributes: true, attributeFilter: ['class'] });
});
