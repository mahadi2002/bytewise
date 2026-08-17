<?php
/**
 * Renders the "বাইট ট্রি" (Byte Tree) shape from BUILD-SPEC §4: ✓ complete
 * (accent-terminal), N% partial (accent-gold), 🔒 locked (text-muted).
 * Expects $tree (SkillTreeService::build() output) and $language.
 */
?>
<div class="skill-tree">
    <p class="skill-tree-track"><?= e($language['name_bn']) ?></p>
    <ul class="skill-tree-list">
        <?php foreach ($tree as $node): ?>
            <?php $m = $node['module']; ?>
            <?php $locked = $node['state'] === 'locked'; ?>
            <li class="skill-node skill-node-<?= e($node['state']) ?>">
                <?php if ($locked): ?>
                    <span class="skill-icon skill-icon-locked" aria-label="লক করা">🔒</span>
                    <span class="skill-title"><?= e($m['title_bn']) ?></span>
                <?php else: ?>
                    <a class="skill-node-link" href="<?= e(url('/courses/' . $language['slug'] . '/' . $m['slug'])) ?>">
                        <?php if ($node['state'] === 'complete'): ?>
                            <span class="skill-icon skill-icon-complete" aria-label="সম্পন্ন">✓</span>
                        <?php elseif ($node['state'] === 'partial'): ?>
                            <span class="skill-icon skill-icon-partial" aria-label="<?= e((string) $node['percent']) ?> শতাংশ সম্পন্ন"><?= e((string) $node['percent']) ?>%</span>
                        <?php else: ?>
                            <span class="skill-icon skill-icon-not-started" aria-label="শুরু হয়নি">0%</span>
                        <?php endif; ?>
                        <span class="skill-title"><?= e($m['title_bn']) ?></span>
                    </a>
                <?php endif; ?>
            </li>
        <?php endforeach; ?>
    </ul>
</div>
