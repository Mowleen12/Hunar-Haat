import 'dart:convert';

// Model for a single recommended product item
class ProductRecommendation {
  final String id;
  final String name;
  final double price;
  final String imageUrl; // URL of the product image
  final String artisan; // Name of the artisan

  ProductRecommendation({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.artisan,
  });

  // Factory constructor to create a ProductRecommendation object from a JSON map
  factory ProductRecommendation.fromJson(Map<String, dynamic> json) {
    return ProductRecommendation(
      id: json['id'].toString(),
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      // Fallback for placeholder image if URL is missing
      imageUrl: json['image_url'] ?? 'https://placehold.co/150x200/F5F1EB/36454F?text=Craft', 
      artisan: json['artisan'] as String,
    );
  }
}

// Helper model to parse the top-level API response structure
class RecommendationResponse {
  final List<ProductRecommendation> recommendations;

  RecommendationResponse({required this.recommendations});

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) {
    var list = json['recommendations'] as List? ?? [];
    List<ProductRecommendation> recommendationList = 
        list.map((i) => ProductRecommendation.fromJson(i as Map<String, dynamic>)).toList();
    
    return RecommendationResponse(recommendations: recommendationList);
  }
}
