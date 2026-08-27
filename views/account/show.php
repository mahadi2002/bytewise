<?php $this->layout('layouts/public', ['title' => 'আমার অ্যাকাউন্ট']); ?>
<section class="account-status">
    <h1>আমার অ্যাকাউন্ট</h1>
    <p><strong>ইমেইল:</strong> <?= e($user['email'] ?? '') ?></p>
    <p><strong>যোগদানের তারিখ:</strong> <?= e($user['created_at'] ?? '') ?></p>
</section>
