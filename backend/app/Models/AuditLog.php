<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/** SRS §18.3 `audit_logs`. No `updated_at` — an audit row is write-once. */
class AuditLog extends Model
{
    const UPDATED_AT = null;

    protected $fillable = [
        'id_user',
        'action',
        'entite',
        'entite_id',
        'ip_address',
    ];
}
