import 'package:flutter/material.dart';

// New Hunar Haat color palette (re-defined here for clarity)
const Color kIndianRed = Color(0xFFB22222);
const Color kLightGrey = Color(0xFFEEEEEE);
const Color kCharcoal = Color(0xFF36454F);

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showSearchIcon;
  final bool showCartIcon;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showSearchIcon = true,
    this.showCartIcon = true,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kIndianRed, // Primary color for the app bar
      title: Text(
        title,
        style: const TextStyle(
          color: kLightGrey, // Use light grey for the title text
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      iconTheme: const IconThemeData(color: kLightGrey), // Set icon color
      actions: [
        if (showSearchIcon)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        if (showCartIcon)
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
      ],
    );
  }
}