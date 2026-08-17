<?php $this->layout('layouts/public', ['title' => 'সেশন মেয়াদোত্তীর্ণ']); ?>
<div class="error-page">
    <h1>৪১৯</h1>
    <p><?= e($message !== '' ? $message : 'সেশন মেয়াদোত্তীর্ণ হয়ে গেছে। আবার চেষ্টা করুন।') ?></p>
    <a href="<?= e(url('/')) ?>">হোমপেজে ফিরে যান</a>
</div>
