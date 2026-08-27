<?php
declare(strict_types=1);

namespace App\Core;

/**
 * One CSP nonce per request (never session-persisted — a nonce that
 * survives across requests defeats the point). Threaded from
 * SecurityHeaders' style-src directive to the page's
 * <meta name="csp-nonce"> tag (see views/layouts/public.php), which
 * assets/js src/editor.js reads and feeds to CodeMirror's
 * EditorView.cspNonce facet.
 *
 * Why this exists: CodeMirror 6 injects a <style> element (via the
 * style-mod package) to draw its theme/syntax colors. This app's CSP is
 * style-src 'self' with no 'unsafe-inline' (see SecurityHeaders — that
 * class's docblock predates this feature and already flags that any
 * in-browser code editor "must be chosen/configured to respect this").
 * Without a matching nonce, the browser silently drops that stylesheet
 * and the editor renders unstyled.
 */
final class Csp
{
    private static ?string $nonce = null;

    public static function nonce(): string
    {
        if (self::$nonce === null) {
            self::$nonce = Crypto::randomToken(16);
        }
        return self::$nonce;
    }
}
