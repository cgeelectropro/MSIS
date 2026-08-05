<?php

namespace App\Http\Controllers\Api\V1;

use App\Enums\InterventionStatus;
use App\Http\Controllers\Controller;
use App\Http\Requests\Intervention\AssignInterventionRequest;
use App\Http\Requests\Intervention\CloseInterventionRequest;
use App\Http\Requests\Intervention\StoreInterventionRequest;
use App\Http\Requests\Intervention\UpdateInterventionStatusRequest;
use App\Http\Resources\InterventionResource;
use App\Models\Intervention;
use App\Models\User;
use App\Services\InterventionService;
use Illuminate\Http\Request;

/** SRS §18.5 Interventions routes / §9.3-9.4. Thin controller — logic in InterventionService. */
class InterventionController extends Controller
{
    public function __construct(private readonly InterventionService $interventionService) {}

    public function index(Request $request): mixed
    {
        $status = $request->filled('statut') ? InterventionStatus::from($request->string('statut')->toString()) : null;

        return InterventionResource::collection(
            $this->interventionService->list(
                $request->user(),
                $status,
                $request->string('search')->toString() ?: null,
                $request->string('priorite')->toString() ?: null,
            )->load(['client', 'technicien'])
        );
    }

    public function store(StoreInterventionRequest $request): mixed
    {
        $intervention = $this->interventionService->create($request->validated(), $request->user());

        return (new InterventionResource($intervention))->response()->setStatusCode(201);
    }

    public function show(Request $request, Intervention $intervention): InterventionResource
    {
        $this->authorize('view', $intervention);

        return new InterventionResource($intervention->load(['client', 'technicien']));
    }

    public function assign(AssignInterventionRequest $request, Intervention $intervention): InterventionResource
    {
        $technicien = User::findOrFail($request->integer('id_technicien'));

        return new InterventionResource(
            $this->interventionService->assign($intervention, $technicien, $request->user())
        );
    }

    public function updateStatus(UpdateInterventionStatusRequest $request, Intervention $intervention): InterventionResource
    {
        $target = InterventionStatus::from($request->string('statut')->toString());

        $this->authorize('updateStatus', [$intervention, $target]);

        return new InterventionResource(
            $this->interventionService->updateStatus(
                $intervention,
                $target,
                $request->string('motif_blocage')->toString() ?: null,
                $request->string('rapport_technique')->toString() ?: null,
                $request->user()
            )
        );
    }

    public function close(CloseInterventionRequest $request, Intervention $intervention): InterventionResource
    {
        return new InterventionResource(
            $this->interventionService->close($intervention, $request->integer('note_satisfaction') ?: null, $request->user())
        );
    }

    public function cancel(Request $request, Intervention $intervention): InterventionResource
    {
        $this->authorize('cancel', $intervention);

        return new InterventionResource($this->interventionService->cancel($intervention, $request->user()));
    }
}
