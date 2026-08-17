<?php $this->layout('layouts/public', ['title' => $lesson['title_bn']]); ?>
<section class="lesson-page quiz-result-page">
    <h1><?= e($lesson['title_bn']) ?></h1>

    <div class="quiz-result-banner <?= $passed ? 'is-passed' : 'is-failed' ?>">
        <p class="quiz-result-score"><?= $passed ? '✓' : '✗' ?> <?= e((string) $scoreCorrect) ?>/<?= e((string) $scoreTotal) ?> সঠিক
            <?php if ($xpAwarded > 0): ?> · +<?= e((string) $xpAwarded) ?> XP<?php endif; ?>
        </p>
        <p class="hint">
            <?= $passed
                ? 'চমৎকার! সব উত্তর সঠিক।'
                : 'কুইজ ঐচ্ছিক — চাইলে নিচের ব্যাখ্যা পড়ে আবার চেষ্টা করুন, অথবা সরাসরি পরবর্তী লেসনে চলে যান।' ?>
        </p>
    </div>

    <?php if (!empty($questions)): ?>
        <ol class="quiz-result-list">
            <?php foreach ($questions as $q): ?>
                <li class="quiz-result-question <?= $q['is_correct'] ? 'is-correct' : 'is-incorrect' ?>">
                    <p class="quiz-result-question-text">
                        <span class="quiz-result-icon"><?= $q['is_correct'] ? '✓' : '✗' ?></span>
                        <?= e($q['question_bn']) ?>
                    </p>
                    <?php if (!empty($q['code_snippet'])): ?>
                        <pre class="code-sample"><code><?= e($q['code_snippet']) ?></code></pre>
                    <?php endif; ?>
                    <ul class="quiz-result-options">
                        <?php foreach ($q['options'] as $opt): ?>
                            <?php
                                $isChosen  = (int) $opt['id'] === (int) ($q['chosen_option_id'] ?? 0);
                                $isCorrect = (bool) $opt['is_correct'];
                                $cls = $isCorrect ? 'is-correct-option' : ($isChosen ? 'is-wrong-choice' : '');
                            ?>
                            <li class="<?= e($cls) ?>">
                                <?= e($opt['option_label']) ?>. <?= e($opt['option_text_bn']) ?>
                                <?php if ($isCorrect): ?><span class="quiz-result-tag">সঠিক উত্তর</span><?php endif; ?>
                                <?php if ($isChosen && !$isCorrect): ?><span class="quiz-result-tag quiz-result-tag-wrong">আপনার উত্তর</span><?php endif; ?>
                            </li>
                        <?php endforeach; ?>
                    </ul>
                    <?php if (!empty($q['explanation_bn'])): ?>
                        <p class="quiz-result-explanation">💡 <?= e($q['explanation_bn']) ?></p>
                    <?php endif; ?>
                </li>
            <?php endforeach; ?>
        </ol>
    <?php endif; ?>

    <div class="quiz-result-actions">
        <form method="post" action="<?= e(url('/lessons/' . $lesson['id'] . '/complete')) ?>" class="lesson-continue-form">
            <?= csrf_field() ?>
            <button type="submit" class="btn btn-accent">পরবর্তী লেসনে যান →</button>
        </form>
        <?php if (!$passed): ?>
            <a href="<?= e(url('/lessons/' . $lesson['id'])) ?>" class="btn btn-ghost">আবার চেষ্টা করুন</a>
        <?php endif; ?>
    </div>
</section>
