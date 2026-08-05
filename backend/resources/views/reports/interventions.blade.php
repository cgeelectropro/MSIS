<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <style>
        body { font-family: sans-serif; font-size: 12px; }
        h1 { font-size: 16px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ccc; padding: 4px 6px; text-align: left; }
        th { background-color: #f0f0f0; }
    </style>
</head>
<body>
    <h1>Rapport d'activité — MSIS</h1>
    <p>Généré le {{ now()->format('d/m/Y H:i') }}</p>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Titre</th>
                <th>Statut</th>
                <th>Priorité</th>
                <th>Client</th>
                <th>Technicien</th>
                <th>Créé le</th>
            </tr>
        </thead>
        <tbody>
            @foreach ($interventions as $i)
                <tr>
                    <td>{{ $i->id_intervention }}</td>
                    <td>{{ $i->titre }}</td>
                    <td>{{ $i->statut->value }}</td>
                    <td>{{ $i->priorite->value }}</td>
                    <td>{{ $i->client?->nom }}</td>
                    <td>{{ $i->technicien?->nom }}</td>
                    <td>{{ $i->created_at?->toDateString() }}</td>
                </tr>
            @endforeach
        </tbody>
    </table>
</body>
</html>
