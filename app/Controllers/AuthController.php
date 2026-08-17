<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Core\Controller;
use App\Core\Request;
use App\Core\Response;
use App\Core\Session;
use App\Core\Validator;
use App\Exceptions\OtpException;
use App\Gateways\GatewayFactory;
use App\Repositories\UserRepository;
use App\Services\OtpService;
use App\Services\SubscriptionService;
use App\Support\Operator;

/**
 * Student subscribe flow — OTP-only, no passwords (rulebook §AUTH). One
 * combined round-trip: mobile -> OTP -> on verify, sign in AND activate the
 * subscription via SubscriptionGateway::confirmSubscription (BUILD-SPEC §5).
 */
final class AuthController extends Controller
{
    public function requestOtp(Request $request): Response
    {
        $v = Validator::make(
            $request->body(),
            ['mobile_number' => 'required|msisdn'],
            ['mobile_number' => 'মোবাইল নম্বর']
        );

        if ($v->fails()) {
            $v->flash();
            return $this->back($request, url('/'));
        }

        $mobile = $v->get('mobile_number');

        if (Operator::fromMobile($mobile) === null) {
            Session::flash('_errors', ['mobile_number' => ['শুধু Robi (018) ও Airtel (016) নম্বর সাপোর্টেড।']]);
            Session::flash('_old', $request->body());
            return $this->back($request, url('/'));
        }

        try {
            (new OtpService())->request($mobile, $request->ipHash());
        } catch (OtpException $e) {
            Session::notify('error', $e->getMessage());
            return $this->back($request, url('/'));
        }

        Session::put('pending_mobile', $mobile);
        Session::notify('success', 'OTP পাঠানো হয়েছে।');

        return $this->redirect(url('/otp/verify'));
    }

    public function verifyForm(Request $request): Response
    {
        $mobile = (string) Session::get('pending_mobile', '');
        if ($mobile === '') {
            return $this->redirect(url('/'));
        }

        return $this->view('subscribe/otp-verify', [
            'title'  => 'OTP যাচাই করুন',
            'mobile' => $mobile,
        ]);
    }

    public function verify(Request $request): Response
    {
        $mobile = (string) Session::get('pending_mobile', '');
        if ($mobile === '') {
            return $this->redirect(url('/'));
        }

        $code = $request->str('otp');

        try {
            (new OtpService())->verify($mobile, $code, $request->ipHash());
        } catch (OtpException $e) {
            Session::notify('error', $e->getMessage());
            return $this->redirect(url('/otp/verify'));
        }

        $operator = Operator::fromMobile($mobile);
        if ($operator === null) {
            // Cannot happen — validated at request time — but never trust it silently.
            Session::notify('error', 'শুধু Robi (018) ও Airtel (016) নম্বর সাপোর্টেড।');
            return $this->redirect(url('/'));
        }

        $userRepo = new UserRepository();
        $user     = $userRepo->findByMobile($mobile);
        $userId   = $user['id'] ?? $userRepo->create($mobile, $operator);
        $userId   = (int) $userId;

        $result = GatewayFactory::subscription()->confirmSubscription($mobile, $code);

        if (!$result->success) {
            Session::notify('error', 'সাবস্ক্রিপশন কনফার্ম করা যায়নি। আবার চেষ্টা করুন।');
            return $this->redirect(url('/otp/verify'));
        }

        SubscriptionService::activate($userId, $result->externalRef, $result->status);

        Session::regenerate();
        Session::put('user_id', $userId);
        Session::forget('pending_mobile');

        if ($result->status === 'active') {
            Session::notify('success', 'সাবস্ক্রাইব সফল হয়েছে! এখন Bytewise-এর সব কনটেন্ট আনলক।');
            return $this->redirect(url('/dashboard'));
        }

        Session::notify('info', 'অ্যাকাউন্ট তৈরি হয়েছে কিন্তু সাবস্ক্রিপশন এখনো সক্রিয় নয়।');
        return $this->redirect(url('/account'));
    }

    public function resend(Request $request): Response
    {
        $mobile = (string) Session::get('pending_mobile', '');
        if ($mobile === '') {
            return $this->redirect(url('/'));
        }

        try {
            (new OtpService())->resend($mobile, $request->ipHash());
            Session::notify('success', 'নতুন কোড পাঠানো হয়েছে।');
        } catch (OtpException $e) {
            Session::notify('error', $e->getMessage());
        }

        return $this->redirect(url('/otp/verify'));
    }

    public function logout(Request $request): Response
    {
        Session::destroyAll();
        return $this->redirect(url('/'));
    }
}
