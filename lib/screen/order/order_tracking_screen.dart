import 'package:flutter/material.dart';
import 'package:ncare/widgets/custom_bottom_nav_bar.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OrderTrackingScreen(),
  ));
}

// ---------------------------------------------------------------------------
// Model for Tracking Step
// ---------------------------------------------------------------------------
class TrackingStep {
  final String title;
  final String date;
  final bool isCompleted;

  const TrackingStep({
    required this.title,
    required this.date,
    required this.isCompleted,
  });
}

// ---------------------------------------------------------------------------
// Main Order Tracking Screen
// ---------------------------------------------------------------------------
class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final int _currentNavIndex = 1; // "Order" tab active

  final List<TrackingStep> _steps = const [
    TrackingStep(title: 'Placed', date: '12 Aug, 26', isCompleted: true),
    TrackingStep(title: 'Confirmed', date: '12 Aug, 26', isCompleted: true),
    TrackingStep(title: 'Packed', date: '13 Aug, 26', isCompleted: false),
    TrackingStep(title: 'Dispatched', date: '14 Aug, 26', isCompleted: false),
    TrackingStep(title: 'Delivered', date: '14 Aug, 26', isCompleted: false),
  ];

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
                    'Order Tracking',
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
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order ID Header + "My Orders" Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Order ID :',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  '#NC123456',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E242B),
                                  ),
                                ),
                              ],
                            ),
                            // "My Orders" pill button
                            OutlinedButton.icon(
                              onPressed: () {
                                Navigator.maybePop(context);
                              },
                              icon: const Icon(
                                Icons.assignment_outlined,
                                size: 16,
                                color: Color(0xFF505BAC),
                              ),
                              label: const Text(
                                'My Orders',
                                style: TextStyle(
                                  color: Color(0xFF505BAC),
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFD6DBE1)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Timeline Tracker
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            children: List.generate(_steps.length, (index) {
                              final step = _steps[index];
                              final isLast = index == _steps.length - 1;
                              final nextCompleted = !isLast && _steps[index + 1].isCompleted;

                              return TimelineStepTile(
                                step: step,
                                isLast: isLast,
                                isLineActive: nextCompleted,
                              );
                            }),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Bottom status info text
                        const Center(
                          child: Text(
                            'Your Order in on the way',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF718096),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Delivery Partner Card
                        const DeliveryPartnerCard(
                          name: 'Rahul Sharma',
                          phone: '+91 000 0000 000',
                          imageUrl: 'https://i.pravatar.cc/150?img=11',
                        ),
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
        currentIndex: _currentNavIndex,
        onTap: (index) => handleBottomNavTap(
          context,
          index,
          currentIndex: _currentNavIndex,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Timeline Step Item Widget
// ---------------------------------------------------------------------------
class TimelineStepTile extends StatelessWidget {
  final TrackingStep step;
  final bool isLast;
  final bool isLineActive;

  const TimelineStepTile({
    super.key,
    required this.step,
    required this.isLast,
    required this.isLineActive,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF3880C9);
    const inactiveColor = Color(0xFFB5BDC9);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator (Node & Vertical Line)
          Column(
            children: [
              // Outer circle indicator
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: step.isCompleted ? activeColor.withValues(alpha: 0.35) : Colors.transparent,
                    width: 3.5,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: step.isCompleted ? activeColor : inactiveColor,
                    ),
                  ),
                ),
              ),

              // Vertical connector line
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.5,
                    color: isLineActive ? activeColor : const Color(0xFFDCE2E8),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 16),

          // Label & Date
          Padding(
            padding: const EdgeInsets.only(bottom: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: step.isCompleted ? const Color(0xFF303B77) : const Color(0xFF1E242B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  step.date,
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
    );
  }
}

// ---------------------------------------------------------------------------
// Delivery Partner Card Widget
// ---------------------------------------------------------------------------
class DeliveryPartnerCard extends StatelessWidget {
  final String name;
  final String phone;
  final String imageUrl;

  const DeliveryPartnerCard({
    super.key,
    required this.name,
    required this.phone,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EFF6), width: 1),
      ),
      child: Row(
        children: [
          // Driver Avatar
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(imageUrl),
            backgroundColor: Colors.grey.shade200,
          ),

          const SizedBox(width: 14),

          // Name and Phone
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Delivery Partner',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF718096),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E242B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  phone,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF8C98A8),
                  ),
                ),
              ],
            ),
          ),

          // Call Button with Ripple Ring Effect
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
            ),
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Calling $name ($phone)...')),
                );
              },
              borderRadius: BorderRadius.circular(25),
              child: Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Color(0xFF505BAC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.phone,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}