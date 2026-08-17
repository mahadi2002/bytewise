<?php $this->layout('layouts/public', ['title' => 'Unsubscribe']); ?>
<?php $status = $subscription['status'] ?? 'pending'; ?>
<section class="unsubscribe-confirm">
    <h1>Unsubscribe করবেন?</h1>
    <p>Unsubscribe করলে আপনার দৈনিক চার্জ বন্ধ হয়ে যাবে এবং Bytewise-এর গেটেড কনটেন্ট আর দেখতে পারবেন না। যেকোনো সময় আবার Subscribe করতে পারবেন।</p>

    <?php if ($status !== 'unsubscribed'): ?>
        <form method="post" action="<?= e(url('/unsubscribe')) ?>">
            <?= csrf_field() ?>
            <button type="submit" class="btn btn-danger">হ্যাঁ, Unsubscribe করুন</button>
        </form>
    <?php else: ?>
        <p>আপনি ইতিমধ্যে Unsubscribe করেছেন।</p>
    <?php endif; ?>

    <a href="<?= e(url('/account')) ?>">অ্যাকাউন্টে ফিরে যান</a>
</section>
