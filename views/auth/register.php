<?php $this->layout('layouts/public', ['title' => 'রেজিস্ট্রেশন']); ?>
<section class="auth-page">
    <h1>রেজিস্ট্রেশন</h1>

    <form method="post" action="<?= e(url('/register')) ?>" class="auth-form">
        <?= csrf_field() ?>
        <label for="email">ইমেইল</label>
        <input type="email" id="email" name="email" value="<?= e(old('email')) ?>" required autofocus>
        <?php if (error_for('email')): ?><p class="form-error"><?= e(error_for('email')) ?></p><?php endif; ?>

        <label for="password">পাসওয়ার্ড</label>
        <input type="password" id="password" name="password" minlength="8" required>
        <?php if (error_for('password')): ?><p class="form-error"><?= e(error_for('password')) ?></p><?php endif; ?>
        <p class="hint">কমপক্ষে ৮ অক্ষর</p>

        <label for="password_confirmation">পাসওয়ার্ড আবার লিখুন</label>
        <input type="password" id="password_confirmation" name="password_confirmation" minlength="8" required>
        <?php if (error_for('password_confirmation')): ?><p class="form-error"><?= e(error_for('password_confirmation')) ?></p><?php endif; ?>

        <button type="submit" class="btn btn-accent">অ্যাকাউন্ট তৈরি করুন</button>
    </form>

    <p class="hint">ইতিমধ্যে অ্যাকাউন্ট আছে? <a href="<?= e(url('/login')) ?>">লগইন করুন</a></p>
</section>
