import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:future_solutions/features/carts/domain/entities/cart_item_entity.dart';
import 'package:future_solutions/features/carts/presentation/pages/carts_page.dart';
import 'package:future_solutions/features/carts/presentation/riverpod/carts_list_provider.dart';
import 'package:future_solutions/features/products/presentation/pages/products_page.dart';
import 'package:future_solutions/features/products/presentation/riverpod/products_list_provider.dart';
import 'package:openapi/openapi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeProductsListNotifier extends ProductsListNotifier {
  @override
  Future<List<Product>> build() async => <Product>[];
}

class _FakeCartItemsNotifier extends CartItemsNotifier {
  @override
  Future<List<CartItemEntity>> build() async => <CartItemEntity>[];
}

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();

  Widget buildTestApp(Widget child) {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'lib/l10n/locales',
      fallbackLocale: const Locale('en'),
      child: ProviderScope(
        overrides: [
          productsListProvider.overrideWith(_FakeProductsListNotifier.new),
          cartItemsProvider.overrideWith(_FakeCartItemsNotifier.new),
        ],
        child: Builder(
          builder: (context) => MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: child,
          ),
        ),
      ),
    );
  }

  testWidgets('Products and carts smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp(const ProductsPage()));
    await tester.pumpAndSettle();

    expect(find.text('Products'), findsOneWidget);

    await tester.pumpWidget(buildTestApp(const CartsPage()));
    await tester.pumpAndSettle();

    expect(find.byType(CartsPage), findsOneWidget);
  });
}
