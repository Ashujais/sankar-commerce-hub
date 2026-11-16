import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

/// Provider managing the product catalog, real-time search, category filtering,
/// sorting strategies, and live API state transitions.
class ProductProvider with ChangeNotifier {
  final ApiService _apiService;

  ProductProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  List<String> _categories = ['All'];

  String _selectedCategory = 'All';
  String _searchQuery = '';
  String _sortBy = 'featured'; // 'featured', 'price_asc', 'price_desc', 'rating', 'discount'
  bool _isGridView = true;

  bool _isLoading = false;
  String? _errorMessage;
  bool _isOfflineMode = false;

  // Getters
  List<ProductModel> get products => _filteredProducts;
  List<ProductModel> get rawProducts => _allProducts;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  bool get isGridView => _isGridView;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isOfflineMode => _isOfflineMode;

  /// Loads products and categories from API or offline fallback.
  Future<void> loadProducts({bool forceRefresh = false}) async {
    if (_allProducts.isNotEmpty && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Fetch products and categories concurrently
      final productResultFuture = _apiService.fetchProducts();
      final categoryResultFuture = _apiService.fetchCategories();

      final results = await Future.wait([productResultFuture, categoryResultFuture]);
      final productResult = results[0] as ApiResult<List<ProductModel>>;
      final categoryResult = results[1] as ApiResult<List<String>>;

      _allProducts = productResult.data;
      _categories = categoryResult.data;
      _isOfflineMode = productResult.isFromCacheOrFallback;
      _errorMessage = productResult.errorMessage;

      _applyFilters();
    } catch (e) {
      _errorMessage = 'Failed to load catalog: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sets the active category filter and re-filters the product list.
  void selectCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  /// Updates search query with instant filtering.
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  /// Changes the sort criteria.
  void setSortBy(String sortOption) {
    _sortBy = sortOption;
    _applyFilters();
    notifyListeners();
  }

  /// Toggles between 2-column Grid and single-column List view.
  void toggleViewMode() {
    _isGridView = !_isGridView;
    notifyListeners();
  }

  /// Clears search and category filters.
  void resetFilters() {
    _selectedCategory = 'All';
    _searchQuery = '';
    _sortBy = 'featured';
    _applyFilters();
    notifyListeners();
  }

  /// Pull-to-refresh reload.
  Future<void> refresh() async {
    await loadProducts(forceRefresh: true);
  }

  /// Finds a product by its integer ID.
  ProductModel? getProductById(int id) {
    final matches = _allProducts.where((p) => p.id == id);
    if (matches.isNotEmpty) return matches.first;
    return null;
  }

  /// Internal filter and sort calculation.
  void _applyFilters() {
    List<ProductModel> temp = List.from(_allProducts);

    // 1. Filter by category
    if (_selectedCategory != 'All') {
      temp = temp.where((p) {
        return p.category.toLowerCase() == _selectedCategory.toLowerCase();
      }).toList();
    }

    // 2. Filter by search query
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      temp = temp.where((p) {
        return p.title.toLowerCase().contains(q) ||
            p.brand.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q);
      }).toList();
    }

    // 3. Apply sorting
    switch (_sortBy) {
      case 'price_asc':
        temp.sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
        break;
      case 'price_desc':
        temp.sort((a, b) => b.discountedPrice.compareTo(a.discountedPrice));
        break;
      case 'rating':
        temp.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'discount':
        temp.sort((a, b) => b.discountPercentage.compareTo(a.discountPercentage));
        break;
      case 'featured':
      default:
        // Default ranking
        break;
    }

    _filteredProducts = temp;
  }
}
