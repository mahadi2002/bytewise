<?php $this->layout('layouts/public', ['title' => 'আমার অ্যাকাউন্ট']); ?>
<?php
$status = $subscription['status'] ?? 'pending';
$labels = [
    'pending'      => 'সাবস্ক্রিপশন এখনো Pending — একটু পর আবার চেক করুন।',
    'active'       => 'আপনার Subscription সক্রিয় আছে। Bytewise-এর সব কনটেন্ট আনলক।',
    'grace'        => 'আপনার শেষ পেমেন্ট ব্যর্থ হয়েছে — গ্রেস পিরিয়ডে আছেন। দ্রুত ব্যালেন্স রিচার্জ করুন, নাহলে অ্যাক্সেস বন্ধ হয়ে যাবে।',
    'expired'      => 'আপনার Subscription মেয়াদোত্তীর্ণ হয়ে গেছে। আবার Subscribe করুন।',
    'unsubscribed' => 'আপনি Unsubscribe করেছেন। আবার Subscribe করতে পারবেন যেকোনো সময়।',
];
?>
<section class="account-status">
    <h1>আমার অ্যাকাউন্ট</h1>
    <p class="status-badge status-<?= e($status) ?>"><?= e($labels[$status] ?? $status) ?></p>
    <?= \App\Core\View::partial('partials/unsubscribe-control', ['status' => $status]) ?>
</section>

<?= \App\Core\View::partial('partials/billing-warning') ?>
