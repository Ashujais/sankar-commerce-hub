import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/product_model.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/product_card.dart';
import '../products/product_detail_screen.dart';

/// Wishlist / Favorites Screen displaying persistently saved products.
class FavoritesScreen extends StatelessWidget {
  final VoidCallback? onExploreTap;

  const FavoritesScreen({super.key, this.onExploreTap});

  @override
  Widget build(BuildContext context) {
    final favProv = Provider.of<FavoriteProvider>(context);
    final productProv = Provider.of<ProductProvider>(context);

    // Filter products that match saved favorite IDs
    final List<ProductModel> favoriteProducts = productProv.rawProducts
        .where((p) => favProv.isFavorite(p.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        actions: [
          if (favoriteProducts.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              tooltip: 'Clear All Favorites',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear Wishlist?'),
                    content: const Text('Are you sure you want to remove all saved items?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          favProv.clearAll();
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
      body: favoriteProducts.isEmpty
          ? EmptyStateView(
              icon: Icons.favorite_border_rounded,
              title: 'Your Wishlist is Empty',
              subtitle: 'Tap the heart icon on any product in the catalog to save it for later.',
              buttonText: 'Browse Catalog',
              onButtonPressed: onExploreTap,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Text(
                    '${favoriteProducts.length} Saved Items (Stored Locally in SharedPreferences)',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: favoriteProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final product = favoriteProducts[index];
                      return ProductCard(
                        product: product,
                        isGrid: true,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(productId: product.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
