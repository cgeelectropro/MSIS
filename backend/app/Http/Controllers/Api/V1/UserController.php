<?php

namespace App\Http\Controllers\Api\V1;

use App\Enums\UserRole;
use App\Http\Controllers\Controller;
use App\Http\Requests\User\CreateTechnicianRequest;
use App\Http\Requests\User\UpdateUserStatusRequest;
use App\Http\Resources\UserResource;
use App\Models\User;
use App\Services\UserService;
use Illuminate\Http\Request;

/** SRS §18.5 Users routes / §9.6. */
class UserController extends Controller
{
    public function __construct(private readonly UserService $userService) {}

    public function index(Request $request): mixed
    {
        $this->authorize('viewAny', User::class);

        $role = $request->filled('role') ? UserRole::from($request->string('role')->toString()) : null;

        return UserResource::collection(
            $this->userService->list($role, $request->string('search')->toString() ?: null)
        );
    }

    public function store(CreateTechnicianRequest $request): mixed
    {
        $user = $this->userService->createTechnician($request->validated(), $request->user());

        return (new UserResource($user))->response()->setStatusCode(201);
    }

    public function updateStatus(UpdateUserStatusRequest $request, User $user): mixed
    {
        $updated = $this->userService->updateStatus($user, $request->boolean('actif'), $request->user());

        return new UserResource($updated);
    }
}
