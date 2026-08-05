<?php

namespace App\Services;

use App\Enums\InterventionStatus;
use App\Models\Intervention;
use App\Models\InterventionStatusHistory;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;

/**
 * SRS §19.1 Reporting Requirements. Pickup/resolution time KPIs are computed
 * from `intervention_status_history` (Gap Analysis D-20b) — `interventions`
 * alone only retains the *current* status, so those two metrics are
 * impossible to compute from it directly, which is exactly the gap that
 * table was added to close.
 */
class ReportingService
{
    /** SRS §23.1 supervisor dashboard KPI set. */
    public function dashboard(): array
    {
        $interventions = Intervention::all();

        return [
            'total' => $interventions->count(),
            'par_statut' => $this->countBy($interventions, 'statut'),
            'par_priorite' => $this->countBy($interventions, 'priorite'),
            'delai_moyen_prise_en_charge_minutes' => $this->averagePickupMinutes(),
            'delai_moyen_resolution_minutes' => $this->averageResolutionMinutes(),
            'charge_par_technicien' => $this->workloadPerTechnician(),
            'satisfaction_moyenne' => round(
                (float) $interventions->whereNotNull('note_satisfaction')->avg('note_satisfaction'),
                2
            ),
        ];
    }

    /** SRS §23.2 weekly trend chart: created vs. closed, last 8 weeks. */
    public function weeklyTrend(): array
    {
        $weeks = collect(range(7, 0))->map(fn ($weeksAgo) => Carbon::now()->subWeeks($weeksAgo)->startOfWeek());

        return $weeks->map(function (Carbon $weekStart) {
            $weekEnd = $weekStart->copy()->endOfWeek();

            return [
                'semaine' => $weekStart->format('Y-m-d'),
                'creees' => Intervention::whereBetween('created_at', [$weekStart, $weekEnd])->count(),
                'cloturees' => Intervention::whereBetween('date_cloture', [$weekStart, $weekEnd])->count(),
            ];
        })->all();
    }

    private function countBy($interventions, string $field): array
    {
        return $interventions->groupBy(fn ($i) => $i->{$field}->value)
            ->map(fn ($group) => $group->count())
            ->all();
    }

    private function averagePickupMinutes(): ?float
    {
        $durations = $this->transitionDurations(InterventionStatus::EnAttente, InterventionStatus::EnCours);

        return $durations->isEmpty() ? null : round($durations->avg(), 1);
    }

    private function averageResolutionMinutes(): ?float
    {
        $durations = $this->transitionDurations(InterventionStatus::EnCours, InterventionStatus::Resolue);

        return $durations->isEmpty() ? null : round($durations->avg(), 1);
    }

    /**
     * For every intervention, finds the first history row transitioning
     * *into* $to from $from and returns the minute-duration since that row's
     * `created_at` relative to the ticket's own creation (pickup) or its
     * first entry into $from (resolution) — computed per-ticket in PHP since
     * the data volumes here (NFR-SCALE-01: 500 concurrent users) don't
     * justify a more complex single SQL query, and this stays portable
     * across MySQL (production) and sqlite (test suite).
     */
    private function transitionDurations(InterventionStatus $from, InterventionStatus $to)
    {
        $rows = InterventionStatusHistory::where('nouveau_statut', $to)
            ->where('ancien_statut', $from)
            ->with('intervention')
            ->get()
            ->groupBy('id_intervention');

        return $rows->map(function ($group) use ($from) {
            $first = $group->sortBy('created_at')->first();
            $intervention = $first->intervention;

            $start = $from === InterventionStatus::EnAttente
                ? $intervention->created_at
                : InterventionStatusHistory::where('id_intervention', $intervention->id_intervention)
                    ->where('nouveau_statut', $from)
                    ->orderBy('created_at')
                    ->value('created_at');

            if (! $start) {
                return null;
            }

            return Carbon::parse($start)->diffInMinutes($first->created_at);
        })->filter(fn ($v) => $v !== null)->values();
    }

    private function workloadPerTechnician(): array
    {
        return DB::table('interventions')
            ->join('users', 'users.id', '=', 'interventions.id_technicien')
            ->whereIn('interventions.statut', ['EN_COURS', 'BLOQUE'])
            ->select('users.id', 'users.nom', DB::raw('count(*) as charge'))
            ->groupBy('users.id', 'users.nom')
            ->get()
            ->map(fn ($row) => ['id_technicien' => $row->id, 'nom' => $row->nom, 'charge' => $row->charge])
            ->all();
    }
}
