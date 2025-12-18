import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/subcategoria_model.dart';
import '../services/categoria_service.dart';
import '../services/subcategoria_service.dart';
import '../widgets/musica_card.dart';

class MusicaScreen extends StatefulWidget {
  const MusicaScreen({super.key});

  @override
  State<MusicaScreen> createState() => _MusicaScreenState();
}

class _MusicaScreenState extends State<MusicaScreen> {
  late Future<List<Subcategoria>> _conciertosFuture;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadConciertos();
  }

  Future<void> _loadConciertos() async {
    try {
      final categoriaService = Provider.of<CategoriaService>(
        context,
        listen: false,
      );
      final subcategoriaService = Provider.of<SubcategoriaService>(
        context,
        listen: false,
      );

      // Get the music category by nemonico
      final categoria = await categoriaService.getCategoriaByNemonico('MUSICA');

      // Get subcategories for this category
      _conciertosFuture = subcategoriaService.getSubcategoriasByCategoria(
        categoria.categoriaId,
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar los conciertos: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Conciertos y Eventos Musicales'),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : _buildConciertosList(),
    );
  }

  Widget _buildConciertosList() {
    return FutureBuilder<List<Subcategoria>>(
      future: _conciertosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              textAlign: TextAlign.center,
            ),
          );
        }

        final conciertos = snapshot.data ?? [];

        if (conciertos.isEmpty) {
          return const Center(
            child: Text(
              'No hay conciertos disponibles en este momento.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: kBottomNavigationBarHeight + 16,
          ),
          itemCount: conciertos.length,
          itemBuilder: (context, index) {
            final concierto = conciertos[index];
            return MusicaCard(subcategoria: concierto);
          },
        );
      },
    );
  }
}
