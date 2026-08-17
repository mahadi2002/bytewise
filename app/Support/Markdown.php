<?php
declare(strict_types=1);

namespace App\Support;

/**
 * Minimal, hand-rolled Markdown-to-HTML for the small subset lesson/problem
 * content actually uses (bold, inline code, paragraphs) — zero Composer
 * dependencies per the series rule. The source string is HTML-escaped
 * FIRST, then markup is layered on top, so even though body_md/statement_md
 * are admin-authored/trusted (never student input), a raw <script> in the
 * source still can't execute — defense in depth, not just trust.
 */
final class Markdown
{
    public static function toHtml(?string $md): string
    {
        if ($md === null || $md === '') {
            return '';
        }

        $escaped = e($md);

        // Inline code: `code`
        $escaped = (string) preg_replace('/`([^`]+)`/u', '<code>$1</code>', $escaped);
        // Bold: **text**
        $escaped = (string) preg_replace('/\*\*([^*]+)\*\*/u', '<strong>$1</strong>', $escaped);
        // Italic: *text* (after bold, so **x** isn't half-matched)
        $escaped = (string) preg_replace('/(?<!\*)\*([^*]+)\*(?!\*)/u', '<em>$1</em>', $escaped);

        $paragraphs = preg_split('/\n\s*\n/u', trim($escaped)) ?: [];
        $html = array_map(
            static fn(string $p): string => '<p>' . nl2br(trim($p)) . '</p>',
            array_filter($paragraphs, static fn(string $p): bool => trim($p) !== '')
        );

        return implode("\n", $html);
    }
}
