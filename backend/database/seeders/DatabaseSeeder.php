<?php

namespace Database\Seeders;

use App\Enums\UserRole;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Fixed-credential accounts for manual/QA testing against a live
     * deployment. Password for all of them: "Password123!".
     */
    public function run(): void
    {
        User::updateOrCreate(
            ['email' => 'admin@msis.test'],
            [
                'nom' => 'Admin Superviseur',
                'password' => Hash::make('Password123!'),
                'role' => UserRole::Admin,
                'telephone' => '+237600000001',
                'actif' => true,
                'email_verified_at' => now(),
            ],
        );

        User::updateOrCreate(
            ['email' => 'technicien@msis.test'],
            [
                'nom' => 'Technicien Test',
                'password' => Hash::make('Password123!'),
                'role' => UserRole::Technicien,
                'telephone' => '+237600000002',
                'actif' => true,
                'email_verified_at' => now(),
            ],
        );

        User::updateOrCreate(
            ['email' => 'client@msis.test'],
            [
                'nom' => 'Client Test',
                'password' => Hash::make('Password123!'),
                'role' => UserRole::Client,
                'telephone' => '+237600000003',
                'actif' => true,
                'email_verified_at' => now(),
            ],
        );

        // A few extra accounts so list/assignment screens have more than one
        // row to show.
        User::factory()->technicien()->count(2)->create();
        User::factory()->count(3)->create();
    }
}
