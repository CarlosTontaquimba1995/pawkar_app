import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pawkar_app/models/jugador_model.dart';
import 'package:pawkar_app/services/jugador_service.dart';
import 'package:pawkar_app/services/subcategoria_service.dart';
import 'package:pawkar_app/widgets/empty_state_widget.dart';

class JugadoresScreen extends StatefulWidget {
  final int subcategoriaId;
  final bool mostrarSoloSancionados;

  const JugadoresScreen({
    super.key,
    required this.subcategoriaId,
    this.mostrarSoloSancionados = false,
  });

  @override
  _JugadoresScreenState createState() => _JugadoresScreenState();
}

class _JugadoresScreenState extends State<JugadoresScreen> {
  bool _isLoading = true;
  String _errorMessage = '';
  final TextEditingController _searchController = TextEditingController();
  final JugadorService _jugadorService = JugadorService();
  List<Jugador> _jugadores = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadJugadores();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadJugadores({String? searchTerm}) async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final params = JugadorQueryParams(
        search: searchTerm,
        // Puedes agregar más parámetros de paginación si es necesario
        // page: 0,
        // size: 20,
      );

      final response = await _jugadorService.getJugadores(params: params);

      setState(() {
        _jugadores = response.content;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar los jugadores: $e';
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _loadJugadores(searchTerm: query.isEmpty ? null : query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.mostrarSoloSancionados 
              ? 'Jugadores Sancionados' 
              : 'Jugadores',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
            letterSpacing: 0.15,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        surfaceTintColor: const Color.fromARGB(0, 214, 5, 5),
        shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.3),
        scrolledUnderElevation: 1,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar jugador...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Center(child: Text(_errorMessage))
                    : _buildJugadoresList(),
          ),
        ],
      ),
    );
  }

  Widget _buildJugadoresList() {
    if (_jugadores.isEmpty) {
      return EmptyStateWidget(
        message: _searchController.text.isEmpty
            ? 'No hay jugadores registrados'
            : 'No se encontraron jugadores',
        actionLabel: 'Recargar',
        onAction: () => _loadJugadores(),
        icon: Icons.people_outline,
      );
    }

    return ListView.builder(
      itemCount: _jugadores.length,
      itemBuilder: (context, index) {
        final jugador = _jugadores[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(child: Text(jugador.nombre[0].toUpperCase())),
            title: Text(jugador.nombre),
            subtitle: Text(
              jugador.documentoIdentidad.isNotEmpty
                  ? jugador.documentoIdentidad
                  : 'Sin documento',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JugadorDetalleScreen(jugador: jugador),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class JugadorDetalleScreen extends StatefulWidget {
  final Jugador jugador;

  const JugadorDetalleScreen({super.key, required this.jugador});

  @override
  State<JugadorDetalleScreen> createState() => _JugadorDetalleScreenState();
}

class _JugadorDetalleScreenState extends State<JugadorDetalleScreen> {
  String? _subcategoriaNombre;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadSubcategoria();
  }

  Future<void> _loadSubcategoria() async {
    if (widget.jugador.subcategoriaId == null) {
      setState(() {
        _isLoading = false;
        _subcategoriaNombre = 'Sin subcategoría';
      });
      return;
    }

    try {
      final subcategoriaService = SubcategoriaService();
      final subcategoria = await subcategoriaService.getSubcategoriaById(
        widget.jugador.subcategoriaId!,
      );

      if (mounted) {
        setState(() {
          _subcategoriaNombre = subcategoria.nombre;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al cargar la subcategoría: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final theme = Theme.of(context);
    DateTime? fechaNacimiento;

    try {
      fechaNacimiento = DateTime.tryParse(widget.jugador.fechaNacimiento);
    } catch (e) {
      debugPrint('Error al parsear fecha: $e');
    }

    // Calculate age from birthdate
    int? age;
    if (fechaNacimiento != null) {
      final now = DateTime.now();
      age = now.year - fechaNacimiento.year;
      if (now.month < fechaNacimiento.month ||
          (now.month == fechaNacimiento.month &&
              now.day < fechaNacimiento.day)) {
        age--;
      }
    }

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200.0,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      '${widget.jugador.nombre} ${widget.jugador.apellido}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            theme.primaryColor,
                            theme.primaryColor.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                      child: Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white24,
                          child: Text(
                            '${widget.jugador.nombre[0]}${widget.jugador.apellido.isNotEmpty ? widget.jugador.apellido[0] : ''}',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Team and Position Card
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildInfoItem(
                                        Icons.groups,
                                        'Equipo',
                                        widget.jugador.nombreEquipo,
                                      ),
                                      const SizedBox(height: 12),
                                      _buildInfoItem(
                                        Icons.sports_soccer,
                                        'Posición',
                                        widget.jugador.nombreRol,
                                      ),
                                    ],
                                  ),
                                ),
                                if (widget.jugador.numeroCamiseta != null)
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: theme.primaryColor.withValues(
                                        alpha:
                                        0.1,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${widget.jugador.numeroCamiseta}',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Personal Information Card
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Información Personal',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Divider(),
                                const SizedBox(height: 8),
                                _buildInfoItem(
                                  Icons.credit_card,
                                  'Documento',
                                  widget.jugador.documentoIdentidad,
                                ),
                                const SizedBox(height: 12),
                                if (fechaNacimiento != null)
                                  _buildInfoItem(
                                    Icons.cake,
                                    'Fecha de Nacimiento',
                                    '${dateFormat.format(fechaNacimiento)} (${age ?? '?'} años)',
                                  ),
                                if (_subcategoriaNombre != null) ...[
                                  const SizedBox(height: 12),
                                  _buildInfoItem(
                                    Icons.category,
                                    'Categoría',
                                    _subcategoriaNombre!,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),

                        if (_errorMessage.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red[200]!),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.isNotEmpty ? value : 'No especificado',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Old _buildInfoRow method removed as it's no longer needed
}
