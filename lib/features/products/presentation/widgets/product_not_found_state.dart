import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProductNotFoundState extends StatelessWidget {
  const ProductNotFoundState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded, size: 58),
            const SizedBox(height: 12),
            Text(
              'products.details.not_found'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
