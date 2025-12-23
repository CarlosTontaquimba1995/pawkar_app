import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/subcategoria_model.dart';
import '../services/subcategoria_service.dart';

class MusicaScreen extends StatefulWidget {
  final int subcategoriaId;

  const MusicaScreen({super.key, required this.subcategoriaId});

  @override
  State<MusicaScreen> createState() => _MusicaScreenState();
}

class _MusicaScreenState extends State<MusicaScreen> {
  final SubcategoriaService _subcategoriaService = SubcategoriaService();
  late Future<Subcategoria> _eventoFuture;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadEvento();
  }

  Future<void> _loadEvento() async {
    try {
      final evento = await _subcategoriaService.getSubcategoriaById(
        widget.subcategoriaId,
      );
      setState(() {
        _eventoFuture = Future.value(evento);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar los detalles del evento: $e';
        _isLoading = false;
      });
    }
  }

  String _getAssetPath(String eventName) {
    if (eventName.toLowerCase().contains('basket')) {
      return 'assets/images/basket.jpg';
    } else if (eventName.toLowerCase().contains('futbol')) {
      return 'assets/images/futbol.jpg';
    } else if (eventName.toLowerCase().contains('gastronomía') ||
        eventName.toLowerCase().contains('comida')) {
      return 'assets/images/gastronomia.jpg';
    } else if (eventName.toLowerCase().contains('voley') ||
        eventName.toLowerCase().contains('voleibol')) {
      return 'assets/images/voley.jpg';
    }
    return 'assets/images/futbol.jpg'; // Default image
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: colorScheme.surface,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : FutureBuilder<Subcategoria>(
              future: _eventoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error al cargar el evento',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  );
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                      'No se encontró el evento',
                      style: theme.textTheme.titleMedium,
                    ),
                  );
                }

                final evento = snapshot.data!;
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: size.height * 0.3, // Reduced height
                      stretch: true,
                      pinned: true,
                      floating: true,
                      backgroundColor: colorScheme.surface,
                      flexibleSpace: LayoutBuilder(
                        builder: (context, constraints) {
                          final expanded = constraints.maxHeight > 120;
                          return FlexibleSpaceBar(
                            titlePadding: const EdgeInsets.only(
                              left: 60,
                              right: 16,
                              bottom: 16,
                            ),
                            title: AnimatedOpacity(
                              opacity: expanded ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                evento.nombre,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.5),
                                      offset: const Offset(1, 1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            background: Stack(
                              fit: StackFit.expand,
                              children: [
                                // Event image with gradient overlay
                                Hero(
                                  tag: 'event-${evento.subcategoriaId}',
                                  child: Image.asset(
                                    _getAssetPath(evento.nombre),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.error),
                                            ),
                                  ),
                                ),
                                // Gradient overlay
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.2),
                                        Colors.black.withOpacity(0.7),
                                      ],
                                      stops: const [0.5, 1.0],
                                    ),
                                  ),
                                ),
                                // Event name (visible when collapsed)
                                if (!expanded)
                                  Positioned(
                                    left: 60,
                                    right: 60,
                                    bottom: 12,
                                    child: Text(
                                      evento.nombre,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(
                                              0.5,
                                            ),
                                            offset: const Offset(1, 1),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                      leading: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ),
                    // Rest of your content...
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Event details card
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Date and time
                                    if (evento.fechaHora != null)
                                      ..._buildInfoRow(
                                        Icons.calendar_today,
                                        _formatDate(evento.fechaHora!),
                                        'Fecha y Hora'
                                      ),
                                        
                                    if (evento.ubicacion.isNotEmpty) ...[
                                      ..._buildInfoRow(
                                        Icons.location_on,
                                        evento.ubicacion,
                                        'Ubicación',
                                      ),
                                      const SizedBox(height: 8),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: ElevatedButton.icon(
                                          onPressed: () => _openMap(evento),
                                          icon: const Icon(
                                            Icons.directions,
                                            size: 18,
                                          ),
                                          label: const Text('Cómo llegar'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                theme.colorScheme.primary,
                                            foregroundColor:
                                                theme.colorScheme.onPrimary,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            elevation: 1,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Description
                            if (evento.descripcion.isNotEmpty) ...[
                              Text(
                                'Descripción',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                evento.descripcion,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                            // Artists section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Artistas Destacados',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (evento.artistas.isEmpty)
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceContainerHighest
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: theme.dividerColor.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.music_off_rounded,
                                      size: 48,
                                      color: theme.colorScheme.onSurfaceVariant
                                          .withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'No hay artistas programados',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: theme.textTheme.bodyMedium?.color
                                            ?.withOpacity(0.8),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            else
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1.5,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                    ),
                                itemCount: evento.artistas.length,
                                itemBuilder: (context, index) {
                                  final artista = evento.artistas[index];
                                  final colorScheme = Theme.of(
                                    context,
                                  ).colorScheme;

                                  return Container(
                                    decoration: BoxDecoration(
                                      color: colorScheme.primaryContainer
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: colorScheme.primary.withOpacity(
                                          0.2,
                                        ),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: colorScheme.primaryContainer
                                                .withOpacity(0.2),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: colorScheme.primary
                                                  .withOpacity(0.3),
                                              width: 2,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              artista.nombre.isNotEmpty
                                                  ? artista.nombre[0]
                                                        .toUpperCase()
                                                  : 'A',
                                              style: GoogleFonts.poppins(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                                color: colorScheme.primary,
                                                height: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          artista.nombre,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (artista.genero.isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: colorScheme.primary
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              artista.genero,
                                              style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                color: colorScheme.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: null, // Hidden for now as per requirements
    );
  }

  List<Widget> _buildInfoRow(IconData icon, String text, String label) {
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
    ];
  }

  String _formatDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat("EEEE d 'de' MMMM 'de' y, hh:mm a", 'es_ES')
          .format(dateTime)
          .replaceFirstMapped(
            RegExp(r'^\w'),
            (match) => match.group(0)!.toUpperCase(),
          );
    } catch (e) {
      return dateTimeString;
    }
  }

  Future<void> _openMap(Subcategoria evento) async {
    final double lat = evento.latitud;
    final double lng = evento.longitud;

    if (lat == 0.0 || lng == 0.0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ubicación no disponible')));
      return;
    }

    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo abrir Google Maps';
    }
  }
}
