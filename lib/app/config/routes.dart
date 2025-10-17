import 'package:flutter/material.dart';
import 'package:pawkar_app/features/home/presentation/screens/home_screen.dart';
import 'package:pawkar_app/features/home/presentation/screens/splash_screen.dart';

// Placeholder screens
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('$title Screen - Under Development'),
      ),
    );
  }
}

class EventListScreen extends StatelessWidget {
  const EventListScreen({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Eventos');
}

class EventDetailScreen extends StatelessWidget {
  final String eventId;
  const EventDetailScreen({super.key, required this.eventId});
  @override
  Widget build(BuildContext context) => PlaceholderScreen(title: 'Evento $eventId');
}

class MatchListScreen extends StatelessWidget {
  const MatchListScreen({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Partidos');
}

class MatchDetailScreen extends StatelessWidget {
  final String matchId;
  const MatchDetailScreen({super.key, required this.matchId});
  @override
  Widget build(BuildContext context) => PlaceholderScreen(title: 'Partido $matchId');
}

class NewsListScreen extends StatelessWidget {
  const NewsListScreen({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Noticias');
}

class NewsDetailScreen extends StatelessWidget {
  final String newsId;
  const NewsDetailScreen({super.key, required this.newsId});
  @override
  Widget build(BuildContext context) => PlaceholderScreen(title: 'Noticia $newsId');
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Ajustes');
}

class AppRoutes {
  // Route names
  static const String splash = '/splash';
  static const String home = '/';
  static const String events = '/events';
  static const String eventDetail = '/events/detail';
  static const String matches = '/matches';
  static const String matchDetail = '/matches/detail';
  static const String news = '/news';
  static const String newsDetail = '/news/detail';
  static const String settings = '/settings';

  static String get initial => splash;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final name = settings.name;
    if (name == null) {
      return _errorRoute(settings);
    }

    switch (name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.events:
        return MaterialPageRoute(builder: (_) => const EventListScreen());
      case AppRoutes.eventDetail:
        final eventId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => EventDetailScreen(eventId: eventId),
        );
      case AppRoutes.matches:
        return MaterialPageRoute(builder: (_) => const MatchListScreen());
      case AppRoutes.matchDetail:
        final matchId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => MatchDetailScreen(matchId: matchId),
        );
      case AppRoutes.news:
        return MaterialPageRoute(builder: (_) => const NewsListScreen());
      case AppRoutes.newsDetail:
        final newsId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => NewsDetailScreen(newsId: newsId),
        );
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return _errorRoute(settings);
    }
}

static Route<dynamic> _errorRoute(RouteSettings settings) {
  return MaterialPageRoute(
    builder: (_) => Scaffold(
      body: Center(
        child: Text('No route defined for ${settings.name}'),
      ),
    ),
  );
}
  // Named routes for navigation
  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const HomeScreen(),
        events: (context) => const EventListScreen(),
        matches: (context) => const MatchListScreen(),
        news: (context) => const NewsListScreen(),
        settings: (context) => const SettingsScreen(),
      };

  // Helper method for navigation
  static Future<T?> push<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(context).pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    BuildContext context,
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return Navigator.of(context).pushReplacementNamed(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }
}
