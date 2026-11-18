import 'package:flutter/material.dart';
import 'package:ncare/widgets/custom_bottom_nav_bar.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NotificationsScreen(),
  ));
}

// ---------------------------------------------------------------------------
// 1. Notification Model
// ---------------------------------------------------------------------------
enum NotificationCategory { orders, offers, updates }

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String date;
  final String time;
  final NotificationCategory category;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.time,
    required this.category,
    this.isRead = false,
  });
}

// ---------------------------------------------------------------------------
// 2. Main Notifications Screen
// ---------------------------------------------------------------------------
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final int _currentNavIndex = 4; // Can be set according to tab routing
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Orders', 'Offers', 'Updates'];

  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Order Delivered',
      message: 'Your Order #NC123456 has been delivered successfully',
      date: '14 Aug, 26',
      time: '10:30 AM',
      category: NotificationCategory.orders,
    ),
    NotificationItem(
      id: '2',
      title: 'Offer for you',
      message: 'Flat 20% Off on all medicines.\nUse code : SAVE20',
      date: '12 Aug, 26',
      time: '10:30 AM',
      category: NotificationCategory.offers,
    ),
    NotificationItem(
      id: '3',
      title: 'Refill Reminder',
      message: "It's time to record your Medicines",
      date: '10 Aug, 26',
      time: '10:30 AM',
      category: NotificationCategory.updates,
    ),
    NotificationItem(
      id: '4',
      title: 'Payment Successfully',
      message: 'Payment of ₹56.00 was successful.',
      date: '08 Aug, 26',
      time: '10:30 AM',
      category: NotificationCategory.orders,
    ),
  ];

  List<NotificationItem> get _filteredNotifications {
    if (_selectedFilter == 'All') return _notifications;
    if (_selectedFilter == 'Orders') {
      return _notifications
          .where((n) => n.category == NotificationCategory.orders)
          .toList();
    }
    if (_selectedFilter == 'Offers') {
      return _notifications
          .where((n) => n.category == NotificationCategory.offers)
          .toList();
    }
    if (_selectedFilter == 'Updates') {
      return _notifications
          .where((n) => n.category == NotificationCategory.updates)
          .toList();
    }
    return _notifications;
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
              const SizedBox(height: 8),
              const Text(
                'Please select an option to upload your prescription',
                style: TextStyle(fontSize: 13, color: Colors.black54),
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
              color: color.withValues(alpha: 0.1),
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

  void _markAllAsRead() {
    setState(() {
      for (var item in _notifications) {
        item.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3880C9), // Top primary blue
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Notifications',
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

            // White Curved Main Sheet
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

                      // Filter Pills Row (All, Orders, Offers, Updates)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: _filters.map((filter) {
                            final isSelected = _selectedFilter == filter;
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedFilter = filter;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(22),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFF505BAC) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(22),
                                      border: Border.all(
                                        color: isSelected ? const Color(0xFF505BAC) : const Color(0xFFE2E8F0),
                                        width: 1,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      filter,
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : const Color(0xFF6B7280),
                                        fontSize: 12,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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

                      // Notification List
                      Expanded(
                        child: _filteredNotifications.isEmpty
                            ? const Center(
                          child: Text(
                            'No notifications found',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        )
                            : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                          itemCount: _filteredNotifications.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return NotificationCard(
                              item: _filteredNotifications[index],
                            );
                          },
                        ),
                      ),

                      // "Mark all as read" Button
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _markAllAsRead,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF505BAC),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              'Mark all as read',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
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
// 3. Notification Card Widget
// ---------------------------------------------------------------------------
class NotificationCard extends StatelessWidget {
  final NotificationItem item;

  const NotificationCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFECEFF3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shopping Cart Icon Container
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E9EE)),
            ),
            child: const Center(
              child: Icon(
                Icons.shopping_cart_outlined,
                color: Color(0xFF718096),
                size: 24,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Title & Message Body
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E242B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.message,
                  style: const TextStyle(
                    fontSize: 11.5,
                    height: 1.35,
                    color: Color(0xFF5D6B82),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Date & Time Timestamp
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.date,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: Color(0xFF8C98A8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.time,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: Color(0xFF8C98A8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

