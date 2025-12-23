import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawkar_app/screens/matches_screen.dart';
import 'package:pawkar_app/screens/settings_screen.dart';
import 'package:pawkar_app/widgets/categorias_section.dart';
import 'package:pawkar_app/widgets/eventos_destacados_section.dart';
import 'package:pawkar_app/widgets/proximos_eventos_section.dart';
import 'package:pawkar_app/widgets/proximos_encuentros_section.dart';
import 'package:pawkar_app/widgets/collapsible_app_bar.dart';
import 'package:pawkar_app/widgets/skeleton_loader.dart';
import 'package:google_fonts/google_fonts.dart';

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

  Widget _buildSkeletonLoader(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          // AppBar skeleton
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: theme.colorScheme.primary,
                padding: const EdgeInsets.only(
                  top: 100,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SkeletonLoader(width: 200, height: 28, borderRadius: 4),
                        const SizedBox(height: 8),
                        SkeletonLoader(width: 180, height: 20, borderRadius: 4),
                        const Spacer(),
                        // Search bar skeleton
                        SkeletonLoader(
                          width: double.infinity,
                          height: 50,
                          borderRadius: 16,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          // Content skeleton
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Categories section
                _buildSectionSkeleton(context, 'Categorías', 120, 4),
                const SizedBox(height: 16),

                // Eventos destacados section
                _buildSectionSkeleton(context, 'Eventos Destacados', 180, 1),
                const SizedBox(height: 16),

                // Próximos eventos section
                _buildSectionSkeleton(context, 'Próximos Eventos', 200, 1),
                const SizedBox(height: 16),

                // Próximos encuentros section
                _buildSectionSkeleton(context, 'Próximos Encuentros', 150, 1),
                const SizedBox(height: 8), // Added bottom padding
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionSkeleton(
    BuildContext context,
    String title,
    double height,
    int itemCount,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLoader(width: 180, height: 24, borderRadius: 4),
                SkeletonLoader(width: 60, height: 16, borderRadius: 4),
              ],
            ),
          ),
          SizedBox(
            height: height,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                return Container(
                  width: 180,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLoader(
                        width: double.infinity,
                        height:
                            height -
                            44, // Reduced to account for text and spacing
                        borderRadius: 12,
                      ),
                      const SizedBox(height: 6),
                      SkeletonLoader(width: 120, height: 14, borderRadius: 4),
                      const SizedBox(height: 2),
                      SkeletonLoader(width: 80, height: 12, borderRadius: 4),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
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
      return _buildSkeletonLoader(context);
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
                margin: const EdgeInsets.only(bottom: 16, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar eventos, categorías...',
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        Iconsax.search_normal,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    isDense: true,
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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
                          showAction: false,
                      icon: Iconsax.category,
                      iconColor: const Color(0xFF8E44AD), // Purple
                          child: const CategoriasSection(),
                    ),
                    _buildSection(
                          context,
                          title: 'Próximos Encuentros',
                          showAction: true,
                      icon: Iconsax.calendar_1,
                      iconColor: const Color(0xFFE74C3C), // Red
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
                    ),
                    _buildSection(
                          context,
                          title: 'Eventos Destacados',
                          showAction: false,
                      icon: Iconsax.star,
                      iconColor: const Color(0xFFF39C12), // Orange
                          child: const EventosDestacadosSection(),
                    ),
                    _buildSection(
                          context,
                          title: 'Próximos Eventos',
                          showAction: false,
                      icon: Iconsax.calendar_tick,
                      iconColor: const Color(0xFF3498DB), // Blue
                          child: const ProximosEventosSection(),
                    ),
                    const SizedBox(height: 20), // Reduced bottom space
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
    bool showAction = false,
    VoidCallback? onAction,
    IconData? icon,
    Color? iconColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: iconColor ?? colorScheme.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                if (showAction)
                  TextButton(
                    onPressed: onAction,
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Ver todo',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }

}
