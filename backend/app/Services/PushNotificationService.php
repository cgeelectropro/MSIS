<?php

namespace App\Services;

use App\Models\User;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

/**
 * SRS §20.1/§21.1 push channel — Firebase Cloud Messaging (HTTP v1 API).
 *
 * This service is the concrete integration point; it is intentionally a safe
 * no-op whenever `services.fcm.credentials_path` isn't set or doesn't point at
 * a readable file (no Firebase project exists in this repository — that's a
 * deployment-time secret, not something to fabricate). Once a service-account
 * JSON is dropped in, this is the only class that needs to work — every
 * caller in the app already goes through here rather than talking to FCM
 * directly. Access tokens minted from that JSON expire hourly, so they're
 * exchanged lazily and cached rather than configured statically.
 */
class PushNotificationService
{
    public function sendToUser(User $user, string $title, string $body, array $data = []): void
    {
        $credentials = $this->credentials();
        if (! $credentials) {
            Log::info('FCM not configured — push suppressed (in-app notification already recorded).', [
                'title' => $title,
            ]);

            return;
        }

        $accessToken = $this->accessToken($credentials);
        if (! $accessToken) {
            Log::warning('FCM token exchange failed — push suppressed.');

            return;
        }

        foreach ($user->deviceTokens()->pluck('token') as $token) {
            $this->send($credentials['project_id'], $accessToken, $token, $title, $body, $data);
        }
    }

    private function send(string $projectId, string $accessToken, string $deviceToken, string $title, string $body, array $data): void
    {
        Http::withToken($accessToken)->post(
            "https://fcm.googleapis.com/v1/projects/{$projectId}/messages:send",
            [
                'message' => [
                    'token' => $deviceToken,
                    'notification' => ['title' => $title, 'body' => $body],
                    'data' => $data,
                ],
            ]
        );
    }

    /** @return array{project_id: string, client_email: string, private_key: string}|null */
    private function credentials(): ?array
    {
        $path = config('services.fcm.credentials_path');
        if (! $path || ! is_readable($path)) {
            return null;
        }

        $json = json_decode(file_get_contents($path), true);
        if (! isset($json['project_id'], $json['client_email'], $json['private_key'])) {
            return null;
        }

        return $json;
    }

    /** Exchanges the service-account JSON for a short-lived OAuth2 bearer token via the JWT-bearer grant (cached ~55min). */
    private function accessToken(array $credentials): ?string
    {
        return Cache::remember('fcm_access_token', 3300, function () use ($credentials) {
            $now = time();
            $header = $this->base64UrlEncode(json_encode(['alg' => 'RS256', 'typ' => 'JWT']));
            $claims = $this->base64UrlEncode(json_encode([
                'iss' => $credentials['client_email'],
                'scope' => 'https://www.googleapis.com/auth/firebase.messaging',
                'aud' => 'https://oauth2.googleapis.com/token',
                'iat' => $now,
                'exp' => $now + 3600,
            ]));

            $signatureInput = "{$header}.{$claims}";
            $signed = openssl_sign($signatureInput, $signature, $credentials['private_key'], OPENSSL_ALGO_SHA256);
            if (! $signed) {
                return null;
            }

            $jwt = $signatureInput.'.'.$this->base64UrlEncode($signature);

            $response = Http::asForm()->post('https://oauth2.googleapis.com/token', [
                'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
                'assertion' => $jwt,
            ]);

            return $response->successful() ? $response->json('access_token') : null;
        });
    }

    private function base64UrlEncode(string $data): string
    {
        return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
    }
}
