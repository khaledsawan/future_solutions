abstract class INetworkInfo {
  /// Last known connectivity state
  bool get isConnected;

  /// Emits connectivity changes
  Stream<bool> get onConnectivityChanged;

  /// Start listening
  void start();

  /// Stop listening
  void stop();
}
