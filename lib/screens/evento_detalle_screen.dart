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


            SliverPadding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 64.0,
                bottom: 8.0,
              ),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600
                      ? 3
                      : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  mainAxisExtent: 140,
                ),
                delegate: SliverChildListDelegate(_buildActionButtons(context)),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  List<Widget> _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final actions = [
      _ActionButtonData(
        icon: Icons.sports_soccer,
        label: 'Encuentros',
        onTap: () => _navigateToEncuentros(context),
        color: colorScheme.primary,
      ),
      _ActionButtonData(
        icon: Icons.people,
        label: 'Equipos',
        onTap: () => _navigateToEquipos(context),
        color: colorScheme.secondary,
      ),
      _ActionButtonData(
        icon: Icons.person,
        label: 'Jugadores',
        onTap: () => _navigateToJugadores(context),
        color: colorScheme.tertiary,
      ),
    ];

    if (isFutbol) {
      actions.add(
        _ActionButtonData(
          icon: Icons.format_list_numbered,
          label: 'Tabla de\nPosiciones',
          onTap: () => _navigateToTablaPosiciones(context),
          color: colorScheme.primaryContainer,
          textColor: colorScheme.onPrimaryContainer,
        ),
      );
    }

    return actions
        .map(
          (action) => _buildActionButton(
            context: context,
            icon: action.icon,
            label: action.label,
            onTap: action.onTap,
            color: action.color,
            textColor: action.textColor,
          ),
        )
        .toList();
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
    Color? textColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // Use primary color with better contrast for text
    final defaultColor = color ?? colorScheme.primary;
    // Use onSurface for better text contrast in both light and dark themes
    final defaultTextColor =
        textColor ?? theme.textTheme.bodyLarge?.color ?? colorScheme.onSurface;
    final isLightTheme = theme.brightness == Brightness.light;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: isLightTheme
                ? defaultColor.withOpacity(0.08)
                : defaultColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isLightTheme
                  ? defaultColor.withOpacity(0.3)
                  : defaultColor.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: isLightTheme
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: defaultColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: defaultColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(icon, size: 24, color: defaultColor),
              ),
              const SizedBox(height: 12),
              Text(
                label.replaceAll('\\n', '\n'),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: defaultTextColor,
                  height: 1.2,
                  fontSize: 14, // Slightly smaller font size for better fit
                  fontFamily:
                      GoogleFonts.poppins().fontFamily, // Use Poppins font
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
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

class _ActionButtonData {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  final Color? textColor;

  _ActionButtonData({
    required this.icon,
    required this.label,
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
