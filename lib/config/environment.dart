import 'dart:io' show Platform;

class Environment {
  // For Android emulator use 10.0.2.2
  // For iOS simulator use localhost
  // For physical devices use your computer's local IP
  static const String _androidBaseUrl = 'http://10.0.2.2:8080';
  static const String _iosBaseUrl = 'http://localhost:8080';

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
