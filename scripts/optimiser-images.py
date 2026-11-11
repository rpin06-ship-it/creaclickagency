"""
Optimise les images du site : sources/img/  ->  assets/img/  (format WebP).

- Images "hero-*" : 1920 px de large max, qualité 78
- Autres images   : 1200 px de large max, qualité 80
- Galerie Réalisations : 1600 px (vue agrandie) + miniature carrée 600 px dans realisations/mini/

Usage (depuis la racine du projet) :
    python scripts/optimiser-images.py
Nécessite Pillow :  pip install pillow
Les originaux dans sources/img/ ne sont jamais modifiés.
"""
from pathlib import Path
from PIL import Image, ImageOps

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "sources" / "img"
DST = ROOT / "assets" / "img"
EXTS = {".jpg", ".jpeg", ".png", ".webp"}


def load(path: Path) -> Image.Image:
    im = Image.open(path)
    im = ImageOps.exif_transpose(im)  # respecte l'orientation des photos de téléphone
    return im.convert("RGB")


def save_resized(im: Image.Image, out: Path, max_w: int, quality: int) -> None:
    if im.width > max_w:
        im = im.resize((max_w, round(im.height * max_w / im.width)), Image.LANCZOS)
    out.parent.mkdir(parents=True, exist_ok=True)
    im.save(out, "WEBP", quality=quality, method=6)


def main() -> None:
    before = after = count = 0
    for src in sorted(SRC.rglob("*")):
        if src.suffix.lower() not in EXTS:
            continue
        rel = src.relative_to(SRC).with_suffix(".webp")
        out = DST / rel
        im = load(src)
        before += src.stat().st_size

        if rel.parts[0] == "realisations":
            save_resized(im, out, 1600, 78)
            thumb = ImageOps.fit(im, (600, 600), Image.LANCZOS)
            tout = DST / "realisations" / "mini" / rel.name
            tout.parent.mkdir(parents=True, exist_ok=True)
            thumb.save(tout, "WEBP", quality=75, method=6)
            after += tout.stat().st_size
        elif src.stem.startswith("hero-"):
            save_resized(im, out, 1920, 78)
        else:
            save_resized(im, out, 1200, 80)

        after += out.stat().st_size
        count += 1

    print(f"{count} images : {before / 1e6:.1f} Mo -> {after / 1e6:.1f} Mo "
          f"(-{100 * (1 - after / before):.0f} %)")


if __name__ == "__main__":
    main()
