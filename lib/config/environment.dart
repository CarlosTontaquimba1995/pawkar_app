import 'dart:io' show Platform;

class Environment {
  static const String _androidBaseUrl = 'http://10.0.2.2:8080';
  static const String _iosBaseUrl = 'http://localhost:8080';
  // For physical devices, use your computer's IP:
  // static const String _deviceBaseUrl = 'http://YOUR_COMPUTER_IP:8080';

  static String get baseUrl {
    if (Platform.isAndroid) {
      return _androidBaseUrl;
    } else if (Platform.isIOS) {
      return _iosBaseUrl;
    }
    // Default to Android emulator address
    return _androidBaseUrl;
  }
}
