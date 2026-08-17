(function () {
    'use strict';

    var page = document.querySelector('.submission-page');
    if (!page || page.dataset.pending !== '1') {
        return;
    }

    var id = page.dataset.submissionId;
    var attempts = 0;
    var maxAttempts = 20; // ~40s at 2s interval, matches BUILD-SPEC §8's 30s timeout-and-retry note

    function poll() {
        attempts++;
        fetch('/submissions/' + id, { headers: { Accept: 'application/json' } })
            .then(function (res) { return res.json(); })
            .then(function (data) {
                if (data.status === 'queued' || data.status === 'running') {
                    if (attempts >= maxAttempts) {
                        var hint = document.getElementById('poll-hint');
                        if (hint) {
                            hint.textContent = 'যাচাই করতে সময় লাগছে — একটু পরে পাতাটি রিলোড করুন।';
                        }
                        return;
                    }
                    setTimeout(poll, 2000);
                    return;
                }
                window.location.reload();
            })
            .catch(function () {
                if (attempts < maxAttempts) {
                    setTimeout(poll, 2000);
                }
            });
    }

    setTimeout(poll, 2000);
})();
