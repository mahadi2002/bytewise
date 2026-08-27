<?php
declare(strict_types=1);

namespace App\Middleware;

use App\Core\Request;
use App\Core\Response;

/**
 * Applied globally in public/index.php. No 'unsafe-inline'/'unsafe-eval' —
 * the in-browser code editor widget (CodeMirror, via assets/dist/editor.js)
 * respects this by feeding App\Core\Csp::nonce() into CodeMirror's
 * EditorView.cspNonce facet, so style-src only needs to trust this one
 * per-request nonce rather than 'unsafe-inline'.
 */
final class SecurityHeaders implements Middleware
{
    private const CSP = "default-src 'self'; img-src 'self' data:; style-src 'self' 'nonce-%s'; "
        . "script-src 'self'; font-src 'self'; connect-src 'self'; frame-ancestors 'none'; "
        . "base-uri 'self'; form-action 'self'; object-src 'none'";

    public function __construct(private readonly string $styleNonce = '')
    {
    }

    public function handle(Request $request, callable $next): Response
    {
        $response = $next();

        $response
            ->withHeader('Content-Security-Policy', sprintf(self::CSP, $this->styleNonce))
            ->withHeader('X-Content-Type-Options', 'nosniff')
            ->withHeader('X-Frame-Options', 'DENY')
            ->withHeader('Referrer-Policy', 'strict-origin-when-cross-origin')
            ->withHeader('Permissions-Policy', 'geolocation=(), microphone=(), camera=()')
            ->withHeader('Cross-Origin-Opener-Policy', 'same-origin');

        if (config('app.env') !== 'local') {
            $response->withHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
        }

        return $response;
    }
}
