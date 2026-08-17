<?php
declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Core\Controller;
use App\Core\Crypto;
use App\Core\RateLimit;
use App\Core\Request;
use App\Core\Response;
use App\Core\Session;
use App\Exceptions\HttpException;
use App\Repositories\AdminUserRepository;
use App\Support\Totp;

/**
 * Admin auth is intentionally separate from student OTP auth — password +
 * TOTP 2FA, own session namespace (admin_user_id, never user_id). Per
 * BUILD-SPEC §9: a small trusted staff set, not the OTP-per-SMS flow.
 */
final class AdminAuthController extends Controller
{
    public function loginForm(Request $request): Response
    {
        if (Session::adminUserId() !== null) {
            return $this->redirect(url('/admin/dashboard'));
        }
        return $this->view('admin/login', ['title' => 'Admin Login']);
    }

    public function login(Request $request): Response
    {
        $email = strtolower($request->str('email'));
        $key   = 'admin_login:' . Crypto::blindIndex($email) . ':' . $request->ipHash();

        $wait = RateLimit::tooMany('admin_login', $key);
        if ($wait !== null) {
            throw new HttpException(429, 'অনেকবার চেষ্টা করা হয়েছে। ' . RateLimit::humanWait($wait) . ' পর আবার চেষ্টা করুন।');
        }
        RateLimit::hit('admin_login', $key);

        $admin = (new AdminUserRepository())->findByEmail($email);

        if ($admin === null || $admin['status'] !== 'active' || !password_verify($request->str('password'), (string) $admin['password_hash'])) {
            Session::notify('error', 'ভুল Email অথবা Password।');
            return $this->redirect(url('/admin/login'));
        }

        $secret = Crypto::decrypt((string) $admin['totp_secret_encrypted']);
        $totp   = $request->str('totp');

        if ($secret === null || !Totp::verify($secret, $totp)) {
            Session::notify('error', 'ভুল Authenticator কোড।');
            return $this->redirect(url('/admin/login'));
        }

        Session::regenerate();
        Session::put('admin_user_id', (int) $admin['id']);
        (new AdminUserRepository())->touchLastLogin((int) $admin['id']);

        return $this->redirect(url('/admin/dashboard'));
    }

    public function logout(Request $request): Response
    {
        Session::forget('admin_user_id');
        Session::destroyAll();
        return $this->redirect(url('/admin/login'));
    }
}
