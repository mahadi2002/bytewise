<?php
declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Core\Controller;
use App\Core\Request;
use App\Core\Response;
use App\Repositories\UserRepository;

/**
 * Plain user list. Email/password auth has no PII-reveal step the way the
 * old encrypted-mobile-number storage did — the email column is stored (and
 * shown here) in the clear, so there is nothing to decrypt or audit-log a
 * reveal of.
 */
final class UserController extends Controller
{
    public function index(Request $request): Response
    {
        return $this->view('admin/users', ['title' => 'Users', 'admin' => true, 'users' => (new UserRepository())->all()]);
    }
}
