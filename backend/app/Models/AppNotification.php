<?php

namespace App\Models;

use App\Enums\NotificationChannel;
use Illuminate\Database\Eloquent\Model;

/**
 * SRS §18.3 `notifications` table. Named `AppNotification` (not `Notification`)
 * to avoid colliding with Laravel's own `Illuminate\Notifications\Notification`
 * base class and its unrelated `database` channel table — see the migration's
 * doc comment for why this app never uses that built-in channel.
 */
class AppNotification extends Model
{
    const UPDATED_AT = null;

    protected $table = 'notifications';

    protected $fillable = ['id_user', 'type', 'canal', 'contenu', 'id_intervention', 'lu'];

    protected function casts(): array
    {
        return [
            'canal' => NotificationChannel::class,
            'lu' => 'boolean',
        ];
    }
}
