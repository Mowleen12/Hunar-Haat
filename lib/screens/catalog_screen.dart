import 'package:flutter/material.dart';
import '../widgets/product_card.dart';
import '../models/product_model.dart' as models; // Ensure this is imported for mockProducts

// New Hunar Haat color palette (re-defined here for clarity)
const Color kIndianRed = Color(0xFFB22222);
const Color kGold = Color(0xFFD4AF37);
const Color kCharcoal = Color(0xFF36454F);
const Color kLightGrey = Color(0xFFEEEEEE);

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kLightGrey, // Use a consistent background color
      appBar: AppBar(
        backgroundColor: kIndianRed, // Match the new primary color
        title: const Text(
          'Categories',
          style: TextStyle(color: kLightGrey, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: kLightGrey),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0), // Slightly more padding
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: screenWidth > 600 ? 3 : 2, // Responsive grid
            childAspectRatio: 0.7,
            crossAxisSpacing: 12, // Increased spacing
            mainAxisSpacing: 12, // Increased spacing
          ),
          itemCount: models.mockProducts.length, // The functional part
          itemBuilder: (context, index) {
            return ProductCard(
              product: models.mockProducts[index],
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/product',
                  arguments: models.mockProducts[index],
                );
              },
            );
          },
        ),
      ),
    );
  }
}