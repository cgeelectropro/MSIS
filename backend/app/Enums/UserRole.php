<?php

namespace App\Enums;

/**
 * SRS §18.3 users.role — fixed 3-role RBAC enum (Official Requirement - Report).
 * "Supervisor" in business/UI language maps to ADMIN here (SRS §7).
 */
enum UserRole: string
{
    case Admin = 'ADMIN';
    case Technicien = 'TECHNICIEN';
    case Client = 'CLIENT';
}
