<?php
declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Core\Controller;
use App\Core\Request;
use App\Core\Response;
use App\Repositories\ContactMessageRepository;

final class ContactMessageController extends Controller
{
    public function index(Request $request): Response
    {
        return $this->view('admin/contact', ['title' => 'Contact Messages', 'admin' => true, 'messages' => (new ContactMessageRepository())->all()]);
    }

    public function updateStatus(Request $request, string $id): Response
    {
        $status = $request->str('status');
        if (in_array($status, ['new', 'read', 'resolved'], true)) {
            (new ContactMessageRepository())->setStatus((int) $id, $status);
        }
        return $this->redirect(url('/admin/contact-messages'));
    }
}
