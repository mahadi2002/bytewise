<?php $this->layout('layouts/public', ['title' => 'অনুমতি নেই']); ?>
<div class="error-page">
    <h1>৪০৩</h1>
    <p><?= e($message !== '' ? $message : 'এই পাতায় প্রবেশের অনুমতি নেই।') ?></p>
    <a href="<?= e(url('/')) ?>">হোমপেজে ফিরে যান</a>
</div>
