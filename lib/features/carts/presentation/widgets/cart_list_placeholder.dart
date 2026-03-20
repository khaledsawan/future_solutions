import 'package:flutter/material.dart';

class CartListPlaceholder extends StatelessWidget {
  const CartListPlaceholder({super.key, this.count = 5});

  final int count;

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).colorScheme.surfaceContainerHighest;

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return Container(
          height: 92,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _line(),
              const SizedBox(height: 10),
              _line(width: 160),
              const Spacer(),
              _line(width: 90),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: count,
    );
  }

  Widget _line({double? width}) {
    return Builder(
      builder: (context) => Container(
        height: 12,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }
}
