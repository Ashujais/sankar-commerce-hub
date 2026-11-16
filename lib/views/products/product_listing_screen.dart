import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/product_provider.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/product_card.dart';
import 'product_detail_screen.dart';

/// Screen 3 (Core): Product Listing Screen with dynamic API integration,
/// real-time search, category filters, sorting, view switcher, and full loading/error/empty states.
class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final productProv = Provider.of<ProductProvider>(context, listen: false);
    _searchController.text = productProv.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSortBottomSheet(BuildContext context) {
    final productProv = Provider.of<ProductProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Text(
                    'Sort Products By',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Divider(),
                _buildSortOption(ctx, productProv, 'featured', 'Featured & Recommended', Icons.star_outline_rounded),
                _buildSortOption(ctx, productProv, 'price_asc', 'Price: Low to High', Icons.arrow_upward_rounded),
                _buildSortOption(ctx, productProv, 'price_desc', 'Price: High to Low', Icons.arrow_downward_rounded),
                _buildSortOption(ctx, productProv, 'rating', 'Customer Rating', Icons.thumb_up_alt_outlined),
                _buildSortOption(ctx, productProv, 'discount', 'Biggest Discounts', Icons.local_offer_outlined),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    ProductProvider productProv,
    String key,
    String title,
    IconData icon,
  ) {
    final isSelected = productProv.sortBy == key;
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.primary : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? AppColors.primary : null,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
          : null,
      onTap: () {
        productProv.setSortBy(key);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final productProv = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
        actions: [
          // Sort Button
          IconButton(
            icon: const Icon(Icons.sort_rounded),
            tooltip: 'Sort Products',
            onPressed: () => _showSortBottomSheet(context),
          ),
          // Grid / List Toggle Button
          IconButton(
            icon: Icon(
              productProv.isGridView
                  ? Icons.view_list_rounded
                  : Icons.grid_view_rounded,
            ),
            tooltip: productProv.isGridView ? 'Switch to List View' : 'Switch to Grid View',
            onPressed: () => productProv.toggleViewMode(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Input Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => productProv.setSearchQuery(val),
              decoration: InputDecoration(
                hintText: 'Search by title, brand, category...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          productProv.setSearchQuery('');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // Categories Horizontal Filter
          SizedBox(
            height: 42,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: productProv.categories.length,
              itemBuilder: (context, index) {
                final category = productProv.categories[index];
                final isSelected = productProv.selectedCategory == category;
                return CategoryChip(
                  label: category,
                  isSelected: isSelected,
                  onTap: () => productProv.selectCategory(category),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Result Count & Active Filters Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${productProv.products.length} Products Found',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                if (productProv.selectedCategory != 'All' ||
                    productProv.searchQuery.isNotEmpty)
                  InkWell(
                    onTap: () {
                      _searchController.clear();
                      productProv.resetFilters();
                    },
                    child: const Text(
                      'Clear Filters',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Body: Loading, Error, Empty, or Product Grid/List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => productProv.refresh(),
              child: _buildBody(context, productProv),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProductProvider productProv) {
    if (productProv.isLoading && productProv.rawProducts.isEmpty) {
      return const ProductGridSkeleton(count: 8);
    }

    if (productProv.errorMessage != null && productProv.products.isEmpty) {
      return ErrorView(
        title: 'Catalog Sync Issue',
        message: productProv.errorMessage!,
        onRetry: () => productProv.refresh(),
      );
    }

    if (productProv.products.isEmpty) {
      return EmptyStateView(
        icon: Icons.search_off_rounded,
        title: 'No Matching Products',
        subtitle:
            'We couldn\'t find any items matching "${productProv.searchQuery.isNotEmpty ? productProv.searchQuery : productProv.selectedCategory}". Try adjusting your filters.',
        buttonText: 'Reset Filters',
        onButtonPressed: () {
          _searchController.clear();
          productProv.resetFilters();
        },
      );
    }

    if (productProv.isGridView) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: productProv.products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final product = productProv.products[index];
          return ProductCard(
            product: product,
            isGrid: true,
            onTap: () => _navigateToDetail(product.id),
          );
        },
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: productProv.products.length,
        itemBuilder: (context, index) {
          final product = productProv.products[index];
          return ProductCard(
            product: product,
            isGrid: false,
            onTap: () => _navigateToDetail(product.id),
          );
        },
      );
    }
  }

  void _navigateToDetail(int productId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(productId: productId),
      ),
    );
  }
}
