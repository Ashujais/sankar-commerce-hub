import 'review_model.dart';

/// Comprehensive product data model matching standard REST API responses.
class ProductModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String sku;
  final double weight;
  final String warrantyInformation;
  final String shippingInformation;
  final String returnPolicy;
  final int minimumOrderQuantity;
  final String thumbnail;
  final List<String> images;
  final List<ProductReview> reviews;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    this.discountPercentage = 0.0,
    this.rating = 4.5,
    this.stock = 10,
    this.brand = 'Sankar Select',
    this.sku = '',
    this.weight = 1.0,
    this.warrantyInformation = '1 Year Official Warranty',
    this.shippingInformation = 'Ships in 2-3 business days',
    this.returnPolicy = '30 days return policy',
    this.minimumOrderQuantity = 1,
    required this.thumbnail,
    this.images = const [],
    this.reviews = const [],
  });

  /// Factory constructor to parse JSON from DummyJSON or local mock.
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    var rawImages = json['images'];
    List<String> parsedImages = [];
    if (rawImages is List) {
      parsedImages = rawImages.map((e) => e.toString()).toList();
    }

    var rawReviews = json['reviews'];
    List<ProductReview> parsedReviews = [];
    if (rawReviews is List) {
      parsedReviews = rawReviews
          .map((r) => ProductReview.fromJson(r as Map<String, dynamic>))
          .toList();
    }

    return ProductModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Untitled Product',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.0,
      stock: json['stock'] as int? ?? 10,
      brand: json['brand'] as String? ?? 'Sankar Prime',
      sku: json['sku'] as String? ?? 'SKU-${json['id']}',
      weight: (json['weight'] as num?)?.toDouble() ?? 1.2,
      warrantyInformation: json['warrantyInformation'] as String? ?? '1-Year Official Warranty',
      shippingInformation: json['shippingInformation'] as String? ?? 'Ships within 48 hours',
      returnPolicy: json['returnPolicy'] as String? ?? '30-Day Money Back Guarantee',
      minimumOrderQuantity: json['minimumOrderQuantity'] as int? ?? 1,
      thumbnail: json['thumbnail'] as String? ?? '',
      images: parsedImages.isNotEmpty ? parsedImages : [json['thumbnail'] as String? ?? ''],
      reviews: parsedReviews,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'price': price,
        'discountPercentage': discountPercentage,
        'rating': rating,
        'stock': stock,
        'brand': brand,
        'sku': sku,
        'weight': weight,
        'warrantyInformation': warrantyInformation,
        'shippingInformation': shippingInformation,
        'returnPolicy': returnPolicy,
        'minimumOrderQuantity': minimumOrderQuantity,
        'thumbnail': thumbnail,
        'images': images,
        'reviews': reviews.map((r) => r.toJson()).toList(),
      };

  /// Calculated effective price with discount applied
  double get discountedPrice {
    if (discountPercentage <= 0) return price;
    final discounted = price - (price * (discountPercentage / 100));
    return double.parse(discounted.toStringAsFixed(2));
  }

  bool get inStock => stock > 0;

  bool get hasDiscount => discountPercentage > 0;
}
