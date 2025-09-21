import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../constants/constants.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4, // Increased elevation for a lifted effect
        margin: const EdgeInsets.all(4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Slightly rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Increased padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Center(
                child: Image.network(
                  product.imageUrl,
                  height: 120,
                  width: 120,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      height: 120,
                      width: 120,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          valueColor: const AlwaysStoppedAnimation<Color>(kGold), // Use gold accent color
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    width: 120,
                    color: kLightGrey, // Use new background color
                    child: const Icon(
                      Icons.palette, // A more relevant icon for art
                      color: kCharcoal,
                      size: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Product Name
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: kCharcoal, // Use the charcoal color
                ),
              ),
              const SizedBox(height: 4),

              // Ratings
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: kGreenColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Text(
                          product.rating.toString(),
                          style: const TextStyle(
                            color: kWhiteColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(Icons.star, color: kWhiteColor, size: 12),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Price Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18, // Slightly larger price font
                      color: kIndianRed, // Use the new primary red color
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        '₹${product.oldPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: kCharcoal,
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${product.discount.toStringAsFixed(0)}% off',
                        style: const TextStyle(
                          color: kGreenColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}