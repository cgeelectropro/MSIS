<?php

namespace App\Services;

use App\Enums\UserRole;
use App\Models\User;
use Illuminate\Auth\Events\PasswordReset;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Password;
use Illuminate\Validation\ValidationException;

/**
 * SRS §14.1 authentication workflow / §17.2-17.4. Controllers stay thin and
 * delegate here; this Service never touches $request beyond what's passed in.
 */
class AuthService
{
    public function __construct(private readonly AuditLogger $auditLogger) {}

    public function register(array $data): User
    {
        return User::create([
            'nom' => $data['nom'],
            'email' => $data['email'],
            'password' => $data['password'],
            'role' => UserRole::Client, // FR-AUTH-11: never trust a client-supplied role at registration.
            'telephone' => $data['telephone'] ?? null,
            'actif' => true,
        ]);
    }

    /**
     * SRS FR-AUTH-06: the client-selected role is re-verified server-side; a
     * mismatch is rejected with the same generic message as a bad password
     * (BRULE-015 anti-enumeration — never confirm which part was wrong).
     *
     * @throws ValidationException
     */
    public function login(string $email, string $password, UserRole $selectedRole, Request $request): array
    {
        $user = User::where('email', $email)->first();

        if (! $user || ! Hash::check($password, $user->password) || $user->role !== $selectedRole) {
            $this->auditLogger->log('login_failed', $user, $request);

            throw ValidationException::withMessages([
                'email' => 'Email ou mot de passe incorrect.',
            ]);
        }

        if (! $user->actif) {
            $this->auditLogger->log('login_failed', $user, $request);

            abort(403, 'Compte désactivé, contactez votre administrateur.');
        }

        $token = $user->createToken('mobile', [$user->role->value]);

        $this->auditLogger->log('login', $user, $request);

        return ['user' => $user, 'token' => $token->plainTextToken];
    }

    public function logout(User $user): void
    {
        $user->currentAccessToken()?->delete();
    }

    /** SRS FR-AUTH-09. */
    public function logoutAllDevices(User $user): void
    {
        $user->tokens()->delete();
    }

    /** SRS SEC-22: revoke-and-reissue, not a true OAuth2 refresh-token grant. */
    public function refresh(User $user): string
    {
        $user->currentAccessToken()?->delete();

        return $user->createToken('mobile', [$user->role->value])->plainTextToken;
    }

    /** SRS BRULE-015: identical outcome regardless of account existence. */
    public function forgotPassword(string $email): void
    {
        Password::sendResetLink(['email' => $email]);
    }

    /**
     * SRS §18.2: successful reset revokes every existing token for the account.
     *
     * @throws ValidationException
     */
    public function resetPassword(array $data): void
    {
        $status = Password::reset(
            $data,
            function (User $user, string $password) {
                $user->forceFill(['password' => $password])->save();
                $user->tokens()->delete();

                event(new PasswordReset($user));

                $this->auditLogger->log('password_reset', $user);
            }
        );

        if ($status !== Password::PASSWORD_RESET) {
            throw ValidationException::withMessages([
                'email' => [__($status)],
            ]);
        }
    }
}
