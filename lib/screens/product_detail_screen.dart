import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../constants/constants.dart'; // This import is crucial
import 'package:carousel_slider/carousel_slider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGrey,
      appBar: AppBar(
        backgroundColor: kIndianRed,
        title: Text(
          product.name,
          style: const TextStyle(color: kLightGrey, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: kLightGrey),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 300,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                aspectRatio: 2.0,
              ),
              items: [
                Image.network(product.imageUrl, fit: BoxFit.cover),
                Image.network(product.imageUrl, fit: BoxFit.cover),
                Image.network(product.imageUrl, fit: BoxFit.cover),
              ],
            ),
            
            Container(
              color: kWhiteColor,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kCharcoal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(Icons.star, color: kWhiteColor, size: 16),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(product.rating * 100).toStringAsFixed(0)} Reviews',
                        style: TextStyle(color: kGreyColor), // Now correctly references kGreyColor
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Text(
                        '₹${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: kIndianRed,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '₹${product.oldPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: kCharcoal,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${product.discount.toStringAsFixed(0)}% off',
                        style: const TextStyle(
                          fontSize: 18,
                          color: kGreenColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  const Divider(color: kLightGrey),
                  
                  const Text(
                    'Product Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kCharcoal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: kCharcoal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: Container(
        color: kWhiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border),
                label: const Text('WISHLIST'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGold,
                  foregroundColor: kCharcoal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart),
                label: const Text('ADD TO CART'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kIndianRed,
                  foregroundColor: kLightGrey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 