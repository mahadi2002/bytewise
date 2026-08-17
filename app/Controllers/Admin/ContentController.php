<?php
declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Core\Controller;
use App\Core\Request;
use App\Core\Response;
use App\Core\Session;
use App\Repositories\LanguageRepository;
use App\Repositories\LessonRepository;
use App\Repositories\ModuleRepository;
use App\Repositories\ProblemRepository;
use App\Repositories\ProjectRepository;

/**
 * Content CRUD. Lessons get the full create/edit/delete treatment (the
 * surface 04-AI-BUILD-PLAYBOOK.md Phase 14's acceptance test exercises via
 * CSV import); languages/modules/problems/projects get list + create for
 * v1 — edit/delete for those is a documented follow-up (TODO.md), not
 * silently missing.
 */
final class ContentController extends Controller
{
    public function languages(Request $request): Response
    {
        return $this->view('admin/content/languages', ['title' => 'Languages', 'admin' => true, 'languages' => (new LanguageRepository())->allIncludingUnpublished()]);
    }

    public function modules(Request $request): Response
    {
        $languages = (new LanguageRepository())->all();
        $modules = [];
        foreach ($languages as $lang) {
            $modules[$lang['id']] = (new ModuleRepository())->forLanguage((int) $lang['id']);
        }
        return $this->view('admin/content/modules', ['title' => 'Modules', 'admin' => true, 'languages' => $languages, 'modulesByLanguage' => $modules]);
    }

    public function storeModule(Request $request): Response
    {
        (new ModuleRepository())->create(
            $request->int('language_id'),
            $request->str('slug'),
            $request->str('title_bn'),
            $request->str('title_en'),
            $request->int('sort_order', 1)
        );
        Session::notify('success', 'Module created.');
        return $this->redirect(url('/admin/content/modules'));
    }

    public function lessons(Request $request): Response
    {
        return $this->view('admin/content/lessons', ['title' => 'Lessons', 'admin' => true, 'lessons' => (new LessonRepository())->all()]);
    }

    public function createLesson(Request $request): Response
    {
        $languages = (new LanguageRepository())->all();
        $modules = [];
        foreach ($languages as $lang) {
            $modules[$lang['id']] = (new ModuleRepository())->forLanguage((int) $lang['id']);
        }
        return $this->view('admin/content/lesson-form', ['title' => 'New Lesson', 'admin' => true, 'lesson' => null, 'languages' => $languages, 'modulesByLanguage' => $modules]);
    }

    public function storeLesson(Request $request): Response
    {
        (new LessonRepository())->create($request->body());
        Session::notify('success', 'Lesson created.');
        return $this->redirect(url('/admin/content/lessons'));
    }

    public function editLesson(Request $request, string $id): Response
    {
        $lesson = (new LessonRepository())->find((int) $id);
        if ($lesson === null) {
            $this->notFound();
        }
        return $this->view('admin/content/lesson-form', ['title' => 'Edit Lesson', 'admin' => true, 'lesson' => $lesson, 'languages' => [], 'modulesByLanguage' => []]);
    }

    public function updateLesson(Request $request, string $id): Response
    {
        (new LessonRepository())->update((int) $id, $request->body());
        Session::notify('success', 'Lesson updated.');
        return $this->redirect(url('/admin/content/lessons'));
    }

    public function deleteLesson(Request $request, string $id): Response
    {
        (new LessonRepository())->delete((int) $id);
        Session::notify('info', 'Lesson deleted.');
        return $this->redirect(url('/admin/content/lessons'));
    }

    public function problems(Request $request): Response
    {
        return $this->view('admin/content/problems', ['title' => 'Problems', 'admin' => true, 'problems' => (new ProblemRepository())->all(), 'languages' => (new LanguageRepository())->all()]);
    }

    public function storeProblem(Request $request): Response
    {
        (new ProblemRepository())->create($request->body());
        Session::notify('success', 'Problem created.');
        return $this->redirect(url('/admin/content/problems'));
    }

    public function projects(Request $request): Response
    {
        $repo     = new ProjectRepository();
        $projects = $repo->all();
        $languagesByProject = $repo->languagesForProjects(array_column($projects, 'id'));

        return $this->view('admin/content/projects', [
            'title' => 'Projects', 'admin' => true,
            'projects' => $projects,
            'languagesByProject' => $languagesByProject,
            'languages' => (new LanguageRepository())->all(),
        ]);
    }

    public function storeProject(Request $request): Response
    {
        (new ProjectRepository())->create($request->body());
        Session::notify('success', 'Project created.');
        return $this->redirect(url('/admin/content/projects'));
    }
}
