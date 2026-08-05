import 'package:flutter/foundation.dart';

/// Single source of truth for "is there a currently valid session," read by
/// both GoRouter's redirect guard (app/router) and the RefreshInterceptor's
/// session-expiry callback. Kept in `core` (not a feature) specifically so the
/// network layer can depend on it without depending on the `authentication`
/// feature or on Riverpod — the `authentication` feature's AuthController
/// (Riverpod) is the only thing that *writes* to this store; everything else
/// only reads it. This is the one deliberate exception to "core never depends
/// on features" — the dependency runs the other way (feature -> core), which
/// is the correct direction per Implementation Plan §1.1.
class AuthSessionStore extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _role;

  bool get isAuthenticated => _isAuthenticated;
  String? get role => _role;

  void setAuthenticated(String role) {
    _isAuthenticated = true;
    _role = role;
    notifyListeners();
  }

  void clear() {
    _isAuthenticated = false;
    _role = null;
    notifyListeners();
  }
}
