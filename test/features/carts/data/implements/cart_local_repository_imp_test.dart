import 'package:flutter_test/flutter_test.dart';
import 'package:future_solutions/core/error/failure.dart';
import 'package:future_solutions/features/carts/data/implements/cart_local_repository_imp.dart';
import 'package:future_solutions/features/carts/data/models/local_cart_item_model.dart';
import 'package:future_solutions/features/carts/data/sources/cart_local_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:openapi/openapi.dart';

class _MockCartLocalDataSource extends Mock implements CartLocalDataSource {}

void main() {
  late _MockCartLocalDataSource mockDataSource;
  late CartLocalRepositoryImp repository;
  late List<LocalCartItemModel> storedItems;

  setUp(() {
    mockDataSource = _MockCartLocalDataSource();
    storedItems = [];

    when(
      () => mockDataSource.getItems(),
    ).thenAnswer((_) async => List<LocalCartItemModel>.from(storedItems));

    when(() => mockDataSource.saveItems(any())).thenAnswer((invocation) async {
      final items =
          invocation.positionalArguments.first as List<LocalCartItemModel>;
      storedItems
        ..clear()
        ..addAll(items);
    });

    repository = CartLocalRepositoryImp(mockDataSource);
  });

  LocalCartItemModel item(int productId, {int quantity = 1}) {
    return LocalCartItemModel(
      productId: productId,
      title: 'Title $productId',
      price: 5.0,
      image: 'image.png',
      category: 'cat',
      quantity: quantity,
    );
  }

  Product product0({int? id}) {
    return Product(
      (b) => b
        ..id = id
        ..title = 'Product'
        ..price = 9.5
        ..description = 'description'
        ..category = 'category'
        ..image = 'image.png',
    );
  }

  group('getItems', () {
    test('returns mapped entities', () async {
      storedItems.add(item(1));

      final result = await repository.getItems();

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('expected data'), (items) {
        expect(items, hasLength(1));
        expect(items.first.productId, 1);
      });
    });
  });

  group('addProduct', () {
    test('returns ValidationFailure when id is missing', () async {
      final result = await repository.addProduct(product0());

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('expected failure'),
      );
    });

    test('creates new entry when product not in cart', () async {
      final product = product0(id: 1);

      final result = await repository.addProduct(product);

      expect(result.isRight(), isTrue);
      expect(storedItems, hasLength(1));
      expect(storedItems.first.quantity, 1);
    });

    test('increments quantity when product exists', () async {
      storedItems.add(item(1, quantity: 2));
      final product = product0(id: 1);

      final result = await repository.addProduct(product);

      expect(result.isRight(), isTrue);
      expect(storedItems.first.quantity, 3);
    });
  });

  group('increment', () {
    test('fails when item missing', () async {
      final result = await repository.increment(5);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('expected failure'),
      );
    });

    test('increments quantity when found', () async {
      storedItems.add(item(3, quantity: 1));

      final result = await repository.increment(3);

      expect(result.isRight(), isTrue);
      expect(storedItems.first.quantity, 2);
    });
  });

  group('decrement', () {
    test('removes item when quantity reaches zero', () async {
      storedItems.add(item(7));

      final result = await repository.decrement(7);

      expect(result.isRight(), isTrue);
      expect(storedItems, isEmpty);
    });

    test('reduces quantity when above one', () async {
      storedItems.add(item(2, quantity: 3));

      final result = await repository.decrement(2);

      expect(result.isRight(), isTrue);
      expect(storedItems.first.quantity, 2);
    });
  });

  test('remove deletes the entry', () async {
    storedItems.add(item(6));

    final result = await repository.remove(6);

    expect(result.isRight(), isTrue);
    expect(storedItems, isEmpty);
  });

  test('clear empties the cart', () async {
    storedItems.addAll([item(1), item(2)]);

    final result = await repository.clear();

    expect(result.isRight(), isTrue);
    expect(storedItems, isEmpty);
  });

  test('getTotalQuantity sums quantities', () async {
    storedItems.addAll([item(1, quantity: 2), item(2, quantity: 3)]);

    final result = await repository.getTotalQuantity();

    expect(result.isRight(), isTrue);
    result.fold((_) => fail('expected data'), (qty) => expect(qty, 5));
  });
}
