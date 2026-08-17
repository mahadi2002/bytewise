<?php
declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Core\Controller;
use App\Core\Request;
use App\Core\Response;
use App\Repositories\AuditLogRepository;

final class AuditLogController extends Controller
{
    public function index(Request $request): Response
    {
        return $this->view('admin/logs', ['title' => 'Audit Log', 'admin' => true, 'entries' => (new AuditLogRepository())->recent(200)]);
    }
}
