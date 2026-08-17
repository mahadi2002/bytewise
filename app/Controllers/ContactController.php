<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Core\Controller;
use App\Core\RateLimit;
use App\Core\Request;
use App\Core\Response;
use App\Core\Session;
use App\Core\Validator;
use App\Exceptions\HttpException;
use App\Repositories\ContactMessageRepository;

final class ContactController extends Controller
{
    public function show(Request $request): Response
    {
        return $this->view('home/contact', ['title' => 'যোগাযোগ']);
    }

    /** Honeypot per BUILD-SPEC §8: a tripped honeypot returns 200 OK but is never persisted — no signal to the bot. */
    public function submit(Request $request): Response
    {
        if ($request->str('website') !== '') {
            return $this->redirect(url('/contact'));
        }

        $wait = RateLimit::tooMany('contact_form', 'ip:' . $request->ipHash());
        if ($wait !== null) {
            throw new HttpException(429, 'অনেকবার চেষ্টা করা হয়েছে। ' . RateLimit::humanWait($wait) . ' পর আবার চেষ্টা করুন।');
        }
        RateLimit::hit('contact_form', 'ip:' . $request->ipHash());

        $v = Validator::make($request->body(), [
            'name'            => 'required|max:100',
            'email_or_mobile' => 'required|max:191',
            'message'         => 'required|max:2000',
        ], ['name' => 'নাম', 'email_or_mobile' => 'Email/মোবাইল', 'message' => 'মেসেজ']);

        if ($v->fails()) {
            $v->flash();
            return $this->redirect(url('/contact'));
        }

        (new ContactMessageRepository())->create(
            $this->currentUserId(),
            $v->get('name'),
            $v->get('email_or_mobile'),
            $v->get('message')
        );

        Session::notify('success', 'ধন্যবাদ! আমরা শীঘ্রই যোগাযোগ করব।');
        return $this->redirect(url('/contact'));
    }
}
