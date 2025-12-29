import 'package:flutter/material.dart';
import 'package:pawkar_app/models/subcategoria_model.dart';
import 'package:pawkar_app/services/subcategoria_service.dart';
import 'package:pawkar_app/widgets/empty_state_widget.dart';
import 'package:pawkar_app/screens/musica_screen.dart';
import 'package:intl/intl.dart';
import 'skeleton_loader.dart';

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
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final eventos = await _subcategoriaService.getProximosEventos();
      setState(() {
        _eventos = eventos;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar los próximos eventos';
      });
    } finally {
      setState(() {
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
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3, // Show 3 skeleton items
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image placeholder
                  const SkeletonLoader(width: 80, height: 80, borderRadius: 8),
                  const SizedBox(width: 12),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        const SkeletonLoader(
                          width: 200,
                          height: 16,
                          borderRadius: 4,
                        ),
                        const SizedBox(height: 8),
                        // Date
                        const SkeletonLoader(
                          width: 150,
                          height: 14,
                          borderRadius: 4,
                        ),
                        const SizedBox(height: 12),
                        // Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: SkeletonLoader(
                            width: 120,
                            height: 36,
                            borderRadius: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    if (_errorMessage.isNotEmpty) {
      return EmptyStateWidget(
        message: _errorMessage,
        icon: Icons.error_outline,
        actionLabel: 'Reintentar',
        onAction: _loadProximosEventos,
      );
    }

    if (_eventos.isEmpty) {
      return EmptyStateWidget(
        message: 'No hay eventos próximos programados',
        icon: Icons.event_available_outlined,
        actionLabel: 'Recargar',
        onAction: _loadProximosEventos,
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
          child: Container(
            height: 200,
            margin: const EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
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
                          Colors.black.withValues(alpha: 0.3),
                          Colors.black.withValues(alpha: 0.8),
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
                            if (evento.ubicacion.isNotEmpty) ...[
                              const Icon(
                                Icons.location_on,
                                size: 14,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  evento.ubicacion,
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
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MusicaScreen(
                                        subcategoriaId: evento.subcategoriaId,
                                      ),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
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
