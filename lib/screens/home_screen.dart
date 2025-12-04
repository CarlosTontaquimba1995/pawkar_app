import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawkar_app/features/home/widgets/categories_section.dart';
import 'package:pawkar_app/features/home/widgets/featured_events_section.dart';
import 'package:pawkar_app/features/home/widgets/upcoming_events_section.dart';
import 'package:pawkar_app/features/home/widgets/matches_section.dart';
import 'package:pawkar_app/models/category.dart';
import 'package:pawkar_app/screens/matches_screen.dart';
import 'package:pawkar_app/screens/settings_screen.dart';
import 'package:pawkar_app/models/event.dart';
import 'package:pawkar_app/widgets/collapsible_app_bar.dart';
import 'package:pawkar_app/services/event_service.dart';
import 'package:pawkar_app/providers/network_state_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final EventService _eventService;
  late final NetworkListStateProvider<Event> _featuredEventsProvider;
  late final NetworkListStateProvider<Event> _matchesProvider;
  late final NetworkListStateProvider<Event> _upcomingEventsProvider;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _loadData();
  }

  void _initializeServices() {
    _eventService = EventService();
    _featuredEventsProvider = NetworkListStateProvider<Event>();
    _matchesProvider = NetworkListStateProvider<Event>();
    _upcomingEventsProvider = NetworkListStateProvider<Event>();
  }

  Future<void> _loadData() async {
    // Load featured events
    _featuredEventsProvider.executeAsync(
      () => _eventService.getFeaturedEvents(),
      onError: (error) {
        if (mounted) {
          debugPrint('Error loading featured events: $error');
        }
      },
    );

    // Load upcoming events
    _upcomingEventsProvider.executeAsync(
      () => _eventService.getUpcomingEvents(),
      onError: (error) {
        if (mounted) {
          debugPrint('Error loading upcoming events: $error');
        }
      },
    );

    // Load matches
    _matchesProvider.executeAsync(
      () => _eventService.getEventsByCategory('Fútbol'),
      onError: (error) {
        if (mounted) {
          debugPrint('Error loading matches: $error');
        }
      },
    );
  }

  void _showThemeSelector(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  // Sample data with subcategories
  final List<Category> _categories = [
    Category(
      id: '1',
      name: 'Música',
      icon: 'music_note',
      subcategories: [
        Category(id: '1-1', name: 'Conciertos', icon: 'mic'),
        Category(id: '1-2', name: 'Festivales', icon: 'festival'),
        Category(id: '1-3', name: 'Orquestas', icon: 'piano'),
      ],
    ),
    Category(
      id: '2',
      name: 'Deportes',
      icon: 'sports_soccer',
      subcategories: [
        Category(
          id: '2-1',
          name: 'Fútbol',
          icon: 'sports_soccer',
          subcategories: [
            Category(id: '2-1-1', name: 'Partidos', icon: 'sports_soccer'),
            Category(
              id: '2-1-2',
              name: 'Tabla de Posiciones',
              icon: 'format_list_numbered',
            ),
            Category(id: '2-1-3', name: 'Equipos', icon: 'groups'),
            Category(id: '2-1-4', name: 'Jugadores', icon: 'person'),
          ],
        ),
        Category(id: '2-2', name: 'Basket', icon: 'sports_basketball'),
        Category(id: '2-3', name: 'Ecuavóley', icon: 'sports_volleyball'),
        Category(id: '2-4', name: 'Tenis', icon: 'sports_tennis'),
      ],
    ),
    Category(
      id: '3',
      name: 'Arte',
      icon: 'palette',
      subcategories: [
        Category(id: '3-1', name: 'Pintura', icon: 'brush'),
        Category(id: '3-2', name: 'Escultura', icon: 'account_balance'),
        Category(id: '3-3', name: 'Fotografía', icon: 'camera_alt'),
      ],
    ),
    Category(
      id: '4',
      name: 'Gastronomía',
      icon: 'restaurant',
      subcategories: [
        Category(id: '4-1', name: 'Comida Típica', icon: 'rice_bowl'),
        Category(id: '4-2', name: 'Postres', icon: 'cake'),
        Category(id: '4-3', name: 'Bebidas', icon: 'local_bar'),
      ],
    ),
    Category(
      id: '5',
      name: 'Teatro',
      icon: 'theater_comedy',
      subcategories: [
        Category(id: '5-1', name: 'Obras de Teatro', icon: 'theater_comedy'),
        Category(id: '5-2', name: 'Stand Up', icon: 'mic'),
        Category(id: '5-3', name: 'Monólogos', icon: 'record_voice_over'),
      ],
    ),
  ];

  // Show subcategories in a bottom sheet
  void _showSubcategories(BuildContext context, Category category) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Calculate initial size based on number of items
    // Each item is approximately 72px height
    final itemCount = category.subcategories.length;
    final headerHeight = 120.0; // Header with drag handle and title
    final itemHeight = 72.0; // Height per item
    final paddingHeight = 32.0; // Top and bottom padding
    final totalHeight = headerHeight + (itemCount * itemHeight) + paddingHeight;

    final screenHeight = MediaQuery.of(context).size.height;

    // If content fits in 90% of screen, use exact size; otherwise use 90% and make scrollable
    final initialSize = itemCount <= 3
        ? (totalHeight / screenHeight).clamp(0.4, 0.9)
        : 0.9;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: initialSize,
        minChildSize: 0.35,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(77),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              // Header with drag handle
              SliverAppBar(
                pinned: true,
                floating: true,
                elevation: 0,
                backgroundColor: theme.scaffoldBackgroundColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                title: Text(
                  category.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                centerTitle: false,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 48,
                          height: 5,
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withAlpha(102),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(16),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: colorScheme.onSurface.withAlpha(31),
                    indent: 0,
                    endIndent: 0,
                  ),
                ),
              ),

              // Subcategories list
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                sliver: SliverList.builder(
                  itemCount: category.subcategories.length,
                  itemBuilder: (context, index) {
                    final subcategory = category.subcategories[index];
                    final hasSubcategories =
                        subcategory.subcategories.isNotEmpty;

                    return _SubcategoryListItem(
                      subcategory: subcategory,
                      index: index,
                      hasSubcategories: hasSubcategories,
                      onTap: () {
                        if (hasSubcategories) {
                          Navigator.pop(context);
                          _showSubcategories(context, subcategory);
                        } else {
                          Navigator.pop(context);
                          _handleSubcategorySelection(subcategory);
                        }
                      },
                    );
                  },
                ),
              ),

              // Bottom spacing
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 24),
                sliver: SliverToBoxAdapter(child: Container()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubcategorySelection(Category subcategory) {
    // Si la subcategoría es "Partidos", navegar a la pantalla de partidos
    if (subcategory.name.toLowerCase() == 'partidos') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MatchesScreen(
            initialMatches: [
              Event(
                id: 'm1',
                title: 'Barcelona vs Emelec',
                description: 'Partido de la Liga Pro',
                dateTime: DateTime.now().add(
                  const Duration(days: 1, hours: 20),
                ),
                location: 'Estadio Monumental',
                category: 'Fútbol',
                isFeatured: true,
                price: 15.00,
                imageUrl: 'assets/images/futbol.jpg',
              ),
              Event(
                id: 'm2',
                title: 'Liga de Quito vs Independiente',
                description: 'Partido de la Liga Pro',
                dateTime: DateTime.now().add(
                  const Duration(days: 2, hours: 18),
                ),
                location: 'Estadio Rodrigo Paz',
                category: 'Fútbol',
                isFeatured: true,
                price: 12.00,
                imageUrl: 'assets/images/futbol.jpg',
              ),
              Event(
                id: 'm3',
                title: 'Aucas vs Orense',
                description: 'Partido de la Liga Pro',
                dateTime: DateTime.now().add(
                  const Duration(days: 3, hours: 19),
                ),
                location: 'Estadio Gonzalo Pozo Ripalda',
                category: 'Fútbol',
                isFeatured: true,
                price: 10.00,
                imageUrl: 'assets/images/futbol.jpg',
              ),
            ],
          ),
        ),
      );
    } else {
      // Para otras subcategorías, mostrar un mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Seleccionado: ${subcategory.name}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: CustomScrollView(
          slivers: [
            CollapsibleAppBar(
              title: 'PAWKAR',
              subtitle: 'Festival Cultural y Deportivo',
              greeting: 'Bienvenido a',
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: IconButton(
                    icon: Icon(Icons.settings, color: Colors.white, size: 24),
                    onPressed: () => _showThemeSelector(context),
                    tooltip: 'Settings',
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
        const SizedBox(height: 8), // Add some space below the sticky search bar
        // Categories Section
        CategoriesSection(
          categories: _categories,
          onCategoryTap: (category) {
            _showSubcategories(context, category);
          },
          onViewAll: () {
            // Show all categories with subcategories
            _showSubcategories(
              context,
              Category(
                id: 'all',
                name: 'Todas las categorías',
                icon: 'category',
                subcategories: _categories,
              ),
            );
          },
        ),

        // Featured Events Section
        FeaturedEventsSection(
          events: [
            Event(
              id: '1',
              title: 'Torneo de Fútbol',
              description: 'Encuentros de fútbol profesional',
              dateTime: DateTime.now().add(const Duration(days: 2)),
              location: 'Estadio Olímpico',
              category: 'Fútbol',
              isFeatured: true,
              price: 12.00,
              imageUrl: 'assets/images/futbol.jpg',
            ),
            Event(
              id: '2',
              title: 'Liga de Baloncesto',
              description: 'Partidos de la liga nacional de baloncesto',
              dateTime: DateTime.now().add(const Duration(days: 4)),
              location: 'Coliseo General Rumiñahui',
              category: 'Baloncesto',
              isFeatured: true,
              price: 10.00,
              imageUrl: 'assets/images/basketball.jpg',
            ),
            Event(
              id: '3',
              title: 'Campeonato de Ecuavóley',
              description: 'Torneo nacional de ecuavóley',
              dateTime: DateTime.now().add(const Duration(days: 3)),
              location: 'Parque La Carolina',
              category: 'Ecuavóley',
              isFeatured: true,
              price: 8.00,
              imageUrl: 'assets/images/volleyball.jpg',
            ),
          ],
          onEventTap: (event) {
            // Find the category by name
            Category? findCategoryByName(
              String name,
              List<Category> categories,
            ) {
              for (var category in categories) {
                if (category.name.toLowerCase() == name.toLowerCase()) {
                  return category;
                }
                if (category.subcategories.isNotEmpty) {
                  final found = findCategoryByName(
                    name,
                    category.subcategories,
                  );
                  if (found != null) return found;
                }
              }
              return null;
            }

            final category = findCategoryByName(event.category, _categories);

            if (category != null && context.mounted) {
              if (category.subcategories.isNotEmpty) {
                // If category has subcategories, show them
                _showSubcategories(context, category);
              } else {
                // If it's a subcategory, navigate to matches screen
                // Get sample matches for this category
                final sampleMatches = [
                  Event(
                    id: 'm1',
                    title: '${category.name} Match 1',
                    description: 'Sample match in ${category.name} category',
                    dateTime: DateTime.now().add(const Duration(days: 1)),
                    location: 'Stadium',
                    category: category.name,
                    isFeatured: true,
                  ),
                  Event(
                    id: 'm2',
                    title: '${category.name} Match 2',
                    description: 'Another match in ${category.name} category',
                    dateTime: DateTime.now().add(const Duration(days: 2)),
                    location: 'Arena',
                    category: category.name,
                    isFeatured: true,
                  ),
                ];

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MatchesScreen(initialMatches: sampleMatches),
                  ),
                );
              }
            }
          },
          onViewAll: () {
            // Navigate to all featured events
          },
        ),

        // Matches Section
        MatchesSection(
          matches: [
            Event(
              id: 'm1',
              title: 'Barcelona vs Emelec',
              description: 'Partido de la Liga Pro',
              dateTime: DateTime.now().add(const Duration(days: 1, hours: 20)),
              location: 'Estadio Monumental',
              category: 'Fútbol',
              isFeatured: true,
              price: 15.00,
              imageUrl: 'assets/images/futbol.jpg',
            ),
            Event(
              id: 'm2',
              title: 'Liga de Quito vs Independiente',
              description: 'Partido de la Liga Pro',
              dateTime: DateTime.now().add(const Duration(days: 2, hours: 18)),
              location: 'Estadio Rodrigo Paz',
              category: 'Fútbol',
              isFeatured: true,
              price: 12.00,
              imageUrl: 'assets/images/futbol.jpg',
            ),
            Event(
              id: 'm3',
              title: 'Aucas vs Orense',
              description: 'Partido de la Liga Pro',
              dateTime: DateTime.now().add(const Duration(days: 3, hours: 19)),
              location: 'Estadio Gonzalo Pozo Ripalda',
              category: 'Fútbol',
              isFeatured: true,
              price: 10.00,
              imageUrl: 'assets/images/futbol.jpg',
            ),
          ],
          onMatchTap: (match) {
            // Navegar al detalle del partido
          },
          onViewAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MatchesScreen(
                  initialMatches: [
                    Event(
                      id: 'm1',
                      title: 'Barcelona vs Emelec',
                      description: 'Partido de la Liga Pro',
                      dateTime: DateTime.now().add(
                        const Duration(days: 1, hours: 20),
                      ),
                      location: 'Estadio Monumental',
                      category: 'Fútbol',
                      isFeatured: true,
                      price: 15.00,
                      imageUrl: 'assets/images/futbol.jpg',
                    ),
                    Event(
                      id: 'm2',
                      title: 'Liga de Quito vs Independiente',
                      description: 'Partido de la Liga Pro',
                      dateTime: DateTime.now().add(
                        const Duration(days: 2, hours: 18),
                      ),
                      location: 'Estadio Rodrigo Paz',
                      category: 'Fútbol',
                      isFeatured: true,
                      price: 12.00,
                      imageUrl: 'assets/images/futbol.jpg',
                    ),
                    Event(
                      id: 'm3',
                      title: 'Aucas vs Orense',
                      description: 'Partido de la Liga Pro',
                      dateTime: DateTime.now().add(
                        const Duration(days: 3, hours: 19),
                      ),
                      location: 'Estadio Gonzalo Pozo Ripalda',
                      category: 'Fútbol',
                      isFeatured: true,
                      price: 10.00,
                      imageUrl: 'assets/images/futbol.jpg',
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // Upcoming Events Section
        UpcomingEventsSection(
          events: [
            Event(
              id: '1',
              title: 'Concierto de Música Andina',
              description: 'Disfruta de lo mejor de la música andina en vivo',
              dateTime: DateTime.now().add(const Duration(days: 3)),
              location: 'Teatro Nacional',
              category: 'Conciertos',
              isFeatured: true,
              price: 25.00,
              imageUrl: 'assets/images/concierto.jpg',
            ),
            Event(
              id: '2',
              title: 'Festival de Jazz',
              description:
                  'Los mejores artistas de jazz nacional e internacional',
              dateTime: DateTime.now().add(const Duration(days: 7)),
              location: 'Casa de la Música',
              category: 'Conciertos',
              isFeatured: true,
              price: 30.00,
              imageUrl: 'assets/images/jazz.jpg',
            ),
            Event(
              id: '3',
              title: 'Noche de Ópera',
              description: 'Obras clásicas de la ópera internacional',
              dateTime: DateTime.now().add(const Duration(days: 5)),
              location: 'Teatro Sucre',
              category: 'Conciertos',
              isFeatured: true,
              price: 35.00,
              imageUrl: 'assets/images/opera.jpg',
            ),
            Event(
              id: '4',
              title: 'Rock en la Plaza',
              description: 'Las mejores bandas de rock nacional',
              dateTime: DateTime.now().add(const Duration(days: 10)),
              location: 'Plaza Grande',
              category: 'Conciertos',
              isFeatured: true,
              price: 20.00,
              imageUrl: 'assets/images/rock.jpg',
            ),
            Event(
              id: '5',
              title: 'Festival de Música Electrónica',
              description: 'DJs internacionales en un evento imperdible',
              dateTime: DateTime.now().add(const Duration(days: 12)),
              location: 'Centro de Convenciones',
              category: 'Conciertos',
              isFeatured: true,
              price: 40.00,
              imageUrl: 'assets/images/electronica.jpg',
            ),
            Event(
              id: '6',
              title: 'Concierto Sinfónico',
              description:
                  'La orquesta sinfónica nacional en un repertorio clásico',
              dateTime: DateTime.now().add(const Duration(days: 8)),
              location: 'Teatro Bolívar',
              category: 'Conciertos',
              isFeatured: true,
              price: 30.00,
              imageUrl: 'assets/images/sinfonico.jpg',
            ),
          ],
          onEventTap: (event) {
            // Navigate to event details
          },
        ),
      ],
    );
  }
}

class _SubcategoryListItem extends StatefulWidget {
  final Category subcategory;
  final int index;
  final bool hasSubcategories;
  final VoidCallback onTap;

  const _SubcategoryListItem({
    required this.subcategory,
    required this.index,
    required this.hasSubcategories,
    required this.onTap,
  });

  @override
  State<_SubcategoryListItem> createState() => _SubcategoryListItemState();
}

class _SubcategoryListItemState extends State<_SubcategoryListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500 + (widget.index * 50)),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Opacity(
        opacity: _opacityAnimation.value,
        child: Transform.scale(scale: _scaleAnimation.value, child: child),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: _isHovered
                    ? colorScheme.primary.withAlpha(26)
                    : colorScheme.surfaceTint.withAlpha(20),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _isHovered
                      ? colorScheme.primary.withAlpha(77)
                      : colorScheme.onSurface.withAlpha(31),
                  width: _isHovered ? 1.5 : 1,
                ),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: colorScheme.primary.withAlpha(26),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? colorScheme.primary.withAlpha(77)
                          : colorScheme.primary.withAlpha(31),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AnimatedScale(
                      scale: _isHovered ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: Icon(
                        _getCategoryIcon(widget.subcategory.icon),
                        color: _isHovered
                            ? colorScheme.onPrimary
                            : colorScheme.primary,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.subcategory.name,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: _isHovered
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: _isHovered
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.hasSubcategories) ...[
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: _isHovered ? 0.25 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.chevron_right,
                        color: colorScheme.onSurface.withAlpha(153),
                        size: 24,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'music_note':
        return Icons.music_note;
      case 'palette':
        return Icons.palette;
      case 'restaurant':
        return Icons.restaurant;
      case 'theater_comedy':
        return Icons.theater_comedy;
      default:
        return Icons.category;
    }
  }
}
