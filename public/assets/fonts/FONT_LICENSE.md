# Font Licenses

All fonts are self-hosted (never loaded from a CDN at runtime), subsetted per weight/script, fetched from Google Fonts' `fonts.gstatic.com` (the canonical distribution point for these exact open-license files) on 2026-08-17.

## Hind Siliguri
- **License:** SIL Open Font License 1.1
- **Source:** https://fonts.google.com/specimen/Hind+Siliguri
- **Files:** `hind-siliguri/hind-siliguri-{400,600,700}-{bengali,latin}.woff2` — static instances, not variable.
- **Use:** Bangla body text (`--font-bangla` in app.css).

## Inter
- **License:** SIL Open Font License 1.1
- **Source:** https://fonts.google.com/specimen/Inter
- **Files:** `inter/inter-variable-latin.woff2` — a single variable-font file covering weights 400–700 (`font-weight: 400 700` in its `@font-face` rule); Google Fonts serves the same physical file for these static weight requests because Inter's distribution is variable-axis based.
- **Use:** Latin text / numerals (`--font-latin` in app.css).

## JetBrains Mono
- **License:** SIL Open Font License 1.1 (JetBrains Mono is OFL, not Apache — corrected from this app's earlier build-spec note, which said Apache 2.0)
- **Source:** https://fonts.google.com/specimen/JetBrains+Mono
- **Files:** `jetbrains-mono/jetbrains-mono-variable-latin.woff2` — a single variable-font file covering weights 400–500 (`font-weight: 400 500`).
- **Use:** Code samples, the in-browser code editor (`--font-mono` in app.css).

No photographic/raster imagery ships in this app (SVG/emoji only per the design system), so there is nothing else to credit here — see rulebook §8.
