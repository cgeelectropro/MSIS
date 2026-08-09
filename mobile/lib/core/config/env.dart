/// Implementation Plan §21 — three environments, switched at build time via
/// `--dart-define=ENV=dev|staging|prod`. `prod` (the live Render deployment,
/// see PRODUCTION_READINESS.md) is the default so a plain `flutter run` /
/// `flutter build` never silently targets a local backend that isn't
/// running — pass `--dart-define=ENV=dev` explicitly to develop against
/// `10.0.2.2:8000`.
enum AppEnvironment { dev, staging, prod }

class Env {
  Env._();

  static const _envName = String.fromEnvironment('ENV', defaultValue: 'prod');

  static AppEnvironment get current => switch (_envName) {
    'staging' => AppEnvironment.staging,
    'dev' => AppEnvironment.dev,
    _ => AppEnvironment.prod,
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
      // Free-tier Render demo deployment (see PRODUCTION_READINESS.md) —
      // the real, live MVP backend, not a placeholder. Swap this for a real
      // domain once the SRS §25 VPS deployment (deploy/vps-setup.sh) is used
      // instead for genuine production.
      AppEnvironment.prod => 'https://msis-backend.onrender.com/api/v1',
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
      // The free-tier Render deployment runs no Reverb (BROADCAST_CONNECTION=null,
      // single web service, no extra port to expose) — this will simply never
      // connect, which is fine: RealtimeChannelClient's reconnect/fallback
      // already handles that, and the 15s REST poll keeps messaging working
      // regardless. Update once a deployment with Reverb is live.
      AppEnvironment.prod => 'wss://msis-backend.onrender.com:8081',
    };
  }
}
