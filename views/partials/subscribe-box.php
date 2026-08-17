<section id="subscribe" class="subscribe-box">
    <h2>আপনার Robi বা Airtel Number দিন</h2>
    <p>Instant Access পাবেন সব Bytewise Content-এ!</p>

    <?php if (($notice['type'] ?? null) === 'error' || error_for('mobile_number')): ?>
        <p class="form-error"><?= e(error_for('mobile_number') ?? ($notice['text'] ?? '')) ?></p>
    <?php endif; ?>

    <form method="post" action="<?= e(url('/otp/request')) ?>" class="subscribe-form">
        <?= csrf_field() ?>
        <label for="mobile_number">Mobile Number</label>
        <input type="tel" id="mobile_number" name="mobile_number" placeholder="01XXXXXXXXX"
               value="<?= e(old('mobile_number')) ?>" inputmode="numeric" maxlength="11" required>
        <p class="hint">শুধু Robi (018) ও Airtel (016) Number</p>
        <p class="hint">⚡ <?= e(price_line('full')) ?> — যেকোনো সময় Unsubscribe করুন</p>
        <button type="submit" class="btn btn-accent">OTP পাঠান →</button>
    </form>
</section>
