import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/empty_state_view.dart';
import '../products/product_detail_screen.dart';

/// Screen for Cart and Checkout management with promo codes, quantities, and order placement.
class CartScreen extends StatefulWidget {
  final VoidCallback? onStartShopping;

  const CartScreen({super.key, this.onStartShopping});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo(CartProvider cartProv) {
    final code = _promoController.text.trim();
    if (code.isEmpty) return;

    final success = cartProv.applyPromoCode(code);
    if (success) {
      _promoController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Promo code "SANKAR10" applied! 10% discount added.'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid promo code. Try "SANKAR10".'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleCheckout(BuildContext context, CartProvider cartProv) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.shopping_bag_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Checkout Order'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Items: ${cartProv.totalItemCount}'),
            const SizedBox(height: 6),
            Text('Shipping: ${cartProv.shippingFee == 0 ? "FREE" : "\$${cartProv.shippingFee.toStringAsFixed(2)}"}'),
            const SizedBox(height: 6),
            Text(
              'Final Amount: \$${cartProv.grandTotal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Payment will be processed via Sankar Group Enterprise Billing.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              Navigator.pop(ctx);
              await cartProv.clearCart();
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (successCtx) => AlertDialog(
                    title: Row(
                      children: const [
                        Icon(Icons.check_circle_rounded, color: AppColors.success),
                        SizedBox(width: 8),
                        Text('Order Confirmed!'),
                      ],
                    ),
                    content: const Text(
                      'Thank you for your order with Sankar Group. A confirmation has been dispatched to your registered email.',
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(successCtx),
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text('Confirm & Pay', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cartProv = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          if (!cartProv.isCartEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Clear Cart',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear Cart?'),
                    content: const Text('Are you sure you want to remove all items?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          cartProv.clearCart();
                          Navigator.pop(ctx);
                        },
                        child: const Text('Clear', style: TextStyle(color: AppColors.error)),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: cartProv.isCartEmpty
          ? EmptyStateView(
              icon: Icons.remove_shopping_cart_outlined,
              title: 'Your Cart is Empty',
              subtitle: 'Explore our industrial catalog and find top-rated gear and components.',
              buttonText: 'Start Browsing',
              onButtonPressed: widget.onStartShopping,
            )
          : Column(
              children: [
                // Free Shipping Progress Bar
                Container(
                  color: isDark ? AppColors.darkCard : Colors.amber.shade50,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.local_shipping_outlined, size: 18, color: AppColors.accentDark),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          cartProv.subtotal >= AppConstants.freeShippingThreshold
                              ? 'You have unlocked FREE delivery!'
                              : 'Add \$${(AppConstants.freeShippingThreshold - cartProv.subtotal).toStringAsFixed(2)} more for FREE shipping.',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Cart Items List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartProv.items.length,
                    itemBuilder: (context, index) {
                      final item = cartProv.items[index];
                      final product = item.product;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              // Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ProductDetailScreen(productId: product.id),
                                      ),
                                    );
                                  },
                                  child: Image.network(
                                    product.thumbnail,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, stack) => Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.grey.shade200,
                                      child: const Icon(Icons.image_not_supported, size: 24),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${product.discountedPrice.toStringAsFixed(2)} each',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.lightTextSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    // Quantity Controls
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(
                                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () => cartProv.updateQuantity(
                                                  product.id,
                                                  item.quantity - 1,
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  child: Icon(Icons.remove, size: 14),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                child: Text(
                                                  '${item.quantity}',
                                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () => cartProv.updateQuantity(
                                                  product.id,
                                                  item.quantity + 1,
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  child: Icon(Icons.add, size: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '\$${item.itemTotal.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: isDark ? AppColors.secondary : AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close_rounded, size: 18, color: Colors.grey),
                                onPressed: () => cartProv.removeFromCart(product.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Promo code and Checkout Summary Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Promo Code Input
                        if (cartProv.appliedPromoCode == null)
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: TextField(
                                    controller: _promoController,
                                    decoration: InputDecoration(
                                      hintText: 'Promo code (try SANKAR10)',
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                      hintStyle: const TextStyle(fontSize: 12),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    textCapitalization: TextCapitalization.characters,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                height: 40,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    padding: const EdgeInsets.symmetric(horizontal: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: () => _applyPromo(cartProv),
                                  child: const Text('Apply', style: TextStyle(fontSize: 12)),
                                ),
                              ),
                            ],
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.success.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.check_circle, size: 16, color: AppColors.success),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Code "${cartProv.appliedPromoCode}" (10% OFF)',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.success),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () => cartProv.removePromoCode(),
                                  child: const Icon(Icons.close, size: 16, color: AppColors.error),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 14),

                        // Subtotal, Discount, Shipping, Total
                        _buildSummaryRow('Subtotal', '\$${cartProv.subtotal.toStringAsFixed(2)}'),
                        if (cartProv.discountAmount > 0)
                          _buildSummaryRow(
                            'Promo Discount',
                            '-\$${cartProv.discountAmount.toStringAsFixed(2)}',
                            isDiscount: true,
                          ),
                        _buildSummaryRow(
                          'Shipping',
                          cartProv.shippingFee == 0 ? 'FREE' : '\$${cartProv.shippingFee.toStringAsFixed(2)}',
                        ),
                        const Divider(height: 18),
                        _buildSummaryRow(
                          'Total Amount',
                          '\$${cartProv.grandTotal.toStringAsFixed(2)}',
                          isBold: true,
                        ),

                        const SizedBox(height: 14),

                        // Checkout Button
                        CustomButton(
                          text: 'Proceed to Checkout (\$${cartProv.grandTotal.toStringAsFixed(2)})',
                          icon: Icons.lock_outline_rounded,
                          onPressed: () => _handleCheckout(context, cartProv),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 14 : 12.5,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 16 : 12.5,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: isDiscount ? AppColors.success : null,
            ),
          ),
        ],
      ),
    );
  }
}
