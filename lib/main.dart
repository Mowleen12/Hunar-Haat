import 'package:flutter/material.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/product_detail_screen.dart';
import 'models/product_model.dart';
import 'screens/cart_screen.dart'; // Import the new CartScreen
import 'screens/catalog_screen.dart'; // Import the new CatalogScreen

void main() {
  runApp(const MyApp());
}

// New Hunar Haat color palette
const Color kIndianRed = Color(0xFFB22222);
const Color kGold = Color(0xFFD4AF37);
const Color kCharcoal = Color(0xFF36454F);
const Color kLightGrey = Color(0xFFEEEEEE);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hunar Haat', // Change the app title
      theme: ThemeData(
        primaryColor: kIndianRed, // Primary color for the app
        scaffoldBackgroundColor: kLightGrey, // Consistent background color
        appBarTheme: const AppBarTheme(
          backgroundColor: kIndianRed, // AppBar background color
          foregroundColor: kLightGrey, // AppBar icon and text color
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: kLightGrey, // Bottom bar background color
          selectedItemColor: kIndianRed, // Selected icon color
          unselectedItemColor: kCharcoal, // Unselected icon color
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: kGold, // Accent color for highlights
          primary: kIndianRed,
        ),
      ),
      // Define named routes for better navigation
      routes: {
        '/': (context) => const MainNavigationScreen(), // Home route
        '/cart': (context) => const CartScreen(), // Cart screen route
        '/catalog': (context) => const CatalogScreen(), // Catalog screen route
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/product') {
          final Product product = settings.arguments as Product;
          return MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          );
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}