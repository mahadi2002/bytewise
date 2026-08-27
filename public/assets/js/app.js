(function () {
    'use strict';

    // CSP is script-src 'self' with no 'unsafe-inline' — inline onchange/
    // onsubmit attributes are silently blocked by the browser. Every
    // interactive behavior in the app goes through delegated listeners
    // here instead, targeted by data attributes rather than per-element
    // inline handlers.

    document.querySelectorAll('select[data-auto-submit]').forEach(function (el) {
        el.addEventListener('change', function () {
            if (el.form) {
                el.form.submit();
            }
        });
    });

    document.querySelectorAll('form[data-confirm]').forEach(function (form) {
        form.addEventListener('submit', function (event) {
            if (!window.confirm(form.dataset.confirm)) {
                event.preventDefault();
            }
        });
    });

    var reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    // Dashboard stat tiles (XP / streak) count up from 0 once, on load —
    // a small reward-flavored moment, not a routine UI transition, so it's
    // fine that it's a plain rAF tween rather than a spring: there's no
    // gesture to stay interruptible with here.
    if (!reduceMotion) {
        document.querySelectorAll('.stat-value').forEach(function (el) {
            var target = parseInt(el.textContent, 10);
            if (!Number.isFinite(target) || target <= 0) {
                return;
            }
            var start = null;
            var duration = 700;
            el.textContent = '0';
            function tick(ts) {
                if (start === null) start = ts;
                var progress = Math.min((ts - start) / duration, 1);
                var eased = 1 - Math.pow(1 - progress, 3); // ease-out cubic, matches --ease-out's settle character
                el.textContent = String(Math.round(target * eased));
                if (progress < 1) {
                    requestAnimationFrame(tick);
                }
            }
            requestAnimationFrame(tick);
        });
    }

    // Landing-page "try before you subscribe" demo: types the code sample
    // out once, then reveals its output — one authored focal moment, not a
    // loop. Static markup already shows the finished code + output, so a
    // failed script or reduced motion just leaves that default in place.
    if (!reduceMotion) {
        var demoCode = document.querySelector('[data-demo-code] code');
        var demoOutput = document.querySelector('[data-demo-output]');
        if (demoCode && demoOutput) {
            var fullText = demoCode.textContent;
            demoCode.textContent = '';
            demoOutput.classList.add('is-hidden');

            var i = 0;
            var typeNext = function () {
                if (i <= fullText.length) {
                    demoCode.textContent = fullText.slice(0, i);
                    i += 1;
                    setTimeout(typeNext, 18);
                } else {
                    demoOutput.classList.remove('is-hidden');
                }
            };
            setTimeout(typeNext, 500);
        }
    }
})();
