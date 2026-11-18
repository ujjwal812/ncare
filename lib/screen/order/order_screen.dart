import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ncare/widgets/custom_bottom_nav_bar.dart';

// ---------------------------------------------------------------------------
// 1. Order Data Model
// ---------------------------------------------------------------------------
enum OrderStatus { delivered, cancelled, ongoing }

class OrderItemModel {
  final String orderId;
  final String date;
  final OrderStatus status;
  final String imageUrl;
  final Color? cardBgColor;

  const OrderItemModel({
    required this.orderId,
    required this.date,
    required this.status,
    required this.imageUrl,
    this.cardBgColor,
  });
}

// ---------------------------------------------------------------------------
// 2. Main My Orders Screen
// ---------------------------------------------------------------------------
class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final int _currentNavIndex = 1; // "Order" tab active
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Ongoing', 'Delivered', 'Cancelled'];

  // Sample Orders matching the design
  final List<OrderItemModel> _allOrders = const [
    OrderItemModel(
      orderId: '#NC123456',
      date: '15 Aug, 26',
      status: OrderStatus.delivered,
      imageUrl:
          'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80',
    ),
    OrderItemModel(
      orderId: '#NC123455',
      date: '10 Aug, 26',
      status: OrderStatus.delivered,
      imageUrl:
          'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80',
      cardBgColor:
          Color(0xFFFDF6EE), // Subtle peach background as seen in design
    ),
    OrderItemModel(
      orderId: '#NC123542',
      date: '08 Aug, 26',
      status: OrderStatus.cancelled,
      imageUrl:
          'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80',
    ),
    OrderItemModel(
      orderId: '#NC123542',
      date: '06 Aug, 26',
      status: OrderStatus.delivered,
      imageUrl:
          'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80',
    ),
  ];

  List<OrderItemModel> get _filteredOrders {
    if (_selectedFilter == 'All') return _allOrders;
    if (_selectedFilter == 'Delivered') {
      return _allOrders
          .where((o) => o.status == OrderStatus.delivered)
          .toList();
    }
    if (_selectedFilter == 'Cancelled') {
      return _allOrders
          .where((o) => o.status == OrderStatus.cancelled)
          .toList();
    }
    if (_selectedFilter == 'Ongoing') {
      return _allOrders.where((o) => o.status == OrderStatus.ongoing).toList();
    }
    return _allOrders;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showPrescriptionBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Upload Prescription',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2432),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _uploadOption(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    color: const Color(0xFF4A55A2),
                    onTap: () {
                      Navigator.pop(context);
                      _showSnackBar('Opening Camera...');
                    },
                  ),
                  _uploadOption(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    color: const Color(0xFFE28913),
                    onTap: () {
                      Navigator.pop(context);
                      _showSnackBar('Opening Gallery...');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _uploadOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3880C9), // Primary top header blue
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 24),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'My Orders',
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

            // Main White Curved Sheet
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
                  child: Column(
                    children: [
                      const SizedBox(height: 18),

                      // Filter Pills Row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: _filters.map((filter) {
                            final isSelected = _selectedFilter == filter;
                            return Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedFilter = filter;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF505BAC)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFF505BAC)
                                            : const Color(0xFFE2E8F0),
                                        width: 1,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      filter,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFF6B7280),
                                        fontSize: 12,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Orders List
                      Expanded(
                        child: _filteredOrders.isEmpty
                            ? const Center(
                                child: Text(
                                  'No orders found',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              )
                            : ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.fromLTRB(16, 4, 16, 20),
                                itemCount: _filteredOrders.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 14),
                                itemBuilder: (context, index) {
                                  final order = _filteredOrders[index];
                                  return OrderCard(
                                    order: order,
                                    onViewDetails: () {
                                      HapticFeedback.lightImpact();
                                      Navigator.pushNamed(
                                          context, '/order_detail');
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) => handleBottomNavTap(
          context,
          index,
          currentIndex: _currentNavIndex,
          onPrescriptionTap: _showPrescriptionBottomSheet,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. Order Card Widget
// ---------------------------------------------------------------------------
class OrderCard extends StatelessWidget {
  final OrderItemModel order;
  final VoidCallback onViewDetails;

  const OrderCard({
    super.key,
    required this.order,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final isDelivered = order.status == OrderStatus.delivered;
    final statusText = isDelivered ? 'Delivered' : 'Cancelled';
    final statusColor =
        isDelivered ? const Color(0xFF00C853) : const Color(0xFFE53935);
    final statusIcon =
        isDelivered ? Icons.check_circle_rounded : Icons.cancel_rounded;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: order.cardBgColor ?? const Color(0xFFFAFBFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: order.cardBgColor != null
              ? const Color(0xFFF1E5D5)
              : const Color(0xFFF1F3F5),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Product Image container
              Container(
                width: 72,
                height: 72,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E9EE)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    order.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.medication_liquid_sharp,
                      color: Color(0xFF3880C9),
                      size: 32,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // Order ID & Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.orderId,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E242B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.date,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF718096),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Top Right Status Badge (Delivered / Cancelled)
          Positioned(
            right: 4,
            top: 2,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(statusIcon, color: statusColor, size: 14),
              ],
            ),
          ),

          // Bottom Right "View Details" Pill Button
          Positioned(
            right: 4,
            bottom: 2,
            child: SizedBox(
              height: 28,
              child: ElevatedButton(
                onPressed: onViewDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF505BAC),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


