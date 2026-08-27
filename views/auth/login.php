<?php $this->layout('layouts/public', ['title' => 'লগইন']); ?>
<section class="auth-page">
    <h1>লগইন</h1>

    <form method="post" action="<?= e(url('/login')) ?>" class="auth-form">
        <?= csrf_field() ?>
        <label for="email">ইমেইল</label>
        <input type="email" id="email" name="email" value="<?= e(old('email')) ?>" required autofocus>

        <label for="password">পাসওয়ার্ড</label>
        <input type="password" id="password" name="password" required>

        <button type="submit" class="btn btn-accent">লগইন করুন</button>
    </form>

    <p class="hint"><a href="<?= e(url('/forgot-password')) ?>">পাসওয়ার্ড ভুলে গেছেন?</a></p>
    <p class="hint">অ্যাকাউন্ট নেই? <a href="<?= e(url('/register')) ?>">রেজিস্ট্রেশন করুন</a></p>
</section>
