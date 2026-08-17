<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

final class OtpRequestRepository
{
    public function latestPending(string $mobileHash, string $purpose): ?array
    {
        return Db::first(
            'SELECT * FROM otp_requests WHERE mobile_hash = ? AND purpose = ? AND consumed_at IS NULL
             ORDER BY id DESC LIMIT 1',
            [$mobileHash, $purpose]
        );
    }

    public function invalidatePending(string $mobileHash, string $purpose): void
    {
        Db::exec(
            'UPDATE otp_requests SET consumed_at = NOW() WHERE mobile_hash = ? AND purpose = ? AND consumed_at IS NULL',
            [$mobileHash, $purpose]
        );
    }

    public function create(string $mobileHash, string $otpHash, string $purpose, int $ttlSeconds, string $requestIp): int
    {
        return Db::insert(
            'INSERT INTO otp_requests (mobile_hash, otp_hash, purpose, expires_at, request_ip)
             VALUES (?, ?, ?, DATE_ADD(NOW(), INTERVAL ? SECOND), INET6_ATON(?))',
            [$mobileHash, $otpHash, $purpose, $ttlSeconds, $requestIp]
        );
    }

    public function incrementAttempts(int $id): void
    {
        Db::exec('UPDATE otp_requests SET attempt_count = attempt_count + 1 WHERE id = ?', [$id]);
    }

    public function markConsumed(int $id): void
    {
        Db::exec('UPDATE otp_requests SET consumed_at = NOW() WHERE id = ?', [$id]);
    }
}
