<?php

namespace App\Enums;

/** SRS §18.3 notifications.canal / §20.1 channel matrix. */
enum NotificationChannel: string
{
    case Push = 'push';
    case InApp = 'in_app';
    case Email = 'email';
}
