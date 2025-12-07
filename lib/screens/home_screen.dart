import 'package:hunar_haat_genai/screens/personalized_recommendations_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product_model.dart' as models;
import '../widgets/product_card.dart';
import 'chat_screen.dart';

// Enhanced Hunar Haat color palette
const Color kIndianRed = Color(0xFFB22222);
const Color kDarkRed = Color(0xFF8B0000);
const Color kGold = Color(0xFFD4AF37);
const Color kLightGold = Color(0xFFFFF8DC);
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
  late AnimationController _floatingButtonController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  int _currentBannerIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchFocused = false;

  final String currentUserId = 'user_101_mock_id';

  final List<String> _bannerImages = [
    'assets/images/rajasthani_handicrafts.jpg',
    'assets/images/kashmiri_artisans.jpg',
    'assets/images/bengal_pottery.jpg',
    'assets/images/mysore_silk.jpg',
    'assets/images/gujurat_embroidery.jpg',
  ];

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Textiles', 'icon': Icons.checkroom_outlined, 'color': kAccentOrange},
    {'name': 'Pottery', 'icon': Icons.water_drop_outlined, 'color': kDeepGreen},
    {'name': 'Jewelry', 'icon': Icons.diamond_outlined, 'color': kGold},
    {'name': 'Wood Craft', 'icon': Icons.forest_outlined, 'color': Color(0xFF8B4513)},
    {'name': 'Paintings', 'icon': Icons.palette_outlined, 'color': Colors.purple},
    {'name': 'Metal Work', 'icon': Icons.handyman_outlined, 'color': kCharcoal},
    {'name': 'Leather', 'icon': Icons.shopping_bag_outlined, 'color': Colors.orange[800]!},
    {'name': 'Stone Craft', 'icon': Icons.foundation_outlined, 'color': Colors.grey[700]!},
  ];

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'Rajasthani Handicrafts',
      'subtitle': 'Authentic crafts from the heart of India',
      'gradient': [Color(0xFFB22222), Color(0xFFFF6B35)],
    },
    {
      'title': 'Kashmiri Artisans',
      'subtitle': 'Exquisite handwoven carpets & shawls',
      'gradient': [Color(0xFF2E7D32), Color(0xFF00897B)],
    },
    {
      'title': 'Bengal Pottery',
      'subtitle': 'Traditional terracotta masterpieces',
      'gradient': [Color(0xFF8B4513), Color(0xFFD4AF37)],
    },
    {
      'title': 'Mysore Silk',
      'subtitle': 'Luxury silk sarees and fabrics',
      'gradient': [Color(0xFF7B1FA2), Color(0xFFD4AF37)],
    },
    {
      'title': 'Gujarat Embroidery',
      'subtitle': 'Intricate mirror work & patterns',
      'gradient': [Color(0xFFFF6B35), Color(0xFFD32F2F)],
    },
  ];

  Widget _buildImageWidget({
    required String imageUrl,
    required double width,
    required double height,
    BoxFit fit = BoxFit.cover,
    double borderRadius = 12,
  }) {
    final isNetwork = imageUrl.startsWith('http');
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: isNetwork
          ? Image.network(
              imageUrl,
              width: width,
              height: height,
              fit: fit,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kLightGrey, kSoftBeige],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: kIndianRed,
                      strokeWidth: 3,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => _buildErrorWidget(width, height, borderRadius),
            )
          : Image.asset(
              imageUrl,
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (context, error, stackTrace) => _buildErrorWidget(width, height, borderRadius),
            ),
    );
  }

  Widget _buildErrorWidget(double width, double height, double borderRadius) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kLightGrey, kSoftBeige],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: kCharcoal.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined,
              color: kCharcoal.withOpacity(0.3), size: 48),
          const SizedBox(height: 8),
          Text('Image unavailable',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: kCharcoal.withOpacity(0.5),
                  fontSize: 11,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _bannerController = PageController(viewportFraction: 0.92);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _floatingButtonController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _floatingButtonController, curve: Curves.elasticOut),
    );
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _floatingButtonController.forward();
    });
    Future.delayed(const Duration(seconds: 4), _autoBanner);
  }

  void _autoBanner() {
    if (mounted && _bannerController.hasClients) {
      int nextPage = (_currentBannerIndex + 1) % _banners.length;
      _bannerController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
      Future.delayed(const Duration(seconds: 4), _autoBanner);
    }
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _animationController.dispose();
    _floatingButtonController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kSoftBeige,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Enhanced App Bar with Fixed Layout
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                backgroundColor: kIndianRed,
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle.light,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [kIndianRed, kDarkRed],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Top Row - Logo and Actions
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: kWhiteColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.store_rounded,
                                          color: kWhiteColor, size: 24),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Hunar Haat',
                                          style: TextStyle(
                                            color: kWhiteColor,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                        Text(
                                          'Crafted with Love 🇮🇳',
                                          style: TextStyle(
                                            color: kWhiteColor.withOpacity(0.9),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    _buildHeaderIconButton(
                                      icon: Icons.notifications_outlined,
                                      badge: true,
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    _buildHeaderIconButton(
                                      icon: Icons.account_circle_outlined,
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Enhanced Search Bar
                            _buildSearchBar(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Premium Banner Section
              SliverToBoxAdapter(
                child: AnimatedBuilder(
                  animation: _slideAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: child,
                    );
                  },
                  child: Container(
                    height: 240,
                    margin: const EdgeInsets.symmetric(vertical: 24),
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
                            return _buildBannerCard(index);
                          },
                        ),
                        // Enhanced Page Indicator
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_banners.length, (index) {
                              bool isActive = _currentBannerIndex == index;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: isActive ? 32 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  gradient: isActive
                                      ? LinearGradient(
                                          colors: [kGold, kLightGold],
                                        )
                                      : null,
                                  color: isActive ? null : kWhiteColor.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: isActive
                                      ? [
                                          BoxShadow(
                                            color: kGold.withOpacity(0.5),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                      : null,
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Enhanced Categories Section
              SliverToBoxAdapter(
                child: _buildSectionHeader(
                  title: 'Craft Categories',
                  icon: Icons.category_outlined,
                  onViewAll: () {
                    HapticFeedback.lightImpact();
                  },
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  height: 130,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 16, right: 4),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      return _buildCategoryCard(index);
                    },
                  ),
                ),
              ),

              // Personalized Recommendations
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    children: [
                      _buildSectionHeader(
                        title: 'Personalized Picks',
                        icon: Icons.auto_awesome,
                        iconColor: Colors.purple,
                        onViewAll: () {
                          HapticFeedback.lightImpact();
                        },
                      ),
                      PersonalizedRecommendationsWidget(
                        currentUserId: currentUserId,
                      ),
                    ],
                  ),
                ),
              ),

              // Featured Products Section
              SliverToBoxAdapter(
                child: _buildSectionHeader(
                  title: 'Featured Handicrafts',
                  icon: Icons.star_rounded,
                  iconColor: kGold,
                  onViewAll: () {
                    HapticFeedback.lightImpact();
                  },
                ),
              ),

              // Featured Products Grid with Staggered Layout
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenWidth > 600 ? 3 : 2,
                    childAspectRatio: 0.5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = models.mockProducts[index % models.mockProducts.length];
                      return _buildProductCard(product, index);
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
      floatingActionButton: ScaleTransition(
        scale: _scaleAnimation,
        child: _buildFloatingChatButton(context),
      ),
    );
  }

  Widget _buildHeaderIconButton({
    required IconData icon,
    bool badge = false,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: kWhiteColor, size: 22),
                if (badge)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: kAccentOrange,
                        shape: BoxShape.circle,
                        border: Border.all(color: kWhiteColor, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onTap: () {
          setState(() {
            _isSearchFocused = true;
          });
          HapticFeedback.lightImpact();
        },
        onSubmitted: (_) {
          setState(() {
            _isSearchFocused = false;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search for handicrafts, artisans...',
          hintStyle: TextStyle(
            fontSize: 14,
            color: kCharcoal.withOpacity(0.5),
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.search_rounded,
              color: _isSearchFocused ? kIndianRed : kCharcoal.withOpacity(0.6),
              size: 22,
            ),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  icon: Icon(Icons.clear, color: kCharcoal.withOpacity(0.6), size: 20),
                )
              : IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                  },
                  icon: Icon(Icons.mic_outlined, color: kCharcoal.withOpacity(0.6), size: 20),
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildBannerCard(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _banners[index]['gradient'][0].withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: _buildImageWidget(
                imageUrl: _bannerImages[index % _bannerImages.length],
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                borderRadius: 24,
              ),
            ),
            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      _banners[index]['gradient'][0].withOpacity(0.9),
                      _banners[index]['gradient'][1].withOpacity(0.7),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
              ),
            ),
            // Decorative Pattern
            Positioned(
              right: -30,
              top: -30,
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 120,
                color: kWhiteColor.withOpacity(0.1),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: kWhiteColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: kWhiteColor.withOpacity(0.5)),
                    ),
                    child: const Text(
                      '🎨 Exclusive',
                      style: TextStyle(
                        color: kWhiteColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _banners[index]['title'],
                    style: const TextStyle(
                      color: kWhiteColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _banners[index]['subtitle'],
                    style: TextStyle(
                      color: kWhiteColor.withOpacity(0.95),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      shadows: const [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kWhiteColor,
                      foregroundColor: _banners[index]['gradient'][0],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      elevation: 4,
                      shadowColor: Colors.black26,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Explore Now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    Color? iconColor,
    required VoidCallback onViewAll,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (iconColor ?? kIndianRed).withOpacity(0.2),
                      (iconColor ?? kIndianRed).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor ?? kIndianRed, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kCharcoal,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: onViewAll,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'View All',
                  style: TextStyle(
                    color: kIndianRed,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios_rounded, color: kIndianRed, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(int index) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(16),
        shadowColor: _categories[index]['color'].withOpacity(0.3),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kWhiteColor, kSoftBeige],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _categories[index]['color'].withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _categories[index]['color'].withOpacity(0.2),
                        _categories[index]['color'].withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _categories[index]['color'].withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _categories[index]['icon'],
                    color: _categories[index]['color'],
                    size: 26,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _categories[index]['name'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: kCharcoal,
                    height: 1.2,
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
  }

  Widget _buildProductCard(models.Product product, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: ProductCard(
        product: product,
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.pushNamed(
            context,
            '/product',
            arguments: product,
          );
        },
      ),
    );
  }

  Widget _buildFloatingChatButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [kIndianRed, kDarkRed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: kIndianRed.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.mediumImpact();
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const ChatScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(0.0, 1.0);
                  var end = Offset.zero;
                  var curve = Curves.easeInOutCubic;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 400),
              ),
            );
          },
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kWhiteColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.support_agent_rounded,
                    color: kWhiteColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Chat Support',
                  style: TextStyle(
                    color: kWhiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}