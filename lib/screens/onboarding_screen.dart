import 'package:flipkart_clone/models/onboarding_model.dart';
import 'package:flutter/material.dart';
import '../constants/constants.dart';
import 'main_navigation_screen.dart';

// Hunar Haat Color Palette (re-defined for clarity)
const Color kIndianRed = Color(0xFFB22222);
const Color kGold = Color(0xFFD4AF37);
const Color kCharcoal = Color(0xFF36454F);
const Color kLightGrey = Color(0xFFEEEEEE);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGrey, // Use the new light grey background
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  _navigateToHome();
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: kIndianRed, // Use the primary red color
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            // Page View
            Expanded(
              flex: 5,
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingItems.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (_, index) {
                  return _buildOnboardingPage(onboardingItems[index]);
                },
              ),
            ),
            
            // Indicators and Next Button
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  // Page Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingItems.length,
                      (index) => _buildPageIndicator(index),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Next/Get Started Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPage == onboardingItems.length - 1) {
                            _navigateToHome();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kIndianRed, // Use primary red color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _currentPage == onboardingItems.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: kLightGrey, // Button text color
                          ),
                        ),
                      ),
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

  Widget _buildOnboardingPage(OnboardingItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: kWhiteColor, // Card-like background for image
            ),
            child: Image.network(
              item.image,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    valueColor: const AlwaysStoppedAnimation<Color>(kGold), // Use accent color
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                color: kLightGrey,
                child: const Icon(
                  Icons.palette, // A more relevant icon for art
                  size: 80,
                  color: kIndianRed, // Use the new primary color
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Title
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: kCharcoal, // Use dark charcoal for text
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Description
          Text(
            item.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey, // Grey for secondary text
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    return Container(
      width: _currentPage == index ? 24 : 8, // Animate width
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: _currentPage == index ? kIndianRed : kCharcoal.withOpacity(0.3), // Updated colors
      ),
    );
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}