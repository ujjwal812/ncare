import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ncare/navigation/all_routes.dart';
import 'package:ncare/widgets/custom_bottom_nav_bar.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<CategoryCategoryGroup> categoryGroups = const [
    CategoryCategoryGroup(
      groupTitle: 'Top Categories',
      categories: [
        CategoryDetail(
          title: 'Pain Relief',
          subtitle: 'Tablets, Sprays & Ointments',
          icon: Icons.healing_rounded,
          color: Color(0xFFEF4444),
          bg: Color(0xFFFEE2E2),
        ),
        CategoryDetail(
          title: 'Vitamins & Supplements',
          subtitle: 'Multivitamins, Calcium & Minerals',
          icon: Icons.vaccines_rounded,
          color: Color(0xFFF59E0B),
          bg: Color(0xFFFEF3C7),
        ),
        CategoryDetail(
          title: 'Diabetes Care',
          subtitle: 'Glucometers, Strips & Medicines',
          icon: Icons.sanitizer_rounded,
          color: Color(0xFF3B82F6),
          bg: Color(0xFFDBEAFE),
        ),
        CategoryDetail(
          title: 'Ayurvedic Care',
          subtitle: 'Herbal & Natural Care',
          icon: Icons.spa_rounded,
          color: Color(0xFF10B981),
          bg: Color(0xFFD1FAE5),
        ),
      ],
    ),
    CategoryCategoryGroup(
      groupTitle: 'Health & Wellness',
      categories: [
        CategoryDetail(
          title: 'Antibiotics',
          subtitle: 'Prescription Anti-infectives',
          icon: Icons.medication_rounded,
          color: Color(0xFF8B5CF6),
          bg: Color(0xFFEDE9FE),
        ),
        CategoryDetail(
          title: 'Skin & Beauty',
          subtitle: 'Creams, Lotions & Serums',
          icon: Icons.face_retouching_natural_rounded,
          color: Color(0xFFEC4899),
          bg: Color(0xFFFCE7F3),
        ),
        CategoryDetail(
          title: 'Baby & Mother',
          subtitle: 'Diapers, Food & Care',
          icon: Icons.child_care_rounded,
          color: Color(0xFFF97316),
          bg: Color(0xFFFFEDD5),
        ),
        CategoryDetail(
          title: 'Cardiac & Heart',
          subtitle: 'BP Monitors & Heart Care',
          icon: Icons.favorite_rounded,
          color: Color(0xFFDC2626),
          bg: Color(0xFFFEE2E2),
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3880C9),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header Bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 24),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'All Categories',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // White Curved Main Body
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search Box
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: const Color(0xFFE5E7EB), width: 1),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const Icon(Icons.search,
                                  color: Color(0xFF9CA3AF), size: 22),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: const InputDecoration(
                                    hintText: 'Search in categories...',
                                    hintStyle: TextStyle(
                                      color: Color(0xFF9CA3AF),
                                      fontSize: 13.5,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onSubmitted: (query) {
                                    if (query.trim().isNotEmpty) {
                                      Navigator.pushNamed(
                                          context, AppRoutes.searchResult);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Render Category Groups
                        ...categoryGroups.map((group) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                group.groupTitle,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 14),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: group.categories.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 1.35,
                                ),
                                itemBuilder: (context, index) {
                                  final cat = group.categories[index];
                                  return InkWell(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.searchResult,
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(18),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: cat.bg,
                                        borderRadius:
                                            BorderRadius.circular(18),
                                        border: Border.all(
                                          color: cat.color
                                              .withValues(alpha: 0.15),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: cat.color
                                                      .withValues(alpha: 0.2),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              cat.icon,
                                              color: cat.color,
                                              size: 22,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cat.title,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                  color: Color(0xFF0F172A),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                cat.subtitle,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey.shade700,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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

class CategoryCategoryGroup {
  final String groupTitle;
  final List<CategoryDetail> categories;

  const CategoryCategoryGroup({
    required this.groupTitle,
    required this.categories,
  });
}

class CategoryDetail {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color bg;

  const CategoryDetail({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.bg,
  });
}
