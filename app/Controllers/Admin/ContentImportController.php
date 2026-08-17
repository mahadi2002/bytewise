<?php
declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Core\Controller;
use App\Core\Request;
use App\Core\Response;
use App\Repositories\LessonRepository;
use App\Repositories\ModuleRepository;

/**
 * CSV bulk import for lessons — BUILD-SPEC §6/§8: a malformed row is
 * skipped and listed in the report, the import continues for valid rows,
 * never a hard fail on the whole batch. This is the mechanism that lets
 * the admin CSV import pipeline exist so seed content (flagged unverified,
 * see TODO.md BLOCKER-5) can be replaced without a code deploy.
 *
 * Expected header row: module_id,slug,title_bn,title_en,body_md,
 * code_sample,code_sample_language,xp_reward,is_free_preview,sort_order
 */
final class ContentImportController extends Controller
{
    public function show(Request $request): Response
    {
        return $this->view('admin/content-import', ['title' => 'Content Import', 'admin' => true, 'report' => null]);
    }

    public function import(Request $request): Response
    {
        $file = $request->file('csv');
        if ($file === null || $file['error'] !== UPLOAD_ERR_OK) {
            return $this->view('admin/content-import', [
                'title' => 'Content Import', 'admin' => true,
                'report' => ['error' => 'কোনো ফাইল আপলোড করা হয়নি বা আপলোড ব্যর্থ হয়েছে।'],
            ]);
        }

        $handle = fopen($file['tmp_name'], 'r');
        if ($handle === false) {
            return $this->view('admin/content-import', ['title' => 'Content Import', 'admin' => true, 'report' => ['error' => 'ফাইল পড়া যায়নি।']]);
        }

        $header = fgetcsv($handle);
        $required = ['module_id', 'slug', 'title_bn', 'title_en', 'body_md'];

        $ok = [];
        $skipped = [];
        $rowNum = 1;

        $lessonRepo = new LessonRepository();
        $moduleRepo = new ModuleRepository();

        while (($row = fgetcsv($handle)) !== false) {
            $rowNum++;
            if ($header === false || count($row) !== count($header)) {
                $skipped[] = "Row {$rowNum}: column count mismatch.";
                continue;
            }

            $data = array_combine($header, $row);
            if ($data === false) {
                $skipped[] = "Row {$rowNum}: could not map columns.";
                continue;
            }

            $missing = array_filter($required, static fn(string $k): bool => trim((string) ($data[$k] ?? '')) === '');
            if ($missing !== []) {
                $skipped[] = "Row {$rowNum}: missing " . implode(', ', $missing) . '.';
                continue;
            }

            if ($moduleRepo->find((int) $data['module_id']) === null) {
                $skipped[] = "Row {$rowNum}: module_id {$data['module_id']} does not exist.";
                continue;
            }

            try {
                $id = $lessonRepo->create([
                    'module_id'            => (int) $data['module_id'],
                    'slug'                 => $data['slug'],
                    'title_bn'             => $data['title_bn'],
                    'title_en'             => $data['title_en'],
                    'body_md'              => $data['body_md'],
                    'code_sample'          => $data['code_sample'] ?? null,
                    'code_sample_language' => $data['code_sample_language'] ?? null,
                    'xp_reward'            => (int) ($data['xp_reward'] ?? 10),
                    'is_free_preview'      => (int) ($data['is_free_preview'] ?? 0),
                    'sort_order'           => (int) ($data['sort_order'] ?? 1),
                ]);
                $ok[] = "Row {$rowNum}: created lesson #{$id} ({$data['slug']}).";
            } catch (\Throwable $e) {
                $skipped[] = "Row {$rowNum}: " . $e->getMessage();
            }
        }

        fclose($handle);

        return $this->view('admin/content-import', [
            'title' => 'Content Import', 'admin' => true,
            'report' => ['ok' => $ok, 'skipped' => $skipped],
        ]);
    }
}
