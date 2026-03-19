import 'dart:async';

import 'package:future_solutions/core/network/network_info.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

@Singleton(as: INetworkInfo)
class NetworkInfoImpl implements INetworkInfo {
  final InternetConnection _connectionChecker;

  StreamSubscription<InternetStatus>? _subscription;
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  bool _isConnected = false;
  bool _started = false;

  NetworkInfoImpl(this._connectionChecker);

  /// Factory method for dependency injection.
  /// Creates a new InternetConnection instance and starts listening.
  @factoryMethod
  static NetworkInfoImpl create() {
    final instance = NetworkInfoImpl(InternetConnection());
    instance.start();
    return instance;
  }

  @override
  bool get isConnected => _isConnected;

  @override
  Stream<bool> get onConnectivityChanged => _controller.stream;

  @override
  void start() {
    if (_started) return;
    _started = true;

    _subscription = _connectionChecker.onStatusChange.listen(_onStatusChange);
    _initializeConnectionState();
  }

  @override
  void stop() {
    _subscription?.cancel();
    _subscription = null;
    _started = false;
  }

  void _onStatusChange(InternetStatus status) {
    final connected = status == InternetStatus.connected;

    if (_isConnected == connected) return;

    _isConnected = connected;
    _controller.add(connected);
  }

  Future<void> _initializeConnectionState() async {
    try {
      final connected = await _connectionChecker.hasInternetAccess;
      if (_isConnected == connected) return;
      _isConnected = connected;
      _controller.add(connected);
    } catch (_) {
      // Keep the previous state on errors; stream updates will fix it later.
    }
  }
}
