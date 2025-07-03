import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatusController.add(_isConnected(result));
    } as void Function(List<ConnectivityResult> event)?);
  }

  bool _isConnected(ConnectivityResult result) {
    return result != ConnectivityResult.none;
  }

  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  Future<bool> checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    return _isConnected(result as ConnectivityResult);
  }

  void dispose() {
    _connectionStatusController.close();
  }
}