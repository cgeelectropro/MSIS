import 'package:flutter/foundation.dart';

/// Implementation Plan §17 — every UseCase returns `Result<Failure, T>`, never
/// throws to the presentation layer. `fieldErrors` carries SRS §18.5's 422
/// validation payload shape (`{"field": ["message", ...]}`) for inline form errors.
@immutable
sealed class Failure {
  const Failure(this.message);

  final String message;
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Vérifiez votre connexion réseau.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, this.fieldErrors);

  final Map<String, List<String>> fieldErrors;
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Session expirée, veuillez vous reconnecter.']);
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure([super.message = "Vous n'êtes pas autorisé à effectuer cette action."]);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Ressource introuvable.']);
}

class RateLimitedFailure extends Failure {
  const RateLimitedFailure([super.message = 'Trop de tentatives, veuillez réessayer plus tard.']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Une erreur est survenue, veuillez réessayer.']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Une erreur inattendue est survenue.']);
}
