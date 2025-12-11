import 'package:flutter/material.dart';
import '../models/categoria_model.dart';
import '../services/categoria_service.dart';

class CategoriasSection extends StatefulWidget {
  const CategoriasSection({super.key});

  @override
  CategoriasSectionState createState() => CategoriasSectionState();
}

class CategoriasSectionState extends State<CategoriasSection> {
  late Future<List<Categoria>> _categoriasFuture;
  final CategoriaService _categoriaService = CategoriaService();

  @override
  void initState() {
    super.initState();
    _loadCategorias();
  }

  Future<void> _loadCategorias() async {
    setState(() {
      _categoriasFuture = _categoriaService.getCategorias();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Categorías',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 150, // Slightly increased height to accommodate content
          child: FutureBuilder<List<Categoria>>(
            future: _categoriasFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No hay categorías disponibles'),
                );
              }

              final categorias = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  return _buildCategoriaItem(categorias[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Get the appropriate icon for each category based on nemonico
  IconData _getCategoryIcon(String? nemonico) {
    if (nemonico == null) return Icons.category;

    final nemonicoLower = nemonico.toLowerCase();

    switch (nemonicoLower) {
      case 'sports':
      case 'deportes':
        return Icons.sports_soccer;
      case 'events':
      case 'eventos':
        return Icons.event;
      case 'gastronomy':
      case 'gastronomia':
        return Icons.restaurant;
      case 'futbol':
        return Icons.sports_soccer;
      case 'basquet':
      case 'baloncesto':
        return Icons.sports_basketball;
      case 'tenis':
        return Icons.sports_tennis;
      case 'voley':
      case 'voleybol':
        return Icons.sports_volleyball;
      case 'beisbol':
        return Icons.sports_baseball;
      case 'ciclismo':
        return Icons.directions_bike;
      case 'natacion':
        return Icons.pool;
      case 'atletismo':
        return Icons.directions_run;
      default:
        return Icons.category;
    }
  }

  Widget _buildCategoriaItem(Categoria categoria) {
    return Container(
      width: 120,
      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {
            // Handle category tap
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                margin: const EdgeInsets.only(top: 8, bottom: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getCategoryIcon(categoria.nemonico),
                  size: 30,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  bottom: 12.0,
                ),
                child: Text(
                  categoria.nombre,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
