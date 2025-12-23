import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawkar_app/screens/matches_screen.dart';
import 'package:pawkar_app/screens/settings_screen.dart';
import 'package:pawkar_app/widgets/categorias_section.dart';
import 'package:pawkar_app/widgets/eventos_destacados_section.dart';
import 'package:pawkar_app/widgets/proximos_eventos_section.dart';
import 'package:pawkar_app/widgets/proximos_encuentros_section.dart';
import 'package:pawkar_app/widgets/collapsible_app_bar.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
      _animationController.forward();
    });
    
    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    try {
      await Future.wait([_initializeServices(), _loadData()]);
    } catch (e) {
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
    // Initialize services here
  }

  Future<void> _loadData() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> _handleRefresh() async {
    try {
      setState(() => _isLoading = true);
      await Future.wait([_initializeServices(), _loadData()]);
    } catch (e) {
      debugPrint('Error during refresh: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error al actualizar los datos'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      );
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        color: colorScheme.primary,
        backgroundColor: colorScheme.surface,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CollapsibleAppBar(
              title: 'PAWKAR RAYMI 2026',
              subtitle: 'Encuentra los mejores eventos',
              greeting: 'PAWKAR APP',
              expandedHeight: 250.0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
              ],
              bottom: Container(
                margin: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar eventos, categorías...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    prefixIcon: const Icon(
                      Iconsax.search_normal,
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildSection(
                          context,
                          title: 'Explorar Categorías',
                          showAction: true,
                          onAction: () {
                            // Navigate to categories screen
                          },
                          child: const CategoriasSection(),
                        )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: 0.1, end: 0),
                    _buildSection(
                          context,
                          title: 'Próximos Encuentros',
                          showAction: true,
                          onAction: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MatchesScreen(initialMatches: []),
                              ),
                            );
                          },
                          child: const ProximosEncuentrosSection(),
                        )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: 0.1, end: 0),
                    _buildSection(
                          context,
                          title: 'Eventos Destacados',
                          showAction: true,
                          onAction: () {
                            // Navigate to featured events
                          },
                          child: const EventosDestacadosSection(),
                        )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: 0.1, end: 0),
                    _buildSection(
                          context,
                          title: 'Próximos Eventos',
                          showAction: true,
                          onAction: () {
                            // Navigate to events screen
                          },
                          child: const ProximosEventosSection(),
                        )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 80), // Space for bottom navigation
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
    bool showAction = false,
    VoidCallback? onAction,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                if (showAction)
                  TextButton(
                    onPressed: onAction,
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Ver todo'),
                  ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return const SizedBox.shrink();
  }

}
