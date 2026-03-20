import 'package:flutter/material.dart';
import 'package:future_solutions/core/widgets/cached_network_image_view.dart';

class ProductHeroImage extends StatelessWidget {
  const ProductHeroImage({super.key, required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).colorScheme.surfaceContainerHighest;

    return Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl == null || imageUrl!.trim().isEmpty
          ? const Icon(Icons.photo_outlined, size: 62)
          : CachedNetworkImageView(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              error: const Center(
                child: Icon(Icons.broken_image_outlined, size: 62),
              ),
            ),
    );
  }
}
