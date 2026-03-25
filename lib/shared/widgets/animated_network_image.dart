import 'package:flutter/material.dart';
import 'package:qhawtak/core/theme/app_colors.dart';

class AnimatedNetworkImage extends StatelessWidget {
  const AnimatedNetworkImage({
    super.key,
    required this.imageUrl,
    required this.height,
    this.width,
    this.borderRadius = 14,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final double height;
  final double? width;
  final double borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: Image.network(
          imageUrl,
          fit: fit,
          frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSyncLoaded) {
            final bool loaded = frame != null || wasSyncLoaded;
            return AnimatedOpacity(
              opacity: loaded ? 1 : 0,
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOut,
              child: child,
            );
          },
          loadingBuilder: (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) {
            if (loadingProgress == null) return child;
            return Container(
              color: AppColors.background,
              child: const Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          },
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            return Container(
              color: AppColors.background,
              child: const Center(
                child: Icon(Icons.local_cafe_outlined, color: AppColors.textSecondary),
              ),
            );
          },
        ),
      ),
    );
  }
}
