import 'package:connectivity_plus/connectivity_plus.dart';

/// Implementation Plan §11 / SRS §16.5 offline-banner requirement: a single
/// online/offline signal consumed by the OfflineBanner widget and by
/// MessageRepositoryImpl (outbox flush trigger).
class ConnectivityService {
  ConnectivityService({Connectivity? connectivity}) : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Stream<bool> get onStatusChange =>
      _connectivity.onConnectivityChanged.map((results) => !results.contains(ConnectivityResult.none));

  Future<bool> get isOnline async {
    final results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }
}
