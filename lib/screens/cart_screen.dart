import 'package:flutter/material.dart';
import '../models/product_model.dart';

// New Hunar Haat color palette (re-defined here for clarity)
const Color kIndianRed = Color(0xFFB22222);
const Color kGold = Color(0xFFD4AF37);
const Color kCharcoal = Color(0xFF36454F);
const Color kLightGrey = Color(0xFFEEEEEE);

// Define mock cart items directly in this file for demonstration.
// In a real application, this data would come from a global state.
final List<Product> mockCartItems = [
  Product(
    id: '1',
    name: 'Handcrafted Wooden Elephant',
    imageUrl: 'https://images.unsplash.com/photo-1620121692062-18d2d6d066b7?q=80&w=1974&auto=format&fit=crop',
    price: 899.0,
    oldPrice: 1200.0,
    discount: 25.0,
    description: 'An exquisitely carved wooden elephant figurine, perfect for home decor. Crafted by skilled artisans from rural India.',
    rating: 4.5,
  ),
  Product(
    id: '3',
    name: 'Kalamkari Hand-Painted Saree',
    imageUrl: 'https://images.unsplash.com/photo-1599813596525-4c6d04f3d178?q=80&w=1964&auto=format&fit=crop',
    price: 3500.0,
    oldPrice: 4000.0,
    discount: 12.5,
    description: 'An elegant Kalamkari saree with a detailed tree of life motif. The fabric is hand-loomed cotton, and the colors are all-natural.',
    rating: 4.7,
  ),
];

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  double get totalAmount {
    return mockCartItems.fold(0, (sum, item) => sum + item.price);
  }

  double get totalDiscount {
    return mockCartItems.fold(0, (sum, item) => sum + (item.oldPrice - item.price));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGrey,
      appBar: AppBar(
        backgroundColor: kIndianRed,
        title: const Text(
          'My Cart',
          style: TextStyle(color: kLightGrey, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: kLightGrey),
        centerTitle: true,
      ),
      body: mockCartItems.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: mockCartItems.length,
                    itemBuilder: (context, index) {
                      final product = mockCartItems[index];
                      return _buildCartItem(product);
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kLightGrey,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text('PRICE DETAILS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kCharcoal)),
                      const SizedBox(height: 12),
                      _buildPriceRow('Price (${mockCartItems.length} items)', '₹${totalAmount.toStringAsFixed(2)}'),
                      _buildPriceRow('Discount', '-₹${totalDiscount.toStringAsFixed(2)}'),
                      _buildPriceRow('Delivery Charges', 'FREE', color: Colors.green),
                      const Divider(color: kCharcoal),
                      _buildPriceRow('Total Amount', '₹${totalAmount.toStringAsFixed(2)}', isBold: true),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kIndianRed,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'PLACE ORDER',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kLightGrey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCartItem(Product product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: kLightGrey,
              ),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: kCharcoal),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '₹${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kIndianRed),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '₹${product.oldPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: kCharcoal,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: kCharcoal.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: () {},
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(),
                              color: kCharcoal,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('1', style: TextStyle(fontWeight: FontWeight.bold, color: kCharcoal)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () {},
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(),
                              color: kCharcoal,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: kCharcoal),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false, Color color = kCharcoal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color)),
        ],
      ),
    );
  }
}