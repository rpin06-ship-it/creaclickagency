# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Static rebuild (plain HTML/CSS/JS, no framework, no build step, no tests) of https://www.creaclickagency.com, a luxury event-planning agency on the Côte d'Azur. The live site is still on Webador; this repo replaces it. All content and UI text are in **French**, and the user communicates in French.

## Commands

```powershell
python -m http.server 8000                         # local preview at http://localhost:8000 (required: all URLs are root-absolute, file:// will not work)
python scripts/optimiser-images.py                 # regenerate assets/img/*.webp from sources/img/ (needs Pillow)
powershell -File scripts\recuperer-images.ps1      # re-download original images from the Webador CDN into sources/img/
```

Git was installed via winget and may be missing from PATH in an old shell: use `"$env:ProgramFiles\Git\cmd\git.exe"`. In a non-interactive shell, `git push` only authenticates (Git Credential Manager, browser flow) after setting `$env:GIT_TERMINAL_PROMPT='1'; $env:GCM_INTERACTIVE='always'`. Remote: `origin` → github.com/rpin06-ship-it/creaclickagency, branch `main`.

## Architecture

- **One folder per page** with an `index.html`, giving clean trailing-slash URLs (`/prestations/`). The slugs deliberately match the old Webador URLs to preserve SEO. Old URLs that changed (`/informations-1`, …) get 301 redirects in **both** `.htaccess` (Apache hosting) and `_redirects` (Netlify/Cloudflare): keep the two files in sync.
- **No templating**: the header (`<nav>`) and footer are copy-pasted into every page. Any menu/footer change must be applied to all `index.html` files and `404.html`; the active page carries `aria-current="page"`. Each page also owns its `<title>`, meta description, canonical and Open Graph tags. A new page must be added to `sitemap.xml`.
- **CSS**: single file `assets/css/style.css`. Colors, fonts and spacing are CSS variables in `:root` (cream/black/gold palette; Cormorant Garamond titles, Inter body). Reusable layout classes: `.section`/`.section-alt`, `.hero` (background image passed via inline `style="--hero-img:url(...)"`, `.hero--page` for inner pages), `.two-cols` (`--reverse`), `.cards cards-3|cards-4`, `.steps`, `.pricing`/`.plan`, `.gallery`, `.faq`, `.form`, `.cta`.
- **JS**: `assets/js/main.js` only handles the mobile menu toggle and the footer year.
- **Image pipeline**: originals live in `sources/img/<page>/` (git-ignored, local only). `scripts/optimiser-images.py` writes WebP into `assets/img/<page>/`: files prefixed `hero-` are capped at 1920 px, other images at 1200 px, and `realisations/` gets a 1600 px version plus a 600 px square thumbnail in `realisations/mini/` (the gallery `<img>` uses the thumbnail and links to the large version). Never hand-edit `assets/img/` except `og/og-default.jpg` (Open Graph image, kept as JPEG). Every `<img>` needs a descriptive French `alt`, its real `width`/`height`, and `loading="lazy"` unless it is above the fold.
- **Contact form** (`contact/index.html`) currently has `action="#"`: it is not wired to any sending service yet. It includes a honeypot field (`.hp`, name `website`).

## Open items

`README.md` keeps the prioritized TODO list: legal-page placeholders marked `[À COMPLÉTER]`, the form backend, the real Instagram URL (currently `https://www.instagram.com/` on every page), gallery alt texts, and hosting/DNS. Texts were paraphrased from the live site and still need the owner's proofreading.
