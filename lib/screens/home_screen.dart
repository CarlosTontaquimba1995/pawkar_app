import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawkar_app/screens/settings_screen.dart';
import 'package:pawkar_app/widgets/collapsible_app_bar.dart';
import 'package:pawkar_app/widgets/categorias_section.dart';
import 'package:pawkar_app/widgets/eventos_destacados_section.dart';
import 'package:pawkar_app/widgets/proximos_encuentros_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await Future.wait([_initializeServices(), _loadData()]);
    } catch (e) {
      // Handle any errors during initialization
      debugPrint('Error during initialization: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _initializeServices() async {
    // Initialize your services here
    // Make sure all service initializations are async
  }

  Future<void> _loadData() async {
    // Load your data here
    // Make sure all data loading is async
  }

  void _showThemeSelector(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  @override
Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CollapsibleAppBar(
              title: 'PAWKAR',
              subtitle: 'Festival Cultural y Deportivo',
              greeting: 'Bienvenido a',
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: IconButton(
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () => _showThemeSelector(context),
                    tooltip: 'Ajustes',
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(child: _buildBody(theme)),
          ],
        ),
      ),
    );
  }
  Widget _buildBody(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const CategoriasSection(),
        const SizedBox(height: 24),
        const EventosDestacadosSection(),
        const SizedBox(height: 24),
        const ProximosEncuentrosSection(),
        const SizedBox(height: 24),
      ],
    );
  }
}
