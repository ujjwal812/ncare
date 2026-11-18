import 'package:flutter/material.dart';
import 'package:ncare/utils/app_colors.dart';

class SplashBackground extends StatelessWidget {
  final Widget child;

  const SplashBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Container(
      width: w,
      height: h,
      decoration: const BoxDecoration(
        gradient: AppColors.splashGradient,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Top Left Ambient Orb
          Positioned(
            top: -h * 0.05,
            left: -w * 0.1,
            child: Container(
              width: w * 0.75,
              height: w * 0.75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.6),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          // Middle Right Ambient Orb
          Positioned(
            top: h * 0.35,
            right: -w * 0.2,
            child: Container(
              width: w * 0.8,
              height: w * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accentOrange.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
