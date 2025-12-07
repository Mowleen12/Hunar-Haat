// lib/services/network_utils.dart
import 'dart:io';

/// Returns the IP the mobile device can use to reach **this** machine.
///
/// • Emulator → 10.0.2.2  
/// • Real device → first non-loopback IPv4 address (192.168.x.x)
Future<String> getBackendHost() async {
  // 1. Emulator special case (Android only)
  if (Platform.isAndroid && !await _isPhysicalDevice()) {
    return '10.0.2.2';
  }

  // 2. Scan all interfaces
  final interfaces = await NetworkInterface.list(
    type: InternetAddressType.IPv4,
    includeLoopback: false,
    includeLinkLocal: false,
  );

  for (var iface in interfaces) {
    for (var addr in iface.addresses) {
      // Skip link-local (169.254.x.x) and loopback
      if (!addr.isLoopback && !addr.address.startsWith('169.254')) {
        return addr.address;
      }
    }
  }

  // 3. Absolute fallback – you can also read a default from .env
  return '10.0.2.2';
}

/// Heuristic: on an emulator the model name contains “sdk_gphone” or “emulator”
Future<bool> _isPhysicalDevice() async {
  try {
    final result = await Process.run('getprop', ['ro.product.model']);
    final model = result.stdout.toString().trim().toLowerCase();
    return !model.contains('sdk_gphone') && !model.contains('emulator');
  } catch (_) {
    return true; // assume physical if we cannot query
  }
}