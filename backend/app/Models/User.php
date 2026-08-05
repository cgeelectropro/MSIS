<?php

namespace App\Models;

use App\Enums\UserRole;
use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

/**
 * SRS §18.3. No soft deletes by design (Gap Analysis D-20 / SRS §18.6): `actif=false`
 * is the terminal account lifecycle state for MVP.
 */
class User extends Authenticatable
{
    /** @use HasFactory<UserFactory> */
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'nom',
        'email',
        'password',
        'role',
        'telephone',
        'actif',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'role' => UserRole::class,
            'actif' => 'boolean',
        ];
    }

    public function isAdmin(): bool
    {
        return $this->role === UserRole::Admin;
    }

    public function isTechnicien(): bool
    {
        return $this->role === UserRole::Technicien;
    }

    public function isClient(): bool
    {
        return $this->role === UserRole::Client;
    }

    public function deviceTokens(): HasMany
    {
        return $this->hasMany(DeviceToken::class, 'id_user');
    }
}
