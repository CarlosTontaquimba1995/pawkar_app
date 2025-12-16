import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/categoria_model.dart';
import '../models/subcategoria_model.dart';
import '../screens/evento_detalle_screen.dart';
import '../screens/eventos_screen.dart';
import '../services/categoria_service.dart';
import '../services/subcategoria_service.dart';

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
        SizedBox(
          height: 150,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 2.0,
                ),
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
    
    // Debug log to see the nemonico being processed
    debugPrint('Nemonico: $nemonicoLower');

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
      case 'music':
      case 'musica':
      case 'msica':
        return Icons.music_note;
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
          onTap: () => _onCategoryTap(categoria),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                margin: const EdgeInsets.only(top: 8, bottom: 6),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withOpacity(0.2),
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

  Future<void> _onCategoryTap(Categoria categoria) async {
    if (categoria.nemonico?.toLowerCase() == 'deportes') {
      try {
        final subcategoriaService = Provider.of<SubcategoriaService>(
          context,
          listen: false,
        );
        final subcategorias = await subcategoriaService
            .getSubcategoriasByCategoria(categoria.categoriaId);

        if (!mounted) return;

        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) =>
              _buildSubcategoriesBottomSheet(categoria, subcategorias),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar subcategorías: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } else if (categoria.nemonico?.toLowerCase() == 'eventos') {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EventosScreen()),
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Próximamente: ${categoria.nombre}')),
        );
      }
    }
  }

  Widget _buildSubcategoriesBottomSheet(
    Categoria categoria,
    List<Subcategoria> subcategorias,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'Subcategorías - ${categoria.nombre}',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (subcategorias.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Center(child: Text('No hay subcategorías disponibles')),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: subcategorias.length,
              itemBuilder: (context, index) {
                final subcategoria = subcategorias[index];
                return _buildSubcategoryTile(subcategoria, colorScheme);
              },
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Get the appropriate icon for each subcategory based on its name
  IconData _getSubcategoryIcon(String subcategoryName) {
    final name = subcategoryName.toLowerCase();

    if (name.contains('futbol') || name.contains('fútbol')) {
      return Icons.sports_soccer;
    } else if (name.contains('básquet') ||
        name.contains('basquet') ||
        name.contains('baloncesto') ||
        name.contains('básquetbol') ||
        name.contains('basquetbol') ||
        name.contains('básket') ||
        name.contains('basket')) {
      return Icons.sports_basketball;
    } else if (name.contains('tenis') || name.contains('ténis')) {
      return Icons.sports_tennis;
    } else if (name.contains('voley') ||
        name.contains('vóley') ||
        name.contains('voleibol')) {
      return Icons.sports_volleyball;
    } else if (name.contains('béisbol') || name.contains('beisbol')) {
      return Icons.sports_baseball;
    } else if (name.contains('natación') || name.contains('natacion')) {
      return Icons.pool;
    } else if (name.contains('ciclismo')) {
      return Icons.directions_bike;
    } else if (name.contains('atletismo')) {
      return Icons.directions_run;
    } else if (name.contains('fútbol sala') ||
        name.contains('futbol sala') ||
        name.contains('futsal')) {
      return Icons.sports_soccer;
    } else if (name.contains('balonmano') || name.contains('handball')) {
      return Icons.sports_handball;
    } else if (name.contains('golf')) {
      return Icons.golf_course;
    } else if (name.contains('escalada') || name.contains('escalar')) {
      return Icons.terrain;
    } else {
      return Icons.sports;
    }
  }

  Widget _buildSubcategoryTile(
    Subcategoria subcategoria,
    ColorScheme colorScheme,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getSubcategoryIcon(subcategoria.nombre),
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          subcategoria.nombre,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(subcategoria.descripcion),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventoDetalleScreen(evento: subcategoria),
            ),
          );
        },
      ),
    );
  }
}
