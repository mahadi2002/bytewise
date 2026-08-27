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
 * Content CRUD. Every resource (languages, modules, lessons, problems,
 * projects) now gets the full create/edit/delete treatment, following the
 * pattern lessons established first: a repository find()/update()/delete()
 * trio, editX/updateX/deleteX controller actions, and an inline-form
 * delete button (POST + CSRF + confirm) on each list row.
 */
final class ContentController extends Controller
{
    public function languages(Request $request): Response
    {
        return $this->view('admin/content/languages', ['title' => 'Languages', 'admin' => true, 'languages' => (new LanguageRepository())->allIncludingUnpublished()]);
    }

    public function editLanguage(Request $request, string $id): Response
    {
        $language = (new LanguageRepository())->findAny((int) $id);
        if ($language === null) {
            $this->notFound();
        }
        return $this->view('admin/content/language-form', ['title' => 'Edit Language', 'admin' => true, 'language' => $language]);
    }

    public function updateLanguage(Request $request, string $id): Response
    {
        (new LanguageRepository())->update((int) $id, $request->body());
        Session::notify('success', 'Language updated.');
        return $this->redirect(url('/admin/languages'));
    }

    public function deleteLanguage(Request $request, string $id): Response
    {
        (new LanguageRepository())->delete((int) $id);
        Session::notify('info', 'Language deleted.');
        return $this->redirect(url('/admin/languages'));
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

    public function editModule(Request $request, string $id): Response
    {
        $module = (new ModuleRepository())->find((int) $id);
        if ($module === null) {
            $this->notFound();
        }
        return $this->view('admin/content/module-form', ['title' => 'Edit Module', 'admin' => true, 'module' => $module]);
    }

    public function updateModule(Request $request, string $id): Response
    {
        (new ModuleRepository())->update(
            (int) $id,
            $request->str('title_bn'),
            $request->str('title_en'),
            $request->int('sort_order', 1),
            $request->int('is_published', 1) === 1
        );
        Session::notify('success', 'Module updated.');
        return $this->redirect(url('/admin/modules'));
    }

    public function deleteModule(Request $request, string $id): Response
    {
        (new ModuleRepository())->delete((int) $id);
        Session::notify('info', 'Module deleted.');
        return $this->redirect(url('/admin/modules'));
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

    public function editProblem(Request $request, string $id): Response
    {
        $problem = (new ProblemRepository())->findAny((int) $id);
        if ($problem === null) {
            $this->notFound();
        }
        return $this->view('admin/content/problem-form', ['title' => 'Edit Problem', 'admin' => true, 'problem' => $problem]);
    }

    public function updateProblem(Request $request, string $id): Response
    {
        (new ProblemRepository())->update((int) $id, $request->body());
        Session::notify('success', 'Problem updated.');
        return $this->redirect(url('/admin/content/problems'));
    }

    public function deleteProblem(Request $request, string $id): Response
    {
        (new ProblemRepository())->delete((int) $id);
        Session::notify('info', 'Problem deleted.');
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

    public function editProject(Request $request, string $id): Response
    {
        $repo    = new ProjectRepository();
        $project = $repo->findAny((int) $id);
        if ($project === null) {
            $this->notFound();
        }
        return $this->view('admin/content/project-form', [
            'title' => 'Edit Project', 'admin' => true,
            'project' => $project,
            'selectedLanguageIds' => array_column($repo->languagesForProject((int) $id), 'id'),
            'languages' => (new LanguageRepository())->all(),
        ]);
    }

    public function updateProject(Request $request, string $id): Response
    {
        (new ProjectRepository())->update((int) $id, $request->body());
        Session::notify('success', 'Project updated.');
        return $this->redirect(url('/admin/content/projects'));
    }

    public function deleteProject(Request $request, string $id): Response
    {
        (new ProjectRepository())->delete((int) $id);
        Session::notify('info', 'Project deleted.');
        return $this->redirect(url('/admin/content/projects'));
    }
}
