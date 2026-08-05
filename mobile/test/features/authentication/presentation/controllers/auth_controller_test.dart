import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:msis_mobile/core/errors/failures.dart';
import 'package:msis_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:msis_mobile/features/authentication/domain/repositories/auth_repository.dart';
import 'package:msis_mobile/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:msis_mobile/features/authentication/presentation/controllers/auth_state.dart';
import 'package:msis_mobile/shared/models/result.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late AuthController controller;

  const user = UserEntity(
    id: 1,
    nom: 'Jean Dupont',
    email: 'jean@example.com',
    role: UserRole.client,
    actif: true,
  );

  setUpAll(() {
    registerFallbackValue(UserRole.client);
  });

  setUp(() {
    repository = MockAuthRepository();
    controller = AuthController(repository);
  });

  // SRS AC-01
  test('login success transitions to AuthAuthenticated with the returned user', () async {
    when(
      () => repository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
        role: any(named: 'role'),
      ),
    ).thenAnswer((_) async => const Result.success(user));

    await controller.login(email: 'jean@example.com', password: 'Password123!', role: UserRole.client);

    expect(controller.state, isA<AuthAuthenticated>());
    expect((controller.state as AuthAuthenticated).user, user);
  });

  // SRS AC-02/BRULE-015: a role mismatch surfaces the same generic failure as bad credentials.
  test('login failure transitions to AuthError with the repository failure', () async {
    when(
      () => repository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
        role: any(named: 'role'),
      ),
    ).thenAnswer((_) async => const Result.failure(ValidationFailure('Email ou mot de passe incorrect.', {})));

    await controller.login(email: 'jean@example.com', password: 'wrong', role: UserRole.client);

    expect(controller.state, isA<AuthError>());
    expect((controller.state as AuthError).failure.message, 'Email ou mot de passe incorrect.');
  });

  test('login sets AuthLoading before resolving', () async {
    when(
      () => repository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
        role: any(named: 'role'),
      ),
    ).thenAnswer((_) async {
      // At this point the controller must already be in the loading state.
      return const Result.success(user);
    });

    final future = controller.login(email: 'jean@example.com', password: 'x', role: UserRole.client);
    expect(controller.state, isA<AuthLoading>());
    await future;
  });

  // SCR-01 Splash: no stored token -> straight to unauthenticated, no API call.
  test('restoreSession with no stored token transitions to AuthUnauthenticated without calling getCurrentUser', () async {
    when(() => repository.hasStoredSession()).thenAnswer((_) async => false);

    await controller.restoreSession();

    expect(controller.state, isA<AuthUnauthenticated>());
    verifyNever(() => repository.getCurrentUser());
  });

  test('restoreSession with a stored token that resolves calls getCurrentUser and authenticates', () async {
    when(() => repository.hasStoredSession()).thenAnswer((_) async => true);
    when(() => repository.getCurrentUser()).thenAnswer((_) async => const Result.success(user));

    await controller.restoreSession();

    expect(controller.state, isA<AuthAuthenticated>());
  });

  // SRS §17.4: an expired/invalid stored token must not leave the app stuck.
  test('restoreSession with a stored token that fails falls back to AuthUnauthenticated', () async {
    when(() => repository.hasStoredSession()).thenAnswer((_) async => true);
    when(() => repository.getCurrentUser()).thenAnswer((_) async => const Result.failure(AuthFailure()));

    await controller.restoreSession();

    expect(controller.state, isA<AuthUnauthenticated>());
  });

  // SRS FR-AUTH-09
  test('logout clears state to AuthUnauthenticated', () async {
    when(() => repository.logout()).thenAnswer((_) async => const Result.success(null));

    await controller.logout();

    expect(controller.state, isA<AuthUnauthenticated>());
    verify(() => repository.logout()).called(1);
  });
}
