import 'package:flutter/material.dart';

// New Hunar Haat color palette (re-defined here for clarity)
const Color kIndianRed = Color(0xFFB22222);
const Color kGold = Color(0xFFD4AF37);
const Color kCharcoal = Color(0xFF36454F);
const Color kLightGrey = Color(0xFFEEEEEE);
const Color kWhiteColor = Colors.white;

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kLightGrey, // Use the new background color
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: kLightGrey, // Use the new background color
        selectedItemColor: kIndianRed, // Primary color for selected item
        unselectedItemColor: kCharcoal, // Charcoal for unselected items
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          _buildBottomNavItem(Icons.home, Icons.home_outlined, 'Home', 0, 0),
          _buildBottomNavItem(Icons.category, Icons.category_outlined, 'Categories', 1, 0),
          _buildBottomNavItem(Icons.shopping_bag, Icons.shopping_bag_outlined, 'Cart', 2, 3), // Changed to shopping_bag for variety
          _buildBottomNavItem(Icons.favorite, Icons.favorite_border, 'Wishlist', 3, 0),
          _buildBottomNavItem(Icons.person, Icons.person_outlined, 'Account', 4, 0),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(
    IconData selectedIcon,
    IconData unselectedIcon,
    String label,
    int index,
    int badgeCount,
  ) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(4),
        child: Stack(
          children: [
            Icon(
              currentIndex == index ? selectedIcon : unselectedIcon,
              size: 24,
              color: currentIndex == index ? kIndianRed : kCharcoal, // Use new colors
            ),
            if (badgeCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: kGold, // Use the accent color for the badge
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: const TextStyle(
                      color: kWhiteColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
      label: label,
    );
  }
}