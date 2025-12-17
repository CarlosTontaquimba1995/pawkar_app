import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../models/subcategoria_model.dart';

class EventoCard extends StatelessWidget {
  final Subcategoria subcategoria;
  final String? imageUrl;

  String _getDefaultImage() {
    return 'assets/images/splash_logo.png';
  }

  const EventoCard({super.key, required this.subcategoria, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    // Log de coordenadas
    if (subcategoria.latitud != null && subcategoria.longitud != null) {
      debugPrint(
        'Coordenadas del evento ${subcategoria.nombre}: ${subcategoria.latitud}, ${subcategoria.longitud}',
      );
    } else {
      debugPrint(
        'El evento ${subcategoria.nombre} no tiene coordenadas definidas',
      );
    }
    
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          // TODO: Navigate to event detail screen
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Event Image with better error handling
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
              child: FutureBuilder<bool>(
                future: _checkImage(imageUrl),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue,
                          ),
                        ),
                      ),
                    );
                  }

                  final imagePath = imageUrl ?? _getDefaultImage();
                  if (snapshot.hasData && snapshot.data == true) {
                    return Stack(
                      children: [
                        if (imagePath.startsWith('http'))
                          Image.network(
                            imagePath,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return _buildImageError();
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                _buildImageError(),
                          )
                        else
                          Image.asset(
                            imagePath,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildImageError(),
                          ),
                        // Dark overlay for better text visibility
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        // Event name overlay
                        Positioned.fill(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                subcategoria.nombre.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Roboto',
                                  letterSpacing: 2.0,
                                  shadows: [
                                    // 3D effect shadows
                                    Shadow(
                                      // bottom right
                                      color: Colors.black54,
                                      offset: const Offset(3, 3),
                                      blurRadius: 8,
                                    ),
                                    Shadow(
                                      // top left
                                      color: Colors.black54,
                                      offset: const Offset(-3, -3),
                                      blurRadius: 8,
                                    ),
                                    Shadow(
                                      // bottom
                                      color: Colors.black87,
                                      offset: const Offset(0, 3),
                                      blurRadius: 10,
                                    ),
                                    // Main text outline
                                    Shadow(
                                      // left
                                      color: Colors.black,
                                      offset: const Offset(-2, 0),
                                      blurRadius: 0,
                                    ),
                                    Shadow(
                                      // right
                                      color: Colors.black,
                                      offset: const Offset(2, 0),
                                      blurRadius: 0,
                                    ),
                                    Shadow(
                                      // top
                                      color: Colors.black,
                                      offset: const Offset(0, -2),
                                      blurRadius: 0,
                                    ),
                                    Shadow(
                                      // bottom
                                      color: Colors.black,
                                      offset: const Offset(0, 2),
                                      blurRadius: 0,
                                    ),
                                  ],
                                  fontFeatures: const [
                                    FontFeature.enable('kern'),
                                    FontFeature.tabularFigures(),
                                    FontFeature.enable('smcp'),
                                  ],
                                  height: 1.1,
                                  inherit: false,
                                  textBaseline: TextBaseline.alphabetic,
                                  leadingDistribution:
                                      TextLeadingDistribution.even,
                                  locale: const Locale('es', 'ES'),
                                  wordSpacing: 1.5,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return _buildImageError();
                  }
                },
              ),
            ),

            // Event Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Description
                  Text(
                    subcategoria.descripcion,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 16.0),

                  // Event Details
                  if (subcategoria.fechaHora != null ||
                      subcategoria.ubicacion != null)
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: colorScheme.primary.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        children: [
                          if (subcategoria.fechaHora != null)
                            _buildDetailRow(
                              Icons.calendar_today_rounded,
                              _formatDate(subcategoria.fechaHora!),
                              colorScheme,
                            ),
                          if (subcategoria.fechaHora != null &&
                              subcategoria.ubicacion != null)
                            const Divider(height: 16, thickness: 0.5),
                          if (subcategoria.ubicacion != null)
                            _buildDetailRow(
                              Icons.location_on_rounded,
                              subcategoria.ubicacion!,
                              colorScheme,
                            ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 12.0),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        // Usar las coordenadas del objeto subcategoria si están disponibles
                        final double? lat = subcategoria.latitud;
                        final double? lng = subcategoria.longitud;

                        if (lat == null || lng == null) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Ubicación no disponible para este evento',
                              ),
                            ),
                          );
                          return;
                        }

                        // URL de Google Maps con las coordenadas
                        final String googleMapsUrl =
                            'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving&dir_action=navigate';

                        // URL alternativa para abrir en el navegador
                        const String googleMapsFallbackUrl =
                            'https://maps.app.goo.gl/uwxf79sPFYJzn3pR8';

                        try {
                          // Primero intentamos abrir la aplicación de Google Maps
                          if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
                            await launchUrl(
                              Uri.parse(googleMapsUrl),
                              mode: LaunchMode.externalApplication,
                            );
                          }
                          // Si falla, intentamos con la URL del enlace directo
                          else if (await canLaunchUrl(
                            Uri.parse(googleMapsFallbackUrl),
                          )) {
                            await launchUrl(
                              Uri.parse(googleMapsFallbackUrl),
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'No se pudo abrir Google Maps. Por favor, instálalo e inténtalo de nuevo.',
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${e.toString()}')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.directions, size: 20),
                      label: const Text('CÓMO LLEGAR'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Check if image is accessible
  Future<bool> _checkImage(String? url) async {
    if (url == null || url.isEmpty) return true;
    try {
      // For local assets
      if (url.startsWith('assets/')) {
        final asset = await rootBundle.load(url);
        return asset.buffer.lengthInBytes > 0;
      }
      // For network images
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Widget _buildImageError() {
    return Stack(
      children: [
        Image.asset(
          'assets/images/splash_logo.png',
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 150,
              color: Colors.grey[800],
              child: const Center(
                child: Icon(Icons.broken_image, size: 50, color: Colors.white),
              ),
            );
          },
        ),
        Container(height: 150, color: Colors.black26),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String text, ColorScheme colorScheme) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[800], fontSize: 14),
          ),
        ),
      ],
    );
  }

  String _formatDate(dynamic date) {
    if (date is String) {
      try {
        // Try to parse the string as a DateTime
        final dateTime = DateTime.parse(date);
        return _formatDateTime(dateTime);
      } catch (e) {
        // If parsing fails, return the original string
        return date;
      }
    } else if (date is DateTime) {
      return _formatDateTime(date);
    }
    return 'Fecha no disponible';
  }

  String _formatDateTime(DateTime date) {
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];

    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day de $month de $year a las $hour:$minute';
  }
}
