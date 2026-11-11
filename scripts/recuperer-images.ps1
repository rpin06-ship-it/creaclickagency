# ---------------------------------------------------------------------------
# Récupère les images du site Webador actuel (CDN primary.jwwb.nl)
# et range les ORIGINAUX dans sources/img/<page>/ avec des noms explicites (SEO).
# Lancer ensuite scripts\optimiser-images.py pour générer les WebP dans assets/img/.
# Usage (depuis la racine du projet) :  powershell -File scripts\recuperer-images.ps1
# Relançable sans risque : les fichiers déjà présents sont ignorés.
# ---------------------------------------------------------------------------
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$cdn  = "https://primary.jwwb.nl/public/x/x/g/temp-cwmqiygmoatlbjxdpbtb/"
$pex  = "https://primary.jwwb.nl/pexels/"

# destination (relative à assets/img) => source
$images = [ordered]@{
  # Accueil
  "accueil/hero-accueil.webp"                  = $cdn + "creaclick_03-standard-psvulv.webp"
  "accueil/engagements.png"                    = $cdn + "img_0673-standard.png"
  # Prestations
  "prestations/hero-prestations.webp"          = $cdn + "creaclick_04-standard-cm1xfh.webp"
  "prestations/etape-1-premier-echange.jpg"    = $cdn + "886476499_1493438345936553_2405986556121632667_n-high.jpg"
  "prestations/etape-2-proposition.jpg"        = $cdn + "888138730_1653117039520754_6306689471414620155_n-high-45xmhp.jpg"
  "prestations/etape-3-coordination.jpg"       = $cdn + "892211112_1142908144906109_1313528099047748519_n-high-w5xa49.jpg"
  "prestations/etape-4-jour-j.jpg"             = $cdn + "886677570_1451618753769893_4129083773350618114_n-high-6o8by4.jpg"
  "prestations/formule-essentiel.jpg"          = $cdn + "896706801_1460582972885144_3891046226200491109_n-high.jpg"
  "prestations/formule-business.jpg"           = $cdn + "893597592_29023741527248369_2464568024602683458_n-high.jpg"
  "prestations/formule-prestige.jpg"           = $cdn + "893400520_1803240610917608_4694017935176435330_n-high-ed68om.jpg"
  # Sponsoring (photos Pexels fournies par Webador)
  "sponsoring/hero-sponsoring.jpg"             = $pex + "64/6405650.jpeg"
  "sponsoring/rayonnement-marque.jpg"          = $pex + "27/2799533.jpeg"
  "sponsoring/evenementiel-haut-de-gamme.jpg"  = $pex + "17/17315476.jpeg"
  # Informations
  "informations/hero-informations.jpg"         = $cdn + "886895154_1750713459999225_6817113797886023687_n-standard-tf64ea.jpg"
  "informations/lieu-evenement.jpg"            = $cdn + "dsc_0038-standard.jpg"
  "informations/logistique.jpg"                = $cdn + "img_0874-standard.jpg"
  # Équipes
  "equipes/hero-equipes.jpg"                   = $cdn + "886811013_1181585624436482_3921844626814474008_n-standard-ym4yrk.jpg"
  # Contact
  "contact/hero-contact.jpg"                   = $cdn + "dsc_0053_1-high.jpg"
}

# Galerie Réalisations (30 photos, ordre du site actuel)
$galerie = @(
  "creaclick_03-high.webp","888033341_1058166253905576_4811785305241981939_n-high.jpg","creaclick_12-high.webp",
  "creaclick_02-high.webp","img_0824-high.jpg","photo_2_creaclick_v2-high.jpg","creaclick_11-high.webp",
  "creaclick_photo_13-high.jpg","photo_1_creaclick_v2-high.jpg","886609310_3594522484040423_8231734444962247948_n-high.jpg",
  "creaclick_04-high.webp","creaclick_13-high.webp","creaclick_10-high.webp","creaclick_01-high.webp",
  "creaclick_09-high.webp","creaclick_08-high.webp","creaclick_07-high.webp","creaclick_06-high.webp",
  "creaclick_photo_09-high.jpg","creaclick_photo_05-high.jpg","creaclick_05-high.webp",
  "884926344_1150742364080585_6348732765403617213_n-high.jpg","photo_3_creaclick_v2-high.jpg",
  "creaclick_photo_10-high.jpg","creaclick_photo_12-high.jpg","creaclick_photo_11-high.jpg",
  "creaclick_photo_01-high.jpg","creaclick_photo_07-high.jpg","creaclick_photo_08-high.jpg","creaclick_photo_06-high.jpg"
)
for ($i = 0; $i -lt $galerie.Count; $i++) {
  $ext = [IO.Path]::GetExtension($galerie[$i])
  $images[("realisations/evenement-prestige-{0:D2}{1}" -f ($i + 1), $ext)] = $cdn + $galerie[$i]
}

$ok = 0; $skip = 0; $ko = @()
foreach ($dest in $images.Keys) {
  $out = Join-Path $root ("sources/img/" + $dest)
  New-Item -ItemType Directory -Force -Path (Split-Path $out) | Out-Null
  if (Test-Path $out) { $skip++; continue }
  try {
    Invoke-WebRequest -Uri $images[$dest] -OutFile $out -UseBasicParsing -TimeoutSec 60
    $ok++
  } catch {
    $ko += "$dest  <=  $($images[$dest])"
  }
}
Write-Host "Telechargees : $ok | deja presentes : $skip | echecs : $($ko.Count)"
$ko | ForEach-Object { Write-Host "  ECHEC $_" }
