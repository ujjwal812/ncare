import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ncare/utils/app_colors.dart';

class ProfileQuickStatsBar extends StatelessWidget {
  final VoidCallback onOrdersTap;
  final VoidCallback onPrescriptionsTap;
  final VoidCallback onCouponsTap;

  const ProfileQuickStatsBar({
    super.key,
    required this.onOrdersTap,
    required this.onPrescriptionsTap,
    required this.onCouponsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            count: '12',
            label: 'Orders',
            icon: Icons.local_shipping_rounded,
            iconColor: AppColors.primaryBlue,
            onTap: onOrdersTap,
          ),
          _buildVerticalDivider(),
          _buildStatItem(
            count: '4',
            label: 'Prescriptions',
            icon: Icons.description_rounded,
            iconColor: AppColors.accentOrange,
            onTap: onPrescriptionsTap,
          ),
          _buildVerticalDivider(),
          _buildStatItem(
            count: '2',
            label: 'Coupons',
            icon: Icons.confirmation_number_rounded,
            iconColor: AppColors.accentGreen,
            onTap: onCouponsTap,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String count,
    required String label,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: iconColor, size: 16),
                const SizedBox(width: 6),
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 28,
      width: 1,
      color: AppColors.borderSubtle,
    );
  }
}
