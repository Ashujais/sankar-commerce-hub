import 'package:flutter_test/flutter_test.dart';
import 'package:sankar_app/models/product_model.dart';
import 'package:sankar_app/models/user_model.dart';
import 'package:sankar_app/models/cart_item_model.dart';

void main() {
  group('ProductModel Tests', () {
    test('Calculates discounted price accurately', () {
      final product = ProductModel(
        id: 101,
        title: 'Precision Tool',
        description: 'Test Description',
        category: 'Tools',
        price: 100.0,
        discountPercentage: 20.0,
        thumbnail: 'https://example.com/thumb.jpg',
      );

      expect(product.discountedPrice, 80.0);
      expect(product.hasDiscount, true);
      expect(product.inStock, true);
    });

    test('Parses from JSON map properly', () {
      final json = {
        'id': 55,
        'title': 'Industrial Sensor',
        'description': 'IoT telemetry',
        'category': 'Industrial',
        'price': 250.0,
        'discountPercentage': 10.0,
        'rating': 4.9,
        'stock': 12,
        'brand': 'Sankar Automation',
        'thumbnail': 'https://example.com/sensor.jpg',
      };

      final product = ProductModel.fromJson(json);
      expect(product.id, 55);
      expect(product.title, 'Industrial Sensor');
      expect(product.brand, 'Sankar Automation');
      expect(product.discountedPrice, 225.0);
    });
  });

  group('UserModel Tests', () {
    test('UserModel JSON roundtrip', () {
      final user = UserModel(
        id: 'usr_123',
        name: 'Rohan Sharma',
        email: 'rohan@sankargroup.com',
        phone: '+91 9988776655',
        role: 'Senior Engineer',
        token: 'token_abc',
      );

      final json = user.toJson();
      final restored = UserModel.fromJson(json);

      expect(restored.id, user.id);
      expect(restored.name, user.name);
      expect(restored.email, user.email);
      expect(restored.role, user.role);
    });
  });

  group('CartItemModel Tests', () {
    test('Calculates itemTotal based on discountedPrice and quantity', () {
      final product = ProductModel(
        id: 1,
        title: 'Calibrated Gauge',
        description: 'Description',
        category: 'Hardware',
        price: 50.0,
        discountPercentage: 10.0, // discounted = 45.0
        thumbnail: 'https://example.com/img.jpg',
      );

      final item = CartItemModel(product: product, quantity: 3);
      expect(item.itemTotal, 135.0);
    });
  });
}
