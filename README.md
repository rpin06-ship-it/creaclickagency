# CreaClick Agency – site web

Refonte en **site statique HTML/CSS/JS** (sans CMS, sans build) du site actuel
<https://www.creaclickagency.com>, hébergé aujourd'hui sur **Webador**.
Contenus et images repris du site en ligne le 11/11/2026.

## Arborescence

```
creaclickagency/
├── index.html                          Accueil
├── prestations/index.html              Prestations + formules (Essentiel / Business / Prestige)
├── sponsoring-et-partenariats/index.html
├── informations/index.html             (ancienne URL Webador : /informations-1 → redirigée)
├── equipes/index.html
├── realisations/index.html             Galerie (30 photos)
├── contact/index.html                  Formulaire de devis + FAQ (schema FAQPage)
├── mentions-legales/index.html         ⚠ à compléter (SIRET, hébergeur…)
├── politique-de-confidentialite/index.html  ⚠ à compléter
├── 404.html
├── assets/
│   ├── css/style.css                   Feuille unique, variables en tête (couleurs, typo)
│   ├── js/main.js                      Menu mobile + année du footer
│   ├── icons/favicon.svg
│   └── img/                            Images OPTIMISÉES (WebP) – générées, ne pas éditer à la main
│       ├── accueil/  prestations/  sponsoring/  informations/
│       ├── equipes/  contact/
│       ├── realisations/ (+ mini/)     Grande version 1600 px + miniature 600 px pour la grille
│       └── og/og-default.jpg           Image de partage réseaux sociaux (1200×630, JPEG)
├── sources/img/                        Images ORIGINALES (non versionnées, voir .gitignore)
├── scripts/
│   ├── recuperer-images.ps1            Re-télécharge les originaux depuis le CDN Webador → sources/img/
│   └── optimiser-images.py             sources/img/ → assets/img/ (WebP redimensionné)
├── robots.txt   sitemap.xml   site.webmanifest
├── .htaccess                           Hébergement Apache : HTTPS, www, 301, cache, sécurité
└── _redirects                          Équivalent pour Netlify / Cloudflare Pages
```

Chaque page est un dossier avec un `index.html` : on obtient des URL propres (`/prestations/`).

## Travailler en local

```powershell
cd C:\Users\user\creaclickagency
python -m http.server 8000
# puis ouvrir http://localhost:8000
```
Les liens sont absolus (`/assets/...`) : il faut passer par un serveur, pas ouvrir le fichier directement.

## Conventions

- **Header / footer** : dupliqués dans chaque page. En cas de modification du menu, modifier **toutes** les pages
  (penser à `aria-current="page"` sur la page active).
- **Couleurs et polices** : uniquement via les variables `:root` en haut de `style.css`.
- **Images** : déposer l'original dans `sources/img/<page>/` (nom en minuscules avec des tirets et un mot-clé,
  préfixe `hero-` pour une image de bandeau), lancer `python scripts/optimiser-images.py`, puis référencer
  le `.webp` produit dans `assets/img/`. Toujours un `alt` descriptif, `width`/`height` réels et
  `loading="lazy"` (sauf l'image du hero).
- **SEO** : chaque page a ses propres `<title>`, meta description, canonical et balises Open Graph.
  Une nouvelle page doit aussi être ajoutée à `sitemap.xml`.

## À faire (par priorité)

1. **Mentions légales et politique de confidentialité** : remplir les champs `[À COMPLÉTER]` (obligation légale).
2. **Formulaire de contact** : le brancher sur un service d'envoi (Formspree, Web3Forms, Netlify Forms ou PHP),
   puis mettre à jour l'attribut `action` dans `contact/index.html`.
3. **Lien Instagram** : remplacer `https://www.instagram.com/` par l'URL du compte (dans toutes les pages).
4. ~~Poids des images~~ : fait (WebP, −43 % ; page Réalisations : 8,8 Mo → 1,5 Mo).
5. **Textes alternatifs** des 30 photos de la galerie Réalisations : décrire chaque événement.
6. **Contenus** : les textes ont été repris et légèrement réécrits à partir du site en ligne. À relire.
7. **Page Équipes** : ajouter photos et prénoms (levier de confiance fort).
8. **Mise en ligne** : choisir un hébergeur (OVH, o2switch, Netlify…), pointer le DNS, puis déclarer le
   sitemap dans Google Search Console. Les 301 de `.htaccess` / `_redirects` protègent le référencement existant.
9. Pistes d'évolution : témoignages clients, page par type d'événement (mariage, séminaire…) pour le SEO local,
   version anglaise (`/en/`), mesure d'audience sans cookies (Plausible, Matomo).
