<?php $this->layout('layouts/public', ['title' => $lesson['title_bn']]); ?>
<section class="lesson-page">
    <h1><?= e($lesson['title_bn']) ?></h1>

    <?php if ($locked): ?>
        <div class="lesson-locked-card">
            <p>🔒 এই লেসনটি Subscribe করা থাকলে দেখা যাবে।</p>
            <a href="<?= e(url('/#subscribe')) ?>" class="btn btn-accent">Subscribe করুন</a>
        </div>
    <?php else: ?>
        <p class="content-meta">
            <a href="<?= e(url('/discussion/lesson/' . $lesson['id'])) ?>" class="discussion-cta">💬 আলোচনা (<?= e((string) ($discussionCount ?? 0)) ?>)</a>
        </p>

        <div class="lesson-body"><?= \App\Support\Markdown::toHtml($lesson['body_md']) ?></div>
        <?php if (!empty($lesson['code_sample'])): ?>
            <pre class="code-sample" data-language="<?= e((string) ($lesson['code_sample_language'] ?? '')) ?>"><code><?= e($lesson['code_sample']) ?></code></pre>
        <?php endif; ?>

        <?php if ($completed ?? false): ?>
            <p class="lesson-completed-badge">✓ এই লেসন সম্পন্ন হয়েছে।</p>
        <?php endif; ?>

        <?php if (!empty($questions)): ?>
            <div class="quiz-optional-note">
                🎯 ঐচ্ছিক কুইজ — উত্তর না দিয়েও পরবর্তী লেসনে যেতে পারবেন। সঠিক উত্তরে বাড়তি XP পাবেন।
            </div>
            <form method="post" action="<?= e(url('/lessons/' . $lesson['id'] . '/quiz')) ?>" class="quiz-form">
                <?= csrf_field() ?>
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
                <button type="submit" class="btn btn-price">কুইজ জমা দিন (XP-এর জন্য)</button>
            </form>
        <?php endif; ?>

        <?php if (isset($module)): ?>
            <form method="post" action="<?= e(url('/lessons/' . $lesson['id'] . '/complete')) ?>" class="lesson-continue-form">
                <?= csrf_field() ?>
                <button type="submit" class="btn btn-accent">পরবর্তী লেসনে যান →</button>
            </form>
        <?php endif; ?>
    <?php endif; ?>
</section>
