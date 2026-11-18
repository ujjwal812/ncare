import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ncare/navigation/all_routes.dart';
import 'package:ncare/utils/app_colors.dart';
import 'package:ncare/widgets/custom_bottom_nav_bar.dart';
import 'package:ncare/widgets/profile/profile_header_banner.dart';
import 'package:ncare/widgets/profile/profile_logout_tile.dart';
import 'package:ncare/widgets/profile/profile_menu_group.dart';
import 'package:ncare/widgets/profile/profile_quick_stats_bar.dart';
import 'package:ncare/widgets/profile/profile_user_info_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _currentIndex = 4;

  void _showSnackBar(String message) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryNavy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showLogoutDialog() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.accentRed,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to log out from your account?',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentRed,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // --- Header Banner Section ---
              ProfileHeaderBanner(
                onEditTap: () =>
                    Navigator.pushNamed(context, AppRoutes.editProfile),
                onBackTap: () => Navigator.maybePop(context),
              ),

              // --- Overlapping Main Profile Content ---
              Transform.translate(
                offset: const Offset(0, -50),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth > 600 ? 32.0 : 16.0,
                  ),
                  child: Column(
                    children: [
                      // User Info Main Card
                      ProfileUserInfoCard(
                        name: 'Ujjwal Kumar',
                        phone: '+91 98765 43210',
                        badgeText: 'PLUS MEMBER',
                        imageUrl: 'https://i.pravatar.cc/300?img=11',
                        onEditAvatar: () => Navigator.pushNamed(
                          context,
                          AppRoutes.editProfile,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Quick Metric Stats Row
                      ProfileQuickStatsBar(
                        onOrdersTap: () =>
                            Navigator.pushNamed(context, AppRoutes.order),
                        onPrescriptionsTap: () => _showSnackBar(
                          'Opening Prescription History...',
                        ),
                        onCouponsTap: () => _showSnackBar(
                          'Opening Offers & Coupons...',
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Group 1: Healthcare & Orders
                      ProfileMenuGroup(
                        title: 'Healthcare & Orders',
                        items: [
                          ProfileMenuTileData(
                            icon: Icons.inventory_2_outlined,
                            iconBgColor: const Color(0xFFEFF6FF),
                            iconColor: AppColors.primaryBlue,
                            title: 'My Orders',
                            subtitle: 'Track active orders & history',
                            onTap: () =>
                                Navigator.pushNamed(context, AppRoutes.order),
                          ),
                          ProfileMenuTileData(
                            icon: Icons.assignment_outlined,
                            iconBgColor: const Color(0xFFFEF3C7),
                            iconColor: AppColors.accentOrange,
                            title: 'Prescription History',
                            subtitle: 'Saved prescriptions & doctor notes',
                            badge: 'NEW',
                            onTap: () => _showSnackBar(
                              'Opening Prescription History...',
                            ),
                          ),
                          ProfileMenuTileData(
                            icon: Icons.local_offer_outlined,
                            iconBgColor: const Color(0xFFECFDF5),
                            iconColor: AppColors.accentGreen,
                            title: 'Offers & Coupons',
                            subtitle: 'Exclusive discounts & promo codes',
                            badge: '2 ACTIVE',
                            badgeColor: AppColors.accentGreen,
                            onTap: () => _showSnackBar(
                              'Opening Offers & Coupons...',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Group 2: Saved Details
                      ProfileMenuGroup(
                        title: 'Saved Details',
                        items: [
                          ProfileMenuTileData(
                            icon: Icons.location_on_outlined,
                            iconBgColor: AppColors.surfaceMuted,
                            iconColor: const Color(0xFF475569),
                            title: 'My Addresses',
                            subtitle: 'Manage delivery addresses',
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.myAddress,
                            ),
                          ),
                          ProfileMenuTileData(
                            icon: Icons.credit_card_outlined,
                            iconBgColor: AppColors.surfaceMuted,
                            iconColor: const Color(0xFF475569),
                            title: 'Payment Methods',
                            subtitle: 'Saved UPI, Cards & Wallets',
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.paymentMethod,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Group 3: Support & Settings
                      ProfileMenuGroup(
                        title: 'App & Support',
                        items: [
                          ProfileMenuTileData(
                            icon: Icons.help_outline_rounded,
                            iconBgColor: AppColors.surfaceMuted,
                            iconColor: const Color(0xFF475569),
                            title: 'Help & Support',
                            subtitle: 'FAQs & 24/7 Customer Care',
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.helpSupport,
                            ),
                          ),
                          ProfileMenuTileData(
                            icon: Icons.settings_outlined,
                            iconBgColor: AppColors.surfaceMuted,
                            iconColor: const Color(0xFF475569),
                            title: 'Settings',
                            subtitle: 'Notifications, language & privacy',
                            onTap: () =>
                                _showSnackBar('Opening App Settings...'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Logout Tile
                      ProfileLogoutTile(
                        onTap: _showLogoutDialog,
                      ),

                      const SizedBox(height: 12),

                      // App Version Subtitle Footer
                      const Text(
                        'N CARE PLUS v1.0.0',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => handleBottomNavTap(
          context,
          index,
          currentIndex: _currentIndex,
        ),
      ),
    );
  }
}
