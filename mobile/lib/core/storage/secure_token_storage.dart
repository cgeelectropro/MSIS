import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// SRS SEC-28: token stored exclusively via platform secure storage
/// (Android Keystore / iOS Keychain) — never SharedPreferences.
class SecureTokenStorage {
  SecureTokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _tokenKey = 'msis_auth_token';

  final FlutterSecureStorage _storage;

  Future<void> saveToken(String token) => _storage.write(key: _tokenKey, value: token);

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<void> clear() => _storage.delete(key: _tokenKey);
}
