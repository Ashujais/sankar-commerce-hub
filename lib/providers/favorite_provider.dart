import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

/// Provider managing wishlist / favorites and persistent state.
class FavoriteProvider with ChangeNotifier {
  final StorageService _storageService = StorageService.instance;

  Set<String> _favoriteIds = {};
  bool _isLoading = false;

  Set<String> get favoriteIds => _favoriteIds;
  int get count => _favoriteIds.length;
  bool get isLoading => _isLoading;

  /// Loads saved favorite IDs from persistent storage.
  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      final list = await _storageService.getFavorites();
      _favoriteIds = list.toSet();
    } catch (_) {
      _favoriteIds = {};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Checks if product is favorited.
  bool isFavorite(int productId) {
    return _favoriteIds.contains(productId.toString());
  }

  /// Toggles favorite status with immediate persistent save.
  Future<void> toggleFavorite(int productId) async {
    final idStr = productId.toString();
    if (_favoriteIds.contains(idStr)) {
      _favoriteIds.remove(idStr);
    } else {
      _favoriteIds.add(idStr);
    }
    notifyListeners();

    await _storageService.saveFavorites(_favoriteIds.toList());
  }

  /// Clears all favorites.
  Future<void> clearAll() async {
    _favoriteIds.clear();
    notifyListeners();
    await _storageService.saveFavorites([]);
  }
}
