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
import 'package:pawkar_app/widgets/custom_card.dart';
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(51),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: theme.dividerColor.withAlpha(128),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                category.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),

            // Divider
            Divider(
              height: 1,
              thickness: 1,
              color: theme.dividerColor.withAlpha(128),
              indent: 24,
              endIndent: 24,
            ),

            // Subcategories list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                itemCount: category.subcategories.length,
                itemBuilder: (context, index) {
                  final subcategory = category.subcategories[index];
                  final hasSubcategories = subcategory.subcategories.isNotEmpty;

                  return CustomCard(
                    glass: false,
                    onTap: () {
                      if (hasSubcategories) {
                        _showSubcategories(context, subcategory);
                      } else {
                        Navigator.pop(context);
                        _handleSubcategorySelection(subcategory);
                      }
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withAlpha(31),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _getCategoryIcon(subcategory.icon),
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      title: Text(
                        subcategory.name,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: hasSubcategories
                          ? Icon(
                              Icons.chevron_right,
                              color: theme.colorScheme.onSurface.withAlpha(153),
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),

            // Bottom padding for better scrolling on some devices
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
          ],
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
