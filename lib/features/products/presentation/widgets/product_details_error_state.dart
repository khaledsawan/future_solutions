import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:future_solutions/core/error/failure.dart';
import 'package:future_solutions/core/widgets/error_widget.dart';
import 'package:future_solutions/core/widgets/offline_placeholder.dart';

class ProductDetailsErrorState extends StatelessWidget {
  const ProductDetailsErrorState({
    super.key,
    required this.failure,
    required this.onRetry,
  });

  final Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (failure is NetworkFailure) {
      return OfflinePlaceholder(
        title: 'errors.network'.tr(),
        subtitle: 'errors.network_subtitle'.tr(),
        actionLabel: 'products.actions.retry'.tr(),
        onRetry: onRetry,
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        ErrorBanner(failure: failure, onRetry: onRetry),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
          label: Text('products.actions.retry'.tr()),
        ),
      ],
    );
  }
}
