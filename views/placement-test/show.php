<?php $this->layout('layouts/public', ['title' => 'স্কিল ডায়াগনস্টিক টেস্ট']); ?>
<section class="placement-test">
    <h1>স্কিল ডায়াগনস্টিক টেস্ট</h1>
    <p>একটি ট্র্যাক বেছে নিন — কয়েকটি প্রশ্নের ভিত্তিতে আপনার জন্য উপযুক্ত শুরুর মডিউল সাজেস্ট করা হবে। সম্পূর্ণ ফ্রি, লগইন লাগবে না।</p>

    <form method="get" action="<?= e(url('/placement-test')) ?>" class="track-picker">
        <select name="track" data-auto-submit>
            <option value="">ট্র্যাক বেছে নিন</option>
            <?php foreach ($languages as $lang): ?>
                <option value="<?= e($lang['slug']) ?>" <?= ($language['slug'] ?? '') === $lang['slug'] ? 'selected' : '' ?>>
                    <?= e($lang['name_bn']) ?>
                </option>
            <?php endforeach; ?>
        </select>
        <button type="submit" class="btn btn-link">যান</button>
    </form>

    <?php if ($language !== null && empty($questions)): ?>
        <p class="hint"><?= e($language['name_bn']) ?> ট্র্যাকের জন্য প্লেসমেন্ট টেস্ট শীঘ্রই আসছে।</p>
    <?php elseif ($language !== null): ?>
        <form method="post" action="<?= e(url('/placement-test')) ?>" class="quiz-form">
            <?= csrf_field() ?>
            <input type="hidden" name="track" value="<?= e($language['slug']) ?>">
            <?php foreach ($questions as $q): ?>
                <fieldset class="quiz-question">
                    <legend><?= e($q['question_bn']) ?></legend>
                    <?php if (!empty($q['code_snippet'])): ?>
                        <pre class="code-sample"><code><?= e($q['code_snippet']) ?></code></pre>
                    <?php endif; ?>
                    <?php foreach ($q['options'] as $opt): ?>
                        <label class="quiz-option">
                            <input type="radio" name="answers[<?= e((string) $q['id']) ?>]" value="<?= e((string) $opt['id']) ?>" required>
                            <?= e($opt['option_label']) ?>. <?= e($opt['option_text_bn']) ?>
                        </label>
                    <?php endforeach; ?>
                </fieldset>
            <?php endforeach; ?>
            <button type="submit" class="btn btn-accent">জমা দিন</button>
        </form>
    <?php endif; ?>
</section>
