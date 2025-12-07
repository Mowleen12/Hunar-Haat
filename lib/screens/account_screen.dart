import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'my_orders_screen.dart';
import 'my_address_screen.dart';
import 'help_support_screen.dart';
import 'login_screen.dart';
import 'profile_builder_screen.dart';
import 'product_cataloging_screen.dart';

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

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock user data - replace with actual user data from your auth system
  final String userName = "Mowleen Armstrong";
  final String userEmail = "mowleen2006@gmail.com";
  final String userPhone = "+91 98765 43210";
  final String memberSince = "Member since 2023";
  final int ordersCount = 12;
  final int wishlistCount = 8;
  final int addressCount = 3;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSoftBeige,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Enhanced App Bar with Profile Header
          SliverAppBar(
            expandedHeight: 340,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: kIndianRed,
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
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildProfileHeader(),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _showSettingsBottomSheet(context);
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kWhiteColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.settings_outlined, size: 20),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Quick Stats Section
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildQuickStats(),
            ),
          ),

          // AI Features Section
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildSectionHeader('AI-Powered Features', Icons.auto_awesome),
            ),
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildAIFeaturesSection(),
            ),
          ),

          // Account Management Section
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildSectionHeader('Account Management', Icons.manage_accounts_outlined),
            ),
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildAccountManagementSection(),
            ),
          ),

          // Support Section
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildSectionHeader('Support & Help', Icons.help_outline_rounded),
            ),
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildSupportSection(),
            ),
          ),

          // Logout Button
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildLogoutButton(),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
      child: Column(
        children: [
          // Profile Picture with Border
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [kGold, kLightGold],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: kGold.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kWhiteColor,
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: kIndianRed.withOpacity(0.2),
                    child: const Icon(
                      Icons.person_rounded,
                      color: kIndianRed,
                      size: 50,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    // Handle profile picture change
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [kAccentOrange, Colors.deepOrange],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: kWhiteColor, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: kAccentOrange.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: kWhiteColor,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // User Name
          Text(
            userName,
            style: const TextStyle(
              color: kWhiteColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          // User Email
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: kWhiteColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kWhiteColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.email_outlined, color: kWhiteColor, size: 16),
                const SizedBox(width: 6),
                Text(
                  userEmail,
                  style: TextStyle(
                    color: kWhiteColor.withOpacity(0.95),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Member Since Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kGold.withOpacity(0.3), kLightGold.withOpacity(0.2)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kGold.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded, color: kGold, size: 16),
                const SizedBox(width: 6),
                Text(
                  memberSince,
                  style: TextStyle(
                    color: kWhiteColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kWhiteColor, kSoftBeige],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.shopping_bag_rounded, ordersCount.toString(), 'Orders', kIndianRed),
          _buildDivider(),
          _buildStatItem(Icons.favorite_rounded, wishlistCount.toString(), 'Wishlist', kAccentOrange),
          _buildDivider(),
          _buildStatItem(Icons.location_on_rounded, addressCount.toString(), 'Addresses', kDeepGreen),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String count, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          count,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kCharcoal,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: kCharcoal.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 60,
      width: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            kCharcoal.withOpacity(0.2),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kIndianRed.withOpacity(0.2), kIndianRed.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: kIndianRed, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kCharcoal,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIFeaturesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildEnhancedOption(
            icon: Icons.auto_awesome_rounded,
            title: 'AI Profile Builder',
            subtitle: 'Create stunning artisan profiles',
            gradient: [Colors.purple, Colors.deepPurple],
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileBuilderScreen()),
              );
            },
          ),
          _buildOptionDivider(),
          _buildEnhancedOption(
            icon: Icons.image_search_rounded,
            title: 'Smart Product Cataloging',
            subtitle: 'AI-powered product listings',
            gradient: [kAccentOrange, Colors.deepOrange],
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductCatalogingScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountManagementSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildEnhancedOption(
            icon: Icons.shopping_bag_outlined,
            title: 'My Orders',
            subtitle: 'Track your purchases',
            gradient: [kIndianRed, kDarkRed],
            badge: ordersCount > 0 ? ordersCount.toString() : null,
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyOrdersScreen()),
              );
            },
          ),
          _buildOptionDivider(),
          _buildEnhancedOption(
            icon: Icons.location_on_outlined,
            title: 'My Addresses',
            subtitle: 'Manage delivery locations',
            gradient: [kDeepGreen, Colors.teal],
            badge: addressCount > 0 ? addressCount.toString() : null,
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyAddressScreen()),
              );
            },
          ),
          _buildOptionDivider(),
          _buildEnhancedOption(
            icon: Icons.favorite_outline_rounded,
            title: 'My Wishlist',
            subtitle: 'Saved items for later',
            gradient: [Colors.pink, Colors.pinkAccent],
            badge: wishlistCount > 0 ? wishlistCount.toString() : null,
            onTap: () {
              HapticFeedback.mediumImpact();
              // Navigate to wishlist
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildEnhancedOption(
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            subtitle: 'Get assistance anytime',
            gradient: [Colors.blue, Colors.blueAccent],
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
              );
            },
          ),
          _buildOptionDivider(),
          _buildEnhancedOption(
            icon: Icons.star_outline_rounded,
            title: 'Rate Our App',
            subtitle: 'Share your experience',
            gradient: [kGold, Colors.amber],
            onTap: () {
              HapticFeedback.mediumImpact();
              // Handle rate app
            },
          ),
          _buildOptionDivider(),
          _buildEnhancedOption(
            icon: Icons.share_outlined,
            title: 'Share App',
            subtitle: 'Invite friends & family',
            gradient: [kDeepGreen, Colors.lightGreen],
            onTap: () {
              HapticFeedback.mediumImpact();
              // Handle share
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    String? badge,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient.map((c) => c.withOpacity(0.2)).toList(),
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: gradient[0], size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kCharcoal,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: kCharcoal.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradient),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: kWhiteColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: kCharcoal.withOpacity(0.4)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: kCharcoal.withOpacity(0.1)),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.red[400]!, Colors.red[600]!],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.mediumImpact();
            _showLogoutDialog(context);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.logout_rounded, color: kWhiteColor, size: 22),
                SizedBox(width: 12),
                Text(
                  'Logout',
                  style: TextStyle(
                    color: kWhiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.logout_rounded, color: Colors.red),
            ),
            const SizedBox(width: 12),
            const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to log out from your account?',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: kCharcoal, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: kWhiteColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [kIndianRed, kAccentOrange]),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kCharcoal,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.edit_outlined, color: kIndianRed),
              title: const Text('Edit Profile'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
                // Navigate to edit profile
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock_outlined, color: kIndianRed),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
                // Navigate to change password
              },
            ),
            ListTile(
              leading: const Icon(Icons.language_outlined, color: kIndianRed),
              title: const Text('Language'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
                // Show language options
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined, color: kIndianRed),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
                // Show privacy policy
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}