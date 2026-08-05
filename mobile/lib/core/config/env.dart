/// Implementation Plan §21 — three environments, switched at build time via
/// `--dart-define=ENV=dev|staging|prod` (dev is the default for local `flutter run`).
/// Base URLs are placeholders pending SRS D-02 (production domain decision).
enum AppEnvironment { dev, staging, prod }

class Env {
  Env._();

  static const _envName = String.fromEnvironment('ENV', defaultValue: 'dev');

  static AppEnvironment get current => switch (_envName) {
    'staging' => AppEnvironment.staging,
    'prod' => AppEnvironment.prod,
    _ => AppEnvironment.dev,
  };

  /// Overrides the environment default when set, e.g.
  /// `--dart-define=API_BASE_URL=http://127.0.0.1:8123/api/v1` for a desktop/web
  /// run against a locally-served backend (10.0.2.2 only resolves from an
  /// Android emulator).
  static const _apiBaseUrlOverride = String.fromEnvironment('API_BASE_URL');

  static String get apiBaseUrl {
    if (_apiBaseUrlOverride.isNotEmpty) return _apiBaseUrlOverride;
    return switch (current) {
      AppEnvironment.dev => 'http://10.0.2.2:8000/api/v1', // Android emulator -> host loopback
      AppEnvironment.staging => 'https://staging.msis.example/api/v1',
      AppEnvironment.prod => 'https://api.msis.example/api/v1',
    };
  }

  static bool get isProd => current == AppEnvironment.prod;

  /// SRS §21.1: must match the backend's `REVERB_APP_KEY` (.env). Public by
  /// design — Pusher-protocol app keys identify the app, they are not secrets
  /// (the actual authorization happens via `/broadcasting/auth`, SEC-15-19).
  static const reverbAppKey = String.fromEnvironment('REVERB_APP_KEY', defaultValue: 'msis_reverb_key');

  /// Reverb listens on its own port, separate from the REST API's (see
  /// docker-compose.yml: nginx is 8080, reverb is 8081) — it must NOT be
  /// derived from [apiBaseUrl]'s port. Override via
  /// `--dart-define=REVERB_WS_URL=ws://127.0.0.1:9124` for local/desktop runs.
  static const _reverbWsUrlOverride = String.fromEnvironment('REVERB_WS_URL');

  static String get reverbWsUrl {
    if (_reverbWsUrlOverride.isNotEmpty) return _reverbWsUrlOverride;
    return switch (current) {
      AppEnvironment.dev => 'ws://10.0.2.2:8081', // Android emulator -> host loopback, Reverb's mapped port
      AppEnvironment.staging => 'wss://staging.msis.example:8081',
      AppEnvironment.prod => 'wss://api.msis.example:8081',
    };
  }
}
