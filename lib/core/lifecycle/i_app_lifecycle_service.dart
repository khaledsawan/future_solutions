import 'dart:ui';

abstract class IAppLifecycleService {
  AppLifecycleState get currentState;

  Stream<AppLifecycleState> get onStateChanged;

  void start();
  void stop();
}
