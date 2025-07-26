import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/services/cart_service.dart';
import 'package:restaurant/widgets/cart_item_tile.dart';
import 'package:restaurant/theme/theme.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _isCheckingOut = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleCheckout(BuildContext context) async {
    final cart = Provider.of<CartService>(context, listen: false);
    setState(() => _isCheckingOut = true);

    await Future.delayed(const Duration(seconds: 2));

    cart.clearCart();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Order placed successfully!"),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  Widget _buildAnimatedPriceRow(
    BuildContext context, {
    required String label,
    required String value,
    required bool isHighlighted,
  }) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutQuart,
          ),
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1,
            child: child,
          ),
        );
      },
      child: Padding(
        key: ValueKey('$label-$value'),
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: isHighlighted ? 16 : 15,
                fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
                color: isHighlighted
                    ? AppColors.black
                    : AppColors.black.withOpacity(0.7),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: isHighlighted ? 18 : 15,
                fontWeight: isHighlighted ? FontWeight.w800 : FontWeight.w600,
                color: isHighlighted
                    ? AppColors.black
                    : AppColors.black.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartService>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("Your Cart",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            )),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.black),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (cart.items.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            size: 60, color: AppColors.gray.withOpacity(0.5)),
                        const SizedBox(height: 24),
                        Text(
                          "Your cart is empty",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkGray,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor:
                                AppColors.brandYellow.withOpacity(0.1),
                          ),
                          child: Text(
                            "Browse Menu",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.brandYellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: cart.items.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 20),
                          itemBuilder: (context, index) {
                            final item = cart.items[index];
                            return CartItemTile(item: item);
                          },
                        ),
                      ),
                      if (cart.items.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 12,
                                spreadRadius: 1,
                                offset: const Offset(0, 6),
                              )
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          child: Column(
                            children: [
                              _buildAnimatedPriceRow(
                                context,
                                label: "Subtotal",
                                value: "\$${cart.subtotal.toStringAsFixed(2)}",
                                isHighlighted: false,
                              ),
                              const SizedBox(height: 4),
                              _buildAnimatedPriceRow(
                                context,
                                label: "Tax (10%)",
                                value:
                                    "\$${(cart.subtotal * 0.1).toStringAsFixed(2)}",
                                isHighlighted: false,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: AppColors.gray.withOpacity(0.2),
                                ),
                              ),
                              _buildAnimatedPriceRow(
                                context,
                                label: "Total",
                                value:
                                    "\$${cart.totalPrice.toStringAsFixed(2)}",
                                isHighlighted: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: _isCheckingOut
                              ? Container(
                                  key: const ValueKey('loading'),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color:
                                        AppColors.brandYellow.withOpacity(0.1),
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          AppColors.brandYellow
                                              .withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : ElevatedButton(
                                  key: const ValueKey('button'),
                                  onPressed: () => _handleCheckout(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.brandYellow,
                                    foregroundColor: AppColors.black,
                                    minimumSize:
                                        const Size(double.infinity, 60),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                    shadowColor:
                                        AppColors.brandYellow.withOpacity(0.4),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "PROCEED TO CHECKOUT",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward_rounded,
                                          size: 20),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
