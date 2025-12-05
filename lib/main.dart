import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'services/configuracion_service.dart';
import 'providers/theme_provider.dart';
import 'theme/app_theme.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final configService = ConfiguracionService();
  final themeProvider = ThemeProvider();

  try {
    // Try to fetch configuration from API
    final config = await configService.getConfiguracion();
    if (config.success) {
      // Update theme colors from API
      final configMap = {
        'primario': config.data.primario,
        'secundario': config.data.secundario,
        'acento1': config.data.acento1,
        'acento2': config.data.acento2,
      };
      AppTheme.updateColors(configMap);
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    context.read<ThemeProvider>().updateFromSystemBrightness(brightness);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'Pawkar App',
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        );
      },
    );
  }
}
