import 'package:flutter/material.dart';
import 'package:restaurant/models/cart_item.dart';
import 'package:restaurant/models/food_item.dart';

class CartService with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addToCart(FoodItem item) {
    final index = _items.indexWhere((cartItem) => cartItem.food.id == item.id);
    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(food: item));
    }
    notifyListeners();
  }

  void removeFromCart(FoodItem item) {
    final index = _items.indexWhere((cartItem) => cartItem.food.id == item.id);
    if (index != -1) {
      _items[index].quantity--;
      if (_items[index].quantity <= 0) {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.food.price * item.quantity);

  double get totalPrice => subtotal * 1.1;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
