import 'package:flutter/material.dart';
import 'package:ncare/navigation/all_routes.dart';
import 'package:ncare/services/cart_service.dart';
import 'package:ncare/widgets/custom_bottom_nav_bar.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CartScreen(),
  ));
}

// ---------------------------------------------------------------------------
// Main Cart Screen
// ---------------------------------------------------------------------------
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final int _currentNavIndex = 3; // 'Cart' tab active

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: CartService.instance,
      builder: (context, child) {
        final cartService = CartService.instance;
        final cartItems = cartService.items;
        final totalItemCount = cartService.totalItemCount;
        final totalMrp = cartService.totalMrp;
        final discount = cartService.discount;
        final deliveryFee = cartService.deliveryFee;
        final finalAmount = cartService.finalAmount;

        return Scaffold(
          backgroundColor: const Color(0xFF3880C9),
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top App Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white, size: 24),
                            onPressed: () => Navigator.maybePop(context),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'My Cart',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // Total Item Badge Pill
                      Row(
                        children: [
                          const Text(
                            'Total Item  ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              totalItemCount.toString().padLeft(2, '0'),
                              style: const TextStyle(
                                color: Color(0xFF2865A0),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

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
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Cart Items List
                            if (cartItems.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Center(
                                  child: Text(
                                    'Your cart is empty',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                  ),
                                ),
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: cartItems.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final item = cartItems[index];
                                  return CartItemCard(
                                    item: item,
                                    onIncrement: () =>
                                        cartService.incrementQty(index),
                                    onDecrement: () =>
                                        cartService.decrementQty(index),
                                  );
                                },
                              ),

                            const SizedBox(height: 24),
                            const Divider(
                                color: Color(0xFFE5E7EB), thickness: 1),
                            const SizedBox(height: 16),

                            // Price Details Heading
                            const Text(
                              'Price Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E242B),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Price Breakdown
                            _buildPriceRow(
                              'MRP ($totalItemCount Items)',
                              '₹${totalMrp.toStringAsFixed(2)}',
                            ),
                            const SizedBox(height: 12),
                            _buildPriceRow(
                              'Discount',
                              '- ₹${discount.toStringAsFixed(2)}',
                              valueColor: const Color(0xFFE91E63),
                            ),
                            const SizedBox(height: 12),
                            _buildPriceRow(
                              'Delivery Fee',
                              '₹${deliveryFee.toStringAsFixed(2)}',
                            ),

                            const SizedBox(height: 16),
                            const Divider(
                                color: Color(0xFFE5E7EB), thickness: 1),
                            const SizedBox(height: 14),

                            // Total Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'To be paid',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E242B),
                                  ),
                                ),
                                Text(
                                  '₹${finalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E242B),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 48),

                            // Checkout Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: cartItems.isEmpty
                                    ? null
                                    : () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.paymentMethod,
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF505BAC),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: const Text(
                                  'Proceed to Checkout',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
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
      },
    );
  }

  Widget _buildPriceRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF718096),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? const Color(0xFF1E242B),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Cart Item Card Widget
// ---------------------------------------------------------------------------
class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E9EE), width: 1),
      ),
      child: Row(
        children: [
          // Image Box
          Container(
            width: 68,
            height: 68,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEDF2F7)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.medication_rounded,
                  color: Color(0xFF3880C9),
                  size: 32,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Details (Name, Composition, Price)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF485899),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.composition,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8C98A8),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '₹${item.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E242B),
                  ),
                ),
              ],
            ),
          ),

          // Counter Capsule (+ / -)
          Container(
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: onDecrement,
                  borderRadius: BorderRadius.circular(12),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child:
                        Icon(Icons.remove, size: 14, color: Color(0xFF4A5568)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    '${item.quantity}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E242B),
                    ),
                  ),
                ),
                InkWell(
                  onTap: onIncrement,
                  borderRadius: BorderRadius.circular(12),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Icon(Icons.add, size: 14, color: Color(0xFF4A5568)),
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
