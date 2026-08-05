<?php

namespace App\Http\Controllers\Api\V1;

use App\Enums\UserRole;
use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\ForgotPasswordRequest;
use App\Http\Requests\Auth\LoginRequest;
use App\Http\Requests\Auth\RegisterRequest;
use App\Http\Requests\Auth\ResetPasswordRequest;
use App\Http\Resources\UserResource;
use App\Services\AuthService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/** SRS §18.5 Authentication routes. Thin controller — all logic in AuthService (SRS §25.1). */
class AuthController extends Controller
{
    public function __construct(private readonly AuthService $authService) {}

    public function register(RegisterRequest $request): JsonResponse
    {
        $user = $this->authService->register($request->validated());

        return (new UserResource($user))->response()->setStatusCode(201);
    }

    public function login(LoginRequest $request): JsonResponse
    {
        $result = $this->authService->login(
            $request->string('email'),
            $request->string('password'),
            UserRole::from($request->string('role')->toString()),
            $request
        );

        return response()->json([
            'token' => $result['token'],
            'user' => new UserResource($result['user']),
        ]);
    }

    public function logout(Request $request): JsonResponse
    {
        $this->authService->logout($request->user());

        return response()->json(['message' => 'Déconnecté.']);
    }

    public function logoutAllDevices(Request $request): JsonResponse
    {
        $this->authService->logoutAllDevices($request->user());

        return response()->json(['message' => 'Déconnecté de tous les appareils.']);
    }

    public function refresh(Request $request): JsonResponse
    {
        $token = $this->authService->refresh($request->user());

        return response()->json(['token' => $token]);
    }

    public function forgotPassword(ForgotPasswordRequest $request): JsonResponse
    {
        $this->authService->forgotPassword($request->string('email'));

        // BRULE-015: identical response whether or not the account exists.
        return response()->json([
            'message' => 'Si un compte existe pour cet email, un lien de réinitialisation a été envoyé.',
        ]);
    }

    public function resetPassword(ResetPasswordRequest $request): JsonResponse
    {
        $this->authService->resetPassword($request->validated());

        return response()->json(['message' => 'Mot de passe réinitialisé.']);
    }

    public function me(Request $request): JsonResponse
    {
        return (new UserResource($request->user()))->response();
    }
}
