<?php
declare(strict_types=1);

namespace App\Middleware;

use App\Core\Request;
use App\Core\Response;
use App\Core\Session;

final class RequireAuth implements Middleware
{
    public function handle(Request $request, callable $next): Response
    {
        if (Session::userId() === null) {
            Session::flash('_notice', ['type' => 'info', 'text' => 'চালিয়ে যেতে লগইন করুন।']);
            return Response::redirect(url('/'));
        }
        return $next($request);
    }
}
