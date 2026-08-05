<?php

namespace App\Http\Middleware;

use App\Services\AuditLogger;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * SRS §25.3 middleware stack, final step. Applied only to routes whose audit
 * `action` name can be derived generically from the route itself (e.g.
 * `intervention.status_change`, `user.deactivate`). Events whose action name
 * depends on outcome (login vs. login_failed) are logged explicitly by their
 * controller via {@see AuditLogger} instead — see AuthController.
 */
class LogAuditTrail
{
    public function __construct(private readonly AuditLogger $auditLogger) {}

    public function handle(Request $request, Closure $next, string $action): Response
    {
        $response = $next($request);

        if ($response->isSuccessful()) {
            $this->auditLogger->log($action, $request->user(), $request);
        }

        return $response;
    }
}
