import 'package:flutter/material.dart';
import 'package:hunar_haat_genai/models/onboarding_model.dart';
import '../models/product_model.dart';

// Hunar Haat Color Palette
const Color kIndianRed = Color(0xFFB22222); // Primary color for app bar and buttons
const Color kGold = Color(0xFFD4AF37); // Accent color for highlights
const Color kCharcoal = Color(0xFF36454F); // Dark text and icons
const Color kLightGrey = Color(0xFFEEEEEE); // Background and light text
const Color kWhiteColor = Colors.white; // For cards and other elements
const Color kGreenColor = Color(0xFF4CAF50); // For positive text like "FREE Delivery"
const Color kGreyColor = Colors.grey; // Added kGreyColor constant
const Color kSecondaryColor = Colors.blue;
const Color kPrimaryColor = kIndianRed; // Consistent primary color

// Mock Data - Products
List<Product> mockProducts = [
  Product(
    id: '1',
    name: 'Handcrafted Wooden Elephant',
    description: 'An exquisitely carved wooden elephant figurine, perfect for home decor. Crafted by skilled artisans from rural India.',
    price: 899.0,
    oldPrice: 1200.0,
    discount: 25.0, // Added discount parameter
    imageUrl: 'https://images.unsplash.com/photo-1620121692062-18d2d6d066b7?q=80&w=1974&auto=format&fit=crop',
    rating: 4.5,
    category: 'Handicrafts',
  ),
  Product(
    id: '2',
    name: 'Jaipur Blue Pottery Vase',
    description: 'A traditional blue pottery vase with intricate floral patterns, a symbol of Rajasthani craftsmanship. Each piece is hand-painted.',
    price: 1500.0,
    oldPrice: 1800.0,
    discount: 16.67, // Added discount parameter
    imageUrl: 'https://images.unsplash.com/photo-1596773343355-6b5a3f3a1d9b?q=80&w=1964&auto=format&fit=crop',
    rating: 4.8,
    category: 'Pottery',
  ),
  Product(
    id: '3',
    name: 'Kalamkari Hand-Painted Saree',
    description: 'An elegant Kalamkari saree with a detailed tree of life motif. The fabric is hand-loomed cotton, and the colors are all-natural.',
    price: 3500.0,
    oldPrice: 4000.0,
    discount: 12.5, // Added discount parameter
    imageUrl: 'https://images.unsplash.com/photo-1599813596525-4c6d04f3d178?q=80&w=1964&auto=format&fit=crop',
    rating: 4.7,
    category: 'Textiles', 
  ),
  Product(
    id: '4',
    name: 'Terracotta Handi Pot',
    description: 'A rustic and authentic terracotta cooking pot, ideal for slow-cooking traditional dishes. Its porous nature enhances flavor and aroma.',
    price: 450.0,
    oldPrice: 600.0,
    discount: 25.0, // Added discount parameter
    imageUrl: 'https://images.unsplash.com/photo-1621217743936-8c46d3e3a35a?q=80&w=1974&auto=format&fit=crop',
    rating: 4.6,
    category: 'Pottery',
  ),
];

// Mock Data - Cart Items
List<Product> mockCartItems = [
  mockProducts[0],
  mockProducts[2],
];

// Mock Data - Wishlist Items
List<Product> mockWishlistItems = [
  mockProducts[1],
  mockProducts[3],
];

// Text Styles - Updated to match the new color palette
const TextStyle kAppBarTextStyle = TextStyle(
  color: kLightGrey,
  fontWeight: FontWeight.w600,
  fontSize: 18,
);

const TextStyle kTitleTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: kCharcoal,
);

const TextStyle kPriceTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: kIndianRed,
);

const TextStyle kOldPriceTextStyle = TextStyle(
  fontSize: 16,
  color: kCharcoal,
  decoration: TextDecoration.lineThrough,
);

const TextStyle kDiscountTextStyle = TextStyle(
  fontSize: 14,
  color: kGreenColor,
  fontWeight: FontWeight.w500,
);

// Onboarding Data - Updated content for Hunar Haat theme
List<OnboardingItem> onboardingItems = [
  OnboardingItem(
    image: 'https://images.unsplash.com/photo-1599813596525-4c6d04f3d178?q=80&w=1964&auto=format&fit=crop',
    title: 'Discover Handcrafted Art',
    description: 'Explore a wide range of unique, handmade products from skilled artisans across India.',
  ),
  OnboardingItem(
    image: 'https://images.unsplash.com/photo-1620121692062-18d2d6d066b7?q=80&w=1974&auto=format&fit=crop',
    title: 'Support Local Artisans',
    description: 'Every purchase helps preserve traditional Indian crafts and empowers the artisan community.',
  ),
  OnboardingItem(
    image: 'https://images.unsplash.com/photo-1596773343355-6b5a3f3a1d9b?q=80&w=1964&auto=format&fit=crop',
    title: 'Curated Collections',
    description: 'Find exclusive, authentic crafts from different regions, curated just for you.',
  ),
];

// Add to your existing constants file

// Wishlist Mock Data
List<Product> mockWishlistItem = [
  Product(
    id: '5',
    name: 'Nike Air Jordan 1',
    description: 'Iconic basketball shoes with premium leather construction and classic design.',
    price: 12999,
    oldPrice: 15999,
    discount: 12.5,
    imageUrl: 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/5c60c37c-7f27-4c6d-8521-350e885b6c16/air-jordan-1-mid-shoes-X5pM09.png',
    rating: 4.4,
    category: 'Footwear',
  ),
  Product(
    id: '6',
    name: 'Amazon Echo Dot (4th Gen)',
    description: 'Smart speaker with Alexa, vibrant sound, and sleek design. Control your smart home with your voice.',
    price: 4499,
    oldPrice: 5999,
    discount: 12.5,
    imageUrl: 'https://m.media-amazon.com/images/I/71KBQ+6H-oL._SL1500_.jpg',
    rating: 4.2,
    category: 'Electronics',
  ),
  Product(
    id: '2',
    name: 'Samsung Galaxy S23 Ultra',
    description: 'Powerful Android phone with S Pen and 200MP camera. Snapdragon 8 Gen 2 processor, 12GB RAM, and stunning 6.8-inch display.',
    price: 124999,
    oldPrice: 134999,
    discount: 12.5,
    imageUrl: 'https://images.samsung.com/is/image/samsung/p6pim/in/2302/gallery/in-galaxy-s23-s918-sm-s918bzgdins-thumb-534856135',
    rating: 4.3,
    category: 'Electronics',
  ),
];