import 'package:flutter/material.dart';
import 'package:pawkar_app/models/subcategoria_model.dart';
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
      return []; // Return empty list on error
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
          height: 150,
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

  Widget _buildEventoItem(Subcategoria evento) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                evento.nombre,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (evento.descripcion.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    evento.descripcion,
                    style: const TextStyle(fontSize: 12),
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
