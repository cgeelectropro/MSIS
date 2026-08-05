<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\User\UpdatePasswordRequest;
use App\Http\Requests\User\UpdateProfileRequest;
use App\Http\Resources\UserResource;
use App\Services\UserService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/** SRS §9.2 Profile & Settings / §18.5. */
class ProfileController extends Controller
{
    public function __construct(private readonly UserService $userService) {}

    public function show(Request $request): UserResource
    {
        return new UserResource($request->user());
    }

    public function update(UpdateProfileRequest $request): UserResource
    {
        return new UserResource($this->userService->updateProfile($request->user(), $request->validated()));
    }

    public function updatePassword(UpdatePasswordRequest $request): JsonResponse
    {
        $this->userService->updatePassword($request->user(), $request->string('password'));

        return response()->json(['message' => 'Mot de passe mis à jour.']);
    }
}
