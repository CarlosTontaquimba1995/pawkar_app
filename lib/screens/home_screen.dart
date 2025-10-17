import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/collapsible_app_bar.dart';
import '../widgets/horizontal_scroll_section.dart';
import '../models/event.dart';
import '../models/category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Sample data - in a real app, this would come from a service or provider
  final List<Category> categories = [
    Category(id: '1', name: 'Deportes', icon: '⚽', count: 12),
    Category(id: '2', name: 'Conciertos', icon: '🎵', count: 8),
    Category(id: '3', name: 'Teatro', icon: '🎭', count: 5),
    Category(id: '4', name: 'Arte', icon: '🎨', count: 7),
    Category(id: '5', name: 'Gastronomía', icon: '🍽️', count: 10),
  ];

  final List<Event> featuredEvents = [
    Event(
      id: '1',
      title: 'Concierto de Música Andina',
      description: 'Disfruta de lo mejor de la música andina en vivo',
      dateTime: DateTime.now().add(const Duration(days: 3)),
      location: 'Teatro Nacional',
      category: 'Conciertos',
      isFeatured: true,
      price: 25.00,
    ),
    Event(
      id: '2',
      title: 'Torneo de Fútbol',
      description: 'Gran torneo de fútbol intercomunal',
      dateTime: DateTime.now().add(const Duration(days: 5)),
      location: 'Estadio Olímpico',
      category: 'Deportes',
      isFeatured: true,
      price: 10.00,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CollapsibleAppBar(
              title: 'PAWKAR 2025',
              subtitle: 'Festival Cultural y Deportivo',
              greeting: 'Bienvenido a',
            ),
            SliverToBoxAdapter(child: _buildBody(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar mejorada
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Container(
            decoration: BoxDecoration(
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
                prefixIcon: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.search,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
              ),
            ),
          ),
        ),

        // Categories Section
        HorizontalScrollSection(
          title: 'Categorías',
          actionText: 'Ver todas',
          children: categories
              .map(
                (category) => ScrollItemCard(
                  title: category.name,
                  icon: Text(
                    category.icon,
                    style: const TextStyle(fontSize: 24),
                    ),
                  onTap: () {
                    // Navigate to category
                  },
                ),
              )
              .toList(),
        ),

        // Featured Events Section
        HorizontalScrollSection(
          title: 'Eventos Destacados',
          actionText: 'Ver más',
          itemHeight: 200,
          children: featuredEvents
              .map(
                (event) => ScrollItemCard(
                  width: 200,
                  height: 180,
                  title: event.title,
                  subtitle: '${event.location} • ${event.formattedDate}',
                  onTap: () {
                    // Navigate to event details
                  },
                  borderRadius: BorderRadius.circular(12),
                  shadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              )
              .toList(),
        ),

        // Upcoming Events Section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Próximos Eventos',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...List.generate(
                featuredEvents.length,
                (index) => _buildEventCard(featuredEvents[index], theme),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Get appropriate icon based on category
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'deportes':
        return Icons.sports_soccer;
      case 'conciertos':
        return Icons.music_note;
      case 'teatro':
        return Icons.theater_comedy;
      case 'arte':
        return Icons.palette;
      case 'gastronomía':
        return Icons.restaurant;
      default:
        return Icons.event;
    }
  }

  Widget _buildEventCard(Event event, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to event details
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del evento
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(event.category),
                    size: 40,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título y precio
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'S/.${event.price?.toStringAsFixed(2) ?? '0.00'}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    
                    // Fecha y hora
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${event.formattedDate} • ${event.formattedTime}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.8,
                              ),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    
                    // Ubicación
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            event.location,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.8,
                              ),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    // Categoría
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        event.category,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
