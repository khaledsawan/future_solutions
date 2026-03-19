import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:future_solutions/core/lifecycle/i_app_lifecycle_service.dart';
import 'package:injectable/injectable.dart';

@singleton
class AppLifecycleService
    with WidgetsBindingObserver
    implements IAppLifecycleService {
  final _controller = StreamController<AppLifecycleState>.broadcast();

  AppLifecycleState _state = AppLifecycleState.resumed;

  @override
  AppLifecycleState get currentState => _state;

  @override
  Stream<AppLifecycleState> get onStateChanged => _controller.stream;

  @override
  void start() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void stop() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_state != state) {
      _state = state;
      _controller.add(state);
    }
  }
}
