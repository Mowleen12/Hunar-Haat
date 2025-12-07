// lib/services/api_service.dart
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static String? _host;
  static const int _port = 5000;
  
  /// Automatically finds the right IP for backend connection
  static Future<String> _getHost() async {
    if (_host != null) return _host!;

    // 0. For Web, use localhost (127.0.0.1)
    if (kIsWeb) {
      _host = '127.0.0.1';
      return _host!;
    }

    // 1. For Desktop platforms (Windows, macOS, Linux), use localhost
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      _host = '127.0.0.1';
      return _host!;
    }

    // 2. For Android (Emulator), use 10.0.2.2
    // This is the special IP that points to the HOST machine's localhost.
    if (Platform.isAndroid) {
      _host = '10.0.2.2';
      return _host!;
    }

    // 3. Fallback for iOS/Other
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
        includeLinkLocal: false,
      );

      for (var iface in interfaces) {
        for (var addr in iface.addresses) {
          if (!addr.isLoopback && !addr.address.startsWith('169.254')) {
            _host = addr.address; 
            return _host!;
          }
        }
      }
    } catch (e) {
      print('Error scanning network interfaces: $e');
    }

    // 4. Final fallback
    _host = '10.0.2.2';
    return _host!;
  }

  /// Build complete URL for endpoint
  static Future<String> _buildUrl(String endpoint) async {
    final host = await _getHost();
    return 'http://$host:$_port/$endpoint';
  }

  /// Send chat message to backend
  static Future<String> postChat(String message) async {
    final url = await _buildUrl('api/gemini-chat');
    
    print('🔵 Sending chat to: $url');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message}),
      ).timeout(const Duration(seconds: 30));

      print('🟢 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data is Map && data['response'] is String) {
          return data['response'];
        }
        return 'Received invalid response format.';
      } else {
        // Try to parse error message from backend
        String errorMsg = 'Server error: ${response.statusCode}';
        try {
          final errorData = jsonDecode(utf8.decode(response.bodyBytes));
          if (errorData is Map && errorData['error'] != null) {
            errorMsg = 'Server Error: ${errorData['error']}';
          }
        } catch (_) {}
        throw Exception(errorMsg);
      }
    } on TimeoutException {
      throw Exception('Request timed out. Check if backend is running on port $_port');
    } on SocketException {
      throw Exception('Cannot connect to backend. Ensure backend is running.');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Generate product listing with image
  static Future<Map<String, dynamic>> generateProductListing({
    required String productName,
    required String imageDataBase64,
    String? category,
    String? price,
  }) async {
    final url = await _buildUrl('api/generate-product-listing');
    
    print('🔵 Generating product listing: $url');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'productName': productName,
          'imageData': imageDataBase64,
          'category': category,
          'price': price,
        }),
      ).timeout(const Duration(seconds: 45));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'description': data['description'] ?? '',
          'tags': List<String>.from(data['tags'] ?? []),
        };
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Image processing timed out. Try again.');
    } on SocketException {
      throw Exception('Cannot connect to backend.');
    } catch (e) {
      throw Exception('Error generating listing: $e');
    }
  }

  /// Generate artisan profile
  static Future<String> generateProfile({
    required String name,
    required String craft,
    String? location,
    String? experience,
  }) async {
    final url = await _buildUrl('api/generate-profile');
    
    print('🔵 Generating profile: $url');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'craft': craft,
          'location': location,
          'experience': experience,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['bio'] ?? 'No bio generated';
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Request timed out.');
    } on SocketException {
      throw Exception('Cannot connect to backend.');
    } catch (e) {
      throw Exception('Error generating profile: $e');
    }
  }

  /// Reset cached host (useful for testing)
  static void resetHost() {
    _host = null;
  }
}