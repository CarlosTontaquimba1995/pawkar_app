import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawkar_app/models/subcategoria_model.dart';
import 'package:pawkar_app/services/encuentro_service.dart';
import 'package:pawkar_app/screens/matches_screen.dart';
import 'package:provider/provider.dart';
import 'package:pawkar_app/features/home/widgets/categories_section.dart';
import 'package:pawkar_app/features/home/widgets/featured_subcategories_section.dart';
import 'package:pawkar_app/features/home/widgets/matches_section.dart';
import 'package:pawkar_app/features/home/widgets/upcoming_events_section.dart';
import 'package:pawkar_app/models/encuentro_model.dart';
import 'package:pawkar_app/models/categoria_model.dart';
import 'package:pawkar_app/screens/settings_screen.dart';
import 'package:pawkar_app/services/categoria_service.dart';
import 'package:pawkar_app/services/subcategoria_service.dart';
import 'package:pawkar_app/providers/network_state_provider.dart';
import 'package:pawkar_app/widgets/collapsible_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final CategoriaService _categoriaService;
  late final SubcategoriaService _subcategoriaService;
  late final EncuentroService _encuentroService;
  late final NetworkListStateProvider<Subcategoria>
  _featuredSubcategoriesProvider;
  late final NetworkListStateProvider<Encuentro> _matchesProvider;
  late final NetworkListStateProvider<Encuentro> _upcomingEventsProvider;
  late final NetworkListStateProvider<Categoria> _categoriesProvider;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _loadData();
  }

  void _initializeServices() {
    _categoriaService = CategoriaService();
    _subcategoriaService = SubcategoriaService();
    _encuentroService = EncuentroService();
    _featuredSubcategoriesProvider = NetworkListStateProvider<Subcategoria>();
    _matchesProvider = NetworkListStateProvider<Encuentro>();
    _upcomingEventsProvider = NetworkListStateProvider<Encuentro>();
    _categoriesProvider = NetworkListStateProvider<Categoria>();
  }

  Future<void> _loadData() async {
    // Load categories
    _categoriesProvider.executeAsync(
      () => _categoriaService.getCategorias(),
      onError: (error) {
        if (mounted) {
          debugPrint('Error loading categories: $error');
        }
      },
    );

    // Load featured subcategories from DEPORTES category
    _featuredSubcategoriesProvider.executeAsync(
      () async {
        try {
          final categoria = await _categoriaService.getCategoriaByNemonico(
            'DEPORTES',
          );
          return _subcategoriaService.getSubcategoriasByCategoria(
            categoria.categoriaId,
          );
        } catch (e) {
          debugPrint('Error loading featured subcategories: $e');
          rethrow;
        }
      },
      onError: (error) {
        if (mounted) {
          debugPrint('Error loading featured subcategories: $error');
        }
      },
    );

    // Load upcoming encuentros
    _upcomingEventsProvider.executeAsync(
      () async {
        final params = EncuentroSearchParams();
        final result = await _encuentroService.searchEncuentrosByQuery(
          params,
          page: 0,
          size: 5, // Get 5 encuentros
        );
        return result.content;
      },
      onError: (error) {
        if (mounted) {
          debugPrint('Error loading upcoming encuentros: $error');
        }
      },
    );

    // Load matches (using the same endpoint with different parameters if needed)
    _matchesProvider.executeAsync(
      () async {
        final params = EncuentroSearchParams(
          estado: 'PROGRAMADO', // Only get scheduled matches
        );
        final result = await _encuentroService.searchEncuentrosByQuery(
          params,
          page: 0,
          size: 5, // Get 5 matches
        );
        return result.content;
      },
      onError: (error) {
        if (mounted) {
          debugPrint('Error loading matches: $error');
        }
      },
    );
  }

  // Show subcategories in a bottom sheet
  void _showSubcategories(
    BuildContext context,
    String categoryName,
    List<Subcategoria>? subcategories,
  ) {
    if (subcategories == null || subcategories.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay subcategorías disponibles')),
        );
      }
      return;
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
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
          child: Column(
            children: [
              // Header with drag handle and title
              Column(
                children: [
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withAlpha(102),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Text(
                          categoryName,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: colorScheme.onSurface.withAlpha(31),
                    indent: 0,
                    endIndent: 0,
                  ),
                ],
              ),
              
              // Subcategories list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: subcategories.length,
                  itemBuilder: (context, index) {
                    final subcategory = subcategories[index];
                    return _buildSubcategoryItem(context, subcategory);
                  },
                ),
              ),
              
              // Bottom padding
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubcategoryItem(BuildContext context, Subcategoria subcategory) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            _handleSubcategorySelection(subcategory);
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: colorScheme.onSurface.withAlpha(31),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(31),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(subcategory.nombre),
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    subcategory.nombre,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurface.withAlpha(153),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    if (categoryName.toLowerCase().contains('fútbol') ||
        categoryName.toLowerCase().contains('futbol')) {
      return Icons.sports_soccer;
    } else if (categoryName.toLowerCase().contains('música') ||
        categoryName.toLowerCase().contains('musica')) {
      return Icons.music_note;
    } else if (categoryName.toLowerCase().contains('arte')) {
      return Icons.palette;
    } else if (categoryName.toLowerCase().contains('gastronomía') ||
        categoryName.toLowerCase().contains('gastronomia')) {
      return Icons.restaurant;
    } else if (categoryName.toLowerCase().contains('teatro')) {
      return Icons.theater_comedy;
    } else if (categoryName.toLowerCase().contains('básquet') ||
        categoryName.toLowerCase().contains('basquet')) {
      return Icons.sports_basketball;
    } else if (categoryName.toLowerCase().contains('tenis')) {
      return Icons.sports_tennis;
    }
    return Icons.category;
  }

  void _handleSubcategorySelection(Subcategoria subcategory) {
    // Navigate to matches screen with the selected subcategory
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MatchesScreen(
            initialMatches: [],
          ), // TODO: Pass actual events for this subcategory
        ),
      );
    }
  }

  void _showThemeSelector(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NetworkListStateProvider<Categoria>>.value(
          value: _categoriesProvider,
        ),
        ChangeNotifierProvider<NetworkListStateProvider<Subcategoria>>.value(
          value: _featuredSubcategoriesProvider,
        ),
        ChangeNotifierProvider<NetworkListStateProvider<Encuentro>>.value(
          value: _matchesProvider,
        ),
        ChangeNotifierProvider<NetworkListStateProvider<Encuentro>>.value(
          value: _upcomingEventsProvider,
        ),
      ],
      child: Scaffold(
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
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        
        // Categories Section
        Consumer<NetworkListStateProvider<Categoria>>(
          builder: (context, categoriesProvider, _) {
            if (categoriesProvider.isLoading) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (categoriesProvider.isError) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        'Error al cargar las categorías',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final categories = categoriesProvider.data ?? [];
            
            return CategoriesSection(
              categories: categories,
              onCategoryTap: (category) {
                // Show subcategories when a category is tapped
                _showSubcategories(
                  context,
                  category.nombre,
                  _featuredSubcategoriesProvider.data,
                );
              },
              onViewAll: () {
                // Show all categories with subcategories
                _showSubcategories(
                  context,
                  'Todas las categorías',
                  _featuredSubcategoriesProvider.data,
                );
              },
            );
          },
        ),

        const SizedBox(height: 16),

        // Featured Subcategories Section
        Consumer<NetworkListStateProvider<Subcategoria>>(
          builder: (context, subcategoriesProvider, _) {
            if (subcategoriesProvider.isLoading) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (subcategoriesProvider.isError) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      const SizedBox(height: 8),
                      Text(
                        'Error al cargar las subcategorías',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final subcategories = subcategoriesProvider.data ?? [];
            
            return FeaturedSubcategoriesSection(
              subcategories: subcategories,
              onSubcategoryTap: (subcategory) {
                _handleSubcategorySelection(subcategory);
              },
              onViewAll: () {
                _showSubcategories(
                  context,
                  'Todas las subcategorías',
                  subcategories,
                );
              },
            );
          },
        ),

        const SizedBox(height: 24),

        // Matches Section
        Consumer<NetworkListStateProvider<Encuentro>>(
          builder: (context, matchesProvider, _) {
            if (matchesProvider.isLoading) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (matchesProvider.isError) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      const SizedBox(height: 8),
                      Text(
                        'Error al cargar los partidos',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final matches = matchesProvider.data ?? [];
            
            return MatchesSection(
              matches: matches,
              onMatchTap: (encuentro) {
                // Handle match tap - navigate to match details
                if (context.mounted) {
                  // TODO: Implement match details navigation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ver detalles de: ${encuentro.titulo}'),
                    ),
                  );
                }
              },
              onViewAll: () {
                // Navigate to all matches screen
                if (context.mounted) {
                  // TODO: Implement all matches screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ver todos los partidos')),
                  );
                }
              },
            );
          },
        ),

        const SizedBox(height: 24),

        // Upcoming Events Section
        Consumer<NetworkListStateProvider<Subcategoria>>(
          builder: (context, upcomingEventsProvider, _) {
            if (upcomingEventsProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (upcomingEventsProvider.isError) {
              return Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Error al cargar los eventos próximos',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _loadData,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            final upcomingEvents = upcomingEventsProvider.data ?? [];

            return UpcomingEventsSection(
              events: upcomingEvents,
              onEventTap: (Subcategoria subcategoria) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ver detalles de: ${subcategoria.nombre}'),
                    ),
                  );
                }
              },
              onViewAll: () {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ver todos los eventos')),
                  );
                }
              },
            );
          },
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}
