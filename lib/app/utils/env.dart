import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class Env {
  static final Env _instance = Env._internal();
  factory Env() => _instance;
  Env._internal();

  static const String _defaultBaseUrl = 'https://api.pawkaraymi.com/v1';
  static const String _defaultAppName = 'PAWKAR RAYMI 2026';
  static const bool _defaultIsProduction = false;

  late String baseUrl;
  late String appName;
  late bool isProduction;

  Future<void> load() async {
    await dotenv.load(fileName: '.env');
    
    baseUrl = dotenv.env['BASE_URL'] ?? _defaultBaseUrl;
    appName = dotenv.env['APP_NAME'] ?? _defaultAppName;
    isProduction = dotenv.env['ENVIRONMENT']?.toLowerCase() == 'production' || kReleaseMode;
  }

  // Helper getters
  static String get apiUrl => _instance.baseUrl;
  static String get appTitle => _instance.appName;
  static bool get isProd => _instance.isProduction;
  
  // API Endpoints
  static String get eventsEndpoint => '$apiUrl/events';
  static String eventDetailsEndpoint(String id) => '$apiUrl/events/$id';
  static String get matchesEndpoint => '$apiUrl/matches';
  static String matchDetailsEndpoint(String id) => '$apiUrl/matches/$id';
  static String get newsEndpoint => '$apiUrl/news';
  static String newsDetailsEndpoint(String id) => '$apiUrl/news/$id';
  
  // WebSocket endpoints (if needed)
  static String get wsBaseUrl => apiUrl.replaceFirst('http', 'ws');
  static String get liveScoresEndpoint => '$wsBaseUrl/live-scores';
  
  // Static method to get instance (for dependency injection)
  static Future<Env> getInstance() async {
    await _instance.load();
    return _instance;
  }
}
