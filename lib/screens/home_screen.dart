import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawkar_app/features/home/widgets/categories_section.dart';
import 'package:pawkar_app/features/home/widgets/featured_events_section.dart';
import 'package:pawkar_app/features/home/widgets/search_bar.dart';
import 'package:pawkar_app/features/home/widgets/upcoming_events_section.dart';
import 'package:pawkar_app/models/category.dart';
import 'package:pawkar_app/models/event.dart';
import 'package:pawkar_app/widgets/collapsible_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Sample data - in a real app, this would come from a service or provider
  final List<Category> _categories = [
    Category(id: '1', name: 'Música', icon: 'music_note'),
    Category(id: '2', name: 'Deportes', icon: 'sports_soccer'),
    Category(id: '3', name: 'Arte', icon: 'palette'),
    Category(id: '4', name: 'Gastronomía', icon: 'restaurant'),
    Category(id: '5', name: 'Teatro', icon: 'theater_comedy'),
  ];

  final List<Event> _featuredEvents = [
    Event(
      id: '1',
      title: 'Torneo de Fútbol',
      description: 'Encuentros de fútbol profesional',
      location: 'Estadio Olímpico',
      dateTime: DateTime.now().add(const Duration(days: 2)),
      category: 'Fútbol',
      isFeatured: true,
      price: 12.00,
      imageUrl: 'assets/images/futbol.jpg',
    ),
    Event(
      id: '2',
      title: 'Liga de Baloncesto',
      description: 'Partidos de la liga nacional de baloncesto',
      location: 'Coliseo General Rumiñahui',
      dateTime: DateTime.now().add(const Duration(days: 4)),
      category: 'Baloncesto',
      isFeatured: true,
      price: 10.00,
      imageUrl: 'assets/images/basketball.jpg',
    ),
    Event(
      id: '3',
      title: 'Campeonato de Ecuavóley',
      description: 'Torneo nacional de ecuavóley',
      location: 'Parque La Carolina',
      dateTime: DateTime.now().add(const Duration(days: 3)),
      category: 'Ecuavóley',
      isFeatured: true,
      price: 8.00,
      imageUrl: 'assets/images/volleyball.jpg',
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
        // Search Bar
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SearchBarWidget(),
        ),

        // Categories Section
        CategoriesSection(
          categories: [
            Category(id: '1', name: 'Deportes', icon: '⚽', count: 12),
            Category(id: '2', name: 'Conciertos', icon: '🎵', count: 8),
            Category(id: '3', name: 'Teatro', icon: '🎭', count: 5),
            Category(id: '4', name: 'Arte', icon: '🎨', count: 7),
            Category(id: '5', name: 'Gastronomía', icon: '🍽️', count: 10),
          ],
          onCategoryTap: (category) {
            // Navigate to category
          },
          onViewAll: () {
            // Navigate to all categories
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
            // Navigate to event details
          },
          onViewAll: () {
            // Navigate to all featured events
          },
        ),

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
          ],
          onEventTap: (event) {
            // Navigate to event details
          },
        ),
      ],
    );
  }
}
