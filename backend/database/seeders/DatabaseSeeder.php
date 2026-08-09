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
        // row to show. Not factory-built: fakerphp/faker is require-dev and
        // the Render image is built with `composer install --no-dev`, so
        // `fake()` isn't available at runtime there.
        foreach ([
            ['nom' => 'Technicien Deux', 'email' => 'technicien2@msis.test', 'role' => UserRole::Technicien, 'phone' => '+237600000004'],
            ['nom' => 'Technicien Trois', 'email' => 'technicien3@msis.test', 'role' => UserRole::Technicien, 'phone' => '+237600000005'],
            ['nom' => 'Client Deux', 'email' => 'client2@msis.test', 'role' => UserRole::Client, 'phone' => '+237600000006'],
            ['nom' => 'Client Trois', 'email' => 'client3@msis.test', 'role' => UserRole::Client, 'phone' => '+237600000007'],
        ] as $extra) {
            User::updateOrCreate(
                ['email' => $extra['email']],
                [
                    'nom' => $extra['nom'],
                    'password' => Hash::make('Password123!'),
                    'role' => $extra['role'],
                    'telephone' => $extra['phone'],
                    'actif' => true,
                    'email_verified_at' => now(),
                ],
            );
        }
    }
}
