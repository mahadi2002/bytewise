<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Core\Controller;
use App\Core\Request;
use App\Core\Response;
use App\Core\Session;
use App\Core\Validator;
use App\Exceptions\HttpException;
use App\Repositories\ProjectRepository;
use App\Repositories\ProjectSubmissionRepository;
use App\Services\ProjectEligibilityService;

final class ProjectController extends Controller
{
    public function index(Request $request): Response
    {
        $repo     = new ProjectRepository();
        $projects = $repo->all();
        $languagesByProject = $repo->languagesForProjects(array_column($projects, 'id'));

        $userId = (int) $this->currentUserId();
        $eligibility = [];
        foreach ($projects as $p) {
            $eligibility[$p['id']] = ProjectEligibilityService::check((int) $p['id'], $userId)['ready'];
        }
        $statuses = (new ProjectSubmissionRepository())->latestStatusesForUser($userId);

        return $this->view('projects/index', [
            'title'    => 'প্রজেক্ট',
            'projects' => $projects,
            'languagesByProject' => $languagesByProject,
            'eligibility' => $eligibility,
            'statuses' => $statuses,
        ]);
    }

    public function show(Request $request, string $id): Response
    {
        $repo    = new ProjectRepository();
        $project = $repo->findForViewer((int) $id, $this->isAuthenticated());
        if ($project === null || !array_key_exists('brief_md', $project)) {
            $this->notFound();
        }

        $userId     = (int) $this->currentUserId();
        $submission = (new ProjectSubmissionRepository())->latestForUserProject($userId, (int) $id);
        $eligibility = ProjectEligibilityService::check((int) $id, $userId);

        return $this->view('projects/show', [
            'title'      => $project['title_bn'],
            'project'    => $project,
            'submission' => $submission,
            'eligibility'=> $eligibility,
        ]);
    }

    public function submit(Request $request, string $id): Response
    {
        $userId = (int) $this->currentUserId();

        // Hard-gate, server-side — the view already hides the form when
        // ineligible, but that's presentation only; a direct POST must be
        // rejected here too (same defense-in-depth pattern as problems).
        if (!ProjectEligibilityService::check((int) $id, $userId)['ready']) {
            throw new HttpException(403, 'এই প্রজেক্টের জন্য প্রয়োজনীয় ভাষা(গুলো) এখনো সম্পূর্ণ হয়নি।');
        }

        $v = Validator::make($request->body(), [
            'submission_link' => 'required|url|max:500',
            'student_notes'   => 'max:1000',
        ], ['submission_link' => 'লিংক']);

        if ($v->fails()) {
            $v->flash();
            return $this->redirect(url('/projects/' . $id));
        }

        (new ProjectSubmissionRepository())->create(
            $userId,
            (int) $id,
            $v->get('submission_link'),
            $v->get('student_notes') !== '' ? $v->get('student_notes') : null
        );

        Session::notify('success', 'জমা দেওয়া হয়েছে — Admin রিভিউ করার পর ফলাফল জানানো হবে।');
        return $this->redirect(url('/projects/' . $id));
    }
}
