import 'package:flutter/material.dart';
import 'package:pawkar_app/models/subcategoria_model.dart';
import 'package:pawkar_app/services/subcategoria_service.dart';
import 'package:pawkar_app/widgets/empty_state_widget.dart';
import 'package:intl/intl.dart';

class ProximosEventosSection extends StatefulWidget {
  const ProximosEventosSection({super.key});

  @override
  State<ProximosEventosSection> createState() => _ProximosEventosSectionState();
}

class _ProximosEventosSectionState extends State<ProximosEventosSection> {
  final SubcategoriaService _subcategoriaService = SubcategoriaService();
  bool _isLoading = true;
  List<Subcategoria> _eventos = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadProximosEventos();
  }

  Future<void> _loadProximosEventos() async {
    try {
      final eventos = await _subcategoriaService.getProximosEventos();
      setState(() {
        _eventos = eventos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar los próximos eventos: $e';
        _isLoading = false;
      });
    }
  }

  String _formatDate(String? dateTimeString) {
    if (dateTimeString == null) return 'Fecha no disponible';
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  // Get appropriate image for event
  String _getEventImage(String eventName) {
    if (eventName.toLowerCase().contains('futbol') ||
        eventName.toLowerCase().contains('fútbol')) {
      return 'assets/images/futbol.jpg';
    } else if (eventName.toLowerCase().contains('baloncesto') ||
        eventName.toLowerCase().contains('básquet') ||
        eventName.toLowerCase().contains('basket')) {
      return 'assets/images/basket.jpg';
    } else if (eventName.toLowerCase().contains('comida') ||
        eventName.toLowerCase().contains('gastronomía') ||
        eventName.toLowerCase().contains('gastronomia')) {
      return 'assets/images/gastronomia.jpg';
    } else if (eventName.toLowerCase().contains('voley') ||
        eventName.toLowerCase().contains('voleibol')) {
      return 'assets/images/voley.jpg';
    } else {
      // Default image
      return 'assets/images/splash_logo.png';
    }
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_eventos.isEmpty) {
      return EmptyStateWidget(
        message: 'No hay eventos próximos programados',
        icon: Icons.event_available_outlined,
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: _eventos.length,
      itemBuilder: (context, index) {
        final evento = _eventos[index];
        final imagePath = _getEventImage(evento.nombre);

        return GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Ver detalles de: ${evento.nombre}'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
          child: Container(
            height: 200,
            margin: const EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image with overlay
                  Image.asset(imagePath, fit: BoxFit.cover),
                  // Darker gradient overlay for better text visibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Event Name - Centered and Bold
                        Center(
                          child: Text(
                            evento.nombre.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  blurRadius: 4,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Date and Location Row
                        Row(
                          children: [
                            if (evento.fechaHora != null) ...[
                              const Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatDate(evento.fechaHora),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black54,
                                      blurRadius: 4,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                            ],
                            if (evento.ubicacion != null) ...[
                              const Icon(
                                Icons.location_on,
                                size: 14,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  evento.ubicacion!,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black54,
                                        blurRadius: 4,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                        // Description (only show if there's space)
                        if (evento.descripcion.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            evento.descripcion,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  blurRadius: 4,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        // View Details Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.only(top: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Text(
                              'Ver detalles',
                              style: TextStyle(
                                color: Color(0xFF6C63FF),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }
}
