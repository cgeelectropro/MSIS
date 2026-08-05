<?php

namespace App\Services;

use App\Models\AuditLog;
use App\Models\User;
use Illuminate\Http\Request;

/**
 * SRS §24.1 audit event catalogue / SEC-35. Every sensitive action funnels through
 * this single service so `audit_logs` writes are never scattered ad hoc across
 * Controllers/Services.
 */
class AuditLogger
{
    public function log(string $action, ?User $actor, ?Request $request = null, ?string $entite = null, ?int $entiteId = null): void
    {
        AuditLog::create([
            'id_user' => $actor?->id,
            'action' => $action,
            'entite' => $entite,
            'entite_id' => $entiteId,
            'ip_address' => $request?->ip() ?? '0.0.0.0',
        ]);
    }
}
