import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final connectivityStatusProvider = StateNotifierProvider((ref) => ConnectivityStatusNotifier());

enum ConnectivityStatus { notDetermined, isConnected, isDisconnected }

class ConnectivityStatusNotifier extends StateNotifier<ConnectivityStatus> {
  final Connectivity _connectivity = Connectivity();
  late ConnectivityStatus lastStatus;
  late StreamSubscription _subscription;

  ConnectivityStatusNotifier() : super(ConnectivityStatus.notDetermined) {
    lastStatus = state;
    _checkConnection();
  }

  void _checkConnection() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final isConnected =
          results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.ethernet) ||
          results.contains(ConnectivityResult.wifi);
      final newStatus =
          isConnected
              ? ConnectivityStatus.isConnected
              : ConnectivityStatus.isDisconnected;
      if (newStatus != lastStatus) {
        state = newStatus;
        lastStatus = newStatus;
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
