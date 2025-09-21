
class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double oldPrice;
  final double discount;
  final String description;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.description,
    required this.rating,
  });
}

// A complete list of all mock products
final List<Product> mockProducts = [
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
    id: '2',
    name: 'Jaipur Blue Pottery Vase',
    imageUrl: 'https://images.unsplash.com/photo-1596773343355-6b5a3f3a1d9b?q=80&w=1964&auto=format&fit=crop',
    price: 1500.0,
    oldPrice: 1800.0,
    discount: 16.0,
    description: 'A traditional blue pottery vase with intricate floral patterns, a symbol of Rajasthani craftsmanship. Each piece is hand-painted.',
    rating: 4.8,
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
  Product(
    id: '4',
    name: 'Terracotta Handi Pot',
    imageUrl: 'https://images.unsplash.com/photo-1621217743936-8c46d3e3a35a?q=80&w=1974&auto=format&fit=crop',
    price: 450.0,
    oldPrice: 600.0,
    discount: 25.0,
    description: 'A rustic and authentic terracotta cooking pot, ideal for slow-cooking traditional dishes. Its porous nature enhances flavor and aroma.',
    rating: 4.6,
  ),
  Product(
    id: '5',
    name: 'Madhubani Art Painting',
    imageUrl: 'https://images.unsplash.com/photo-1616421949704-3b2d1d2b7d2f?q=80&w=1964&auto=format&fit=crop',
    price: 950.0,
    oldPrice: 1100.0,
    discount: 13.6,
    description: 'A vibrant Madhubani painting depicting a folk scene. Hand-drawn by artists from the Mithila region of Bihar.',
    rating: 4.9,
  ),
  Product(
    id: '6',
    name: 'Pattachitra Scroll Painting',
    imageUrl: 'https://images.unsplash.com/photo-1587595431976-508b9e6f4f2c?q=80&w=1974&auto=format&fit=crop',
    price: 2100.0,
    oldPrice: 2500.0,
    discount: 16.0,
    description: 'A traditional Pattachitra scroll from Odisha, telling a mythological story. Made on a treated cloth base with natural colors.',
    rating: 4.8,
  ),
  Product(
    id: '7',
    name: 'Intricate Dhokra Metal Figure',
    imageUrl: 'https://images.unsplash.com/photo-1606775551989-1d4d3c333333?q=80&w=1964&auto=format&fit=crop',
    price: 1800.0,
    oldPrice: 2200.0,
    discount: 18.2,
    description: 'A tribal metal figure crafted using the ancient lost-wax casting technique of Dhokra art. A unique piece of decor with a rich history.',
    rating: 4.6,
  ),
  Product(
    id: '8',
    name: 'Phulkari Embroidered Dupatta',
    imageUrl: 'https://images.unsplash.com/photo-1632731119777-6d6f28148b1d?q=80&w=1974&auto=format&fit=crop',
    price: 1350.0,
    oldPrice: 1600.0,
    discount: 15.6,
    description: 'A beautiful dupatta with traditional Phulkari embroidery from Punjab. The vibrant threadwork creates a stunning floral pattern.',
    rating: 4.7,
  ),
];

// Mock data for the cart screen
final List<Product> mockCartItems = [
  mockProducts[0],
  mockProducts[2],
];

// Mock data for the wishlist screen
final List<Product> mockWishlistItems = [
  mockProducts[1],
  mockProducts[3],
  mockProducts[5],
  mockProducts[7],
];