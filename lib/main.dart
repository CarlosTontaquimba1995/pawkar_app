// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'config/app_config.dart';
import 'theme/app_colors.dart';
import 'providers/theme_provider.dart';
import 'routes/app_routes.dart';
import 'services/navigation_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Initialize default theme colors
  AppColors.initialize();
  
  final themeProvider = ThemeProvider();
  final navigationService = NavigationService();

  try {
    // Load and apply theme configuration
    await AppConfig.loadTheme();
    final config = await AppConfig.getConfig();
    
    // Theme will be updated by the provider
    themeProvider.updateTheme(config);
  } catch (e) {
    debugPrint('Error initializing app: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        Provider.value(value: navigationService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Pawkar App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      navigatorKey: context.read<NavigationService>().navigatorKey,
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.splash,
    );
  }
}
