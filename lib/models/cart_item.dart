import 'package:restaurant/models/food_item.dart';

class CartItem {
  final FoodItem food;
  int quantity;

  CartItem({required this.food, this.quantity = 1});
}
