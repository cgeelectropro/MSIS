<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\PieceJointe;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\HttpFoundation\StreamedResponse;

/**
 * SRS §22 FILE-09: the only way to reach an attachment's bytes. The route is
 * gated by Laravel's `signed` middleware (see routes/api.php) — the signed
 * URL is generated exclusively by PieceJointeResource for a viewer who has
 * already passed InterventionPolicy/MessagePolicy, so no separate policy
 * check is duplicated here; a forged/expired signature is rejected before
 * this method ever runs.
 */
class AttachmentController extends Controller
{
    public function download(PieceJointe $pieceJointe): StreamedResponse
    {
        return Storage::disk('local')->response($pieceJointe->chemin_fichier, null, [
            'Content-Type' => $pieceJointe->type_mime,
        ]);
    }
}
