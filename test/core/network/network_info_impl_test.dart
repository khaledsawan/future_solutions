import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:future_solutions/core/network/network_info_impl.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';

class MockInternetConnection extends Mock implements InternetConnection {}

void main() {
  late NetworkInfoImpl networkInfo;
  late MockInternetConnection mockConnection;
  late StreamController<InternetStatus> statusController;

  setUp(() {
    mockConnection = MockInternetConnection();
    statusController = StreamController<InternetStatus>.broadcast();

    when(
      () => mockConnection.onStatusChange,
    ).thenAnswer((_) => statusController.stream);

    networkInfo = NetworkInfoImpl(mockConnection);
  });

  tearDown(() async {
    await statusController.close();
    networkInfo.stop();
  });

  test('isConnected returns last known state synchronously', () {
    expect(networkInfo.isConnected, false);
  });

  test('emits true when InternetStatus.connected', () async {
    final emitted = <bool>[];

    networkInfo.start();

    final sub = networkInfo.onConnectivityChanged.listen(emitted.add);

    statusController.add(InternetStatus.connected);
    await Future.delayed(Duration.zero);

    expect(networkInfo.isConnected, true);
    expect(emitted, [true]);

    await sub.cancel();
  });

  test('emits false when InternetStatus.disconnected', () async {
    final emitted = <bool>[];

    networkInfo.start();

    final sub = networkInfo.onConnectivityChanged.listen(emitted.add);

    statusController.add(InternetStatus.connected);
    statusController.add(InternetStatus.disconnected);

    await Future.delayed(Duration.zero);

    expect(emitted, [true, false]);
    expect(networkInfo.isConnected, false);

    await sub.cancel();
  });

  test('does not emit duplicate values', () async {
    final emitted = <bool>[];

    networkInfo.start();

    final sub = networkInfo.onConnectivityChanged.listen(emitted.add);

    statusController.add(InternetStatus.connected);
    statusController.add(InternetStatus.connected);
    statusController.add(InternetStatus.connected);

    await Future.delayed(Duration.zero);

    expect(emitted, [true]);

    await sub.cancel();
  });

  test('does nothing if start is called twice', () {
    networkInfo.start();
    networkInfo.start();

    verify(() => mockConnection.onStatusChange).called(1);
  });
}
