<?php
/**
 * Shared unsubscribe control — included from every account/subscription
 * view so it's never hand-duplicated per state. Reachable regardless of
 * status; only its label copy varies. See 03-ENV-AND-CONFIG.md §10 grep
 * checklist — this partial is the thing being grepped for.
 */
?>
<?php if (($status ?? null) !== 'unsubscribed'): ?>
    <a href="<?= e(url('/unsubscribe')) ?>" class="unsubscribe-link">Unsubscribe করুন</a>
<?php else: ?>
    <a href="<?= e(url('/#subscribe')) ?>" class="btn btn-accent">আবার Subscribe করুন</a>
<?php endif; ?>
