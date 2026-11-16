/// Public REST API endpoints used for product catalog, search, and categories.
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://dummyjson.com';
  static const Duration timeoutDuration = Duration(seconds: 12);

  // Products
  static const String products = '$baseUrl/products?limit=100';
  static const String categories = '$baseUrl/products/categories';
  static String productsByCategory(String category) => '$baseUrl/products/category/$category';
  static String searchProducts(String query) => '$baseUrl/products/search?q=$query';
  static String productDetail(int id) => '$baseUrl/products/$id';
}
