<?php

use App\Models\Intervention;
use App\Policies\MessagePolicy;
use Illuminate\Support\Facades\Broadcast;

Broadcast::channel('App.Models.User.{id}', function ($user, $id) {
    return (int) $user->id === (int) $id;
});

/**
 * SRS §14.4/§20.1: private conversation channel. Delegates to
 * MessagePolicy::viewConversation — the exact same rule object the REST
 * endpoints use (MessageController@index calls `authorize('viewConversation', ...)`)
 * — rather than re-implementing the boolean check inline, so there is exactly
 * one place this rule is defined and exactly one place it's unit-tested
 * (tests/Feature/Messaging/MessagingTest.php's REST-level access-control
 * cases already cover it end to end).
 *
 * Presence (not just private) so the Flutter client can react to "User
 * Connected"/"User Disconnected" for the typing-indicator UX (SRS FR-DET-10,
 * disabled under polling fallback per Gap Analysis D-29).
 */
Broadcast::channel('intervention.{id}', function ($user, $id) {
    $intervention = Intervention::find($id);

    if (! $intervention) {
        return false;
    }

    $authorized = app(MessagePolicy::class)->viewConversation($user, $intervention);

    return $authorized ? ['id' => $user->id, 'nom' => $user->nom] : false;
});
