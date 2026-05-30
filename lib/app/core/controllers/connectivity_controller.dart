import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final RxBool isConnected = true.obs;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _subscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectivity);
  }

  Future<void> _initConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectivity(result);
  }

  void _updateConnectivity(List<ConnectivityResult> result) {
    isConnected.value = !result.contains(ConnectivityResult.none);
  }

  Future<void> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectivity(result);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
