import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// The deep-blue brand gradient (§14 design tokens) used as a full-bleed
/// backdrop on auth screens, with a couple of soft decorative blobs for
/// depth rather than a flat fill.
class BrandGradientBackground extends StatelessWidget {
  const BrandGradientBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF072A63), AppColors.primary, Color(0xFF1565C0)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -60,
            child: _blob(180, Colors.white.withValues(alpha: 0.06)),
          ),
          Positioned(
            bottom: -100,
            left: -80,
            child: _blob(220, Colors.white.withValues(alpha: 0.05)),
          ),
          child,
        ],
      ),
    );
  }

  Widget _blob(double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}
