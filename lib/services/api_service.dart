import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/constants/api_endpoints.dart';
import '../models/product_model.dart';
import 'mock_data.dart';

/// Result wrapper indicating data and whether live API or offline fallback was served.
class ApiResult<T> {
  final T data;
  final bool isFromCacheOrFallback;
  final String? errorMessage;

  ApiResult({
    required this.data,
    this.isFromCacheOrFallback = false,
    this.errorMessage,
  });
}

/// Service handling REST API interactions with DummyJSON and resilient offline fallback.
class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches products list from public API with timeout and fallback.
  Future<ApiResult<List<ProductModel>>> fetchProducts() async {
    try {
      final response = await _client
          .get(Uri.parse(ApiEndpoints.products))
          .timeout(ApiEndpoints.timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> productsJson = body['products'] as List<dynamic>? ?? [];

        final List<ProductModel> products = productsJson
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();

        // Also merge Sankar signature items at top for branding demonstration
        final merged = [...MockData.fallbackProducts, ...products];
        return ApiResult(data: merged, isFromCacheOrFallback: false);
      } else {
        return ApiResult(
          data: MockData.fallbackProducts,
          isFromCacheOrFallback: true,
          errorMessage: 'API returned code ${response.statusCode}. Showing offline catalog.',
        );
      }
    } on SocketException {
      return ApiResult(
        data: MockData.fallbackProducts,
        isFromCacheOrFallback: true,
        errorMessage: 'Network unavailable. Displaying cached Sankar catalog.',
      );
    } on TimeoutException {
      return ApiResult(
        data: MockData.fallbackProducts,
        isFromCacheOrFallback: true,
        errorMessage: 'Connection timed out. Displaying cached Sankar catalog.',
      );
    } catch (e) {
      return ApiResult(
        data: MockData.fallbackProducts,
        isFromCacheOrFallback: true,
        errorMessage: 'Notice: Using structured catalog ($e).',
      );
    }
  }

  /// Searches products dynamically via API.
  Future<ApiResult<List<ProductModel>>> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      return fetchProducts();
    }

    try {
      final url = ApiEndpoints.searchProducts(Uri.encodeComponent(query.trim()));
      final response = await _client
          .get(Uri.parse(url))
          .timeout(ApiEndpoints.timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> productsJson = body['products'] as List<dynamic>? ?? [];

        final List<ProductModel> apiResults = productsJson
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();

        // Also search fallback products locally
        final localMatches = MockData.fallbackProducts.where((p) {
          final q = query.toLowerCase();
          return p.title.toLowerCase().contains(q) ||
              p.brand.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q) ||
              p.description.toLowerCase().contains(q);
        }).toList();

        final combined = [...localMatches, ...apiResults];
        return ApiResult(data: combined, isFromCacheOrFallback: false);
      } else {
        final localMatches = _filterMockDataByQuery(query);
        return ApiResult(data: localMatches, isFromCacheOrFallback: true);
      }
    } catch (_) {
      final localMatches = _filterMockDataByQuery(query);
      return ApiResult(data: localMatches, isFromCacheOrFallback: true);
    }
  }

  /// Fetches product categories.
  Future<ApiResult<List<String>>> fetchCategories() async {
    try {
      final response = await _client
          .get(Uri.parse(ApiEndpoints.categories))
          .timeout(ApiEndpoints.timeoutDuration);

      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);
        List<String> categories = ['All'];

        if (body is List) {
          for (var item in body) {
            if (item is String) {
              categories.add(_capitalize(item));
            } else if (item is Map && item.containsKey('name')) {
              categories.add(_capitalize(item['name'].toString()));
            } else if (item is Map && item.containsKey('slug')) {
              categories.add(_capitalize(item['slug'].toString()));
            }
          }
        }

        // Add Sankar Group signature categories if not present
        for (var cat in MockData.fallbackCategories) {
          if (!categories.contains(cat)) {
            categories.add(cat);
          }
        }

        return ApiResult(data: categories, isFromCacheOrFallback: false);
      } else {
        return ApiResult(data: MockData.fallbackCategories, isFromCacheOrFallback: true);
      }
    } catch (_) {
      return ApiResult(data: MockData.fallbackCategories, isFromCacheOrFallback: true);
    }
  }

  /// Fetches single product details by ID.
  Future<ApiResult<ProductModel>> fetchProductDetail(int id) async {
    // Check mock products first
    final mockMatch = MockData.fallbackProducts.where((p) => p.id == id);
    if (mockMatch.isNotEmpty) {
      return ApiResult(data: mockMatch.first, isFromCacheOrFallback: false);
    }

    try {
      final response = await _client
          .get(Uri.parse(ApiEndpoints.productDetail(id)))
          .timeout(ApiEndpoints.timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final product = ProductModel.fromJson(body);
        return ApiResult(data: product, isFromCacheOrFallback: false);
      } else {
        return ApiResult(
          data: MockData.fallbackProducts.first,
          isFromCacheOrFallback: true,
          errorMessage: 'Failed to load details.',
        );
      }
    } catch (e) {
      return ApiResult(
        data: MockData.fallbackProducts.first,
        isFromCacheOrFallback: true,
        errorMessage: 'Network error loading product details.',
      );
    }
  }

  List<ProductModel> _filterMockDataByQuery(String query) {
    final q = query.toLowerCase();
    return MockData.fallbackProducts.where((p) {
      return p.title.toLowerCase().contains(q) ||
          p.brand.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q);
    }).toList();
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s.split('-').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}
