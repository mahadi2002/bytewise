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
use App\Repositories\DiscussionPostRepository;

final class DiscussionController extends Controller
{
    public function index(Request $request, string $contextType, string $contextId): Response
    {
        $posts = (new DiscussionPostRepository())->forContext($contextType, (int) $contextId);

        return $this->view('discussion/index', [
            'title'       => 'আলোচনা',
            'contextType' => $contextType,
            'contextId'   => (int) $contextId,
            'posts'       => $posts,
        ]);
    }

    public function store(Request $request, string $contextType, string $contextId): Response
    {
        $userId = (int) $this->currentUserId();

        $wait = RateLimit::tooMany('discussion_post', 'user:' . $userId);
        if ($wait !== null) {
            throw new HttpException(429, 'অনেকবার পোস্ট করা হয়েছে। ' . RateLimit::humanWait($wait) . ' পর আবার চেষ্টা করুন।');
        }
        RateLimit::hit('discussion_post', 'user:' . $userId);

        $v = Validator::make($request->body(), ['body_md' => 'required|max:2000'], ['body_md' => 'মেসেজ']);
        if ($v->fails()) {
            Session::notify('error', $v->firstError() ?? 'ইনপুট সঠিক নয়।');
            return $this->redirect(url('/discussion/' . $contextType . '/' . $contextId));
        }

        $parentId = $request->int('parent_post_id') ?: null;

        (new DiscussionPostRepository())->create($userId, $contextType, (int) $contextId, $parentId, $v->get('body_md'));

        return $this->redirect(url('/discussion/' . $contextType . '/' . $contextId));
    }
}
