import 'package:flutter/material.dart';
import '../models/product.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final Map<String, int> _items = {}; // Product ID -> Quantity

  Map<String, int> get items => _items;

  int get itemCount => _items.values.fold(0, (sum, quantity) => sum + quantity);

  void addItem(String productId) {
    if (_items.containsKey(productId)) {
      _items.update(productId, (existing) => existing + 1);
    } else {
      _items.putIfAbsent(productId, () => 1);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]! > 1) {
        _items.update(productId, (existing) => existing - 1);
      } else {
        _items.remove(productId);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double getTotalAmount(List<Product> allProducts) {
    double total = 0.0;
    _items.forEach((key, quantity) {
      final product = allProducts.firstWhere((p) => p.id == key);
      total += product.price * quantity;
    });
    return total;
  }
}
