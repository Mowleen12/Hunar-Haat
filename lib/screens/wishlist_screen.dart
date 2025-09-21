import 'package:flutter/material.dart';
import '../constants/constants.dart';

class WishlistScreen extends StatelessWidget {
  final List<Map<String, dynamic>> wishlistItems = [
    {
      'name': 'Handmade Jute Bag',
      'price': 499,
      'image': 'assets/images/jute_bag.jpg',
    },
    {
      'name': 'Wooden Carving',
      'price': 899,
      'image': 'assets/images/wood_carving.jpg',
    },
    {
      'name': 'Clay Pottery Set',
      'price': 699,
      'image': 'assets/images/clay_pottery.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Wishlist",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: kIndianRed,
      ),
      body: wishlistItems.isEmpty
          ? Center(
              child: Text(
                "Your wishlist is empty!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                final item = wishlistItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        item['image'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      item['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("₹${item['price']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.shopping_cart_outlined,
                              color: Colors.green),
                          onPressed: () {
                            // Add to cart logic
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                            // Remove from wishlist logic
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
