import 'package:flutter/material.dart';
import 'package:ncare/screen/order/Result_found_screen.dart';
import 'package:ncare/services/cart_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final MedicineModel medicine;

  const ProductDetailScreen({
    super.key,
    required this.medicine,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedPackIndex = 0;
  bool _isFavorite = false;

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

  @override
  Widget build(BuildContext context) {
    final med = widget.medicine;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F3FD), // Soft background under artwork
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar Icons
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Color(0xFF4A5568), size: 24),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color:
                            _isFavorite ? Colors.red : const Color(0xFF8C98A8),
                        size: 22,
                      ),
                      onPressed: () {
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });
                        _showSnackBar(_isFavorite
                            ? 'Added to Wishlist'
                            : 'Removed from Wishlist');
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Product Hero Image Preview
            Expanded(
              flex: 4,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.network(
                    med.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.medication_rounded,
                      size: 120,
                      color: Color(0xFF3880C9),
                    ),
                  ),
                ),
              ),
            ),

            // Details Bottom Sheet Container
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      med.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF485899),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Subtitle / Composition
                    Text(
                      med.composition,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8A94A6),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Star Rating
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Color(0xFFFFB800), size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${med.rating} (${med.reviewsCount})',
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF718096),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Price & Discount Tag
                    Row(
                      children: [
                        Text(
                          '₹${med.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E242B),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '₹${med.originalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                            color: Color(0xFFA0AEC0),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            med.discountPercentage,
                            style: const TextStyle(
                              color: Color(0xFFE64A19),
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Pack Size Selector
                    Row(
                      children: [
                        const Text(
                          'Pack Size',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                              height: 1, color: const Color(0xFFEDF2F7)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Pack size options
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(med.packSizes.length, (index) {
                          final isSelected = _selectedPackIndex == index;
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: InkWell(
                              onTap: () =>
                                  setState(() => _selectedPackIndex = index),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFFFFA726)
                                        : const Color(0xFFE2E8F0),
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Text(
                                  med.packSizes[index],
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? const Color(0xFFE91E63)
                                        : const Color(0xFF718096),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // About Medicine Header
                    Row(
                      children: [
                        const Text(
                          'About Medicine',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                              height: 1, color: const Color(0xFFEDF2F7)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Medicine Description Body
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Text(
                          med.description,
                          style: const TextStyle(
                            fontSize: 11.5,
                            height: 1.5,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Add to Cart Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          CartService.instance.addItem(
                            id: '${med.id}_${med.packSizes[_selectedPackIndex]}',
                            name: '${med.name} (${med.packSizes[_selectedPackIndex]})',
                            composition: med.composition,
                            price: med.price,
                            imageUrl: med.imageUrl,
                          );
                          _showSnackBar(
                              '${med.name} (${med.packSizes[_selectedPackIndex]}) added to cart!');
                        },
                        icon: const Icon(Icons.shopping_cart_outlined,
                            color: Colors.white, size: 20),
                        label: const Text(
                          'Add to Cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF505BAC),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
