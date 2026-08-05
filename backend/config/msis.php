<?php

/**
 * Centralizes every SRS-named constant so no "magic number" from SRS.md is inlined
 * across the codebase (Implementation Plan §21 configuration checklist).
 */
return [

    // SRS §17.4 / SEC-20: Sanctum token lifetime.
    'auth' => [
        'token_expiration_minutes' => (int) env('SANCTUM_TOKEN_EXPIRATION_MINUTES', 720),
        'max_failed_login_attempts' => 5, // FR-AUTH-07
        'password_reset_token_ttl_minutes' => 60, // §18.2
    ],

    // SRS §17.9 / BRULE-014 rate limits.
    'rate_limits' => [
        'login' => '5,15', // 5 attempts / 15 minutes, per IP+account
        'forgot_password' => '3,60', // 3 requests / hour, per email
        'intervention_create' => '20,60', // 20 / hour, per user
        'message_send' => '60,1', // 60 / minute, per user
    ],

    // SRS §22 / BRULE-009 file upload rules.
    'uploads' => [
        'max_size_kb' => (int) env('MSIS_MAX_UPLOAD_MB', 10) * 1024,
        'max_attachments_per_ticket' => (int) env('MSIS_MAX_ATTACHMENTS_PER_TICKET', 5),
        'allowed_image_mimes' => ['image/jpeg', 'image/png', 'image/webp'],
        'allowed_document_mimes' => ['application/pdf'],
    ],

    // SRS BRULE-007 field validation.
    'validation' => [
        'title_min' => 5,
        'title_max' => 150,
        'description_min' => 10,
        'description_max' => 3000,
    ],

    // SRS BRULE-010 SLA/notification thresholds.
    'sla' => [
        'unassigned_high_priority_hours' => 2,
        'unassigned_default_hours' => 24,
        'resolved_unconfirmed_reminder_days' => 5,
        'auto_closure_days' => 7, // BRULE-011, gated by SRS D-13 — see AutoCloseResolvedInterventions job.
    ],

    // SRS §18.6 / D-26b audit retention.
    'audit' => [
        'retention_months' => 12,
    ],
];
