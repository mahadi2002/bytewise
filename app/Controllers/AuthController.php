<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Core\Controller;
use App\Core\Crypto;
use App\Core\Logger;
use App\Core\RateLimit;
use App\Core\Request;
use App\Core\Response;
use App\Core\Session;
use App\Core\Validator;
use App\Repositories\PasswordResetRepository;
use App\Repositories\UserRepository;
use PDOException;

/**
 * Standard email + password auth. Replaces the old fused OTP-verify /
 * subscription-activate flow entirely — registration now just creates a
 * user row and logs them in, no gateway of any kind involved, since this is
 * a free, login-or-registered-only hobby app with no subscription tier.
 */
final class AuthController extends Controller
{
    /**
     * Pre-generated bcrypt hash of an arbitrary value, used only to give
     * password_verify() something real to chew on when no user was found —
     * see the timing-safety note in login() below.
     */
    private const DUMMY_PASSWORD_HASH = '$2b$10$fQ2fVBccd.K1CnVu/TB7QOjDmg9Pp1GcW1D8byiqjzJooAEuv1wH.';

    public function registerForm(Request $request): Response
    {
        if (Session::userId() !== null) {
            return $this->redirect(url('/dashboard'));
        }
        return $this->view('auth/register', ['title' => 'রেজিস্ট্রেশন']);
    }

    public function register(Request $request): Response
    {
        $key  = $request->ipHash();
        $wait = RateLimit::tooMany('register', $key);
        if ($wait !== null) {
            Session::notify('error', 'অনেকবার চেষ্টা করা হয়েছে। ' . RateLimit::humanWait($wait) . ' পর আবার চেষ্টা করুন।');
            return $this->redirect(url('/register'));
        }
        RateLimit::hit('register', $key);

        $v = Validator::make(
            $request->body(),
            [
                'email'    => 'required|email',
                'password' => 'required|min:8|max:255',
            ],
            ['email' => 'ইমেইল', 'password' => 'পাসওয়ার্ড']
        );

        if ($v->fails()) {
            $v->flash();
            return $this->redirect(url('/register'));
        }

        $email       = strtolower($v->get('email'));
        $password    = (string) $request->input('password', '');
        $confirmation = (string) $request->input('password_confirmation', '');

        if ($password !== $confirmation) {
            Session::flash('_errors', ['password_confirmation' => ['পাসওয়ার্ড দুটি মিলছে না।']]);
            Session::flash('_old', ['email' => $email]);
            return $this->redirect(url('/register'));
        }

        $userRepo = new UserRepository();

        // Duplicate-email check never reveals *why* registration failed —
        // same generic message either way, so this endpoint can't be used
        // to enumerate which emails already have an account.
        if ($userRepo->emailExists($email)) {
            Session::notify('error', 'রেজিস্ট্রেশন সম্পন্ন করা যায়নি। তথ্য যাচাই করে আবার চেষ্টা করুন, অথবা লগইন করুন।');
            Session::flash('_old', ['email' => $email]);
            return $this->redirect(url('/register'));
        }

        try {
            $userId = $userRepo->create($email, password_hash($password, PASSWORD_DEFAULT));
        } catch (PDOException $e) {
            // A concurrent submission can win the emailExists() check above
            // and still collide on uq_users_email by the time create() runs
            // — same generic message the pre-check would have shown, so this
            // race can't be used to enumerate emails either.
            if ($e->getCode() === '23000') {
                Session::notify('error', 'রেজিস্ট্রেশন সম্পন্ন করা যায়নি। তথ্য যাচাই করে আবার চেষ্টা করুন, অথবা লগইন করুন।');
                Session::flash('_old', ['email' => $email]);
                return $this->redirect(url('/register'));
            }
            throw $e;
        }

        Session::regenerate();
        Session::put('user_id', $userId);
        Session::notify('success', 'স্বাগতম! আপনার অ্যাকাউন্ট তৈরি হয়েছে।');

        return $this->redirect(url('/dashboard'));
    }

    public function loginForm(Request $request): Response
    {
        if (Session::userId() !== null) {
            return $this->redirect(url('/dashboard'));
        }
        return $this->view('auth/login', ['title' => 'লগইন']);
    }

    public function login(Request $request): Response
    {
        $email = strtolower($request->str('email'));
        $key   = Crypto::blindIndex($email) . ':' . $request->ipHash();

        $wait = RateLimit::tooMany('login', $key);
        if ($wait !== null) {
            Session::notify('error', 'অনেকবার চেষ্টা করা হয়েছে। ' . RateLimit::humanWait($wait) . ' পর আবার চেষ্টা করুন।');
            return $this->redirect(url('/login'));
        }
        RateLimit::hit('login', $key);

        $user = (new UserRepository())->findByEmail($email);

        // Always run password_verify() against a real bcrypt hash, even
        // when no user was found — otherwise the null-user branch returns
        // immediately while the wrong-password branch pays bcrypt's cost,
        // and that timing gap lets a caller enumerate registered emails.
        $hashToCheck = $user !== null ? (string) $user['password_hash'] : self::DUMMY_PASSWORD_HASH;
        $passwordOk  = password_verify($request->str('password'), $hashToCheck);

        // Generic failure message either way — never reveal whether the
        // email or the password was the wrong part.
        if ($user === null || $user['status'] !== 'active' || !$passwordOk) {
            Session::notify('error', 'ভুল Email অথবা Password।');
            Session::flash('_old', ['email' => $email]);
            return $this->redirect(url('/login'));
        }

        Session::regenerate();
        Session::put('user_id', (int) $user['id']);
        (new UserRepository())->touchLastSeen((int) $user['id']);
        Session::notify('success', 'লগইন সফল হয়েছে!');

        return $this->redirect(url('/dashboard'));
    }

    public function logout(Request $request): Response
    {
        Session::destroyAll();
        return $this->redirect(url('/'));
    }

    public function forgotPasswordForm(Request $request): Response
    {
        return $this->view('auth/forgot-password', ['title' => 'পাসওয়ার্ড ভুলে গেছেন']);
    }

    public function forgotPassword(Request $request): Response
    {
        $v = Validator::make($request->body(), ['email' => 'required|email'], ['email' => 'ইমেইল']);

        if ($v->fails()) {
            $v->flash();
            return $this->redirect(url('/forgot-password'));
        }

        $email = strtolower($v->get('email'));
        $key   = Crypto::blindIndex($email) . ':' . $request->ipHash();

        $wait = RateLimit::tooMany('password_reset_request', $key);
        if ($wait === null) {
            RateLimit::hit('password_reset_request', $key);
            $this->issuePasswordReset($email);
        }
        // else: silently drop it. The response is identical to the success
        // path below either way — no signal to a caller hammering this
        // endpoint about whether they're rate-limited or just unlucky.

        // Always the same message, regardless of whether the email exists,
        // is rate-limited, or a reset mail was actually queued — this
        // endpoint must never let a caller enumerate registered emails.
        Session::notify('success', 'এই ইমেইলটি নিবন্ধিত থাকলে, একটি পাসওয়ার্ড রিসেট লিংক পাঠানো হয়েছে।');
        return $this->redirect(url('/login'));
    }

    private function issuePasswordReset(string $email): void
    {
        $user = (new UserRepository())->findByEmail($email);
        if ($user === null) {
            return;
        }

        $userId = (int) $user['id'];
        $token  = Crypto::randomToken(32);
        $hash   = hash('sha256', $token);

        $resetRepo = new PasswordResetRepository();
        $resetRepo->invalidatePendingForUser($userId);
        $resetRepo->create($userId, $hash, 3600);

        $link    = url('/reset-password/' . $token);
        $subject = (string) config('app.name') . ' — পাসওয়ার্ড রিসেট';
        $body    = "আপনার পাসওয়ার্ড রিসেট করতে এই লিংকে যান (১ ঘণ্টার জন্য বৈধ):\n\n{$link}\n\n"
            . "আপনি যদি এই অনুরোধ না করে থাকেন, এই মেইলটি উপেক্ষা করুন।";

        $sent = @mail($email, $subject, $body, 'From: ' . (string) config('app.mail_from'));
        if (!$sent) {
            Logger::warning('Password reset mail() call failed or is unconfigured', ['user_id' => $userId]);
        }

        // Local dev convenience: no real mail transport is typically
        // configured on a dev machine, so the link is also written to a log
        // file — same pattern the old OTP flow used for its dev codes.
        // Never happens outside APP_ENV=local, and the token itself is
        // already blocked from ever landing in the general 'app' channel by
        // Logger::scrub() — this is a dedicated, separate channel file.
        if (config('app.env') === 'local') {
            Logger::channel('password-reset-dev-links', $email . ' => ' . $link);
        }
    }

    public function resetPasswordForm(Request $request, string $token): Response
    {
        $reset = (new PasswordResetRepository())->findValidByTokenHash(hash('sha256', $token));
        if ($reset === null) {
            Session::notify('error', 'লিংকটি অবৈধ অথবা মেয়াদোত্তীর্ণ। আবার রিসেট অনুরোধ করুন।');
            return $this->redirect(url('/forgot-password'));
        }

        return $this->view('auth/reset-password', ['title' => 'নতুন পাসওয়ার্ড', 'token' => $token]);
    }

    public function resetPassword(Request $request, string $token): Response
    {
        $reset = (new PasswordResetRepository())->findValidByTokenHash(hash('sha256', $token));
        if ($reset === null) {
            Session::notify('error', 'লিংকটি অবৈধ অথবা মেয়াদোত্তীর্ণ। আবার রিসেট অনুরোধ করুন।');
            return $this->redirect(url('/forgot-password'));
        }

        $v = Validator::make($request->body(), ['password' => 'required|min:8|max:255'], ['password' => 'পাসওয়ার্ড']);
        if ($v->fails()) {
            $v->flash();
            return $this->redirect(url('/reset-password/' . $token));
        }

        $password     = (string) $request->input('password', '');
        $confirmation = (string) $request->input('password_confirmation', '');
        if ($password !== $confirmation) {
            Session::flash('_errors', ['password_confirmation' => ['পাসওয়ার্ড দুটি মিলছে না।']]);
            return $this->redirect(url('/reset-password/' . $token));
        }

        $userRepo = new UserRepository();
        $userRepo->updatePassword((int) $reset['user_id'], password_hash($password, PASSWORD_DEFAULT));

        $resetRepo = new PasswordResetRepository();
        $resetRepo->markConsumed((int) $reset['id']);
        $resetRepo->invalidatePendingForUser((int) $reset['user_id']);

        Session::notify('success', 'পাসওয়ার্ড পরিবর্তন হয়েছে। এখন লগইন করুন।');
        return $this->redirect(url('/login'));
    }
}
