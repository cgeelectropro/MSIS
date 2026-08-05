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
