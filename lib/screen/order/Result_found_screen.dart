import 'package:flutter/material.dart';
import 'package:ncare/screen/order/product_deats_screen.dart';
import 'package:ncare/services/cart_service.dart';

// Data Model for Medicines
class MedicineModel {
  final String id;
  final String name;
  final String composition;
  final double price;
  final double originalPrice;
  final String discountPercentage;
  final double rating;
  final String reviewsCount;
  final String imageUrl;
  final String description;
  final List<String> packSizes;

  const MedicineModel({
    required this.id,
    required this.name,
    required this.composition,
    required this.price,
    required this.originalPrice,
    required this.discountPercentage,
    required this.rating,
    required this.reviewsCount,
    required this.imageUrl,
    required this.description,
    required this.packSizes,
  });
}

// Sample Data List
const List<MedicineModel> sampleMedicines = [
  MedicineModel(
    id: '1',
    name: 'Crocin 650 Tablet',
    composition: 'Paracetamol 650 mg',
    price: 15.60,
    originalPrice: 20.00,
    discountPercentage: '22% OFF',
    rating: 4.5,
    reviewsCount: '1.2K',
    imageUrl:
        'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80',
    description:
        'Crocin 650 Tablet is a trusted paracetamol medicine used to reduce fever and relieve mild to moderate pain, such as headache, body pain, and toothache. It works by blocking pain signals and lowering body temperature.',
    packSizes: ['10 Tablet', '15 Tablet', 'Strip of 20'],
  ),
  MedicineModel(
    id: '2',
    name: 'Dolo 650 Tablet',
    composition: 'Paracetamol 650 mg',
    price: 14.20,
    originalPrice: 18.00,
    discountPercentage: '20% OFF',
    rating: 4.6,
    reviewsCount: '3.4K',
    imageUrl:
        'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80',
    description:
        'Dolo 650 is widely prescribed for fast relief from high fever and severe body ache with rapid relief action.',
    packSizes: ['15 Tablet', '30 Tablet'],
  ),
  MedicineModel(
    id: '3',
    name: 'Calpol 650 Tablet',
    composition: 'Paracetamol 650 mg',
    price: 16.10,
    originalPrice: 21.00,
    discountPercentage: '23% OFF',
    rating: 4.4,
    reviewsCount: '980',
    imageUrl:
        'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80',
    description:
        'Calpol 650 helps soothe fever and body aches with rapid release paracetamol formula.',
    packSizes: ['10 Tablet', '15 Tablet'],
  ),
  MedicineModel(
    id: '4',
    name: 'Crocin 650 Advance',
    composition: 'Paracetamol 650 mg',
    price: 15.60,
    originalPrice: 20.00,
    discountPercentage: '22% OFF',
    rating: 4.5,
    reviewsCount: '1.2K',
    imageUrl:
        'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80',
    description:
        'Crocin 650 Advance is an effective medicine for symptomatic relief of fever and body pain.',
    packSizes: ['10 Tablet', '20 Tablet'],
  ),
];

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
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
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 24),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Result found',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // White Rounded Body
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
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'We found similar medicines',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E242B),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // List of items
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: sampleMedicines.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            final medicine = sampleMedicines[index];
                            return MedicineResultCard(
                              medicine: medicine,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailScreen(
                                      medicine: medicine,
                                    ),
                                  ),
                                );
                              },
                              onAddTap: () {
                                CartService.instance.addItem(
                                  id: medicine.id,
                                  name: medicine.name,
                                  composition: medicine.composition,
                                  price: medicine.price,
                                  imageUrl: medicine.imageUrl,
                                );
                                _showSnackBar('${medicine.name} added to cart!');
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 28),

                        // View More Results Button
                        Center(
                          child: OutlinedButton(
                            onPressed: () {
                              _showSnackBar('Loading more results...');
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFD6DBE1)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 36,
                                vertical: 14,
                              ),
                            ),
                            child: const Text(
                              'View More Results',
                              style: TextStyle(
                                color: Color(0xFF4A5568),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MedicineResultCard extends StatelessWidget {
  final MedicineModel medicine;
  final VoidCallback onTap;
  final VoidCallback onAddTap;

  const MedicineResultCard({
    super.key,
    required this.medicine,
    required this.onTap,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFBFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F3F5)),
        ),
        child: Row(
          children: [
            // Thumbnail container
            Container(
              width: 70,
              height: 70,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E9EE)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  medicine.imageUrl,
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

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine.name,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A5998),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    medicine.composition,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF8C98A8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '₹${medicine.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E242B),
                    ),
                  ),
                ],
              ),
            ),

            // Plus / Add Button
            GestureDetector(
              onTap: onAddTap,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFB5BDC9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
