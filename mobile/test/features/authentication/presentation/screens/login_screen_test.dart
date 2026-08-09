import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:msis_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:msis_mobile/features/authentication/domain/repositories/auth_repository.dart';
import 'package:msis_mobile/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:msis_mobile/features/authentication/presentation/screens/login_screen.dart';
import 'package:msis_mobile/shared/models/result.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;

  setUpAll(() {
    registerFallbackValue(UserRole.client);
  });

  setUp(() {
    repository = MockAuthRepository();
  });

  Widget buildTestable() {
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
        GoRoute(path: '/client', builder: (context, state) => const SizedBox.shrink()),
        GoRoute(path: '/register', builder: (context, state) => const SizedBox.shrink()),
        GoRoute(path: '/forgot-password', builder: (context, state) => const SizedBox.shrink()),
      ],
    );

    return ProviderScope(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  // SRS BRULE-006: submit is validated client-side before any API call is made.
  testWidgets('submit is blocked until a role is selected and fields are valid', (tester) async {
    await tester.pumpWidget(buildTestable());

    final submitButton = find.widgetWithText(FilledButton, 'Se connecter');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pump();

    verifyNever(
      () => repository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
        role: any(named: 'role'),
      ),
    );
  });

  // SRS FR-AUTH-02: the eye icon toggles password visibility without clearing input.
  testWidgets('password visibility toggle does not clear the entered text', (tester) async {
    await tester.pumpWidget(buildTestable());

    final passwordField = find.widgetWithText(TextFormField, 'Mot de passe');
    await tester.enterText(passwordField, 'Password123!');
    final visibilityIcon = find.byIcon(Icons.visibility);
    await tester.ensureVisible(visibilityIcon);
    await tester.tap(visibilityIcon);
    await tester.pump();

    final field = tester.widget<TextFormField>(passwordField);
    expect(field.controller!.text, 'Password123!');
  });

  // SRS FR-AUTH-01/06: role + credentials are submitted together.
  testWidgets('a valid submission calls the repository with the selected role', (tester) async {
    when(
      () => repository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
        role: any(named: 'role'),
      ),
    ).thenAnswer(
      (_) async => const Result.success(
        UserEntity(id: 1, nom: 'Jean', email: 'jean@example.com', role: UserRole.client, actif: true),
      ),
    );

    await tester.pumpWidget(buildTestable());

    await tester.tap(find.text('Client'));
    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'jean@example.com');
    await tester.enterText(find.widgetWithText(TextFormField, 'Mot de passe'), 'Password123!');
    final submitButton = find.widgetWithText(FilledButton, 'Se connecter');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pump();

    verify(
      () => repository.login(email: 'jean@example.com', password: 'Password123!', role: UserRole.client),
    ).called(1);
  });
}
