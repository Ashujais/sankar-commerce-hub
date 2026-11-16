import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sankar_app/models/product_model.dart';
import 'package:sankar_app/providers/cart_provider.dart';
import 'package:sankar_app/providers/product_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('CartProvider Tests', () {
    test('Adds products and updates totals properly', () async {
      final cart = CartProvider();
      await cart.loadCart();

      final product = ProductModel(
        id: 1,
        title: 'Industrial Drill',
        description: 'Test drill',
        category: 'Hardware',
        price: 100.0,
        discountPercentage: 0.0,
        thumbnail: '',
      );

      await cart.addToCart(product, quantity: 2);
      expect(cart.totalItemCount, 2);
      expect(cart.subtotal, 200.0);
      expect(cart.isCartEmpty, false);

      // Apply promo code SANKAR10
      final applied = cart.applyPromoCode('SANKAR10');
      expect(applied, true);
      expect(cart.discountAmount, 20.0); // 10% of 200
      expect(cart.grandTotal, 180.0); // 200 - 20 (free shipping >= $50)

      // Remove product
      await cart.removeFromCart(1);
      expect(cart.totalItemCount, 0);
      expect(cart.isCartEmpty, true);
    });
  });

  group('ProductProvider Filter and Sort Tests', () {
    test('Selects category and filters catalog', () async {
      final productProv = ProductProvider();
      await productProv.loadProducts();

      expect(productProv.rawProducts.isNotEmpty, true);

      // Select specific category
      productProv.selectCategory('Watches');
      expect(productProv.selectedCategory, 'Watches');
      for (final p in productProv.products) {
        expect(p.category.toLowerCase(), 'watches');
      }

      // Reset filters
      productProv.resetFilters();
      expect(productProv.selectedCategory, 'All');
    });

    test('Search query matches title or brand', () async {
      final productProv = ProductProvider();
      await productProv.loadProducts();

      productProv.setSearchQuery('Caliper');
      for (final p in productProv.products) {
        final matches = p.title.toLowerCase().contains('caliper') ||
            p.description.toLowerCase().contains('caliper');
        expect(matches, true);
      }
    });
  });
}
