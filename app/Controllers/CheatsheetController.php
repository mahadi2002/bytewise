<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Core\Controller;
use App\Core\Request;
use App\Core\Response;
use App\Repositories\CheatsheetRepository;
use App\Repositories\LanguageRepository;

final class CheatsheetController extends Controller
{
    /** GET /cheatsheets/{track} — [F] summary only, syntax highlights. */
    public function summary(Request $request, string $track): Response
    {
        $language = (new LanguageRepository())->findBySlug($track);
        if ($language === null) {
            $this->notFound();
        }

        $sheet = (new CheatsheetRepository())->summaryForLanguage((int) $language['id']);

        return $this->view('cheatsheets/show', [
            'title'    => $language['name_bn'] . ' চিট শিট',
            'language' => $language,
            'sheet'    => $sheet,
            'full'     => false,
        ]);
    }

    /** GET /cheatsheets/{track}/full — [G] full detailed sheet. */
    public function full(Request $request, string $track): Response
    {
        $language = (new LanguageRepository())->findBySlug($track);
        if ($language === null) {
            $this->notFound();
        }

        $sheet = (new CheatsheetRepository())->fullForLanguage((int) $language['id']);

        return $this->view('cheatsheets/show', [
            'title'    => $language['name_bn'] . ' চিট শিট',
            'language' => $language,
            'sheet'    => $sheet,
            'full'     => true,
        ]);
    }
}
