import 'package:flutter_test/flutter_test.dart';
import 'package:future_solutions/core/base/base_repo.dart';
import 'package:future_solutions/core/error/failure.dart';
import 'package:future_solutions/core/model/fetch_data_params.dart';
import 'package:future_solutions/core/network/network_info.dart';
import 'package:future_solutions/core/usecases/usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockNetworkInfo extends Mock implements INetworkInfo {}

void main() {
  late BaseRepository repository;
  late _MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNetworkInfo = _MockNetworkInfo();
    repository = BaseRepository(networkInfo: mockNetworkInfo);
  });

  group('fetchData', () {
    test('returns NetworkFailure when offline and skips fetch', () async {
      when(() => mockNetworkInfo.isConnected).thenReturn(false);
      var fetchCalled = false;

      final params = FetchDataParams<String, NoParams>(
        getData: (_) async {
          fetchCalled = true;
          return 'ok';
        },
        requestParams: const NoParams(),
      );

      final result = await repository.fetchData(params: params);

      expect(fetchCalled, isFalse);
      result.fold((failure) {
        expect(failure, isA<NetworkFailure>());
      }, (_) => fail('expected a failure'));
    });

    test('returns data when online', () async {
      when(() => mockNetworkInfo.isConnected).thenReturn(true);

      final params = FetchDataParams<String, NoParams>(
        getData: (_) async => 'success',
        requestParams: const NoParams(),
      );

      final result = await repository.fetchData(params: params);

      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => ''), 'success');
    });
  });
}
