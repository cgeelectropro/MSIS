<?php

namespace App\Enums;

/**
 * SRS §18.3 interventions.statut. BRULE-002/003 define the legal transition graph.
 * Annulee is the SRS D-17 pending-decision extension (Engineering Recommendation);
 * included here since D-17 is treated as accepted per SRS FR-CRT-08.
 */
enum InterventionStatus: string
{
    case EnAttente = 'EN_ATTENTE';
    case EnCours = 'EN_COURS';
    case Bloque = 'BLOQUE';
    case Resolue = 'RESOLUE';
    case Cloturee = 'CLOTUREE';
    case Annulee = 'ANNULEE';

    /**
     * BRULE-002/003: legal "from" => ["to", ...] transition map.
     *
     * @return array<string, array<string>>
     */
    public static function transitions(): array
    {
        return [
            self::EnAttente->value => [self::EnCours->value, self::Annulee->value],
            self::EnCours->value => [self::Bloque->value, self::Resolue->value],
            self::Bloque->value => [self::EnCours->value],
            self::Resolue->value => [self::Cloturee->value],
            self::Cloturee->value => [],
            self::Annulee->value => [],
        ];
    }

    public function canTransitionTo(self $target): bool
    {
        return in_array($target->value, self::transitions()[$this->value] ?? [], true);
    }

    public function labelFr(): string
    {
        return match ($this) {
            self::EnAttente => 'En attente',
            self::EnCours => 'En cours',
            self::Bloque => 'Bloqué',
            self::Resolue => 'Résolue',
            self::Cloturee => 'Clôturée',
            self::Annulee => 'Annulée',
        };
    }
}
