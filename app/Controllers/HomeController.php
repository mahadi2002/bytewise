<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Core\Controller;
use App\Core\Db;
use App\Core\Request;
use App\Core\Response;

final class HomeController extends Controller
{
    /** A logged-in user has no reason to see the subscribe pitch again — send them to their dashboard. */
    public function index(Request $request): Response
    {
        if ($this->currentUserId() !== null) {
            return $this->redirect(url('/dashboard'));
        }

        return $this->view('landing/index', [
            'extraScripts' => ['dist/editor.js'],
        ]);
    }

    public function faq(Request $request): Response
    {
        return $this->view('home/faq', ['title' => 'FAQ']);
    }

    public function privacy(Request $request): Response
    {
        return $this->view('home/privacy', ['title' => 'Privacy Policy']);
    }

    public function terms(Request $request): Response
    {
        return $this->view('home/terms', ['title' => 'Terms & Conditions']);
    }

    /** Uptime monitor target. Runs a real SELECT 1 — not a hardcoded 200. */
    public function health(Request $request): Response
    {
        try {
            $ok = (int) Db::value('SELECT 1') === 1;
        } catch (\Throwable) {
            $ok = false;
        }

        return $this->json(['status' => $ok ? 'ok' : 'db_unreachable'], $ok ? 200 : 500);
    }
}
