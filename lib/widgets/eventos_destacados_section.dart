import 'package:flutter/material.dart';
import 'package:pawkar_app/models/subcategoria_model.dart';
import 'package:pawkar_app/screens/equipos_screen.dart';
import 'package:pawkar_app/services/categoria_service.dart';
import 'package:pawkar_app/services/subcategoria_service.dart';

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

  Future<List<Subcategoria>> _loadEventosDestacados() async {
    try {
      final categoriaDeportes = await _categoriaService.getCategoriaByNemonico(
        'DEPORTES',
      );
      return await _subcategoriaService.getSubcategoriasByCategoria(
        categoriaDeportes.categoriaId,
      );
    } catch (e) {
      debugPrint('Error loading featured events: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Subcategoria>>(
      future: _eventosDestacadosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay eventos destacados'));
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

  String _getImageForEvent(String eventName) {
    final lowerName = eventName.toLowerCase();
    if (lowerName.contains('futbol') || lowerName.contains('fútbol')) {
      return 'assets/images/futbol.jpg';
    } else if (lowerName.contains('basket') ||
        lowerName.contains('básket') ||
        lowerName.contains('baloncesto')) {
      return 'assets/images/basket.jpg';
    } else if (lowerName.contains('voley') || lowerName.contains('voleibol')) {
      return 'assets/images/voley.jpg';
    } else if (lowerName.contains('gastronomía') ||
        lowerName.contains('gastronomia')) {
      return 'assets/images/gastronomia.jpg';
    }
    return 'assets/images/splash_logo.png';
  }

  Widget _buildEventoItem(Subcategoria evento) {
    final imagePath = _getImageForEvent(evento.nombre);
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EquiposScreen(subcategoriaId: evento.subcategoriaId),
          ),
        );
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  evento.nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
