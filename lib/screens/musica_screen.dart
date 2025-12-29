import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/skeleton_loader.dart';
import '../models/subcategoria_model.dart';
import '../services/subcategoria_service.dart';
import '../theme/app_colors.dart';

// Initialize colors when the file loads
final appColors = AppColors();

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


  Widget _buildSkeletonLoader() {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            width: double.infinity,
            height: size.height * 0.3,
            color: Colors.grey[200],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title placeholder
                const SkeletonLoader(width: 200, height: 28, borderRadius: 4),
                const SizedBox(height: 16),
                // Date and location placeholders
                ...List.generate(
                  4,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        const SkeletonLoader(
                          width: 24,
                          height: 24,
                          shape: BoxShape.circle,
                          borderRadius: 0,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SkeletonLoader(
                                width: 120,
                                height: 16,
                                borderRadius: 4,
                              ),
                              const SizedBox(height: 4),
                              SkeletonLoader(
                                width: 200,
                                height: 14,
                                borderRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Description title
                SkeletonLoader(width: 150, height: 20, borderRadius: 4),
                const SizedBox(height: 8),
                // Description lines
                ...List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: SkeletonLoader(
                      width: double.infinity,
                      height: 16,
                      borderRadius: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getAssetPath(String eventName) {
    // Clean and normalize the event name for matching
    final cleanName = eventName.trim().toLowerCase();
    print('🔍 Event name: "$eventName"');

    // Check for specific event images (most specific first)
    if (cleanName == 'urban pawkar') {
      return 'assets/images/eventos/urban_pawkar.jpeg';
    } else if (cleanName.contains('noche internacional')) {
      return 'assets/images/eventos/noche_internacional.jpeg';
    } else if (cleanName.contains('ciclon')) {
      return 'assets/images/eventos/ciclon.jpeg';
    } else if (cleanName.contains('runakay')) {
      return 'assets/images/eventos/runakay.jpeg';
    } else if (cleanName.contains('pawkar')) {
      return cleanName.contains('oscuro')
          ? 'assets/images/eventos/pawkar_oscuro.jpeg'
          : 'assets/images/eventos/pawkar_claro.jpeg';
    }

    // Fallback to sport-specific images
    if (cleanName.contains('basket')) {
      return 'assets/images/basket.jpg';
    } else if (cleanName.contains('futbol')) {
      return 'assets/images/futbol.jpg';
    } else if (cleanName.contains('gastronomía') ||
        cleanName.contains('comida')) {
      return 'assets/images/gastronomia.jpg';
    } else if (cleanName.contains('voley') || cleanName.contains('voleibol')) {
      return 'assets/images/voley.jpg';
    }
    
    // Default image
    final defaultImage = 'assets/images/eventos/urban_pawkar.jpeg';
    print('ℹ️  Using default image: $defaultImage');
    return defaultImage;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Debug: Print the exact paths being used
    print('\n🔍 Testing image paths:');
    print('1. assets/images/eventos/noche_internacional.JPEG');
    print('2. assets/images/eventos/runakay.JPEG');
    print('3. assets/images/eventos/urban_pawkar.JPEG');

    // Debug: Check if files exist in the file system
    try {
      final dir = Directory('assets/images/eventos');
      if (dir.existsSync()) {
        print('\n📂 Contents of assets/images/eventos:');
        dir.listSync().forEach((element) {
          print('- ${element.path}');
        });
      } else {
        print('\n❌ Directory not found: ${dir.path}');
      }
    } catch (e) {
      print('\n❌ Error checking directory: $e');
    }
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
          ? _buildSkeletonLoader()
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
                  return _buildSkeletonLoader();
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
                            title: const SizedBox.shrink(),
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
                                    errorBuilder: (context, error, stackTrace) {
                                      print('❌ Error loading image: $error');
                                      return Container(
                                        color: Colors.grey[300],
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.error,
                                              size: 48,
                                              color: Colors.red,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'No se pudo cargar la imagen\n${evento.nombre}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                // Gradient overlay for better text contrast
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.5),
                                        Colors.black.withOpacity(0.9),
                                      ],
                                      stops: const [0.2, 0.8],
                                    ),
                                  ),
                                ),
                                // Centered event name
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: Text(
                                    evento.nombre.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 36,
                                      letterSpacing: 0.5,
                                      height: 1.1,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.9),
                                          offset: const Offset(2, 2),
                                          blurRadius: 10,
                                        ),
                                        Shadow(
                                          color: Colors.black,
                                          offset: const Offset(0, 0),
                                          blurRadius: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Collapsed app bar title
                                if (!expanded)
                                  Positioned(
                                    left: 60,
                                    right: 60,
                                    bottom: 12,
                                    child: Text(
                                      evento.nombre,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        letterSpacing: 0.3,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(
                                              0.8,
                                            ),
                                            offset: const Offset(1, 1),
                                            blurRadius: 6,
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
                              color: Colors.black.withValues(alpha: 0.2),
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
                                    color: AppColors.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (evento.artistas.isEmpty)
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppColors.surface.withValues(
                                    alpha: 0.3,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.onSurface.withValues(
                                      alpha: 0.1,
                                    ),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.music_off_rounded,
                                      size: 48,
                                      color: AppColors.onSurface
                                          .withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'No hay artistas programados',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: AppColors.onSurface.withValues(
                                          alpha:
                                          0.8,
                                        ),
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
                                      color: AppColors.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: AppColors.primary.withValues(
                                          alpha:
                                          0.3,
                                        ),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.05,
                                          ),
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
                                                .withValues(alpha: 0.2),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: colorScheme.primary
                                                  .withValues(alpha: 0.3),
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
                                                  .withValues(alpha: 0.1),
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
