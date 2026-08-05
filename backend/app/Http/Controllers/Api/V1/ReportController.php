<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Intervention;
use App\Services\ReportingService;
use Barryvdh\DomPDF\Facade\Pdf;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use League\Csv\Writer;
use Symfony\Component\HttpFoundation\Response;

/**
 * SRS §18.5 "Notifications et rapports" table / §19 / §23. Export runs
 * synchronously (not the queued-Job + signed-URL flow sketched in RPT-16) —
 * a deliberate scope simplification for this build: at the stated 500-user
 * NFR-SCALE-01 ceiling, a filtered CSV/PDF export is fast enough to return
 * inline, and this keeps the endpoint's behavior fully testable without a
 * queue-worker dependency in the test environment.
 */
class ReportController extends Controller
{
    public function __construct(private readonly ReportingService $reporting) {}

    public function dashboard(): JsonResponse
    {
        return response()->json([
            'kpis' => $this->reporting->dashboard(),
            'tendance_hebdomadaire' => $this->reporting->weeklyTrend(),
        ]);
    }

    public function export(Request $request): Response
    {
        $format = $request->query('format', 'csv');
        abort_unless(in_array($format, ['csv', 'pdf'], true), 422, 'Format non supporté.');

        $query = Intervention::with(['client', 'technicien']);
        if ($status = $request->query('statut')) {
            $query->where('statut', $status);
        }
        if ($priority = $request->query('priorite')) {
            $query->where('priorite', $priority);
        }
        $interventions = $query->orderByDesc('created_at')->get();

        return $format === 'pdf' ? $this->exportPdf($interventions) : $this->exportCsv($interventions);
    }

    private function exportCsv($interventions): Response
    {
        $csv = Writer::createFromString('');
        $csv->insertOne(['ID', 'Titre', 'Statut', 'Priorité', 'Client', 'Technicien', 'Créé le']);

        foreach ($interventions as $i) {
            $csv->insertOne([
                $i->id_intervention,
                $i->titre,
                $i->statut->value,
                $i->priorite->value,
                $i->client?->nom,
                $i->technicien?->nom,
                $i->created_at?->toDateString(),
            ]);
        }

        return response($csv->toString(), 200, [
            'Content-Type' => 'text/csv',
            'Content-Disposition' => 'attachment; filename="interventions.csv"',
        ]);
    }

    private function exportPdf($interventions): Response
    {
        $pdf = Pdf::loadView('reports.interventions', ['interventions' => $interventions]);

        return $pdf->download('interventions.pdf');
    }
}
