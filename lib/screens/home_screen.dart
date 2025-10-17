import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// Custom color palette
const Color primaryColor = Color(0xFF473587); // Deep Purple
const Color secondaryColor = Color(0xFF5C7EBE); // Blue
const Color accentColor = Color(0xFFECE63E); // Yellow
const Color highlightColor = Color(0xFFC83F74); // Pink
const Color tealColor = Color(0xFF83BDBC); // Teal

// Theme colors
const Color backgroundColor = Color(0xFFF9FAFB);
const Color surfaceColor = Color(0xFFFFFFFF);
const Color errorColor = Color(0xFFEF4444);
const Color onPrimaryColor = Colors.white;
const Color onSecondaryColor = Colors.white;
const Color onBackgroundColor = Color(0xFF1F2937);
const Color onSurfaceColor = Color(0xFF1F2937);
const Color onErrorColor = Colors.white;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _appBarController;
  late Animation<double> _appBarAnimation;
  late ScrollController _scrollController;
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _appBarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _appBarAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _appBarController, curve: Curves.easeInOut),
    );
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse &&
        !_showAppBarTitle) {
      setState(() => _showAppBarTitle = true);
      _appBarController.forward();
    } else if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward &&
        _showAppBarTitle) {
      setState(() => _showAppBarTitle = false);
      _appBarController.reverse();
    }
  }

  @override
  void dispose() {
    // Dispose animation controllers
    _appBarController.dispose();

    // Clean up scroll controller
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    // Call super dispose last
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar with Collapsing Effect
            SliverAppBar.large(
              expandedHeight: size.height * 0.3,
              floating: false,
              pinned: true,
              backgroundColor: theme.colorScheme.primary,
              elevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              title: AnimatedOpacity(
                opacity: _showAppBarTitle ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  'PAWKAR APP',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  final double expandedHeight = constraints.biggest.height;
                  final double visibleMainHeight = size.height * 0.3;
                  final double scrolledPercentage =
                      1.0 -
                      ((expandedHeight - kToolbarHeight) /
                          (visibleMainHeight - kToolbarHeight));

                  return FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor, secondaryColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 16.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FadeTransition(
                                opacity: Tween<double>(begin: 1.0, end: 0.0)
                                    .animate(
                                      CurvedAnimation(
                                        parent: _appBarController,
                                        curve: const Interval(
                                          0.0,
                                          0.5,
                                          curve: Curves.easeInOut,
                                        ),
                                      ),
                                    ),
                                child: Text(
                                  'Bienvenido a',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              FadeTransition(
                                opacity: Tween<double>(begin: 1.0, end: 0.0)
                                    .animate(
                                      CurvedAnimation(
                                        parent: _appBarController,
                                        curve: const Interval(
                                          0.0,
                                          0.5,
                                          curve: Curves.easeInOut,
                                        ),
                                      ),
                                    ),
                                child: Text(
                                  'PAWKAR 2025',
                                  style: theme.textTheme.displaySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              FadeTransition(
                                opacity: Tween<double>(begin: 1.0, end: 0.0)
                                    .animate(
                                      CurvedAnimation(
                                        parent: _appBarController,
                                        curve: const Interval(
                                          0.0,
                                          0.5,
                                          curve: Curves.easeInOut,
                                        ),
                                      ),
                                    ),
                                child: Text(
                                  'Festival Cultural y Deportivo',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Main Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Actions Section
                    _buildSectionHeader(
                      context,
                      title: 'Acciones Rápidas',
                      subtitle:
                          'Accede rápidamente a las secciones principales',
                    ),
                    const SizedBox(height: 16),
                    _buildQuickActionsGrid(context),

                    const SizedBox(height: 32),

                    // Events Section
                    _buildSectionHeader(
                      context,
                      title: 'Eventos Destacados',
                      subtitle: 'Descubre los eventos principales del festival',
                    ),
                    const SizedBox(height: 16),
                    _buildHorizontalScrollSection(
                      context,
                      items: [
                        _CategoryItem(
                          title: 'Runa Kay',
                          subtitle: 'Tradición y cultura',
                          icon: Icons.celebration,
                          color: primaryColor,
                        ),
                        _CategoryItem(
                          title: 'Noche Internacional',
                          subtitle: 'Música y danza',
                          icon: Icons.nights_stay,
                          color: highlightColor,
                        ),
                        _CategoryItem(
                          title: 'Urbano Pakkar',
                          subtitle: 'Arte urbano',
                          icon: Icons.location_city,
                          color: accentColor,
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Sports Section
                    _buildSectionHeader(
                      context,
                      title: 'Deportes',
                      subtitle: 'Sigue tus deportes favoritos',
                    ),
                    const SizedBox(height: 16),
                    _buildHorizontalScrollSection(
                      context,
                      items: [
                        _CategoryItem(
                          title: 'Fútbol',
                          subtitle: 'Torneo local',
                          icon: Icons.sports_soccer,
                          color: tealColor,
                          image: 'assets/images/futbol.jpg',
                        ),
                        _CategoryItem(
                          title: 'Baloncesto',
                          subtitle: '3x3 y 5x5',
                          icon: Icons.sports_basketball,
                          color: secondaryColor,
                          image: 'assets/images/basketball.jpg',
                        ),
                        _CategoryItem(
                          title: 'Ecuavóley',
                          subtitle: 'Tradicional',
                          icon: Icons.sports_volleyball,
                          color: highlightColor,
                          image: 'assets/images/volleyball.jpg',
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Gastronomy Section
                    _buildSectionHeader(
                      context,
                      title: 'Gastronomía',
                      subtitle: 'Sabores tradicionales',
                    ),
                    const SizedBox(height: 16),
                    _buildHorizontalScrollSection(
                      context,
                      items: [
                        _CategoryItem(
                          title: 'Platos Típicos',
                          subtitle: 'Sabores locales',
                          icon: Icons.restaurant,
                          color: primaryColor,
                          image: 'assets/images/comida_tipica.jpg',
                        ),
                      ],
                    ),

                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showSearchBottomSheet,
          icon: const Icon(
            Icons.search,
            color: Color.fromARGB(221, 255, 255, 255),
          ),
          label: const Text(
            'Buscar',
            style: TextStyle(
              color: Color.fromARGB(221, 255, 255, 255),
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: primaryColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    String? subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: onBackgroundColor,
            letterSpacing: -0.5,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: onBackgroundColor.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        const SizedBox(height: 8),
        Container(
          width: 48,
          height: 4,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    final quickActions = [
      _QuickActionItem(
        title: 'Agenda',
        icon: Icons.calendar_today_rounded,
        color: primaryColor,
      ),
      _QuickActionItem(
        title: 'Mapa',
        icon: Icons.map_rounded,
        color: secondaryColor,
      ),
      _QuickActionItem(
        title: 'Favoritos',
        icon: Icons.favorite_border_rounded,
        color: highlightColor,
      ),
      _QuickActionItem(
        title: 'Más',
        icon: Icons.more_horiz_rounded,
        color: tealColor,
      ),
    ];

    return SizedBox(
      height: 90, // Reduced height to prevent overflow
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: quickActions.length,
        itemBuilder: (context, index) {
          final action = quickActions[index];
          return _buildQuickActionCard(context, action);
        },
      ),
    );
  }

  Widget _buildQuickActionCard(BuildContext context, _QuickActionItem action) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToCategory(context, action.title),
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 72, // Slightly reduced width
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44, // Slightly smaller icon container
                  height: 44,
                  decoration: BoxDecoration(
                    color: action.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    action.icon,
                    color: action.color,
                    size: 20, // Slightly smaller icon
                  ),
                ),
                const SizedBox(height: 4), // Reduced spacing
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    action.title,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: onSurfaceColor.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                      fontSize: 10, // Smaller font size
                      height: 1.2, // Tighter line height
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2, // Allow text to wrap to second line
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalScrollSection(
    BuildContext context, {
    required List<_CategoryItem> items,
  }) {
    return _HorizontalScrollSection(
      items: items,
      onBuildCard: (context, item) => _buildEventCard(context, item),
    );
  }

  Widget _buildEventCard(BuildContext context, _CategoryItem item) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (value * 0.05),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _navigateToCategory(context, item.title),
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Imagen o color de fondo
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: item.color.withOpacity(0.1),
                    image: item.image != null
                        ? DecorationImage(
                            image: AssetImage(item.image!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),

                // Degradado superior - Mejor legibilidad del texto
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(
                          0.2,
                        ), // Más claro en la parte superior
                        Colors.black.withOpacity(
                          0.7,
                        ), // Más oscuro en la parte inferior
                      ],
                      stops: const [
                        0.3,
                        1.0,
                      ], // Comienza el degradado más abajo
                    ),
                  ),
                ),
                // Capa adicional para mejor contraste del texto
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                      ],
                      stops: const [0.1, 1.0],
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Badge
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: item.color.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: item.color.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 12,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'PRÓXIMO EVENTO',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                        fontSize: 10,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Title and Subtitle
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (item.subtitle != null) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  _getIconForCategory(item.title),
                                  size: 16,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    item.subtitle!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.white.withOpacity(0.9),
                                          height: 1.3,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),

                      // Bottom Row
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Ver más',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                        mainAxisSize: MainAxisSize.min,
                      ),
                    ],
                  ),
                ),

                // Border highlight
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: item.color.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Fútbol':
        return Icons.sports_soccer;
      case 'Baloncesto':
        return Icons.sports_basketball;
      case 'Ecuavóley':
        return Icons.sports_volleyball;
      case 'Atletismo':
        return Icons.directions_run;
      case 'Platos Típicos':
        return Icons.restaurant;
      case 'Postres':
        return Icons.cake;
      case 'Bebidas':
        return Icons.local_drink;
      default:
        return Icons.event;
    }
  }

  Widget _buildCategorySection(
    BuildContext context, {
    required List<_CategoryItem> items,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildCategoryCard(context, item: item);
      },
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required _CategoryItem item,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToCategory(context, item.title),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                item.color.withOpacity(0.1),
                item.color.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Icon(item.icon, color: item.color),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (item.subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  item.subtitle!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGastronomyCard(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToCategory(context, 'Gastronomía'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.brown[50]!, Colors.brown[100]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.brown[700]!.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.restaurant,
                  size: 32,
                  color: Colors.brown[700],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comida Típica',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Descubre los sabores tradicionales de nuestra región',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.brown),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCategory(BuildContext context, String category) {
    // TODO: Implement navigation to specific category
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navegando a: $category'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showSearchBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 8.0,
              ),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Buscar eventos, deportes, comida...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceVariant,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Búsquedas recientes',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Add recent searches here
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _HorizontalScrollSection extends StatefulWidget {
  final List<_CategoryItem> items;
  final Widget Function(BuildContext, _CategoryItem) onBuildCard;

  const _HorizontalScrollSection({
    Key? key,
    required this.items,
    required this.onBuildCard,
  }) : super(key: key);

  @override
  _HorizontalScrollSectionState createState() =>
      _HorizontalScrollSectionState();
}

class _HorizontalScrollSectionState extends State<_HorizontalScrollSection> {
  late final PageController _pageController;
  late final ValueNotifier<int> _currentPage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _currentPage = ValueNotifier<int>(0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Carousel with PageView
        SizedBox(
          height: 240,
          child: NotificationListener<ScrollUpdateNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification) {
                final page = _pageController.page?.round() ?? 0;
                _currentPage.value = page;
              }
              return false;
            },
            child: Stack(
              children: [
                // Main PageView
                PageView.builder(
                  controller: _pageController,
                  itemCount: widget.items.length,
                  onPageChanged: (index) {
                    _currentPage.value = index;
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 16.0,
                      ),
                      child: widget.onBuildCard(context, widget.items[index]),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // Page indicators removed as per request
      ],
    );
  }
}

class _CategoryItem {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final String? routeName;
  final String? image;

  const _CategoryItem({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.color,
    this.routeName,
    this.image,
  });
}

class _QuickActionItem {
  final String title;
  final IconData icon;
  final Color color;

  const _QuickActionItem({
    required this.title,
    required this.icon,
    required this.color,
  });
}
