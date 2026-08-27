<?php $this->layout('layouts/public', ['title' => 'Privacy Policy']); ?>
<section class="static-page">
    <h1>Privacy Policy</h1>
    <p>আপনার পাসওয়ার্ড কখনো প্লেইনটেক্সটে সংরক্ষণ করা হয় না — শুধুমাত্র হ্যাশ (PHP <code>password_hash()</code>) সংরক্ষণ করা হয়।</p>
    <p>আমরা আপনার তথ্য তৃতীয় পক্ষের সাথে বিক্রি বা শেয়ার করি না।</p>
    <p>যেকোনো প্রশ্নের জন্য <a href="<?= e(url('/contact')) ?>">যোগাযোগ করুন</a>।</p>
</section>
