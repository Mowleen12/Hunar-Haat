import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recommendation_models.dart';

// Enhanced Hunar Haat colors (must be defined locally or imported)
const Color kIndianRed = Color(0xFFB22222);
const Color kCharcoal = Color(0xFF36454F);
const Color kLightGrey = Color(0xFFEEEEEE);
const Color kWhiteColor = Colors.white;

class PersonalizedRecommendationsWidget extends StatelessWidget {
  // Use a stable ID (like the user's ID) for personalized home page recommendations
  final String currentUserId; 

  const PersonalizedRecommendationsWidget({
    Key? key, 
    required this.currentUserId
  }) : super(key: key);

  // NOTE: Replace with the actual IP address or host where your Flask/AI API is running
  // For Android emulator testing on localhost, use 'http://10.0.2.2:5000'
  // For web/desktop, use 'http://localhost:5000'
  static const String API_BASE_URL = 'http://10.0.2.2:5000';
  static const String API_ENDPOINT = '$API_BASE_URL/api/recommendations/content-based';

  Future<List<ProductRecommendation>> fetchRecommendations(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(API_ENDPOINT),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        // Send the user ID (or last viewed product ID) as the query context
        body: jsonEncode(<String, dynamic>{
          'product_id': userId, // Using userId as context for the home screen
          'k': 6, // Request 6 items
        }),
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        if (jsonBody['success'] == true) {
           return RecommendationResponse.fromJson(jsonBody).recommendations;
        } else {
           throw Exception(jsonBody['error'] ?? 'API returned failure status.');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Recommendation fetch error: $e');
      // In a real app, log this error but return an empty list for graceful degradation
      return []; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductRecommendation>>(
      future: fetchRecommendations(currentUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Placeholder loading indicator matching the design aesthetic
          return _buildLoadingPlaceholder();
        } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
          // Do not show the entire section if there's an error or no data
          return const SizedBox.shrink();
        }

        final recommendations = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Horizontal ListView for the carousel
            SizedBox(
              height: 250, // Define a fixed height for the horizontal list items
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16, right: 4),
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  final product = recommendations[index];
                  return _RecommendationCard(product: product);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  // A visually appealing loading state matching the card design
  Widget _buildLoadingPlaceholder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16, right: 4),
            itemCount: 3, 
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                width: 150,
                decoration: BoxDecoration(
                  color: kLightGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: CircularProgressIndicator(color: kIndianRed, strokeWidth: 2),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// Custom Card Widget for recommendations
class _RecommendationCard extends StatelessWidget {
  final ProductRecommendation product;

  const _RecommendationCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: kCharcoal.withOpacity(0.1), 
            blurRadius: 8, 
            offset: const Offset(0, 4)
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Implement navigation to the product detail page using product.id
          // Navigator.pushNamed(context, '/product', arguments: product.id);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Area
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                product.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  color: kLightGrey,
                  child: const Center(child: Icon(Icons.palette, size: 40, color: kCharcoal)),
                ),
              ),
            ),
            // Text Details
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: kCharcoal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                product.artisan,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, color: kCharcoal.withOpacity(0.7)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Text(
                '₹${product.price.toStringAsFixed(0)}',
                style: const TextStyle(color: kIndianRed, fontWeight: FontWeight.w800, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
