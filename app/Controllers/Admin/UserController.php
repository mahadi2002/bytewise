<?php
declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Core\Controller;
use App\Core\Request;
use App\Core\Response;
use App\Repositories\AuditLogRepository;
use App\Repositories\UserRepository;

/**
 * PII (mobile number) shown decrypted only on explicit per-row reveal,
 * itself audit-logged — BUILD-SPEC §5 route table / 03-ENV-AND-CONFIG.md
 * §10 security checklist.
 */
final class UserController extends Controller
{
    public function index(Request $request): Response
    {
        return $this->view('admin/users', ['title' => 'Users', 'admin' => true, 'users' => (new UserRepository())->all(), 'revealed' => null]);
    }

    public function reveal(Request $request, string $id): Response
    {
        $repo = new UserRepository();
        $user = $repo->find((int) $id);
        if ($user === null) {
            $this->notFound();
        }

        $mobile = $repo->decryptedMobile($user);

        (new AuditLogRepository())->log(
            'admin',
            $this->currentAdminId(),
            'user.pii_reveal',
            'users',
            (int) $id,
            ['field' => 'mobile_number'],
            $request->ip()
        );

        return $this->view('admin/users', [
            'title' => 'Users', 'admin' => true,
            'users' => $repo->all(),
            'revealed' => ['user_id' => (int) $id, 'mobile' => $mobile],
        ]);
    }
}
