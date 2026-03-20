import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_solutions/core/error/failure.dart';
import 'package:future_solutions/core/widgets/error_widget.dart';
import 'package:future_solutions/features/carts/presentation/riverpod/carts_list_provider.dart';
import 'package:future_solutions/features/products/presentation/riverpod/product_actions_controller.dart';
import 'package:future_solutions/features/products/presentation/riverpod/products_list_provider.dart';
import 'package:future_solutions/features/products/presentation/widgets/product_card.dart';
import 'package:future_solutions/features/products/presentation/widgets/product_form_bottom_sheet.dart';
import 'package:future_solutions/features/products/presentation/widgets/product_list_placeholder.dart';
import 'package:future_solutions/features/products/presentation/widgets/products_empty_state.dart';
import 'package:future_solutions/features/products/presentation/widgets/products_error_state.dart';
import 'package:future_solutions/route/app_router.dart';
import 'package:openapi/openapi.dart';

@RoutePage()
class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _hasLoadedOnce = false;
  int _lastCount = 0;
  late final ProviderSubscription<AsyncValue<List<Product>>> _productsSub;

  @override
  void initState() {
    super.initState();

    _productsSub = ref.listenManual<AsyncValue<List<Product>>>(
      productsListProvider,
      (prev, next) {
        final nextList = next.asData?.value;
        if (nextList == null) return;

        if (!_hasLoadedOnce) {
          _hasLoadedOnce = true;
          _lastCount = nextList.length;
          return;
        }

        final nextCount = nextList.length;
        final shouldScrollToTop = nextCount > _lastCount;
        _lastCount = nextCount;

        if (!shouldScrollToTop) return;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || !_scrollController.hasClients) return;
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOut,
          );
        });
      },
    );
  }

  @override
  void dispose() {
    _productsSub.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsListProvider);
    final cartCount = ref.watch(cartTotalQuantityProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('products.title'.tr()),
        actions: [
          IconButton(
            tooltip: 'carts.title'.tr(),
            onPressed: () => context.pushRoute(const CartsRoute()),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart_outlined),
                if (cartCount > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      constraints: const BoxConstraints(minWidth: 18),
                      child: Text(
                        '$cartCount',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showProductFormBottomSheet(context: context),
        icon: const Icon(Icons.add_rounded),
        label: Text('products.actions.add'.tr()),
      ),
      body: productsAsync.when(
        loading: ProductListPlaceholder.new,
        error: (error, stackTrace) => ProductsErrorState(
          failure: _asFailure(error),
          onRetry: () => ref.read(productsListProvider.notifier).refresh(),
        ),
        data: (products) {
          if (products.isEmpty) {
            return ProductsEmptyState(
              onAddPressed: () => showProductFormBottomSheet(context: context),
            );
          }

          return RepaintBoundary(
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(productsListProvider.notifier).refresh(),
              child: ListView.separated(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    product: product,
                    onTap: () {
                      final id = product.id;
                      if (id == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('products.messages.missing_id'.tr()),
                          ),
                        );
                        return;
                      }
                      context.pushRoute(ProductDetailsRoute(productId: id));
                    },
                    onEdit: () => showProductFormBottomSheet(
                      context: context,
                      product: product,
                    ),
                    onDelete: () => _deleteProduct(context, ref, product),
                    onAddToCart: () => _addToCart(context, ref, product),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemCount: products.length,
              ),
            ),
          );
        },
      ),
    );
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

  Future<void> _deleteProduct(
    BuildContext context,
    WidgetRef ref,
    Product product,
  ) async {
    final id = product.id;
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('products.messages.missing_id'.tr())),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('products.messages.confirm_delete_title'.tr()),
          content: Text(
            'products.messages.confirm_delete_body'.tr(
              namedArgs: {'title': product.title ?? ''},
            ),
          ),
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
        .deleteProduct(id);

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
