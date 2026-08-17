<?php $this->layout('layouts/public', ['title' => 'অনেকবার চেষ্টা করা হয়েছে']); ?>
<div class="error-page">
    <h1>৪২৯</h1>
    <p><?= e($message !== '' ? $message : 'অনেকবার চেষ্টা করা হয়েছে। একটু পরে আবার চেষ্টা করুন।') ?></p>
</div>
