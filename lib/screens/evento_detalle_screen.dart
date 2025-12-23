import 'dart:developer';

import 'package:flutter/material.dart';
import '../utils/custom_page_route.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../models/subcategoria_model.dart';
import 'equipos_screen.dart';
import 'jugadores_screen.dart';
import 'tabla_posiciones_screen.dart';

class EventoDetalleScreen extends StatefulWidget {
  final Subcategoria evento;
  const EventoDetalleScreen({super.key, required this.evento});

  @override
  State<EventoDetalleScreen> createState() => _EventoDetalleScreenState();
}

class _EventoDetalleScreenState extends State<EventoDetalleScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  /// Handles scroll events to show/hide the app bar title.
  void _onScroll() {
    final shouldShowTitle = _scrollController.offset > 100;
    if (shouldShowTitle != _showAppBarTitle) {
      setState(() => _showAppBarTitle = shouldShowTitle);
    }
  }

  bool get isFutbol =>
      widget.evento.nombre.toLowerCase().contains('futbol') ||
      widget.evento.nombre.toLowerCase().contains('fútbol');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme.copyWith(
      titleLarge: theme.textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface, // Ensure good contrast
      ),
      bodyLarge: theme.textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurfaceVariant, // Slightly muted for body text
      ),
    );

    return Theme(
      data: Theme.of(context).copyWith(textTheme: textTheme),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              stretch: true,
              shadowColor: Colors.black26,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: _showAppBarTitle
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          widget.evento.nombre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      )
                    : null,
                background: _EventHeader(
                  imagePath: _getImageForEvent(
                    widget.evento.nombre,
                    deporte: widget.evento.deporte,
                  ),
                  title: widget.evento.nombre,
                  description: widget.evento.descripcion,
                ),
              ),
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                  style: IconButton.styleFrom(
                    foregroundColor: colorScheme.onSurface,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),


            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 32,
                  left: 16,
                  right: 16,
                  bottom: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    ..._buildActionTiles(context),

                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  List<Widget> _buildActionTiles(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final actions = [
      _ActionTileData(
        icon: Icons.people,
        title: 'Equipos',
        subtitle: 'Explorar equipos participantes',
        onTap: () => _navigateToEquipos(context),
        color: colorScheme.secondary,
      ),
      _ActionTileData(
        icon: Icons.person,
        title: 'Jugadores',
        subtitle: 'Ver jugadores registrados',
        onTap: () => _navigateToJugadores(context),
        color: colorScheme.tertiary,
      ),
    ];

    // Show Tabla de Posiciones for all events
    actions.add(
      _ActionTileData(
        icon: Icons.format_list_numbered,
        title: 'Tabla de Posiciones',
        subtitle: 'Ver la clasificación actual',
        onTap: () => _navigateToTablaPosiciones(context),
        color: colorScheme.primaryContainer,
      ),
    );

    return actions
        .map(
          (action) => _buildActionTile(
            context: context,
            icon: action.icon,
            title: action.title,
            subtitle: action.subtitle,
            onTap: action.onTap,
            color: action.color,
          ),
        )
        .toList();
  }

  Widget _buildActionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.1), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            title: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.textTheme.titleMedium?.color,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color:
                    theme.textTheme.bodySmall?.color,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.colorScheme.primary.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildFloatingActionButton(BuildContext context) {
    return null;
  }

  void _navigateToEquipos(BuildContext context) {
    Navigator.of(context).push(
      CustomPageRoute(
        child: EquiposScreen(subcategoriaId: widget.evento.subcategoriaId),
        direction: AxisDirection.right,
      ),
    );
  }

  void _navigateToJugadores(BuildContext context) {
    Navigator.of(context).push(
      CustomPageRoute(
        child: JugadoresScreen(subcategoriaId: widget.evento.subcategoriaId),
        direction: AxisDirection.right,
      ),
    );
  }

  /// Navigates to the standings screen with a consistent slide transition.
  void _navigateToTablaPosiciones(BuildContext context) {
    try {
      Navigator.of(context).push(
        CustomPageRoute(
          child: TablaPosicionesScreen(
            subcategoriaId: widget.evento.subcategoriaId,
          ),
          direction: AxisDirection.right,
        ),
      );
    } catch (e, stackTrace) {
      log(
        'Error navigating to standings screen',
        error: e,
        stackTrace: stackTrace,
      );
      _showErrorSnackBar(context, 'No se pudo cargar la tabla de posiciones');
    }
  }


  /// Shows an error message in a snackbar.
  void _showErrorSnackBar(BuildContext context, String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
        showCloseIcon: true,
      ),
    );
  }

  /// Helper method to get image path based on event name and sport type
  /// Returns the appropriate image path based on the event name and deporte field.
  ///
  /// If no matching image is found, returns a default football image.
  String _getImageForEvent(
    String eventName, {
    String? deporte,
    String? nemonico,
  }) {
    try {
      final lowerName = eventName.toLowerCase();
      final lowerDeporte = deporte?.toLowerCase() ?? '';
      final lowerNemonico = nemonico?.toLowerCase() ?? '';

      // Mapeo de deportes a imágenes
      final Map<List<String>, String> deporteImagenMap = {
        // Fútbol
        [
          'futbol',
          'fútbol',
          'soccer',
          'futbolito',
          'futsal',
          'futbol sala',
          'microfutbol',
          'fútbol de salón',
        ]: 'assets/images/futbol.jpg',

        // Baloncesto
        [
          'basket',
          'baloncesto',
          'básquet',
          'basquet',
          'basquetbol',
          'basketball',
          'básquetbol',
          'basket ball',
          'básket',
        ]: 'assets/images/basket.jpg',

        // Gastronomía
        [
          'gastronomia',
          'comida',
          'chef',
          'culinaria',
          'cocina',
          'restaurante',
          'gourmet',
          'gastronomía',
        ]: 'assets/images/gastronomia.jpg',

        // Voleibol
        ['voley', 'voleibol', 'volley', 'volleyball', 'vóley', 'vóleibol']:
            'assets/images/voley.jpg',

        // Tenis - Usando futbol.jpg como respaldo
        ['tenis', 'tennis']: 'assets/images/futbol.jpg',
      };

      // 1. Primero buscar por nemonico si está disponible
      if (lowerNemonico.isNotEmpty) {
        for (final entry in deporteImagenMap.entries) {
          if (entry.key.any((keyword) => lowerNemonico.contains(keyword))) {
            return entry.value;
          }
        }
      }

      // 2. Luego buscar por deporte
      if (lowerDeporte.isNotEmpty) {
        for (final entry in deporteImagenMap.entries) {
          if (entry.key.any((keyword) => lowerDeporte.contains(keyword))) {
            return entry.value;
          }
        }
      }

      // 3. Finalmente buscar por nombre del evento
      for (final entry in deporteImagenMap.entries) {
        if (entry.key.any((keyword) => lowerName.contains(keyword))) {
          return entry.value;
        }
      }

      // Si no se encuentra ninguna coincidencia, devolver imagen por defecto
      return 'assets/images/futbol.jpg';
    } catch (e) {
      debugPrint('Error getting image for event: $e');
      return 'assets/images/futbol.jpg'; // Usar futbol.jpg como respaldo en caso de error
    }
  }

}

class _ActionTileData {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color color;

  const _ActionTileData({
    required this.icon,
    required this.title,
    this.subtitle = '',
    required this.onTap,
    required this.color,
  });
}

class _EventHeader extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const _EventHeader({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildBackgroundImage(),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  colorScheme.surface.withOpacity(0.95),
                  colorScheme.surface.withOpacity(0.7),
                  colorScheme.surface.withOpacity(0.4),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),
        ),

        // Content
        Padding(
          padding: const EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            bottom: 24.0,
            top:
                kToolbarHeight *
                2.2, 
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimary,
                    height: 1.2,
                  ),
                ),
              ),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundImage() {
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey[200],
        child: const Icon(Icons.error_outline, size: 48, color: Colors.grey),
      ),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: frame == null ? _buildShimmerEffect() : child,
        );
      },
    );
  }

  /// Builds a shimmer effect for loading states.
  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(color: Colors.white),
    );
  }
}
