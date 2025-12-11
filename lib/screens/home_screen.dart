import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawkar_app/screens/settings_screen.dart';
import 'package:pawkar_app/widgets/collapsible_app_bar.dart';
import 'package:pawkar_app/widgets/categorias_section.dart';
import 'package:pawkar_app/widgets/eventos_destacados_section.dart';
import 'package:pawkar_app/widgets/proximos_eventos_section.dart';
import 'package:pawkar_app/widgets/proximos_encuentros_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    // Delay the refresh indicator to show after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
    });
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
    // This is where you would typically load your data
    // For example:
    // await someService.loadCategories();
    // await someOtherService.loadEvents();
    // The actual data loading should be handled by individual widgets

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
  }

  void _showThemeSelector(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  Future<void> _handleRefresh() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await Future.wait([_initializeServices(), _loadData()]);
    } catch (e) {
      debugPrint('Error during refresh: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al actualizar los datos'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          color: Theme.of(context).primaryColor,
          backgroundColor: Colors.white,
          strokeWidth: 2.5,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
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
        const ProximosEventosSection(),
        const SizedBox(height: 24),
      ],
    );
  }
}
