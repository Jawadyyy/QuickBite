import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/models/cart_item.dart';
import 'package:restaurant/services/cart_service.dart';
import 'package:restaurant/theme/theme.dart';

class CartItemTile extends StatefulWidget {
  final CartItem item;
  const CartItemTile({super.key, required this.item});

  @override
  State<CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile> {
  bool _isRemoving = false;
  bool _isAdding = false;

  Future<void> _handleAdd(BuildContext context) async {
    final cart = Provider.of<CartService>(context, listen: false);
    setState(() => _isAdding = true);
    await Future.delayed(const Duration(milliseconds: 150));
    cart.addToCart(widget.item.food);
    setState(() => _isAdding = false);
  }

  Future<void> _handleRemove(BuildContext context) async {
    final cart = Provider.of<CartService>(context, listen: false);
    setState(() => _isRemoving = true);
    await Future.delayed(const Duration(milliseconds: 150));
    cart.removeFromCart(widget.item.food);
    setState(() => _isRemoving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.gray.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.gray.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: widget.item.food.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.item.food.imageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: AppColors.brandYellow,
                              strokeWidth: 2,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.fastfood,
                              size: 30, color: AppColors.darkGray);
                        },
                      ),
                    )
                  : Icon(Icons.fastfood, size: 30, color: AppColors.darkGray),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.food.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${widget.item.food.price.toStringAsFixed(2)} each",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${(widget.item.food.price * widget.item.quantity).toStringAsFixed(2)} total",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.brandYellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.gray.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: _isRemoving
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.brandYellow,
                            ),
                          )
                        : const Icon(Icons.remove, size: 20),
                    onPressed: _isRemoving || _isAdding
                        ? null
                        : () => _handleRemove(context),
                    splashRadius: 20,
                    padding: const EdgeInsets.all(8),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      widget.item.quantity.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: _isAdding
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.brandYellow,
                            ),
                          )
                        : const Icon(Icons.add, size: 20),
                    onPressed: _isRemoving || _isAdding
                        ? null
                        : () => _handleAdd(context),
                    splashRadius: 20,
                    padding: const EdgeInsets.all(8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
