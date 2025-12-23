import 'package:flutter/material.dart';
import 'package:pawkar_app/models/subcategoria_model.dart';
import 'package:pawkar_app/screens/evento_detalle_screen.dart';
import 'package:pawkar_app/services/categoria_service.dart';
import 'package:pawkar_app/services/subcategoria_service.dart';
import 'package:pawkar_app/widgets/empty_state_widget.dart';
import 'package:pawkar_app/widgets/skeleton_loader.dart';

class EventosDestacadosSection extends StatefulWidget {
  const EventosDestacadosSection({super.key});

  @override
  EventosDestacadosSectionState createState() =>
      EventosDestacadosSectionState();
}

class EventosDestacadosSectionState extends State<EventosDestacadosSection> {
  late final Future<List<Subcategoria>> _eventosDestacadosFuture;
  final CategoriaService _categoriaService = CategoriaService();
  final SubcategoriaService _subcategoriaService = SubcategoriaService();

  @override
  void initState() {
    super.initState();
    _eventosDestacadosFuture = _loadEventosDestacados();
  }

  // In your EventosDestacadosSectionState class

Future<List<Subcategoria>> _loadEventosDestacados() async {
    try {
      debugPrint('Buscando categoría DEPORTES...');
      final categoriaDeportes = await _categoriaService
          .getCategoriaByNemonico('DEPORTES')
          .catchError((error) {
            debugPrint('Error al cargar la categoría: $error');
            return null;
          });

      if (categoriaDeportes == null) {
        debugPrint(
          'La categoría DEPORTES no existe o hubo un error al cargarla',
        );
        return [];
      }
  
      debugPrint(
        'Obteniendo subcategorías para categoría ID: ${categoriaDeportes.categoriaId}',
      );

      try {
        final subcategorias = await _subcategoriaService
            .getSubcategoriasByCategoria(categoriaDeportes.categoriaId);
        debugPrint('Se encontraron ${subcategorias.length} subcategorías');
        return subcategorias;
      } catch (error) {
        debugPrint('Error al cargar subcategorías: $error');
        return [];
      }
    } catch (e, stackTrace) {
      debugPrint('Error inesperado al cargar eventos destacados:');
      debugPrint('Error: $e');
      debugPrint('Stack trace: $stackTrace');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Subcategoria>>(
      future: _eventosDestacadosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildSkeletonLoader();
        } else if (snapshot.hasError) {
          // Show error state with retry button
          return EmptyStateWidget(
            message: 'No se pudieron cargar los eventos destacados',
            icon: Icons.error_outline,
            actionLabel: 'Reintentar',
            onAction: () {
              setState(() {
                _eventosDestacadosFuture = _loadEventosDestacados();
              });
            },
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return EmptyStateWidget(
            message: 'No hay eventos destacados disponibles',
            icon: Icons.event_busy,
            actionLabel: 'Recargar',
            onAction: () {
              setState(() {
                _eventosDestacadosFuture = _loadEventosDestacados();
              });
            },
          );
        }

        final eventos = snapshot.data!;
        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: eventos.length,
            itemBuilder: (context, index) {
              return _buildEventoItem(eventos[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildSkeletonLoader() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLoader(width: 200, height: 120, borderRadius: 12),
                const SizedBox(height: 8),
                const SkeletonLoader(width: 160, height: 16, borderRadius: 4),
                const SizedBox(height: 4),
                const SkeletonLoader(width: 120, height: 14, borderRadius: 4),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getImageForEvent(String eventName) {
    try {
      final lowerName = eventName.toLowerCase();
      
      // Only use images that we know exist in the assets
      if (lowerName.contains('futbol') || lowerName.contains('fútbol')) {
        return 'assets/images/futbol.jpg';
      } else if (lowerName.contains('basket') ||
          lowerName.contains('básket') ||
          lowerName.contains('basquet') ||
          lowerName.contains('básquet') ||
          lowerName.contains('baloncesto')) {
        return 'assets/images/basket.jpg';
      } else if (lowerName.contains('voley') ||
          lowerName.contains('voleibol') ||
          lowerName.contains('vóley') ||
          lowerName.contains('vóleibol')) {
        return 'assets/images/voley.jpg';
      } else if (lowerName.contains('gastronomía') ||
          lowerName.contains('gastronomia') ||
          lowerName.contains('comida') ||
          lowerName.contains('restaurante')) {
        return 'assets/images/gastronomia.jpg';
      }
      
      // Default fallback to splash logo if no match found
      return 'assets/images/splash_logo.png';
    } catch (e) {
      debugPrint('Error getting image for event: $e');
      return 'assets/images/splash_logo.png';
    }
  }

  Widget _buildEventoItem(Subcategoria evento) {
    final imagePath = _getImageForEvent(evento.nombre);
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventoDetalleScreen(evento: evento),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
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
              // Imagen de fondo
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
              // Gradiente para mejorar la legibilidad del texto
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.1),
                    ],
                    stops: const [0.0, 0.4, 0.7, 1.0],
                  ),
                ),
              ),
              // Contenido del texto
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fecha o etiqueta destacada (opcional)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Destacado',
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Título del evento
                    Text(
                      evento.nombre,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        shadows: [
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Subtítulo o ubicación (opcional)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.white.withOpacity(0.9),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Ver detalles',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
