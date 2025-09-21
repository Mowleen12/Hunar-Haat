import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

// Enhanced Hunar Haat color palette
const Color kIndianRed = Color(0xFFB22222);
const Color kGold = Color(0xFFD4AF37);
const Color kCharcoal = Color(0xFF36454F);
const Color kLightGrey = Color(0xFFEEEEEE);
const Color kWhiteColor = Colors.white;
const Color kAccentOrange = Color(0xFFFF6B35);
const Color kSoftBeige = Color(0xFFF5F1EB);
const Color kDeepGreen = Color(0xFF2E7D32);

class ProductCatalogingScreen extends StatefulWidget {
  const ProductCatalogingScreen({super.key});

  @override
  State<ProductCatalogingScreen> createState() =>
      _ProductCatalogingScreenState();
}

class _ProductCatalogingScreenState extends State<ProductCatalogingScreen>
    with TickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _selectedImage;
  String? _generatedDescription;
  List<String> _generatedTags = [];
  String? _errorMessage;
  bool _isLoading = false;

  late AnimationController _animationController;
  late AnimationController _resultAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // Product categories for suggestions
  final List<String> _categories = [
    'Textiles & Fabrics',
    'Pottery & Ceramics',
    'Wood Crafts',
    'Metal Work',
    'Jewelry',
    'Leather Goods',
    'Stone Crafts',
    'Bamboo Products',
    'Glass Work',
    'Paper Crafts',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _resultAnimationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _animationController.dispose();
    _resultAnimationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        HapticFeedback.lightImpact();
        setState(() {
          _selectedImage = File(pickedFile.path);
          _generatedDescription = null;
          _generatedTags = [];
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error selecting image: $e';
      });
    }
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: kCharcoal.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Select Image Source',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kCharcoal,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildImageSourceOption(
                    icon: Icons.photo_camera,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildImageSourceOption(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: kLightGrey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: kIndianRed),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: kCharcoal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateListing() async {
    if (!_formKey.currentState!.validate() || _selectedImage == null) {
      setState(() {
        _errorMessage = 'Please enter product details and select an image.';
      });
      return;
    }

    HapticFeedback.mediumImpact();
    
    setState(() {
      _isLoading = true;
      _generatedDescription = null;
      _generatedTags = [];
      _errorMessage = null;
    });

    try {
      final productName = _nameController.text;
      final category = _categoryController.text;
      final price = _priceController.text;
      final imageData = await _selectedImage!.readAsBytes();
      final imageDataBase64 = base64Encode(imageData);

      final url = Uri.parse('http://192.168.1.11:5000/api/generate-product-listing');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'productName': productName,
        'category': category,
        'price': price,
        'imageData': imageDataBase64,
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          _generatedDescription = responseData['description'];
          _generatedTags = List<String>.from(responseData['tags']);
        });
        _resultAnimationController.forward();
      } else {
        setState(() {
          _errorMessage = 'Server Error: Unable to generate listing. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection Error: Please check your internet connection.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    List<String>? suggestions,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kCharcoal,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kIndianRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: kIndianRed, size: 20),
            ),
            filled: true,
            fillColor: kWhiteColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kLightGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kLightGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kIndianRed, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        if (suggestions != null) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions.take(5).map((suggestion) {
              return InkWell(
                onTap: () => controller.text = suggestion,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: kIndianRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kIndianRed.withOpacity(0.3)),
                  ),
                  child: Text(
                    suggestion,
                    style: TextStyle(
                      color: kIndianRed,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildImageSelector() {
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.photo_camera, color: kIndianRed, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Product Image',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: kCharcoal,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: _showImageSourceBottomSheet,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _selectedImage == null ? kSoftBeige : Colors.transparent,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                border: Border.all(
                  color: _selectedImage == null ? kLightGrey : Colors.transparent,
                  style: _selectedImage == null ? BorderStyle.solid : BorderStyle.none,
                ),
              ),
              child: _selectedImage == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_outlined, 
                             size: 48, color: kCharcoal.withOpacity(0.5)),
                        const SizedBox(height: 12),
                        Text(
                          'Tap to add product image',
                          style: TextStyle(
                            color: kCharcoal.withOpacity(0.7),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Camera or Gallery',
                          style: TextStyle(
                            color: kCharcoal.withOpacity(0.5),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: kWhiteColor.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: _showImageSourceBottomSheet,
                              icon: Icon(Icons.edit, color: kIndianRed, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneratedResults() {
    if (_generatedDescription == null) return const SizedBox.shrink();

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: const EdgeInsets.only(top: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [kWhiteColor, kSoftBeige],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: kDeepGreen.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kDeepGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.auto_awesome, color: kDeepGreen, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI-Generated Listing',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kCharcoal,
                        ),
                      ),
                      Text(
                        'Ready for your marketplace!',
                        style: TextStyle(
                          fontSize: 14,
                          color: kCharcoal.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Description Section
            Text(
              'Product Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kCharcoal,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kLightGrey),
              ),
              child: Text(
                _generatedDescription!,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: kCharcoal,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Tags Section
            Text(
              'Suggested Tags',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kCharcoal,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _generatedTags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kGold.withOpacity(0.2), kAccentOrange.withOpacity(0.1)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kGold.withOpacity(0.5)),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: kCharcoal,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 20),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                        text: 'Description: $_generatedDescription\n\nTags: ${_generatedTags.join(", ")}'
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Listing copied to clipboard!'),
                          backgroundColor: kDeepGreen,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccentOrange,
                      foregroundColor: kWhiteColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _resultAnimationController.reset();
                      setState(() {
                        _generatedDescription = null;
                        _generatedTags = [];
                      });
                    },
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Generate New'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kDeepGreen,
                      foregroundColor: kWhiteColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSoftBeige,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kIndianRed,
        foregroundColor: kWhiteColor,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 20),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Smart Cataloging',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'AI-powered product listing',
              style: TextStyle(
                fontSize: 12,
                color: kWhiteColor.withOpacity(0.8),
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About Smart Cataloging'),
                  content: const Text('Upload a product image and our AI will automatically generate detailed descriptions and relevant tags for your marketplace listing.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Got it!', style: TextStyle(color: kIndianRed)),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.info_outline, size: 20),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [kIndianRed, kAccentOrange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: kIndianRed.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.smart_toy, color: kWhiteColor, size: 40),
                        const SizedBox(height: 12),
                        Text(
                          'AI-Powered Product Cataloging',
                          style: TextStyle(
                            color: kWhiteColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Upload your product image and let AI create compelling descriptions and tags',
                          style: TextStyle(
                            color: kWhiteColor.withOpacity(0.9),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Image Selection
                  _buildImageSelector(),

                  const SizedBox(height: 24),

                  // Form Fields
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildFormField(
                          controller: _nameController,
                          label: 'Product Name',
                          icon: Icons.shopping_bag_outlined,
                          hint: 'Enter the product name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a product name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        _buildFormField(
                          controller: _categoryController,
                          label: 'Category (Optional)',
                          icon: Icons.category_outlined,
                          hint: 'Select or enter category',
                          suggestions: _categories,
                        ),
                        const SizedBox(height: 20),

                        _buildFormField(
                          controller: _priceController,
                          label: 'Price (Optional)',
                          icon: Icons.currency_rupee,
                          hint: 'Enter price in ₹',
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Generate Button
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: kIndianRed.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _generateListing,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kIndianRed,
                        foregroundColor: kWhiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      icon: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: kWhiteColor,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.auto_awesome, size: 20),
                      label: Text(
                        _isLoading ? 'Analyzing Image...' : 'Generate Smart Listing',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Error Message
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red[700], fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Generated Results
                  _buildGeneratedResults(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}