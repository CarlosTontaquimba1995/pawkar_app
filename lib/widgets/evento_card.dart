import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
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
                                      offset: Offset(3, 3),
                                      blurRadius: 8,
                                    ),
                                    Shadow(
                                      // top left
                                      color: Colors.black54,
                                      offset: Offset(-3, -3),
                                      blurRadius: 8,
                                    ),
                                    Shadow(
                                      // bottom
                                      color: Colors.black87,
                                      offset: Offset(0, 3),
                                      blurRadius: 10,
                                    ),
                                    // Main text outline
                                    Shadow(
                                      // left
                                      color: Colors.black,
                                      offset: Offset(-2, 0),
                                      blurRadius: 0,
                                    ),
                                    Shadow(
                                      // right
                                      color: Colors.black,
                                      offset: Offset(2, 0),
                                      blurRadius: 0,
                                    ),
                                    Shadow(
                                      // top
                                      color: Colors.black,
                                      offset: Offset(0, -2),
                                      blurRadius: 0,
                                    ),
                                    Shadow(
                                      // bottom
                                      color: Colors.black,
                                      offset: Offset(0, 2),
                                      blurRadius: 0,
                                    ),
                                  ],
                                  fontFeatures: [
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
                  // Removed duplicate title to keep only the one on the image

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
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Handle button press
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('VER MÁS'),
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
        // Dark overlay for better text visibility
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            ),
          ),
        ),
        // Event name overlay - centered
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
                      offset: Offset(3, 3),
                      blurRadius: 8,
                    ),
                    Shadow(
                      // top left
                      color: Colors.black54,
                      offset: Offset(-3, -3),
                      blurRadius: 8,
                    ),
                    Shadow(
                      // bottom
                      color: Colors.black87,
                      offset: Offset(0, 3),
                      blurRadius: 10,
                    ),
                    // Main text outline
                    Shadow(
                      // left
                      color: Colors.black,
                      offset: Offset(-2, 0),
                      blurRadius: 0,
                    ),
                    Shadow(
                      // right
                      color: Colors.black,
                      offset: Offset(2, 0),
                      blurRadius: 0,
                    ),
                    Shadow(
                      // top
                      color: Colors.black,
                      offset: Offset(0, -2),
                      blurRadius: 0,
                    ),
                    Shadow(
                      // bottom
                      color: Colors.black,
                      offset: Offset(0, 2),
                      blurRadius: 0,
                    ),
                  ],
                  fontFeatures: [
                    FontFeature.enable('kern'),
                    FontFeature.tabularFigures(),
                    FontFeature.enable('smcp'),
                  ],
                  height: 1.1,
                  inherit: false,
                  textBaseline: TextBaseline.alphabetic,
                  leadingDistribution: TextLeadingDistribution.even,
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
  }

  Widget _buildDetailRow(IconData icon, String text, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.0, color: colorScheme.primary),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic date) {
    DateTime dateTime;

    if (date is String) {
      try {
        dateTime = DateTime.parse(date);
      } catch (e) {
        // If parsing fails, return the original string or a default message
        return date.toString();
      }
    } else if (date is DateTime) {
      dateTime = date;
    } else {
      return ''; // or some default value
    }

    return '${_getWeekday(dateTime.weekday)}, ${dateTime.day} de ${_getMonthName(dateTime.month)} ${dateTime.year}';
  }

  String _getWeekday(int weekday) {
    const weekdays = [
      'Domingo',
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
    ];
    return weekdays[weekday % 7];
  }

  String _getMonthName(int month) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return months[month - 1];
  }
}
