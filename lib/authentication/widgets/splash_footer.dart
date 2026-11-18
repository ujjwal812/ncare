import 'package:flutter/material.dart';
import 'package:ncare/utils/app_colors.dart';

class SplashFooter extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final AnimationController progressController;

  const SplashFooter({
    super.key,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.progressController,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tagline Chip
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.favorite_rounded,
                    color: Color(0xFFFF5252),
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Your Health  •  Our Priority',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Feature Pills Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _FeatureBadge(
                  icon: Icons.verified_rounded,
                  label: '100% Genuine',
                ),
                _DividerDot(),
                _FeatureBadge(
                  icon: Icons.local_shipping_rounded,
                  label: 'Fast Delivery',
                ),
                _DividerDot(),
                _FeatureBadge(
                  icon: Icons.health_and_safety_rounded,
                  label: 'Trusted Care',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Smooth Animated Loading Bar
            SizedBox(
              width: w * 0.42,
              height: 4,
              child: AnimatedBuilder(
                animation: progressController,
                builder: (context, child) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: progressController.value,
                      backgroundColor: Colors.white.withValues(alpha: 0.25),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.accentOrange,
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: h * 0.03),
          ],
        ),
      ),
    );
  }
}

class _FeatureBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureBadge({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 15,
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

class _DividerDot extends StatelessWidget {
  const _DividerDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
    );
  }
}
