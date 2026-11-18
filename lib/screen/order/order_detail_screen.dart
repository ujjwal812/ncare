import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ncare/navigation/all_routes.dart';
import 'package:ncare/widgets/custom_bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order Detail',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF3880C9),
        fontFamily: 'Roboto',
      ),
      home: const OrderDetailScreen(),
    );
  }
}

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final int _currentNavIndex = 1; // "Order" tab active

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3880C9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3880C9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.maybePop(context);
          },
        ),
        titleSpacing: 0,
        title: const Text(
          'Order Detail',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 18.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order ID & Delivery Date Card
                      _buildHeaderInfoCard(),
                      const SizedBox(height: 16),

                      // Order Item 1: Crocine 650
                      _buildOrderItemCard(
                        title: 'crocine 650 Tablet',
                        unit: '10 Tablet',
                        price: '₹15.60',
                        qty: '1',
                        iconData: Icons.medication_liquid_sharp,
                        cardColor: const Color(0xFFE3F2FD),
                      ),
                      const SizedBox(height: 12),

                      // Order Item 2: Dolo 650
                      _buildOrderItemCard(
                        title: 'Dolo 650 Tablet',
                        unit: '15 Tablet',
                        price: '₹28.50',
                        qty: '1',
                        iconData: Icons.medical_services_outlined,
                        cardColor: const Color(0xFFEDE7F6),
                      ),
                      const SizedBox(height: 20),

                      const Divider(color: Color(0xFFCFD8DC), thickness: 1),
                      const SizedBox(height: 12),

                      // Price Details Section
                      const Text(
                        'Price Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E272E),
                        ),
                      ),
                      const SizedBox(height: 14),

                      _buildPriceRow('MRP (2 Items)', '₹44.00'),
                      const SizedBox(height: 10),
                      _buildPriceRow(
                        'Discount',
                        '- ₹8.00',
                        valueColor: const Color(0xFFE91E63),
                      ),
                      const SizedBox(height: 10),
                      _buildPriceRow('Delivery Fee', '₹20.00'),
                      const SizedBox(height: 14),

                      const Divider(color: Color(0xFFECEFF1), thickness: 1),
                      const SizedBox(height: 10),

                      // To be paid
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'To be paid',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E272E),
                            ),
                          ),
                          Text(
                            '₹56.00',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E272E),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Track Order Status Button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 14.0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pushNamed(context, AppRoutes.orderTracking);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4C5DB8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Track Order Status',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          HapticFeedback.selectionClick();
          handleBottomNavTap(
            context,
            index,
            currentIndex: _currentNavIndex,
          );
        },
      ),
    );
  }

  // Header Info Card (Order ID + Delivered Date)
  Widget _buildHeaderInfoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Order ID Side
          Expanded(
            child: Row(
              children: [
                Icon(Icons.receipt_long_outlined,
                    size: 28, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Order ID :',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '#NC123456',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263238),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Vertical Separator
          Container(
            height: 32,
            width: 1,
            color: Colors.grey.shade300,
          ),
          const SizedBox(width: 14),

          // Delivered On Side
          Expanded(
            child: Row(
              children: [
                Icon(Icons.local_shipping_outlined,
                    size: 28, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Delivered on :',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '14 Aug, 2026',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263238),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Medicine Item Card
  Widget _buildOrderItemCard({
    required String title,
    required String unit,
    required String price,
    required String qty,
    required IconData iconData,
    required Color cardColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Medicine Product Thumbnail
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              iconData,
              size: 32,
              color: const Color(0xFF1E88E5),
            ),
          ),
          const SizedBox(width: 12),

          // Title & Unit
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3F51B5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Price & Qty
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF263238),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Qty : $qty',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Row for Price details
  Widget _buildPriceRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: valueColor ?? const Color(0xFF263238),
          ),
        ),
      ],
    );
  }
}
