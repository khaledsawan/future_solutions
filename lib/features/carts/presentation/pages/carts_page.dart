import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_solutions/core/error/failure.dart';
import 'package:future_solutions/core/widgets/error_widget.dart';
import 'package:future_solutions/features/carts/presentation/riverpod/cart_actions_controller.dart';
import 'package:future_solutions/features/carts/presentation/riverpod/carts_list_provider.dart';
import 'package:future_solutions/features/carts/presentation/widgets/cart_empty_state.dart';
import 'package:future_solutions/features/carts/presentation/widgets/cart_error_state.dart';
import 'package:future_solutions/features/carts/presentation/widgets/cart_item_tile.dart';
import 'package:future_solutions/features/carts/presentation/widgets/cart_list_placeholder.dart';

@RoutePage()
class CartsPage extends ConsumerWidget {
  const CartsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItemsAsync = ref.watch(cartItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('carts.title'.tr()),
        actions: [
          IconButton(
            tooltip: 'carts.actions.clear'.tr(),
            onPressed: () => _clearCart(context, ref),
            icon: const Icon(Icons.delete_sweep_outlined),
          ),
        ],
      ),
      body: cartItemsAsync.when(
        loading: CartListPlaceholder.new,
        error: (error, stackTrace) => CartErrorState(
          failure: _asFailure(error),
          onRetry: () => ref.read(cartItemsProvider.notifier).refresh(),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const CartEmptyState(onAddPressed: null);
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(cartItemsProvider.notifier).refresh(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = items[index];
                return CartItemTile(
                  item: item,
                  onIncrement: () => _increment(context, ref, item.productId),
                  onDecrement: () => _decrement(context, ref, item.productId),
                  onRemove: () => _remove(context, ref, item.productId),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _increment(
    BuildContext context,
    WidgetRef ref,
    int productId,
  ) async {
    final result = await ref
        .read(cartActionsControllerProvider.notifier)
        .increment(productId);
    if (!context.mounted) return;
    _showResult(context, result);
  }

  Future<void> _decrement(
    BuildContext context,
    WidgetRef ref,
    int productId,
  ) async {
    final result = await ref
        .read(cartActionsControllerProvider.notifier)
        .decrement(productId);
    if (!context.mounted) return;
    _showResult(context, result);
  }

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    int productId,
  ) async {
    final result = await ref
        .read(cartActionsControllerProvider.notifier)
        .remove(productId);
    if (!context.mounted) return;
    _showResult(context, result);
  }

  Future<void> _clearCart(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('carts.messages.confirm_clear_title'.tr()),
        content: Text('carts.messages.confirm_clear_body'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('carts.actions.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('carts.actions.clear'.tr()),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final result = await ref
        .read(cartActionsControllerProvider.notifier)
        .clear();
    if (!context.mounted) return;
    _showResult(context, result);
  }

  void _showResult(BuildContext context, CartActionResult result) {
    if (!context.mounted) return;

    if (result.isSuccess) {
      final message = result.messageKey?.tr(namedArgs: result.namedArgs);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? 'carts.messages.success'.tr())),
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
