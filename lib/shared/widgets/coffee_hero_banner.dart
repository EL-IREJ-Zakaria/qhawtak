import 'package:flutter/material.dart';
import 'package:qhawtak/core/theme/app_colors.dart';
import 'package:qhawtak/shared/widgets/animated_network_image.dart';

class CoffeeHeroBanner extends StatelessWidget {
  const CoffeeHeroBanner({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.height = 138,
  });

  final String imageUrl;
  final String title;
  final String subtitle;
  final double height;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.97, end: 1),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      builder: (BuildContext context, double value, Widget? child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Stack(
        children: <Widget>[
          AnimatedNetworkImage(
            imageUrl: imageUrl,
            height: height,
            borderRadius: 18,
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.black.withValues(alpha: 0.06),
                    Colors.black.withValues(alpha: 0.52),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFFF5E9DA),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Qhawtak',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
