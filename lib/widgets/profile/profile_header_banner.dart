import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ncare/utils/app_colors.dart';

class ProfileHeaderBanner extends StatelessWidget {
  final VoidCallback onBackTap;
  final VoidCallback onEditTap;

  const ProfileHeaderBanner({
    super.key,
    required this.onBackTap,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, topPadding + 8, 16, 70),
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
          // Ambient Background Glow Circles
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onBackTap();
                  },
                ),
              ),

              // Title Header
              const Text(
                'My Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),

              // Edit Profile Action Button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.edit_rounded,
                    color: AppColors.primaryBlue,
                    size: 20,
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onEditTap();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
