/**
 * CodeMirror 6 set-up shared by the interactive problem editor
 * (views/problems/show.php) and every read-only code block (lesson
 * samples + inline quiz snippets in views/lessons/show.php, and the
 * landing-page demo) — "reading and problem-solving share one visual
 * treatment" per the phase-2 brief.
 *
 * Vendored via npm (see package.json) and bundled by Vite into
 * assets/dist/editor.js — never loaded from a CDN, matching this app's
 * zero-external-dependency-at-runtime posture.
 *
 * CSP note: this app's style-src has no 'unsafe-inline' (see
 * app/Middleware/SecurityHeaders.php). CodeMirror injects a <style>
 * element to draw its theme, so every EditorState below carries
 * EditorView.cspNonce.of(nonce()) — the same per-request nonce the PHP
 * layout puts in <meta name="csp-nonce">. Without it the browser silently
 * drops CodeMirror's stylesheet and the editor renders unstyled.
 */
import { EditorView, keymap, lineNumbers, highlightActiveLine, highlightActiveLineGutter, drawSelection } from '@codemirror/view';
import { EditorState, Compartment } from '@codemirror/state';
import { defaultKeymap, history, historyKeymap, indentWithTab } from '@codemirror/commands';
import { indentOnInput, bracketMatching, syntaxHighlighting, HighlightStyle } from '@codemirror/language';
import { closeBrackets, closeBracketsKeymap } from '@codemirror/autocomplete';
import { tags as t } from '@lezer/highlight';
import { cpp } from '@codemirror/lang-cpp';
import { java } from '@codemirror/lang-java';
import { python } from '@codemirror/lang-python';
import { javascript } from '@codemirror/lang-javascript';
import { sql } from '@codemirror/lang-sql';

function nonce() {
    var meta = document.querySelector('meta[name="csp-nonce"]');
    return meta ? (meta.getAttribute('content') || '') : '';
}

// Captured eagerly at module-evaluation time (this script tag is emitted
// before app.js's in views/layouts/public.php) — app.js's typing effect
// clears [data-demo-code] code's textContent synchronously as soon as ITS
// module runs, which happens before DOMContentLoaded fires. Reading the
// length from inside a DOMContentLoaded handler below would always see the
// already-cleared '', so it has to happen here, at the top of this module.
var landingDemoLength = (function () {
    var codeEl = document.querySelector('[data-demo-code] code');
    return codeEl ? (codeEl.textContent || '').length : 0;
})();

/** judge_language_code / code_sample_language values (see 001_content.sql) -> CodeMirror language support. */
function languageExtension(code) {
    switch (String(code || '').toLowerCase()) {
        case 'c':
        case 'cpp':
        case 'c++':
            return cpp();
        case 'java':
            return java();
        case 'python':
        case 'python3':
        case 'py':
            return python();
        case 'javascript':
        case 'js':
            return javascript();
        case 'sql':
            return sql();
        default:
            return [];
    }
}

// Colors pulled straight from app.css's :root tokens via var() — this
// stays in lockstep with the dark-terminal theme automatically, including
// the prefers-contrast:more override, without duplicating hex values here.
var highlightStyle = HighlightStyle.define([
    { tag: t.keyword, color: 'var(--accent-terminal)', fontWeight: '600' },
    { tag: [t.name, t.deleted, t.character, t.propertyName, t.macroName], color: 'var(--text-primary)' },
    { tag: [t.function(t.variableName), t.labelName], color: 'var(--info)' },
    { tag: [t.typeName, t.className, t.namespace, t.self, t.modifier], color: 'var(--accent-gold)' },
    { tag: [t.number, t.bool, t.atom, t.special(t.variableName)], color: 'var(--accent-gold)' },
    { tag: [t.string, t.special(t.string), t.regexp, t.processingInstruction, t.inserted], color: 'var(--accent-gold)' },
    { tag: [t.operator, t.operatorKeyword, t.url, t.escape, t.link], color: 'var(--accent-terminal-hover)' },
    { tag: [t.meta, t.comment], color: 'var(--text-muted)', fontStyle: 'italic' },
    { tag: t.invalid, color: 'var(--danger)' },
    { tag: t.strong, fontWeight: 'bold' },
    { tag: t.emphasis, fontStyle: 'italic' },
    { tag: t.heading, fontWeight: 'bold', color: 'var(--accent-gold)' },
]);

/** Shared base — no border/background here; the two callers below paint their own chrome (editable box vs. inside an existing pre.code-sample). */
function baseTheme(extra) {
    return EditorView.theme(Object.assign({
        '&': { fontSize: '0.9375rem' },
        '.cm-content': { fontFamily: "'JetBrains Mono', monospace", caretColor: 'var(--accent-terminal)' },
        '.cm-cursor, .cm-dropCursor': { borderLeftColor: 'var(--accent-terminal)' },
        '&.cm-focused .cm-selectionBackground, .cm-selectionBackground': { backgroundColor: 'rgba(57, 211, 83, 0.25)' },
        '.cm-matchingBracket, .cm-nonmatchingBracket': { backgroundColor: 'rgba(245, 166, 35, 0.25)', outline: 'none' },
        '.cm-scroller': { fontFamily: 'inherit', lineHeight: '1.6' },
    }, extra), { dark: true });
}

var editableTheme = baseTheme({
    '&': { fontSize: '0.9375rem', backgroundColor: 'var(--surface)', color: 'var(--text-primary)', border: '1px solid var(--border)', borderRadius: '8px' },
    '&.cm-focused': { outline: 'none', borderColor: 'var(--accent-terminal)', boxShadow: '0 0 0 3px rgba(57, 211, 83, 0.15)' },
    '.cm-content': { fontFamily: "'JetBrains Mono', monospace", caretColor: 'var(--accent-terminal)', padding: '1rem 0' },
    '.cm-gutters': { backgroundColor: 'var(--surface)', color: 'var(--text-muted)', border: 'none', borderRight: '1px solid var(--border)' },
    '.cm-activeLine': { backgroundColor: 'rgba(255, 255, 255, 0.03)' },
    '.cm-activeLineGutter': { backgroundColor: 'rgba(255, 255, 255, 0.03)' },
    '.cm-scroller': { fontFamily: 'inherit', lineHeight: '1.6', minHeight: '320px', overflow: 'auto' },
});

var readOnlyTheme = baseTheme({
    '&': { backgroundColor: 'transparent' },
    '.cm-content': { padding: '0' },
    '.cm-scroller': { fontFamily: 'inherit', lineHeight: '1.6', overflow: 'visible' },
});

var readOnlyExtensions = [
    EditorView.editable.of(false),
    EditorState.readOnly.of(true),
    syntaxHighlighting(highlightStyle, { fallback: true }),
    readOnlyTheme,
];

/**
 * Interactive editor for a <textarea class="code-editor"> — the textarea
 * stays in the DOM (hidden, not disabled) so the surrounding <form> keeps
 * POSTing source_code exactly as before; no backend/submission changes.
 */
function mountEditor(textarea) {
    var languageCompartment = new Compartment();
    var initialLanguage = textarea.dataset.language || '';

    var view = new EditorView({
        state: EditorState.create({
            doc: textarea.value,
            extensions: [
                lineNumbers(),
                highlightActiveLine(),
                highlightActiveLineGutter(),
                history(),
                drawSelection(),
                indentOnInput(),
                bracketMatching(),
                closeBrackets(),
                EditorView.lineWrapping,
                keymap.of([
                    // Escape before indentWithTab so keyboard-only users can
                    // always get out: indentWithTab makes Tab indent instead
                    // of moving focus, so without an escape hatch Tab alone
                    // can never leave the editor. Press Escape, then Tab.
                    { key: 'Escape', run: function (v) { v.contentDOM.blur(); return true; } },
                    indentWithTab,
                    ...closeBracketsKeymap,
                    ...defaultKeymap,
                    ...historyKeymap,
                ]),
                languageCompartment.of(languageExtension(initialLanguage)),
                syntaxHighlighting(highlightStyle, { fallback: true }),
                editableTheme,
                EditorView.cspNonce.of(nonce()),
                EditorView.updateListener.of(function (update) {
                    if (update.docChanged) {
                        textarea.value = update.state.doc.toString();
                    }
                }),
            ],
        }),
    });

    var wrapper = document.createElement('div');
    wrapper.className = 'code-editor-cm';
    textarea.insertAdjacentElement('afterend', wrapper);
    wrapper.appendChild(view.dom);
    textarea.setAttribute('hidden', '');

    // The textarea carries aria-describedby (pointing at the visually-hidden
    // "Escape then Tab" hint) in the markup, but hiding it removes it from
    // the accessibility tree — the real focusable surface is CodeMirror's
    // contenteditable contentDOM, so the association has to move there too.
    var describedBy = textarea.getAttribute('aria-describedby');
    if (describedBy) {
        view.contentDOM.setAttribute('aria-describedby', describedBy);
    }

    // Belt-and-suspenders flush right before submit — the updateListener
    // above already keeps textarea.value current on every doc change, this
    // just guarantees it regardless of edge-case event ordering.
    var form = textarea.form;
    if (form) {
        form.addEventListener('submit', function () {
            textarea.value = view.state.doc.toString();
        });
    }

    // Language-agnostic problems (problems.language_id IS NULL): the
    // language picker <select> lives in the same form. Re-highlight for
    // whichever judge_language_code the chosen <option> carries.
    var picker = form ? form.querySelector('select[name="language_id"]') : null;
    if (picker) {
        picker.addEventListener('change', function () {
            var opt = picker.options[picker.selectedIndex];
            var lang = opt ? opt.dataset.lang : '';
            view.dispatch({ effects: languageCompartment.reconfigure(languageExtension(lang)) });
        });
    }
}

/** Read-only highlighted view, mounted inside an existing <pre class="code-sample">. */
function mountReadOnly(container, code, language) {
    var view = new EditorView({
        state: EditorState.create({
            doc: code,
            extensions: readOnlyExtensions.concat([
                languageExtension(language),
                EditorView.cspNonce.of(nonce()),
            ]),
        }),
    });
    container.textContent = '';
    container.appendChild(view.dom);
    return view;
}

function enhanceCodeSample(pre) {
    var codeEl = pre.querySelector('code');
    if (!codeEl) {
        return;
    }
    var code = codeEl.textContent || '';
    var language = pre.dataset.language || '';
    var host = document.createElement('div');
    host.className = 'code-sample-cm';
    pre.insertBefore(host, codeEl);
    codeEl.remove();
    mountReadOnly(host, code, language);
}

/**
 * The landing-page demo keeps its authored "typed out, then runs" moment
 * (app.js owns the typing animation) — once that finishes, the plain text
 * it revealed is swapped for the same highlighted treatment every other
 * code block gets, rather than duplicating a second effect here.
 */
function enhanceLandingDemo() {
    var pre = document.querySelector('[data-demo-code]');
    if (!pre) {
        return;
    }
    var codeEl = pre.querySelector('code');
    if (!codeEl) {
        return;
    }
    var language = pre.dataset.language || 'c';
    var reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    var swap = function () {
        var code = codeEl.textContent || '';
        var cursor = pre.querySelector('.landing-demo-cursor');
        var host = document.createElement('div');
        host.className = 'code-sample-cm';
        pre.insertBefore(host, codeEl);
        codeEl.remove();
        if (cursor) {
            cursor.remove();
        }
        mountReadOnly(host, code, language);
    };

    if (reduceMotion) {
        swap();
        return;
    }
    // app.js's typing effect types the sample out char-by-char then leaves
    // the full text in place; give it its full animation window (500ms
    // start delay + ~18ms/char, see landingDemoLength above) before
    // swapping in the highlighted version.
    var waitMs = 500 + landingDemoLength * 18 + 150;
    window.setTimeout(swap, waitMs);
}

document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('textarea.code-editor').forEach(mountEditor);
    document.querySelectorAll('pre.code-sample').forEach(function (pre) {
        if (pre.hasAttribute('data-demo-code')) {
            return; // handled separately, after its typing animation
        }
        enhanceCodeSample(pre);
    });
    enhanceLandingDemo();
});
