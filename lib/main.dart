// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'services/configuracion_service.dart';
import 'providers/theme_provider.dart';
import 'theme/app_colors.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize default colors
  AppColors.initialize();

  // Initialize services
  final configService = ConfiguracionService();
  final themeProvider = ThemeProvider();

  try {
    // Try to fetch configuration from API
    final config = await configService.getConfiguracion();
    if (config.success) {
      themeProvider.updateTheme(config.data);
    }
  } catch (e) {
    debugPrint('Error loading configuration: $e');
    // Continue with default theme
  }

  runApp(
    ChangeNotifierProvider.value(value: themeProvider, child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'Pawkar App',
          theme: themeProvider.themeData,
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        );
      },
    );
  }
}
