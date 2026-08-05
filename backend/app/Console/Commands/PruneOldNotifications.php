<?php

namespace App\Console\Commands;

use App\Models\AppNotification;
use Illuminate\Console\Command;

/**
 * Engineering Recommendation ("Cleanup expired notifications" background
 * task): read notifications older than 90 days are no longer operationally
 * useful in the in-app feed (SCR-14) — unlike `audit_logs`, which has a hard
 * 12-month retention requirement (SRS §18.6/SEC-36), the in-app notification
 * feed has no stated retention rule, so this is a housekeeping default, not
 * a compliance one.
 */
class PruneOldNotifications extends Command
{
    protected $signature = 'app:prune-old-notifications';

    protected $description = 'Delete read in-app notifications older than 90 days';

    public function handle(): void
    {
        $deleted = AppNotification::where('lu', true)
            ->where('created_at', '<', now()->subDays(90))
            ->delete();

        $this->info("Pruned {$deleted} old notification(s).");
    }
}
