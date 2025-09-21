import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

// Hunar Haat color palette
const Color kIndianRed = Color(0xFFB22222);
const Color kGold = Color(0xFFD4AF37);
const Color kCharcoal = Color(0xFF36454F);
const Color kLightGrey = Color(0xFFEEEEEE);
const Color kWhiteColor = Colors.white;
const Color kAccentOrange = Color(0xFFFF6B35);
const Color kSoftBeige = Color(0xFFF5F1EB);
const Color kDeepGreen = Color(0xFF2E7D32);

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> 
    with TickerProviderStateMixin {
  final List<types.Message> _messages = [];
  final _uuid = const Uuid();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isTyping = false;
  
  // Enhanced users with avatars
  final _currentUser = const types.User(
    id: 'user_id', 
    firstName: 'You',
    imageUrl: 'https://i.pravatar.cc/150?img=1',
  );
  
  final _geminiBotUser = const types.User(
    id: 'gemini_bot_id', 
    firstName: 'Hunar',
    lastName: 'Assistant',
    imageUrl: 'https://i.pravatar.cc/150?img=68',
  );

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
    _animationController.forward();
    
    // Add welcome message
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    final welcomeMessage = types.TextMessage(
      author: _geminiBotUser,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: _uuid.v4(),
      text: '🙏 Namaste! Welcome to Hunar Haat! I\'m here to help you discover amazing handicrafts and answer any questions about our artisan products. How can I assist you today?',
    );
    _addMessage(welcomeMessage);
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  Future<void> _handleSendPressed(types.PartialText message) async {
    // Haptic feedback
    HapticFeedback.lightImpact();
    
    // Add the user's message to the chat
    final userMessage = types.TextMessage(
      author: _currentUser,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: _uuid.v4(),
      text: message.text,
    );
    _addMessage(userMessage);

    // Set typing indicator
    setState(() {
      _isTyping = true;
    });

    // Prepare the request body for the Gemini API
    final requestBody = jsonEncode({
      'message': message.text,
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.11:5000/api/gemini-chat'),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      setState(() {
        _isTyping = false;
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        final botMessageContent = responseData['response'];

        // Add the actual response from the bot
        final botMessage = types.TextMessage(
          author: _geminiBotUser,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: _uuid.v4(),
          text: botMessageContent,
        );
        _addMessage(botMessage);
      } else {
        // Handle API errors
        _addMessage(types.TextMessage(
          author: _geminiBotUser,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: _uuid.v4(),
          text: '🚫 Oops! I\'m having trouble connecting right now. Please try again in a moment. (Error: ${response.statusCode})',
        ));
      }
    } catch (e) {
      // Handle network errors
      setState(() {
        _isTyping = false;
      });
      _addMessage(types.TextMessage(
        author: _geminiBotUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: _uuid.v4(),
        text: '🔌 Connection Error: I\'m having trouble reaching my servers. Please check your internet connection and try again.',
      ));
    }
  }

  Widget _buildTypingIndicator() {
    if (!_isTyping) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: _geminiBotUser.imageUrl != null 
                ? NetworkImage(_geminiBotUser.imageUrl!) 
                : null,
            backgroundColor: kIndianRed.withOpacity(0.1),
            child: _geminiBotUser.imageUrl == null 
                ? Icon(Icons.support_agent, size: 16, color: kIndianRed)
                : null,
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kLightGrey,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.5 + (0.5 * value),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: kCharcoal.withOpacity(0.4 + (0.4 * value)),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
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
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: _geminiBotUser.imageUrl != null 
                      ? NetworkImage(_geminiBotUser.imageUrl!) 
                      : null,
                  backgroundColor: kWhiteColor.withOpacity(0.2),
                  child: _geminiBotUser.imageUrl == null 
                      ? Icon(Icons.support_agent, color: kWhiteColor, size: 20)
                      : null,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: kDeepGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: kWhiteColor, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hunar Assistant',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kWhiteColor,
                    ),
                  ),
                  Text(
                    'Online • Always here to help',
                    style: TextStyle(
                      fontSize: 12,
                      color: kWhiteColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Clear chat functionality
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear Chat'),
                  content: const Text('Are you sure you want to clear this conversation?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel', style: TextStyle(color: kCharcoal)),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _messages.clear();
                        });
                        Navigator.pop(context);
                        _addWelcomeMessage();
                      },
                      child: Text('Clear', style: TextStyle(color: kIndianRed)),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.refresh, size: 20),
          ),
          IconButton(
            onPressed: () {
              // Show help/info
              _showHelpBottomSheet();
            },
            icon: const Icon(Icons.info_outline, size: 20),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Custom header with gradient
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kIndianRed, kAccentOrange],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  // Chat interface
                  Chat(
                    messages: _messages,
                    onSendPressed: _handleSendPressed,
                    user: _currentUser,
                    theme: _buildChatTheme(),
                    showUserAvatars: true,
                    showUserNames: false,
                    dateHeaderThreshold: 86400000, // 24 hours
                    timeFormat: DateFormat.Hm(),
                    dateFormat: DateFormat.yMd(),
                    // Remove customBottomWidget to show default input
                  ),
                  // Typing indicator overlay
                  Positioned(
                    bottom: 80,
                    left: 0,
                    right: 0,
                    child: _buildTypingIndicator(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ChatTheme _buildChatTheme() {
    return DefaultChatTheme(
      backgroundColor: kSoftBeige,
      primaryColor: kIndianRed,
      secondaryColor: kLightGrey,
      messageBorderRadius: 16,
      messageInsetsHorizontal: 16,
      messageInsetsVertical: 12,
      sentMessageBodyTextStyle: TextStyle(
        color: kWhiteColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      receivedMessageBodyTextStyle: TextStyle(
        color: kCharcoal,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
      inputBackgroundColor: kWhiteColor,
      inputBorderRadius: const BorderRadius.all(Radius.circular(24)),
      inputTextColor: kCharcoal,
      inputTextStyle: const TextStyle(fontSize: 14, height: 1.4),
      sentMessageCaptionTextStyle: TextStyle(
        color: kWhiteColor.withOpacity(0.8),
        fontSize: 12,
      ),
      receivedMessageCaptionTextStyle: TextStyle(
        color: kCharcoal.withOpacity(0.6),
        fontSize: 12,
      ),
    );
  }

  Widget? _buildCustomInput() {
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: null, // Let the default input be used, just with custom container
    );
  }

  void _showHelpBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: kCharcoal.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.help_outline, color: kIndianRed, size: 24),
                const SizedBox(width: 12),
                Text(
                  'How can I help you?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kCharcoal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildHelpItem(
              icon: Icons.shopping_bag,
              title: 'Product Information',
              description: 'Ask about any handicraft, price, or artisan details',
            ),
            _buildHelpItem(
              icon: Icons.location_on,
              title: 'Regional Crafts',
              description: 'Discover crafts from specific regions of India',
            ),
            _buildHelpItem(
              icon: Icons.palette,
              title: 'Craft Techniques',
              description: 'Learn about traditional art forms and techniques',
            ),
            _buildHelpItem(
              icon: Icons.support_agent,
              title: 'Customer Support',
              description: 'Get help with orders, shipping, and returns',
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kIndianRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.tips_and_updates, color: kIndianRed, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Try asking: "Show me pottery from Rajasthan" or "What\'s special about Kashmiri shawls?"',
                      style: TextStyle(
                        fontSize: 12,
                        color: kCharcoal.withOpacity(0.8),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: kIndianRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: kIndianRed, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kCharcoal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: kCharcoal.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}