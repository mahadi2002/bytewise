<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

/** summary_md is free, full_md is the gated column — same branch-the-SELECT rule as LessonRepository. */
final class CheatsheetRepository
{
    public function summaryForLanguage(int $languageId): ?array
    {
        return Db::first('SELECT id, language_id, summary_md, updated_at FROM cheatsheets WHERE language_id = ?', [$languageId]);
    }

    public function fullForLanguage(int $languageId): ?array
    {
        return Db::first('SELECT id, language_id, summary_md, full_md, updated_at FROM cheatsheets WHERE language_id = ?', [$languageId]);
    }
}
