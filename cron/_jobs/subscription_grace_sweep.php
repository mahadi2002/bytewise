<?php
declare(strict_types=1);

/**
 * Two-step sweep, invoked once/day via cron/run-jobs.php's job guard:
 *  1. Every 'active' subscription is re-checked against SubscriptionGateway
 *     ::checkStatus(); a non-active carrier status moves it into 'grace'.
 *  2. Any subscription that has been in 'grace' longer than
 *     GRACE_PERIOD_DAYS moves to 'expired'.
 *
 * Runs inside cron/run-jobs.php's try/catch — no local error handling here.
 */

use App\Gateways\GatewayFactory;
use App\Repositories\BillingEventRepository;
use App\Repositories\SubscriptionRepository;
use App\Core\Db;

const GRACE_PERIOD_DAYS = 3;

$subRepo = new SubscriptionRepository();
$billing = new BillingEventRepository();
$gateway = GatewayFactory::subscription();

$active = Db::all("SELECT * FROM subscriptions WHERE status = 'active'");
foreach ($active as $sub) {
    if ($sub['gateway_external_ref'] === null) {
        continue;
    }
    $live = $gateway->checkStatus((string) $sub['gateway_external_ref']);
    if ($live->status !== 'active') {
        $subRepo->setStatus((int) $sub['id'], 'grace');
        $billing->log((int) $sub['id'], 'grace_entered');
    }
}

$cutoff = date('Y-m-d H:i:s', strtotime('-' . GRACE_PERIOD_DAYS . ' days'));
$graceExpired = $subRepo->graceExpiredBefore($cutoff);
foreach ($graceExpired as $sub) {
    $subRepo->setStatus((int) $sub['id'], 'expired');
    $billing->log((int) $sub['id'], 'expired');
}
