class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double oldPrice;
  final double discount;
  final String description;
  final double rating;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.description,
    required this.rating,
    required this.category,
  });
}

final List<Product> mockProducts = [
  Product(
    id: '1',
    name: 'Handcrafted Wooden Elephant',
    imageUrl: 'assets/images/wooden_elephant.jpg',
    price: 899.0,
    oldPrice: 1200.0,
    discount: 25.0,
    description: 'An exquisitely carved wooden elephant figurine, perfect for home decor. Crafted by skilled artisans from rural India.',
    rating: 4.5,
    category: 'Handicrafts',
  ),
  Product(
    id: '2',
    name: 'Jaipur Blue Pottery Vase',
    imageUrl: 'assets/images/blue_pottery.jpg',
    price: 1500.0,
    oldPrice: 1800.0,
    discount: 16.0,
    description: 'A traditional blue pottery vase with intricate floral patterns, a symbol of Rajasthani craftsmanship. Each piece is hand-painted.',
    rating: 4.8,
    category: 'Pottery',
  ),
  Product(
    id: '3',
    name: 'Kalamkari Hand-Painted Saree',
    imageUrl: 'assets/images/handpainted_saree.jpg',
    price: 3500.0,
    oldPrice: 4000.0,
    discount: 12.5,
    description: 'An elegant Kalamkari saree with a detailed tree of life motif. The fabric is hand-loomed cotton, and the colors are all-natural.',
    rating: 4.7,
    category: 'Textiles',
  ),
  Product(
    id: '4',
    name: 'Terracotta Handi Pot',
    imageUrl: 'assets/images/handi_pot.jpg',
    price: 450.0,
    oldPrice: 600.0,
    discount: 25.0,
    description: 'A rustic and authentic terracotta cooking pot, ideal for slow-cooking traditional dishes. Its porous nature enhances flavor and aroma.',
    rating: 4.6,
    category: 'Pottery',
  ),
  Product(
    id: '5',
    name: 'Madhubani Art Painting',
    imageUrl: 'assets/images/madhubani_art.jpg',
    price: 950.0,
    oldPrice: 1100.0,
    discount: 13.6,
    description: 'A vibrant Madhubani painting depicting a folk scene. Hand-drawn by artists from the Mithila region of Bihar.',
    rating: 4.9,
    category: 'Art',
  ),
  Product(
    id: '6',
    name: 'Eco-friendly Jute Bag',
    imageUrl: 'assets/images/jute_bag.jpg',
    price: 350.0,
    oldPrice: 500.0,
    discount: 30.0,
    description: 'A stylish and durable jute bag, perfect for daily use. Eco-friendly and biodegradable, made by artisans in West Bengal.',
    rating: 4.4,
    category: 'Accessories',
  ),
  Product(
    id: '7',
    name: 'Intricate Dhokra Metal Figure',
    imageUrl: 'assets/images/dhokra_metal_figure.jpg',
    price: 1800.0,
    oldPrice: 2200.0,
    discount: 18.2,
    description: 'A tribal metal figure crafted using the ancient lost-wax casting technique of Dhokra art. A unique piece of decor with a rich history.',
    rating: 4.6,
    category: 'Handicrafts',
  ),
  Product(
    id: '8',
    name: 'Phulkari Embroidered Dupatta',
    imageUrl: 'assets/images/embroidered_dupatta.jpg',
    price: 1350.0,
    oldPrice: 1600.0,
    discount: 15.6,
    description: 'A beautiful dupatta with traditional Phulkari embroidery from Punjab. The vibrant threadwork creates a stunning floral pattern.',
    rating: 4.7,
    category: 'Textiles',
  ),
];

final List<Product> mockCartItems = [
  mockProducts[0],
  mockProducts[2],
];

final List<Product> mockWishlistItems = [
  mockProducts[1],
  mockProducts[3],
  mockProducts[5],
  mockProducts[7],
];