<?php $this->layout('layouts/public', ['title' => 'যোগাযোগ']); ?>
<section class="static-page contact-page">
    <h1>যোগাযোগ</h1>
    <form method="post" action="<?= e(url('/contact')) ?>" class="contact-form">
        <?= csrf_field() ?>
        <!-- Honeypot: real users never see/fill this (CSS-hidden); a bot filling it trips silent rejection. -->
        <div class="hp-field" aria-hidden="true">
            <label for="website">Website</label>
            <input type="text" id="website" name="website" tabindex="-1" autocomplete="off">
        </div>

        <label for="name">নাম</label>
        <input type="text" id="name" name="name" value="<?= e(old('name')) ?>" required>

        <label for="email_or_mobile">Email অথবা মোবাইল নম্বর</label>
        <input type="text" id="email_or_mobile" name="email_or_mobile" value="<?= e(old('email_or_mobile')) ?>" required>

        <label for="message">মেসেজ</label>
        <textarea id="message" name="message" rows="4" required><?= e(old('message')) ?></textarea>

        <button type="submit" class="btn btn-accent">পাঠান</button>
    </form>
</section>
