import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:future_solutions/features/carts/presentation/pages/carts_page.dart';
import 'package:future_solutions/features/products/presentation/pages/product_details_page.dart';
import 'package:future_solutions/features/products/presentation/pages/products_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: ProductsRoute.page, path: '/', initial: true),
    AutoRoute(page: ProductDetailsRoute.page, path: '/products/:id'),
    AutoRoute(page: CartsRoute.page, path: '/carts'),
  ];
}
