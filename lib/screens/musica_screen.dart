import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/subcategoria_model.dart';
import '../services/subcategoria_service.dart';

class MusicaScreen extends StatefulWidget {
  final int subcategoriaId;

  const MusicaScreen({super.key, required this.subcategoriaId});

  @override
  State<MusicaScreen> createState() => _MusicaScreenState();
}

class _MusicaScreenState extends State<MusicaScreen> {
  final SubcategoriaService _subcategoriaService = SubcategoriaService();
  late Future<Subcategoria> _eventoFuture;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadEvento();
  }

  Future<void> _loadEvento() async {
    try {
      final evento = await _subcategoriaService.getSubcategoriaById(
        widget.subcategoriaId,
      );
      setState(() {
        _eventoFuture = Future.value(evento);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar los detalles del evento: $e';
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
        title: const Text('Detalles del Evento'),
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
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : FutureBuilder<Subcategoria>(
              future: _eventoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No se encontró el evento'));
                }

                final evento = snapshot.data!;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event details
                      Text(
                        evento.nombre,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (evento.descripcion.isNotEmpty) ...[
                        Text(evento.descripcion),
                        const SizedBox(height: 16),
                      ],
                          
                      // Date and location
                      if (evento.fechaHora != null ||
                          evento.ubicacion.isNotEmpty) ...[
                        const Text(
                          'Información del evento',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (evento.fechaHora != null) ...[
                          ListTile(
                            leading: const Icon(Icons.calendar_today),
                            title: const Text('Fecha y Hora'),
                            subtitle: Text(_formatDate(evento.fechaHora!)),
                          ),
                        ],
                        if (evento.ubicacion.isNotEmpty) ...[
                          ListTile(
                            leading: const Icon(Icons.location_on),
                            title: const Text('Ubicación'),
                            subtitle: Text(evento.ubicacion),
                          ),
                        ],
                        const Divider(),
                        const SizedBox(height: 8),
                      ],
                          
                      // Artists section
                      Text(
                        'Artistas',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (evento.artistas.isEmpty)
                        const Text('No hay artistas programados')
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: evento.artistas.length,
                          itemBuilder: (context, index) {
                            final artista = evento.artistas[index];
                            return ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(artista.nombre),
                              subtitle: Text(artista.genero),
                            );
                          },
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  String _formatDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('EEEE d MMMM y, hh:mm a', 'es_ES').format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }
}
