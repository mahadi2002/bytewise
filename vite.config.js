import { defineConfig } from 'vite';
import { resolve } from 'node:path';

// Minimal build-tooling layer for CSS/JS only — the PHP backend is
// untouched. Two independent entries (no shared imports between them, so
// Rollup emits exactly one file per entry, no vendor-chunk splitting to
// account for in views/layouts/public.php):
//
//   - `main`   — public/assets/js/app.js, unchanged logic, just processed/
//                minified through Vite same as everything else.
//   - `editor` — src/editor.js, the new CodeMirror 6 bundle (vendored via
//                npm, never a CDN) used for both the interactive problem
//                editor and read-only lesson/landing syntax highlighting.
//   - `styles` — public/assets/css/app.css, passed through as a build
//                input so it goes through the same pipeline (minification,
//                cache-busted via the app's existing asset() helper).
//
// Output is plain ES modules with fixed, unhashed filenames (no manifest.
// json to parse) so views/layouts/public.php can reference
// assets/dist/main.js / editor.js / styles.css directly — content-hash
// cache-busting is already handled by asset()'s ?v=filemtime query string.
export default defineConfig({
  // Vite's default publicDir ('public') gets copied verbatim into outDir on
  // every build. Our outDir (public/assets/dist) lives INSIDE that same
  // publicDir, so with the default left on, Vite copies public/ into
  // public/assets/dist/, which contains public/assets/dist itself — an
  // unbounded recursive self-copy. This app already serves public/ as its
  // docroot directly (see public/index.php), so Vite has no static assets
  // of its own to pass through; turn the feature off entirely.
  publicDir: false,
  build: {
    outDir: 'public/assets/dist',
    emptyOutDir: true,
    manifest: false,
    target: 'es2020',
    rollupOptions: {
      input: {
        main: resolve(__dirname, 'public/assets/js/app.js'),
        editor: resolve(__dirname, 'src/editor.js'),
        styles: resolve(__dirname, 'public/assets/css/app.css'),
      },
      output: {
        entryFileNames: '[name].js',
        assetFileNames: '[name][extname]',
        chunkFileNames: '[name].js',
      },
    },
  },
});
