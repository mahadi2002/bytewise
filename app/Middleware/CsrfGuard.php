<?php
declare(strict_types=1);

namespace App\Middleware;

use App\Core\Csrf;
use App\Core\Request;
use App\Core\Response;
use App\Exceptions\HttpException;

/** Applied to every POST/PATCH/DELETE route via the `csrf` middleware key. */
final class CsrfGuard implements Middleware
{
    public function handle(Request $request, callable $next): Response
    {
        if (in_array($request->method, ['POST', 'PATCH', 'PUT', 'DELETE'], true)) {
            $token = $request->str('_token');
            if (!Csrf::check($token)) {
                Csrf::rotate();
                throw new HttpException(419, 'সেশন মেয়াদোত্তীর্ণ হয়ে গেছে, আবার চেষ্টা করুন।');
            }
        }

        return $next($request);
    }
}
