// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [CartsPage]
class CartsRoute extends PageRouteInfo<void> {
  const CartsRoute({List<PageRouteInfo>? children})
    : super(CartsRoute.name, initialChildren: children);

  static const String name = 'CartsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CartsPage();
    },
  );
}

/// generated route for
/// [ProductDetailsPage]
class ProductDetailsRoute extends PageRouteInfo<ProductDetailsRouteArgs> {
  ProductDetailsRoute({
    required int productId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ProductDetailsRoute.name,
         args: ProductDetailsRouteArgs(productId: productId, key: key),
         rawPathParams: {'id': productId},
         initialChildren: children,
       );

  static const String name = 'ProductDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ProductDetailsRouteArgs>(
        orElse: () =>
            ProductDetailsRouteArgs(productId: pathParams.getInt('id')),
      );
      return ProductDetailsPage(productId: args.productId, key: args.key);
    },
  );
}

class ProductDetailsRouteArgs {
  const ProductDetailsRouteArgs({required this.productId, this.key});

  final int productId;

  final Key? key;

  @override
  String toString() {
    return 'ProductDetailsRouteArgs{productId: $productId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProductDetailsRouteArgs) return false;
    return productId == other.productId && key == other.key;
  }

  @override
  int get hashCode => productId.hashCode ^ key.hashCode;
}

/// generated route for
/// [ProductsPage]
class ProductsRoute extends PageRouteInfo<void> {
  const ProductsRoute({List<PageRouteInfo>? children})
    : super(ProductsRoute.name, initialChildren: children);

  static const String name = 'ProductsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProductsPage();
    },
  );
}
