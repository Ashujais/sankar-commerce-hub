import 'package:flutter/foundation.dart';
import '../core/constants/app_constants.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../services/storage_service.dart';

/// Provider managing shopping cart state, quantities, discounts, and persistence.
class CartProvider with ChangeNotifier {
  final StorageService _storageService = StorageService.instance;

  List<CartItemModel> _items = [];
  String? _appliedPromoCode;
  double _promoDiscount = 0.0;
  bool _isLoading = false;

  List<CartItemModel> get items => _items;
  String? get appliedPromoCode => _appliedPromoCode;
  bool get isLoading => _isLoading;

  int get totalItemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + item.itemTotal);
  }

  double get discountAmount {
    return subtotal * _promoDiscount;
  }

  double get shippingFee {
    if (subtotal == 0) return 0.0;
    return subtotal >= AppConstants.freeShippingThreshold
        ? 0.0
        : AppConstants.standardShippingFee;
  }

  double get grandTotal {
    if (subtotal == 0) return 0.0;
    return (subtotal - discountAmount) + shippingFee;
  }

  bool get isCartEmpty => _items.isEmpty;

  /// Load persisted cart items on start.
  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await _storageService.getCartItems();
    } catch (_) {
      _items = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Adds a product to cart or increments its count if already present.
  Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    final existingIndex = _items.indexWhere((i) => i.product.id == product.id);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItemModel(product: product, quantity: quantity));
    }

    notifyListeners();
    await _saveToStorage();
  }

  /// Updates quantity of an existing item.
  Future<void> updateQuantity(int productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }

    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      notifyListeners();
      await _saveToStorage();
    }
  }

  /// Removes product from cart.
  Future<void> removeFromCart(int productId) async {
    _items.removeWhere((i) => i.product.id == productId);
    notifyListeners();
    await _saveToStorage();
  }

  /// Validates and applies promo code.
  bool applyPromoCode(String code) {
    if (code.trim().toUpperCase() == AppConstants.validPromoCode) {
      _appliedPromoCode = AppConstants.validPromoCode;
      _promoDiscount = AppConstants.promoDiscountPercent;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Removes applied promo code.
  void removePromoCode() {
    _appliedPromoCode = null;
    _promoDiscount = 0.0;
    notifyListeners();
  }

  /// Clears entire cart (e.g. after successful checkout).
  Future<void> clearCart() async {
    _items.clear();
    _appliedPromoCode = null;
    _promoDiscount = 0.0;
    notifyListeners();
    await _saveToStorage();
  }

  Future<void> _saveToStorage() async {
    await _storageService.saveCartItems(_items);
  }
}
