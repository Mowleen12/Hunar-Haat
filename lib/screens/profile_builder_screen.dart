import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

// Enhanced Hunar Haat color palette
const Color kIndianRed = Color(0xFFB22222);
const Color kGold = Color(0xFFD4AF37);
const Color kCharcoal = Color(0xFF36454F);
const Color kLightGrey = Color(0xFFEEEEEE);
const Color kWhiteColor = Colors.white;
const Color kAccentOrange = Color(0xFFFF6B35);
const Color kSoftBeige = Color(0xFFF5F1EB);
const Color kDeepGreen = Color(0xFF2E7D32);

class ProfileBuilderScreen extends StatefulWidget {
  const ProfileBuilderScreen({super.key});

  @override
  State<ProfileBuilderScreen> createState() => _ProfileBuilderScreenState();
}

class _ProfileBuilderScreenState extends State<ProfileBuilderScreen> 
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _craftController = TextEditingController();
  final _locationController = TextEditingController();
  final _experienceController = TextEditingController();

  String? _generatedBio;
  String? _errorMessage;
  bool _isLoading = false;
  int _currentStep = 0;

  late AnimationController _animationController;
  late AnimationController _resultAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // Predefined craft suggestions
  final List<String> _craftSuggestions = [
    'Pottery & Ceramics',
    'Wood Carving',
    'Handloom Weaving',
    'Metal Work',
    'Jewelry Making',
    'Leather Craft',
    'Embroidery',
    'Stone Carving',
    'Textile Printing',
    'Bamboo Craft',
    'Glass Work',
    'Paper Craft',
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
    _craftController.dispose();
    _locationController.dispose();
    _experienceController.dispose();
    _animationController.dispose();
    _resultAnimationController.dispose();
    super.dispose();
  }

  Future<void> _generateProfile() async {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.lightImpact();
      
      setState(() {
        _isLoading = true;
        _generatedBio = null;
        _errorMessage = null;
      });

      final artisanName = _nameController.text;
      final craftType = _craftController.text;
      final location = _locationController.text;
      final experience = _experienceController.text;

      final url = Uri.parse('http://192.168.1.11:5000/api/generate-profile'); 
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'name': artisanName,
        'craft': craftType,
        'location': location,
        'experience': experience,
      });

      try {
        final response = await http.post(url, headers: headers, body: body);

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          setState(() {
            _generatedBio = responseData['bio'];
          });
          _resultAnimationController.forward();
        } else {
          setState(() {
            _errorMessage = 'Error: ${response.statusCode} - ${response.body}';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Connection Error: Please check your internet connection and try again.';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildStepIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: List.generate(3, (index) {
          bool isActive = index <= _currentStep;
          bool isCompleted = index < _currentStep;
          
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: isActive ? kIndianRed : kLightGrey,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: isCompleted ? kDeepGreen : (isActive ? kIndianRed : kLightGrey),
                ),
              ),
            ),
          );
        }),
      ),
    );
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        if (suggestions != null) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions.take(6).map((suggestion) {
              return InkWell(
                onTap: () {
                  controller.text = suggestion;
                },
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

  Widget _buildGeneratedProfile() {
    if (_generatedBio == null) return const SizedBox.shrink();

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
              color: kIndianRed.withOpacity(0.1),
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
                        'AI-Generated Profile',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kCharcoal,
                        ),
                      ),
                      Text(
                        'Ready to showcase your craft!',
                        style: TextStyle(
                          fontSize: 14,
                          color: kCharcoal.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _generatedBio!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Profile copied to clipboard!'),
                        backgroundColor: kDeepGreen,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: Icon(Icons.copy, color: kCharcoal.withOpacity(0.7)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kLightGrey),
              ),
              child: Text(
                _generatedBio!,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: kCharcoal,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _resultAnimationController.reset();
                      setState(() {
                        _generatedBio = null;
                        _currentStep = 0;
                      });
                    },
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Generate New'),
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
                      // Save profile functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Profile saved successfully!'),
                          backgroundColor: kDeepGreen,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.save, size: 18),
                    label: const Text('Save Profile'),
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
              'AI Profile Builder',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Craft your artisan story',
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
                  title: const Text('About Profile Builder'),
                  content: const Text('Our AI helps create compelling profiles for artisans by analyzing their craft, experience, and background to generate personalized descriptions.'),
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
                  // Header Card
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
                        Icon(Icons.auto_awesome, color: kWhiteColor, size: 40),
                        const SizedBox(height: 12),
                        Text(
                          'Create Your Artisan Profile',
                          style: TextStyle(
                            color: kWhiteColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Let AI craft a compelling story that showcases your unique skills and heritage',
                          style: TextStyle(
                            color: kWhiteColor.withOpacity(0.9),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  _buildStepIndicator(),

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
                          label: 'Artisan Name',
                          icon: Icons.person,
                          hint: 'Enter the artisan\'s full name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the artisan\'s name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        _buildFormField(
                          controller: _craftController,
                          label: 'Type of Craft',
                          icon: Icons.palette,
                          hint: 'Select or enter craft type',
                          suggestions: _craftSuggestions,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the type of craft';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        _buildFormField(
                          controller: _locationController,
                          label: 'Location (Optional)',
                          icon: Icons.location_on,
                          hint: 'City, State (e.g., Jaipur, Rajasthan)',
                        ),
                        const SizedBox(height: 20),

                        _buildFormField(
                          controller: _experienceController,
                          label: 'Years of Experience (Optional)',
                          icon: Icons.star,
                          hint: 'Number of years',
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
                      onPressed: _isLoading ? null : _generateProfile,
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
                        _isLoading ? 'Generating...' : 'Generate AI Profile',
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

                  // Generated Profile
                  _buildGeneratedProfile(),

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