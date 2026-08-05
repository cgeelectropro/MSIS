<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

/** SRS FR-USR-05 / §21.1 email channel. */
class TechnicianInvitation extends Notification
{
    use Queueable;

    public function __construct(private readonly string $temporaryPassword) {}

    public function via(object $notifiable): array
    {
        return ['mail'];
    }

    public function toMail(object $notifiable): MailMessage
    {
        return (new MailMessage)
            ->subject('Invitation MSIS — Compte Technicien')
            ->greeting("Bonjour {$notifiable->nom},")
            ->line('Un compte Technicien a été créé pour vous sur la plateforme MSIS.')
            ->line("Mot de passe temporaire : {$this->temporaryPassword}")
            ->line('Veuillez le modifier dès votre première connexion.');
    }
}
