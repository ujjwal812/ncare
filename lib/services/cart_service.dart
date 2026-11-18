import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String name;
  final String composition;
  final double unitPrice;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.composition,
    required this.unitPrice,
    required this.imageUrl,
    this.quantity = 1,
  });

  double get totalPrice => unitPrice * quantity;
}

class CartService extends ChangeNotifier {
  CartService._internal() {
    // Initial sample items
    _items.addAll([
      CartItem(
        id: '1',
        name: 'Crocin 650 Tablet',
        composition: 'Paracetamol 650 mg',
        unitPrice: 15.60,
        quantity: 1,
        imageUrl:
            'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80',
      ),
      CartItem(
        id: '2',
        name: 'Dolo 650 Tablet',
        composition: 'Paracetamol 650 mg',
        unitPrice: 28.40,
        quantity: 1,
        imageUrl:
            'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80',
      ),
    ]);
  }

  static final CartService instance = CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItemCount =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalMrp =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get discount => _items.isEmpty ? 0.0 : 8.00;

  double get deliveryFee => _items.isEmpty ? 0.0 : 20.00;

  double get finalAmount =>
      _items.isEmpty ? 0.0 : (totalMrp - discount + deliveryFee);

  void addItem({
    required String id,
    required String name,
    required String composition,
    required double price,
    required String imageUrl,
    int quantity = 1,
  }) {
    final existingIndex = _items.indexWhere((item) =>
        item.id == id || item.name.toLowerCase() == name.toLowerCase());
    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(
        CartItem(
          id: id,
          name: name,
          composition: composition,
          unitPrice: price,
          imageUrl: imageUrl,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void incrementQty(int index) {
    if (index >= 0 && index < _items.length) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQty(int index) {
    if (index >= 0 && index < _items.length) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
