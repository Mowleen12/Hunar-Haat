import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

// --- MESSAGE MODEL ---
// A simple local model to hold chat message data.
class ChatMessage {
  final String id;
  final String text;
  final DateTime timestamp;
  final bool isUserMessage;

  // 1. ADD THE copyWith METHOD
  ChatMessage copyWith({
    String? id,
    String? text,
    DateTime? timestamp,
    bool? isUserMessage,
  }) {
    return ChatMessage(
      // 2. Use the ?? operator to safely provide defaults
      id: id ?? this.id,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isUserMessage: isUserMessage ?? this.isUserMessage,
    );
  }

  ChatMessage({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.isUserMessage,
  });
}

// --- HUNAR HAAT COLOR PALETTE ---
const Color kIndianRed = Color(0xFFB22222);
const Color kDarkRed = Color(0xFF8B0000);
const Color kGold = Color(0xFFD4AF37);
const Color kCharcoal = Color(0xFF36454F);
const Color kWhiteColor = Colors.white;
const Color kAccentOrange = Color(0xFFFF6B35);
const Color kSoftBeige = Color(0xFFF5F1EB);
const Color kDeepGreen = Color(0xFF2E7D32);
const Color kLightGold = Color(0xFFFFF8DC);

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _uuid = const Uuid();

  late AnimationController _introAnimationController;
  late AnimationController _typingDotController;

  late Animation<double> _fadeAnimation;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();

    // 1. Intro Animation Controller
    _introAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();

    // 2. Typing Dot Looping Controller
    _typingDotController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _introAnimationController, curve: Curves.easeInOut),
    );

    // Add welcome message with animation delay
    Future.delayed(const Duration(milliseconds: 500), _addWelcomeMessage);
  }

  @override
  void dispose() {
    _introAnimationController.dispose();
    _typingDotController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // --- MESSAGE MANAGEMENT ---

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      id: _uuid.v4(),
      timestamp: DateTime.now(),
      isUserMessage: false,
      text:
          '🙏 Namaste! Welcome to Hunar Haat!\n\nI\'m your personal handicraft assistant, here to help you discover the finest Indian artisan products.\n\n✨ Ask me about:\n• Traditional crafts from any region\n• Product recommendations\n• Artisan stories\n• Price ranges and categories\n\nHow may I assist you today?',
    );
    _addMessage(welcomeMessage);
  }

  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.insert(0, message);
    });
    // Scroll to the bottom (top of reversed list) after adding a message
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _handleSendPressed(String text) async {
    if (text.trim().isEmpty) return;

    HapticFeedback.mediumImpact();

    // 1. Add user's message
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      timestamp: DateTime.now(),
      isUserMessage: true,
      text: text,
    );
    _addMessage(userMessage);
    _textController.clear();

    // 2. Show typing indicator
    setState(() => _isTyping = true);

    try {
      // 3. Call backend — NO IP, FULLY AUTOMATIC
      final botReply = await ApiService.postChat(text);

      HapticFeedback.lightImpact();

      // 4. ADD BOT MESSAGE (THIS WAS MISSING!)
      final botMessage = ChatMessage(
        id: _uuid.v4(),
        timestamp: DateTime.now(),
        isUserMessage: false,
        text: botReply,
      );
      _addMessage(botMessage);
    } catch (e, stackTrace) {
      // 5. Show error as a bot message
      print('❌ ERROR in _handleSendPressed: $e');
      print('Stack trace: $stackTrace');
      
      final errorMessage = ChatMessage(
        id: _uuid.v4(),
        timestamp: DateTime.now(),
        isUserMessage: false,
        text:
            'Connection Error\nFailed to reach server. Please check your internet.\nError: $e', // Added error details to UI for visibility
      );
      _addMessage(errorMessage);
    } finally {
      // 6. Hide typing indicator
      setState(() => _isTyping = false);
    }
  }

  // --- TYPING INDICATOR WIDGETS ---

  Widget _buildTypingDot(int index) {
    return AnimatedBuilder(
      animation: _typingDotController,
      builder: (context, child) {
        // Calculate phase delay for staggered animation
        final delay = index * 0.2;
        final totalDuration = 1.0;
        double animationValue =
            (_typingDotController.value + delay) % totalDuration;

        // Ping-pong curve (0 -> 1 -> 0)
        double scale = 0.0;
        if (animationValue < 0.5) {
          scale = Curves.easeOutCubic.transform(animationValue * 2);
        } else {
          scale =
              Curves.easeOutCubic.transform(1.0 - (animationValue - 0.5) * 2);
        }

        // Apply vertical offset for the bounce effect
        return Transform.translate(
          offset: Offset(0, -4 * scale),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kIndianRed, kAccentOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kIndianRed.withOpacity(0.3 * scale),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypingIndicator() {
    if (!_isTyping) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Bot Avatar
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(right: 12, bottom: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kIndianRed, width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/bot_avatar.jpg', // Placeholder image
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: kIndianRed.withOpacity(0.1),
                      child: const Icon(Icons.support_agent,
                          size: 20, color: kIndianRed),
                    );
                  },
                ),
              ),
            ),
            // Typing Dots Bubble
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kLightGold, kSoftBeige],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTypingDot(0),
                  const SizedBox(width: 6),
                  _buildTypingDot(1),
                  const SizedBox(width: 6),
                  _buildTypingDot(2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- MESSAGE BUBBLE WIDGET ---

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUserMessage;
    final timeString = DateFormat('h:mm a').format(message.timestamp);

    // Determines the bubble's primary color/gradient
    final BoxDecoration decoration = BoxDecoration(
      gradient: isUser
          ? LinearGradient(
              colors: [kIndianRed, kDarkRed],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      color: isUser ? null : kWhiteColor,
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(18),
        topRight: const Radius.circular(18),
        bottomLeft: Radius.circular(isUser ? 18 : 4),
        bottomRight: Radius.circular(isUser ? 4 : 18),
      ),
      boxShadow: [
        BoxShadow(
          color: isUser
              ? kIndianRed.withOpacity(0.3)
              : Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );

    // Determines text style
    final TextStyle bodyTextStyle = isUser
        ? TextStyle(
            color: kWhiteColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            height: 1.5,
          )
        : TextStyle(
            color: kCharcoal,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            height: 1.5,
          );

    final TextStyle captionTextStyle = TextStyle(
      color:
          isUser ? kWhiteColor.withOpacity(0.85) : kCharcoal.withOpacity(0.6),
      fontSize: 11,
      fontWeight: FontWeight.w500,
    );

    // Message bubble content
    final bubbleContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      decoration: decoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SelectableText(
            message.text,
            style: bodyTextStyle,
          ),
          const SizedBox(height: 4),
          Text(
            timeString,
            style: captionTextStyle,
          ),
        ],
      ),
    );

    // Full row layout (including avatar for bot)
    return Padding(
      padding: EdgeInsets.only(
        top: 12,
        bottom: 4,
        left: isUser ? 60 : 16, // Inset user message
        right: isUser ? 16 : 60, // Inset bot message
      ),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Bot Avatar (Only for non-user messages)
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 4),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kIndianRed, width: 2),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/bot_avatar.jpg', // Placeholder image
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: kIndianRed.withOpacity(0.1),
                        child: const Icon(Icons.support_agent,
                            size: 16, color: kIndianRed),
                      );
                    },
                  ),
                ),
              ),
            ),

          Flexible(child: bubbleContent),
        ],
      ),
    );
  }

  // --- COMPOSER (Input Field) WIDGET ---

  Widget _buildComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: kWhiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: kSoftBeige,
                borderRadius: BorderRadius.circular(26),
              ),
              child: TextField(
                controller: _textController,
                style: const TextStyle(
                    fontSize: 15, height: 1.4, color: kCharcoal),
                decoration: const InputDecoration(
                  hintText: 'Ask about crafts, prices, or regions...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: kCharcoal),
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                onSubmitted: _handleSendPressed,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kIndianRed, kDarkRed],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: _isTyping
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(kWhiteColor),
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.send_rounded, color: kWhiteColor),
              onPressed: _isTyping
                  ? null
                  : () => _handleSendPressed(_textController.text),
            ),
          ),
        ],
      ),
    );
  }

  // --- BUILD METHOD ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSoftBeige,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [kIndianRed, kDarkRed],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: kIndianRed.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: kWhiteColor,
            title: const Text('Hunar Assistant'),
            actions: [
              IconButton(
                onPressed: () => _showClearChatDialog(),
                icon: const Icon(Icons.refresh_rounded),
              ),
              IconButton(
                onPressed: () => _showHelpBottomSheet(),
                icon: const Icon(Icons.info_outline_rounded),
              ),
            ],
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Decorative gradient bar
            Container(
              height: 5,
              decoration: BoxDecoration(
                // Must use BoxDecoration to hold the gradient
                gradient: LinearGradient(
                  colors: [kGold, kAccentOrange, kIndianRed],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ), // The gradient object itself is correctly assigned here.
            ),
            Expanded(
              child: Stack(
                children: [
                  // Background Pattern
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _BackgroundPatternPainter(),
                    ),
                  ),
                  // Message List
                  ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.only(bottom: 80, top: 10),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(_messages[index]);
                    },
                  ),
                  // Typing Indicator Overlay (Positioned on top of the list)
                  _buildTypingIndicator(),
                ],
              ),
            ),
            // Input Field (Composer)
            _buildComposer(),
          ],
        ),
      ),
    );
  }

  // --- DIALOGS AND BOTTOM SHEETS ---

  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content:
            const Text('Are you sure you want to clear this conversation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _messages.clear();
              });
              Navigator.pop(context);
              _addWelcomeMessage();
            },
            style: ElevatedButton.styleFrom(backgroundColor: kIndianRed),
            child: const Text('Clear', style: TextStyle(color: kWhiteColor)),
          ),
        ],
      ),
    );
  }

  void _showHelpBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hunar Assistant Help',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildHelpItem(
              icon: Icons.shopping_bag_outlined,
              title: 'Product Information',
              description: 'Ask about handicrafts, prices, and artisan details',
              color: kIndianRed,
            ),
            _buildHelpItem(
              icon: Icons.location_on_outlined,
              title: 'Regional Crafts',
              description:
                  'Discover authentic crafts from specific Indian regions',
              color: kDeepGreen,
            ),
          ],
        ),
      ),
    );
  }

  // Helper for bottom sheet items (kept from your original code)
  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: kCharcoal)),
                const SizedBox(height: 3),
                Text(description,
                    style: TextStyle(
                        fontSize: 12,
                        color: kCharcoal.withOpacity(0.7),
                        height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- CUSTOM PAINTER CLASS (from your original code) ---

class _BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kCharcoal.withOpacity(0.02)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const spacing = 40.0;

    // Vertical lines
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    // Horizontal lines
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    // Draw decorative mandala patterns in corners
    final mandalaPaint = Paint()
      ..color = kGold.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    final Path topRightPath = Path();
    topRightPath.addOval(
        Rect.fromCircle(center: Offset(size.width - 40, 40), radius: 30));
    canvas.drawPath(topRightPath, mandalaPaint);

    final Path bottomLeftPath = Path();
    bottomLeftPath.addOval(
        Rect.fromCircle(center: Offset(40, size.height - 40), radius: 30));
    canvas.drawPath(bottomLeftPath, mandalaPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
