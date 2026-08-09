import 'package:flutter/material.dart';

/// The app's visual signature on auth screens: a rounded, elevated glyph
/// mark rather than a bare `Icon`. `onGradient: true` renders it for use
/// over the brand gradient (frosted glass look); otherwise it renders as a
/// soft tinted container suited to a plain surface.
class AppLogoMark extends StatelessWidget {
  const AppLogoMark({this.size = 72, this.onGradient = false, super.key});

  final double size;
  final bool onGradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        color: onGradient ? Colors.white.withValues(alpha: 0.16) : theme.colorScheme.primary.withValues(alpha: 0.1),
        border: onGradient ? Border.all(color: Colors.white.withValues(alpha: 0.3)) : null,
        boxShadow: onGradient
            ? null
            : [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Icon(
        Icons.shield_outlined,
        size: size * 0.5,
        color: onGradient ? Colors.white : theme.colorScheme.primary,
      ),
    );
  }
}
