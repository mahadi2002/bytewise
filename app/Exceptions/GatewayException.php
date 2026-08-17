<?php
declare(strict_types=1);

namespace App\Exceptions;

use RuntimeException;

/** Thrown by CarrierGateway/RemoteJudgeGateway when unconfigured or the remote call fails. */
class GatewayException extends RuntimeException
{
}
