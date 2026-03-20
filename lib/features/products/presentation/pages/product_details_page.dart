import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_solutions/core/error/failure.dart';
import 'package:future_solutions/core/widgets/error_widget.dart';
import 'package:future_solutions/features/products/presentation/riverpod/product_actions_controller.dart';
import 'package:future_solutions/features/products/presentation/riverpod/product_detail_provider.dart';
import 'package:future_solutions/features/products/presentation/widgets/product_detail_placeholder.dart';
import 'package:future_solutions/features/products/presentation/widgets/product_details_error_state.dart';
import 'package:future_solutions/features/products/presentation/widgets/product_form_bottom_sheet.dart';
import 'package:future_solutions/features/products/presentation/widgets/product_hero_image.dart';
import 'package:future_solutions/features/products/presentation/widgets/product_not_found_state.dart';
import 'package:openapi/openapi.dart';

@RoutePage()
class ProductDetailsPage extends ConsumerWidget {
  const ProductDetailsPage({
    @PathParam('id') required this.productId,
    super.key,
  });

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(productId));
    final loadedProduct = productAsync.asData?.value;

    return Scaffold(
      appBar: AppBar(title: Text('products.details.title'.tr())),
      floatingActionButton: loadedProduct == null
          ? null
          : FloatingActionButton(
              onPressed: () => _addToCart(context, ref, loadedProduct),
              tooltip: 'products.actions.add_to_cart'.tr(),
              child: const Icon(Icons.add_shopping_cart_rounded),
            ),
      body: productAsync.when(
        loading: ProductDetailPlaceholder.new,
        error: (error, stackTrace) => ProductDetailsErrorState(
          failure: _asFailure(error),
          onRetry: () => ref.invalidate(productDetailProvider(productId)),
        ),
        data: (product) {
          if (product == null) {
            return const ProductNotFoundState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(productDetailProvider(productId));
              await ref.read(productDetailProvider(productId).future);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductHeroImage(imageUrl: product.image),
                  const SizedBox(height: 20),
                  Text(
                    product.title ?? 'products.form.untitled'.tr(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.sell_outlined, size: 18),
                        label: Text(
                          '\$${(product.price ?? 0).toStringAsFixed(2)}',
                        ),
                      ),
                      Chip(
                        avatar: const Icon(Icons.category_outlined, size: 18),
                        label: Text(
                          product.category ??
                              'products.form.uncategorized'.tr(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'products.form.description'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description ??
                        'products.details.no_description'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: () => showProductFormBottomSheet(
                            context: context,
                            product: product,
                          ),
                          icon: const Icon(Icons.edit_outlined),
                          label: Text('products.actions.edit'.tr()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _deleteProduct(context, ref),
                          icon: const Icon(Icons.delete_outline),
                          label: Text('products.actions.delete'.tr()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteProduct(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('products.messages.confirm_delete_title'.tr()),
          content: Text('products.details.confirm_delete_body'.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('products.actions.cancel'.tr()),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('products.actions.delete'.tr()),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    final result = await ref
        .read(productActionsControllerProvider.notifier)
        .deleteProduct(productId);

    if (!context.mounted) return;

    if (result.isSuccess) {
      final message = result.messageKey?.tr(namedArgs: result.namedArgs);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? 'products.messages.success'.tr())),
      );
      context.router.maybePop();
    } else if (result.failure != null) {
      ErrorSnackbar.show(context, result.failure!);
    }
  }

  Future<void> _addToCart(
    BuildContext context,
    WidgetRef ref,
    Product product,
  ) async {
    final result = await ref
        .read(productActionsControllerProvider.notifier)
        .addToCart(product);

    if (!context.mounted) return;

    if (result.isSuccess) {
      final message = result.messageKey?.tr(namedArgs: result.namedArgs);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? 'products.messages.success'.tr())),
      );
    } else if (result.failure != null) {
      ErrorSnackbar.show(context, result.failure!);
    }
  }

  Failure _asFailure(Object error) {
    if (error is Failure) return error;
    return UnknownFailure(error.toString());
  }
}
