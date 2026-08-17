<?php $this->layout('layouts/public', ['title' => $problem['title_bn']]); ?>
<section class="problem-page">
    <h1><?= e($problem['title_bn']) ?> <span class="difficulty-badge difficulty-<?= e($problem['difficulty']) ?>"><?= e($problem['difficulty']) ?></span></h1>

    <div class="problem-statement"><?= \App\Support\Markdown::toHtml($problem['statement_md']) ?></div>

    <form method="post" action="<?= e(url('/problems/' . $problem['id'] . '/submit')) ?>" class="submit-form">
        <?= csrf_field() ?>
        <?php if (!$isAgnostic && $language !== null): ?>
            <input type="hidden" name="language_id" value="<?= e((string) $language['id']) ?>">
            <p class="hint">ভাষা: <?= e($language['name_bn']) ?></p>
        <?php else: ?>
            <label for="language_id">ভাষা বেছে নিন</label>
            <select name="language_id" id="language_id" required>
                <option value="">-- ভাষা --</option>
                <?php foreach ($pickableLanguages as $lang): ?>
                    <option value="<?= e((string) $lang['id']) ?>"><?= e($lang['name_bn']) ?></option>
                <?php endforeach; ?>
            </select>
        <?php endif; ?>
        <textarea name="source_code" class="code-editor" rows="14" spellcheck="false"><?= e($problem['starter_code'] ?? '') ?></textarea>
        <button type="submit" class="btn btn-accent">Submit করুন</button>
    </form>
</section>
