import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CartEmptyState extends StatelessWidget {
  const CartEmptyState({super.key, this.onAddPressed});

  final VoidCallback? onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'carts.empty.title'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'carts.empty.subtitle'.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            if (onAddPressed != null)
              FilledButton.icon(
                onPressed: onAddPressed,
                icon: const Icon(Icons.add_rounded),
                label: Text('carts.actions.add'.tr()),
              ),
          ],
        ),
      ),
    );
  }
}
