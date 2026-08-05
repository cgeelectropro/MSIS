<?php

use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Schedule;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');

// SRS SEC-21: daily pruning of expired Sanctum tokens.
Schedule::command('sanctum:prune-expired --hours=24')->daily();

// Engineering Recommendation: housekeeping for the in-app notification feed.
Schedule::command('app:prune-old-notifications')->weekly();

// SRS §25.4/DEP-06: nightly database backup, local-disk rotation of 14. See
// BackupDatabase's doc comment re: off-site destination (D-26, still open).
Schedule::command('app:backup-database')->dailyAt('02:00');
