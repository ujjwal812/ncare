import 'package:flutter/material.dart';
import 'package:ncare/utils/location_helper.dart';
import 'package:ncare/widgets/custom_bottom_nav_bar.dart';

class AddressModel {
  final String id;
  final String title;
  final String fullAddress;
  final IconData icon;

  const AddressModel({
    required this.id,
    required this.title,
    required this.fullAddress,
    required this.icon,
  });
}

class MyAddressScreen extends StatefulWidget {
  const MyAddressScreen({super.key});

  @override
  State<MyAddressScreen> createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {
  final int _currentNavIndex = 4; // Active tab state
  String _selectedAddressId = '1';

  late List<AddressModel> _addresses;

  @override
  void initState() {
    super.initState();
    _addresses = [
      const AddressModel(
        id: '1',
        title: 'Home',
        fullAddress: '123, Green Street, Pune - 411001',
        icon: Icons.home_rounded,
      ),
      const AddressModel(
        id: '2',
        title: 'Work',
        fullAddress: '45, Business Park, Pune - 411057',
        icon: Icons.work_rounded,
      ),
      const AddressModel(
        id: '3',
        title: "Mom's House",
        fullAddress: 'AB, Flower Street, Pune - 411002',
        icon: Icons.location_city_rounded,
      ),
    ];
  }

  Future<void> _fetchCurrentLiveLocation() async {
    UserAddressData? addressData =
        await LocationHelper.fetchLiveAddressDetails(context);
    if (addressData != null) {
      final String liveId = DateTime.now().millisecondsSinceEpoch.toString();
      final newAddr = AddressModel(
        id: liveId,
        title: 'Current Live Location',
        fullAddress: addressData.fullFormattedAddress,
        icon: Icons.my_location_rounded,
      );
      setState(() {
        _addresses.insert(0, newAddr);
        _selectedAddressId = liveId;
      });
    }
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

  void _showAddNewAddressDialog() {
    final titleController = TextEditingController();
    final addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Add New Address',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Address Name (e.g. Home, Office)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Full Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isDense: true,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    addressController.text.isNotEmpty) {
                  Navigator.pop(context);
                  _showSnackBar('New address added successfully!');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3880C9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Save Address',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
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
            // Header Bar
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
                    'Select Delivery Address',
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

            // White Rounded Sheet Body
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 24, 18, 20),
                    child: Column(
                      children: [
                        // List of Addresses
                        Expanded(
                          child: ListView.separated(
                            itemCount: _addresses.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              final addr = _addresses[index];
                              final isSelected =
                                  _selectedAddressId == addr.id;

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedAddressId = addr.id;
                                  });
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFAFBFC),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF3880C9)
                                          : const Color(0xFFECEFF3),
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          addr.icon,
                                          color: const Color(0xFF5D6B82),
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              addr.title,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF1E242B),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              addr.fullAddress,
                                              style: const TextStyle(
                                                fontSize: 12.5,
                                                color: Color(0xFF718096),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Icon(
                                        isSelected
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_off,
                                        color: isSelected
                                            ? const Color(0xFF3880C9)
                                            : const Color(0xFFA0AEC0),
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Use Current Live Location Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: _fetchCurrentLiveLocation,
                            icon: const Icon(
                              Icons.my_location_rounded,
                              color: Color(0xFF3880C9),
                              size: 20,
                            ),
                            label: const Text(
                              'Use Current Live Location',
                              style: TextStyle(
                                color: Color(0xFF3880C9),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xFF3880C9),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // + Add New Address Pill Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _showAddNewAddressDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3880C9),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              '+ Add New Address',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
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
