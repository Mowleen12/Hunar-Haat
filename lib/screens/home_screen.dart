import 'package:flutter/material.dart';
import '../widgets/product_card.dart';
import '../models/product_model.dart' as models;
import 'chat_screen.dart';

// Enhanced Hunar Haat color palette
const Color kIndianRed = Color(0xFFB22222);
const Color kGold = Color(0xFFD4AF37);
const Color kCharcoal = Color(0xFF36454F);
const Color kLightGrey = Color(0xFFEEEEEE);
const Color kWhiteColor = Colors.white;
const Color kAccentOrange = Color(0xFFFF6B35);
const Color kSoftBeige = Color(0xFFF5F1EB);
const Color kDeepGreen = Color(0xFF2E7D32);

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late PageController _bannerController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentBannerIndex = 0;
  final TextEditingController _searchController = TextEditingController();
// State for BottomNavigationBar

  // Corrected image loading with a reliable service
  final List<String> _bannerImages = [
    'https://source.unsplash.com/random/400x200?crafts',
    'https://source.unsplash.com/random/400x200?artisan',
    'https://source.unsplash.com/random/400x200?pottery',
    'https://source.unsplash.com/random/400x200?weaving',
    'https://source.unsplash.com/random/400x200?embroidery',
  ];

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Textiles', 'icon': Icons.checkroom, 'color': kAccentOrange},
    {'name': 'Pottery', 'icon': Icons.grain, 'color': kDeepGreen},
    {'name': 'Jewelry', 'icon': Icons.diamond, 'color': kGold},
    {'name': 'Wood Craft', 'icon': Icons.forest, 'color': Colors.brown},
    {'name': 'Paintings', 'icon': Icons.brush, 'color': Colors.purple},
    {'name': 'Metal Work', 'icon': Icons.handyman, 'color': kCharcoal},
    {'name': 'Leather', 'icon': Icons.shopping_bag, 'color': Colors.orange},
    {'name': 'Stone Craft', 'icon': Icons.foundation, 'color': Colors.grey},
  ];

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'Rajasthani Handicrafts',
      'subtitle': 'Authentic crafts from the heart of India',
      'gradient': [kIndianRed, kAccentOrange],
    },
    {
      'title': 'Kashmiri Artisans',
      'subtitle': 'Exquisite handwoven carpets & shawls',
      'gradient': [kDeepGreen, Colors.teal],
    },
    {
      'title': 'Bengal Pottery',
      'subtitle': 'Traditional terracotta masterpieces',
      'gradient': [Colors.brown, kGold],
    },
    {
      'title': 'Mysore Silk',
      'subtitle': 'Luxury silk sarees and fabrics',
      'gradient': [Colors.purple, kGold],
    },
    {
      'title': 'Gujarat Embroidery',
      'subtitle': 'Intricate mirror work & patterns',
      'gradient': [kAccentOrange, Colors.red],
    },
  ];

  Widget _buildImageWidget({
    required String imageUrl,
    required double width,
    required double height,
    BoxFit fit = BoxFit.cover,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: kLightGrey,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: kIndianRed,
                strokeWidth: 2,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: kLightGrey,
              borderRadius: BorderRadius.circular(12),
              // ignore: deprecated_member_use
              border: Border.all(color: kCharcoal.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image_outlined,
                    // ignore: deprecated_member_use
                    color: kCharcoal.withOpacity(0.5),
                    size: 40),
                const SizedBox(height: 8),
                Text('Image not\navailable',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        // ignore: deprecated_member_use
                        color: kCharcoal.withOpacity(0.7),
                        fontSize: 10)),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _bannerController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    Future.delayed(const Duration(seconds: 3), _autoBanner);
  }

  void _autoBanner() {
    if (mounted && _bannerController.hasClients) {
      setState(() {
        _currentBannerIndex = (_currentBannerIndex + 1) % _banners.length;
      });
      _bannerController.animateToPage(
        _currentBannerIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      Future.delayed(const Duration(seconds: 3), _autoBanner);
    }
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kSoftBeige,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            slivers: [
              // Enhanced App Bar
              // ...
// Enhanced App Bar
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: kIndianRed,
                elevation: 0,
                shadowColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [kIndianRed, kAccentOrange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    // CORRECTED: Adjusted padding to fix overflow.
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.store, color: kWhiteColor, size: 24),
                                SizedBox(width: 8),
                                Text(
                                  'Hunar Haat',
                                  style: TextStyle(
                                    color: kWhiteColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.notifications_outlined,
                                      color: kWhiteColor, size: 22),
                                  constraints: const BoxConstraints(
                                      minWidth: 40, minHeight: 40),
                                  padding: const EdgeInsets.all(8),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                      Icons.account_circle_outlined,
                                      color: kWhiteColor,
                                      size: 22),
                                  constraints: const BoxConstraints(
                                      minWidth: 40, minHeight: 40),
                                  padding: const EdgeInsets.all(8),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Enhanced Search Bar
                        Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: kWhiteColor,
                            borderRadius: BorderRadius.circular(21),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search for handicrafts, folk art...',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: kCharcoal.withOpacity(0.6),
                                fontWeight: FontWeight.w400,
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(Icons.search,
                                    color: kIndianRed, size: 20),
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(8),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.mic,
                                      color: kCharcoal.withOpacity(0.6),
                                      size: 18),
                                  constraints: const BoxConstraints(
                                      minWidth: 24, minHeight: 24),
                                ),
                              ),
                              border: InputBorder.none,
                              // FIX HERE: Reduce the vertical padding to prevent overflow
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
// ...

              // Enhanced Banner Section
              SliverToBoxAdapter(
                child: Container(
                  height: 220,
                  margin: const EdgeInsets.all(16),
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _bannerController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentBannerIndex = index;
                          });
                        },
                        itemCount: _banners.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: _banners[index]['gradient'],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _banners[index]['gradient'][0]
                                      .withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // Background image with overlay
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Stack(
                                      children: [
                                        _buildImageWidget(
                                          imageUrl: _bannerImages[
                                              index % _bannerImages.length],
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                        // Gradient overlay for text readability
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            gradient: LinearGradient(
                                              colors: [
                                                // ignore: deprecated_member_use
                                                Colors.black.withOpacity(0.6),
                                                Colors.transparent,
                                                // ignore: deprecated_member_use
                                                Colors.black.withOpacity(0.3),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Decorative pattern
                                Positioned(
                                  right: -20,
                                  top: -20,
                                  child: Icon(
                                    Icons.auto_awesome,
                                    size: 100,
                                    // ignore: deprecated_member_use
                                    color: kWhiteColor.withOpacity(0.1),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _banners[index]['title'],
                                        style: const TextStyle(
                                          color: kWhiteColor,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _banners[index]['subtitle'],
                                        style: TextStyle(
                                          // ignore: deprecated_member_use
                                          color: kWhiteColor.withOpacity(0.9),
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kWhiteColor,
                                          foregroundColor: _banners[index]
                                              ['gradient'][0],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 8),
                                        ),
                                        child: const Text('Explore Now',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      // Page Indicator
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_banners.length, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentBannerIndex == index ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _currentBannerIndex == index
                                    ? kWhiteColor
                                    // ignore: deprecated_member_use
                                    : kWhiteColor.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Enhanced Categories Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Craft Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kCharcoal,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            color: kIndianRed,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  height: 110,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 12),
                        child: Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(12),
                          shadowColor:
                              _categories[index]['color'].withOpacity(0.2),
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: kWhiteColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: _categories[index]['color']
                                          .withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _categories[index]['icon'],
                                      color: _categories[index]['color'],
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _categories[index]['name'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: kCharcoal,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // Enhanced Featured Products Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.star, color: kGold, size: 20),
                          SizedBox(width: 6),
                          Text(
                            'Featured Handicrafts',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kCharcoal,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            color: kIndianRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenWidth > 600 ? 3 : 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = models
                          .mockProducts[index % models.mockProducts.length];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/product',
                            arguments: product,
                          );
                        },
                      );
                    },
                    childCount: models.mockProducts.length,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: kIndianRed.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            backgroundColor: kIndianRed,
            foregroundColor: kWhiteColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
            icon: const Icon(Icons.support_agent, size: 20),
            label: const Text(
              'Chat Support',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
        ),
      ),
    );
  }
}
