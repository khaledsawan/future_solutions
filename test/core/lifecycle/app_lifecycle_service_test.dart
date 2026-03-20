import 'package:future_solutions/core/lifecycle/app_lifecycle_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppLifecycleService lifecycle;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    lifecycle = AppLifecycleService();
  });

  tearDown(() {
    lifecycle.stop();
  });

  test('initial state is resumed', () {
    expect(lifecycle.currentState, AppLifecycleState.resumed);
  });

  test('emits lifecycle changes', () async {
    final emitted = <AppLifecycleState>[];

    lifecycle.start();

    final sub = lifecycle.onStateChanged.listen(emitted.add);

    lifecycle.didChangeAppLifecycleState(AppLifecycleState.paused);
    lifecycle.didChangeAppLifecycleState(AppLifecycleState.resumed);

    await Future.delayed(Duration.zero);

    expect(emitted, [AppLifecycleState.paused, AppLifecycleState.resumed]);

    await sub.cancel();
  });

  test('does not emit duplicate states', () async {
    final emitted = <AppLifecycleState>[];

    lifecycle.start();

    final sub = lifecycle.onStateChanged.listen(emitted.add);

    lifecycle.didChangeAppLifecycleState(AppLifecycleState.resumed);
    lifecycle.didChangeAppLifecycleState(AppLifecycleState.resumed);

    await Future.delayed(Duration.zero);

    expect(emitted, isEmpty);

    await sub.cancel();
  });
}
