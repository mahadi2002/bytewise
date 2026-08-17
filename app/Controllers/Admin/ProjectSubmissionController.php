<?php
declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Core\Controller;
use App\Core\Request;
use App\Core\Response;
use App\Core\Session;
use App\Repositories\ProjectSubmissionRepository;
use App\Services\ProjectReviewService;

final class ProjectSubmissionController extends Controller
{
    public function index(Request $request): Response
    {
        return $this->view('admin/project-submissions', [
            'title' => 'Project Submissions',
            'admin' => true,
            'queue' => (new ProjectSubmissionRepository())->pendingQueue(),
        ]);
    }

    public function approve(Request $request, string $id): Response
    {
        ProjectReviewService::approve((int) $id, (int) $this->currentAdminId(), $request->str('notes') ?: null);
        Session::notify('success', 'Approved.');
        return $this->redirect(url('/admin/project-submissions'));
    }

    public function requestChanges(Request $request, string $id): Response
    {
        ProjectReviewService::requestChanges((int) $id, (int) $this->currentAdminId(), $request->str('notes') ?: null);
        Session::notify('info', 'Changes requested.');
        return $this->redirect(url('/admin/project-submissions'));
    }
}
