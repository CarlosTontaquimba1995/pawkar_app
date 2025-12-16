import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../models/subcategoria_model.dart';
import 'matches_screen.dart';
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
              flexibleSpace: FlexibleSpaceBar(
                title: _showAppBarTitle
                    ? Text(
                        widget.evento.nombre,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      )
                    : null,
                background: _EventHeader(
                  imagePath: _getImageForEvent(widget.evento.nombre),
                  title: widget.evento.nombre,
                  description: widget.evento.descripcion,
                ),
              ),
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),


            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 24,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Información del evento
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                color: Colors.blue,
                              ),
                            ),
                            title: Text(
                              'Información del Evento',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              widget.evento.descripcion.isNotEmpty
                                  ? widget.evento.descripcion
                                  : 'No hay descripción disponible',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            isThreeLine: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Acciones principales
                    Text(
                      'Acciones disponibles',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._buildActionTiles(context),

                    // Información adicional
                    const SizedBox(height: 24),
                    Text(
                      'Detalles adicionales',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.calendar_today,
                                color: Colors.orange,
                              ),
                            ),
                            title: Text(
                              'Fecha de inicio',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            trailing: Text(
                              'Próximamente',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.color,
                                  ),
                            ),
                          ),
                          const Divider(height: 1, indent: 72, endIndent: 16),
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.group,
                                color: Colors.green,
                              ),
                            ),
                            title: Text(
                              'Equipos participantes',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            trailing: Text(
                              '0',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
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
        icon: Icons.sports_soccer,
        title: 'Encuentros',
        subtitle: 'Ver todos los partidos programados',
        onTap: () => _navigateToEncuentros(context),
        color: colorScheme.primary,
      ),
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

    if (isFutbol) {
      actions.add(
        _ActionTileData(
          icon: Icons.format_list_numbered,
          title: 'Tabla de Posiciones',
          subtitle: 'Ver la clasificación actual',
          onTap: () => _navigateToTablaPosiciones(context),
          color: colorScheme.primaryContainer,
          textColor: colorScheme.onPrimaryContainer,
        ),
      );
    }

    return actions
        .map(
          (action) => _buildActionTile(
            context: context,
            icon: action.icon,
            title: action.title,
            subtitle: action.subtitle,
            onTap: action.onTap,
            color: action.color,
            textColor: action.textColor,
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
    Color? textColor,
  }) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                color: textColor ?? theme.textTheme.titleMedium?.color,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color:
                    textColor?.withOpacity(0.8) ??
                    theme.textTheme.bodySmall?.color,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildFloatingActionButton(BuildContext context) {
    return null;
  }

  /// Navigates to the matches screen with a slide transition.
  void _navigateToEncuentros(BuildContext context) {
    try {
      Navigator.of(context).push(
        PageRouteBuilder<dynamic>(
          pageBuilder: (_, __, ___) => const MatchesScreen(initialMatches: []),
          transitionsBuilder: (_, animation, __, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            final tween = Tween<Offset>(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    } catch (e, stackTrace) {
      log(
        'Error navigating to matches screen',
        error: e,
        stackTrace: stackTrace,
      );
      _showErrorSnackBar(
        context,
        'No se pudo cargar la pantalla de encuentros',
      );
    }
  }

  void _navigateToEquipos(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EquiposScreen(subcategoriaId: widget.evento.subcategoriaId),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _navigateToJugadores(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            JugadoresScreen(subcategoriaId: widget.evento.subcategoriaId),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  /// Navigates to the standings screen with a slide-up transition.
  void _navigateToTablaPosiciones(BuildContext context) {
    try {
      Navigator.of(context).push(
        PageRouteBuilder<dynamic>(
          pageBuilder: (_, __, ___) => TablaPosicionesScreen(
            subcategoriaId: widget.evento.subcategoriaId,
          ),
          transitionsBuilder: (_, animation, __, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            final tween = Tween<Offset>(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
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

  /// Helper method to get image path based on event name
  /// Returns the appropriate image path based on the event name.
  ///
  /// If no matching image is found, returns a default football image.
  String _getImageForEvent(String eventName) {
    if (eventName.isEmpty) return 'assets/images/futbol.jpg';
    
    final lowerName = eventName.toLowerCase();
    
    if (lowerName.contains('futbol') || lowerName.contains('fútbol')) {
      return 'assets/images/futbol.jpg';
    } else if (lowerName.contains('basket') ||
        lowerName.contains('baloncesto')) {
      return 'assets/images/basket.jpg';
    } else if (lowerName.contains('gastronom')) {
      // Matches both 'gastronomia' and 'gastronomía'
      return 'assets/images/gastronomia.jpg';
    }
    
    // Default fallback
    return 'assets/images/futbol.jpg';
  }
}

class _ActionTileData {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color color;
  final Color? textColor;

  const _ActionTileData({
    required this.icon,
    required this.title,
    this.subtitle = '',
    required this.onTap,
    required this.color,
    this.textColor,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image with gradient overlay
        _buildBackgroundImage(),

        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                colorScheme.surface.withOpacity(0.7),
                colorScheme.surface.withOpacity(0.9),
              ],
            ),
          ),
        ),

        // Content
        Padding(
          padding: const EdgeInsets.all(
            24.0,
          ).copyWith(top: kToolbarHeight * 1.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: colorScheme.onSurface,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    color: colorScheme.onSurface.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
