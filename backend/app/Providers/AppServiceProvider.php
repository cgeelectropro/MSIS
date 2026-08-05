<?php

namespace App\Providers;

use App\Models\PieceJointe;
use Illuminate\Auth\Notifications\ResetPassword;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void {}

    public function boot(): void
    {
        // SRS §18.2: this is a pure API backend with no web reset form, so the
        // reset link deep-links directly into the Flutter app (SCR-04) instead
        // of a Laravel Blade `password.reset` route, which this project has none of.
        ResetPassword::createUrlUsing(function ($notifiable, string $token) {
            $scheme = config('app.frontend_scheme', 'msisapp');

            return "{$scheme}://reset-password?token={$token}&email=".urlencode($notifiable->getEmailForPasswordReset());
        });

        // Gap Analysis D-30: delete the physical file whenever its row is deleted
        // via Eloquent. Note: this model event does NOT fire for the database-level
        // ON DELETE CASCADE triggered by a parent intervention/message being deleted
        // directly in SQL — only Eloquent-initiated deletes. Covering the DB-cascade
        // path would require a scheduled orphan-file sweep; out of MVP scope for now.
        PieceJointe::deleting(fn (PieceJointe $pieceJointe) => $pieceJointe->deleteFile());
    }
}
