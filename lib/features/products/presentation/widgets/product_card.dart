import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:future_solutions/core/widgets/cached_network_image_view.dart';
import 'package:openapi/openapi.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onAddToCart,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final title = product.title ?? 'products.form.untitled'.tr();
    final price = product.price ?? 0;
    final category = product.category ?? 'products.form.uncategorized'.tr();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 82,
                  height: 82,
                  child: product.image == null || product.image!.isEmpty
                      ? _fallbackImage(context)
                      : CachedNetworkImageView(
                          imageUrl: product.image!,
                          fit: BoxFit.cover,
                          error: _fallbackImage(context),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      category,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            '\$${price.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        const Spacer(),
                        IconButton.filledTonal(
                          visualDensity: VisualDensity.compact,
                          onPressed: onAddToCart,
                          tooltip: 'products.actions.add_to_cart'.tr(),
                          icon: const Icon(Icons.add_shopping_cart_rounded),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') onEdit();
                            if (value == 'delete') onDelete();
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text('products.actions.edit'.tr()),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('products.actions.delete'.tr()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fallbackImage(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: const Center(
        child: Icon(Icons.image_not_supported_outlined, size: 28),
      ),
    );
  }
}
