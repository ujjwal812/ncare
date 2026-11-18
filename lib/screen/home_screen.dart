import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ncare/navigation/all_routes.dart';
import 'package:ncare/services/cart_service.dart';
import 'package:ncare/utils/location_helper.dart';
import 'package:ncare/widgets/custom_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _currentIndex = 0;
  String _currentAddress = '123, Green Street, Pune';
  bool _isLoadingAddress = false;

  Future<void> _fetchLiveLocation() async {
    HapticFeedback.mediumImpact();
    setState(() => _isLoadingAddress = true);
    
    UserAddressData? addressData =
        await LocationHelper.fetchLiveAddressDetails(context);
    
    if (mounted) {
      setState(() {
        _isLoadingAddress = false;
        if (addressData != null) {
          _currentAddress = addressData.fullFormattedAddress;
        }
      });
    }
  }

  void _showSnackBar(BuildContext context, String message, {bool isSuccess = false}) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle_rounded : Icons.info_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess ? const Color(0xFF10B981) : const Color(0xFF1E293B),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E56A0), // Top status bar background match
      body: SafeArea(
        bottom: false,
        child: Container(
          color: const Color(0xFFF8FAFC),
          child: Column(
            children: [
              // -------------------------------------------------------------
              // Header & Search Bar inside Top Gradient Container
              // -------------------------------------------------------------
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1E56A0), Color(0xFF2C74B3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Column(
                  children: [
                    // User Profile Header
                    UserHeaderSection(
                      userName: 'Ujjwal',
                      address: _currentAddress,
                      isLoadingAddress: _isLoadingAddress,
                      onProfileTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.pushNamed(context, AppRoutes.profile);
                      },
                      onAddressTap: _fetchLiveLocation,
                      onNotificationTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.pushNamed(context, AppRoutes.notification);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Modern Search Box
                    SearchBoxBar(
                      onSearchTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.pushNamed(context, AppRoutes.search);
                      },
                      onArrowTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.pushNamed(context, AppRoutes.search);
                      },
                    ),
                  ],
                ),
              ),

              // -------------------------------------------------------------
              // Main Scrollable Content Body
              // -------------------------------------------------------------
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Promo Banner Card
                      PromoBannerCard(
                        title: 'Flat 20% OFF',
                        subtitle: 'On First Order',
                        code: 'MED20',
                        onTap: () => _showSnackBar(
                          context,
                          'Coupon MED20 copied to clipboard!',
                          isSuccess: true,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Quick Services Grid / Row
                      QuickServicesRow(
                        onServiceTap: (title) {
                          HapticFeedback.lightImpact();
                          if (title == 'Medicines' || title == 'Health Care') {
                            Navigator.pushNamed(context, AppRoutes.search);
                          } else {
                            _showSnackBar(context, 'Opening $title...');
                          }
                        },
                      ),

                      const SizedBox(height: 22),

                      // Upload Prescription Card Hero Section
                      UploadPrescriptionCard(
                        onUploadTap: () => showPrescriptionBottomSheet(context),
                      ),

                      const SizedBox(height: 24),

                      // Section Header: Popular Categories
                      _buildSectionHeader(
                        title: 'Popular Categories',
                        actionLabel: 'View All',
                        onActionTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pushNamed(context, AppRoutes.search);
                        },
                      ),

                      const SizedBox(height: 12),

                      // 2x2 Category Grid
                      PopularCategoriesGrid(
                        onCategoryTap: (category) {
                          HapticFeedback.lightImpact();
                          Navigator.pushNamed(context, AppRoutes.searchResult);
                        },
                      ),

                      const SizedBox(height: 24),

                      // Section Header: Health Essentials / Trending
                      _buildSectionHeader(
                        title: 'Health Essentials',
                        actionLabel: 'See More',
                        onActionTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pushNamed(context, AppRoutes.searchResult);
                        },
                      ),

                      const SizedBox(height: 12),

                      // Horizontal List of Trending Products
                      TrendingProductsRow(
                        onProductTap: (productName) {
                          HapticFeedback.lightImpact();
                          double price = 150.0;
                          if (productName.contains('Multivitamin')) price = 299.0;
                          if (productName.contains('Thermometer')) price = 180.0;
                          if (productName.contains('Spray')) price = 145.0;
                          CartService.instance.addItem(
                            id: productName,
                            name: productName,
                            composition: 'Health Care Product',
                            price: price,
                            imageUrl:
                                'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=300&q=80',
                          );
                          _showSnackBar(context, '$productName added to cart!', isSuccess: true);
                        },
                      ),

                      const SizedBox(height: 24),

                      // Trust Badges Section
                      const TrustBadgesSection(),
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
          onPrescriptionTap: () => showPrescriptionBottomSheet(context),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String actionLabel,
    required VoidCallback onActionTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
            letterSpacing: -0.3,
          ),
        ),
        GestureDetector(
          onTap: onActionTap,
          child: Row(
            children: [
              Text(
                actionLabel,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 2),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 11,
                color: Color(0xFF2563EB),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 1. User Header Section
// ---------------------------------------------------------------------------
class UserHeaderSection extends StatelessWidget {
  final String userName;
  final String address;
  final bool isLoadingAddress;
  final VoidCallback onProfileTap;
  final VoidCallback onAddressTap;
  final VoidCallback onNotificationTap;

  const UserHeaderSection({
    super.key,
    required this.userName,
    required this.address,
    this.isLoadingAddress = false,
    required this.onProfileTap,
    required this.onAddressTap,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Profile Image with ring badge
        GestureDetector(
          onTap: onProfileTap,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Greeting & Address Box
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onProfileTap,
                child: Row(
                  children: [
                    const Text(
                      'Hii, ',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Color(0xFFFFD166),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(' 👋', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              GestureDetector(
                onTap: onAddressTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 13,
                        color: Color(0xFFFFD166),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          isLoadingAddress ? 'Fetching live location...' : address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      isLoadingAddress
                          ? const SizedBox(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Notification Icon with Active Indicator Dot
        GestureDetector(
          onTap: onNotificationTap,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 0.8,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 2. Search Box Bar
// ---------------------------------------------------------------------------
class SearchBoxBar extends StatelessWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onArrowTap;

  const SearchBoxBar({
    super.key,
    required this.onSearchTap,
    required this.onArrowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: Color(0xFF2563EB), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              readOnly: true,
              decoration: const InputDecoration(
                hintText: 'Search Medicines, healthcare, lab tests...',
                hintStyle: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 13,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onTap: onSearchTap,
            ),
          ),
          GestureDetector(
            onTap: onArrowTap,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFF2563EB),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. Flat 20% OFF Promo Banner
// ---------------------------------------------------------------------------
class PromoBannerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String code;
  final VoidCallback onTap;

  const PromoBannerCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.code,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Banner text & Coupon
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.content_copy_rounded,
                          size: 12,
                          color: Color(0xFF1D4ED8),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Use Code: $code',
                          style: const TextStyle(
                            color: Color(0xFF1D4ED8),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Product artwork mockup at right edge
            Positioned(
              right: 12,
              bottom: 0,
              top: 0,
              child: Image.network(
                'https://png.pngtree.com/png-vector/20240131/ourmid/pngtree-medicine-bottle-pills-capsules-mockup-png-image_11579294.png',
                fit: BoxFit.contain,
                width: 130,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.medication_rounded,
                  size: 70,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. Quick Services Row
// ---------------------------------------------------------------------------
class QuickServicesRow extends StatelessWidget {
  final ValueChanged<String> onServiceTap;

  const QuickServicesRow({
    super.key,
    required this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    final services = [
      {'title': 'Medicines', 'icon': Icons.medical_services_rounded, 'color': const Color(0xFFEC4899), 'bg': const Color(0xFFFCE7F3)},
      {'title': 'Health Care', 'icon': Icons.favorite_rounded, 'color': const Color(0xFFEF4444), 'bg': const Color(0xFFFEE2E2)},
      {'title': 'Lab Tests', 'icon': Icons.science_rounded, 'color': const Color(0xFF06B6D4), 'bg': const Color(0xFFCFFAFE)},
      {'title': 'Offers', 'icon': Icons.local_offer_rounded, 'color': const Color(0xFFF59E0B), 'bg': const Color(0xFFFEF3C7)},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: services.map((item) {
        final title = item['title'] as String;
        final icon = item['icon'] as IconData;
        final color = item['color'] as Color;
        final bg = item['bg'] as Color;

        return Expanded(
          child: GestureDetector(
            onTap: () => onServiceTap(title),
            child: Column(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: bg,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(icon, color: color, size: 26),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// 5. Upload Prescription Card
// ---------------------------------------------------------------------------
class UploadPrescriptionCard extends StatelessWidget {
  final VoidCallback onUploadTap;

  const UploadPrescriptionCard({
    super.key,
    required this.onUploadTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFFF97316), Color(0xFFEA580C)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF97316).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular Medical Icon Box
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.receipt_long_rounded,
                color: Color(0xFFEA580C),
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Title & Subtitle
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Upload Prescription',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Get medicines delivered safely & fast',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // Action Button
          ElevatedButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              onUploadTap();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFC2410C),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Text(
              'UPLOAD NOW',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6. Popular Categories 2x2 Grid
// ---------------------------------------------------------------------------
class PopularCategoriesGrid extends StatelessWidget {
  final ValueChanged<String> onCategoryTap;

  const PopularCategoriesGrid({
    super.key,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'title': 'Pain Relief',
        'bg': const Color(0xFFEFF6FF),
        'image': 'https://images.unsplash.com/photo-1579684385127-1ef15d508118?auto=format&fit=crop&w=400&q=80',
      },
      {
        'title': 'Vitamins & Care',
        'bg': const Color(0xFFFFF7ED),
        'image': 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80',
      },
      {
        'title': 'Diabetes Care',
        'bg': const Color(0xFFECFDF5),
        'image': 'https://images.unsplash.com/photo-1628771065518-0d82f1938462?auto=format&fit=crop&w=400&q=80',
      },
      {
        'title': 'Baby & Mother',
        'bg': const Color(0xFFFDF2F8),
        'image': 'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?auto=format&fit=crop&w=400&q=80',
      },
    ];

    return GridView.builder(
      itemCount: categories.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        final cat = categories[index];
        final title = cat['title'] as String;

        return InkWell(
          onTap: () => onCategoryTap(title),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            decoration: BoxDecoration(
              color: cat['bg'] as Color,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned(
                  right: -10,
                  bottom: -10,
                  top: 0,
                  width: 95,
                  child: Image.network(
                    cat['image'] as String,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(),
                  ),
                ),
                Positioned(
                  left: 12,
                  bottom: 14,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// 7. Trending Health Products Row
// ---------------------------------------------------------------------------
class TrendingProductsRow extends StatelessWidget {
  final ValueChanged<String> onProductTap;

  const TrendingProductsRow({
    super.key,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    final products = [
      {
        'name': 'Multivitamin Tablets',
        'price': '₹299',
        'mrp': '₹499',
        'discount': '40% OFF',
        'image': 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=300&q=80',
      },
      {
        'name': 'Digital Thermometer',
        'price': '₹180',
        'mrp': '₹300',
        'discount': '40% OFF',
        'image': 'https://images.unsplash.com/photo-1584017911766-d451b3d0e843?auto=format&fit=crop&w=300&q=80',
      },
      {
        'name': 'Pain Relief Spray',
        'price': '₹145',
        'mrp': '₹199',
        'discount': '27% OFF',
        'image': 'https://images.unsplash.com/photo-1579684385127-1ef15d508118?auto=format&fit=crop&w=300&q=80',
      },
    ];

    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: products.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = products[index];
          final name = item['name']!;

          return Container(
            width: 145,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Expanded(
                  child: Stack(
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item['image']!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.medication, color: Colors.grey, size: 40),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDC2626),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item['discount']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          item['price']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item['mrp']!,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => onProductTap(name),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 8. Trust Badges Footer Section
// ---------------------------------------------------------------------------
class TrustBadgesSection extends StatelessWidget {
  const TrustBadgesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _TrustItem(icon: Icons.verified_user_rounded, title: '100% Genuine'),
          _TrustItem(icon: Icons.flash_on_rounded, title: 'Fast Delivery'),
          _TrustItem(icon: Icons.shield_rounded, title: 'Secure Pay'),
        ],
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _TrustItem({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF475569)),
        const SizedBox(width: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF475569),
          ),
        ),
      ],
    );
  }
}
