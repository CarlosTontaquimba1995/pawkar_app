import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawkar_app/models/plantilla_model.dart';
import 'package:pawkar_app/services/plantilla_service.dart';

class PlantillasScreen extends StatefulWidget {
  final int subcategoriaId;
  final int equipoId;
  final String equipoNombre;

  const PlantillasScreen({
    super.key,
    required this.subcategoriaId,
    required this.equipoId,
    required this.equipoNombre,
  });

  @override
  _PlantillasScreenState createState() => _PlantillasScreenState();
}

class _PlantillasScreenState extends State<PlantillasScreen> {
  bool _isLoading = true;
  bool _isRefreshing = false;
  String _errorMessage = '';
  List<Plantilla> _jugadores = [];
  final PlantillaService _plantillaService = PlantillaService();

  @override
  void initState() {
    super.initState();
    _loadPlantillas();
  }

  Future<void> _loadPlantillas() async {
    try {
      if (!mounted) return;
      
      setState(() {
        if (!_isRefreshing) _isLoading = true;
        _errorMessage = '';
      });

      final jugadores = await _plantillaService.getPlantillasByEquipo(
        widget.equipoId,
      );
      
      if (!mounted) return;
      setState(() {
        _jugadores = jugadores;
        _isLoading = false;
        _isRefreshing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error al cargar la plantilla: ${e.toString()}';
        _isLoading = false;
        _isRefreshing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plantilla: ${widget.equipoNombre}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading
                ? null
                : () {
                    setState(() => _isRefreshing = true);
                    _loadPlantillas();
                  },
          ),
        ],
      ),
      body: _buildContent(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implementar agregar jugador a la plantilla
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Agregar jugador a la plantilla')),
          );
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Agregar Jugador'),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _loadPlantillas,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (_jugadores.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 72,
              color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay jugadores en la plantilla',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Presiona el botón + para agregar jugadores',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPlantillas,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _jugadores.length,
        itemBuilder: (context, index) {
          final jugador = _jugadores[index];
          return _buildJugadorTile(jugador);
        },
      ),
    );
  }

  Widget _buildJugadorTile(Plantilla jugador) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tieneSancion = jugador.tieneSancion;
    final sancion = tieneSancion && jugador.sanciones.isNotEmpty
        ? jugador.sanciones.first
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () => _mostrarOpcionesJugador(jugador),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Player number in circle avatar
              CircleAvatar(
                backgroundColor: colorScheme.primaryContainer,
                child: Text(
                  '${jugador.numeroCamiseta}',
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Player name and position
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jugador.jugadorNombreCompleto.isNotEmpty
                          ? jugador.jugadorNombreCompleto
                          : 'Jugador sin nombre',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: tieneSancion ? colorScheme.error : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Position chip
                        _buildInfoChip(
                          icon: Icons.flag,
                          label: jugador.rolNombre.isNotEmpty
                              ? jugador.rolNombre
                              : 'Sin posición',
                        ),
                        // Sanction indicator
                        if (tieneSancion && sancion != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: sancion.tipoSancion == 'TARJETA_ROJA'
                                  ? Colors.red[700]
                                  : Colors.amber[600],
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: sancion.tipoSancion == 'TARJETA_ROJA'
                                    ? Colors.red[900]!
                                    : Colors.amber[800]!,
                                width: 1,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Chevron icon to indicate tappable
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    bool isError = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isError
            ? Theme.of(context).colorScheme.errorContainer.withOpacity(0.2)
            : Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isError
                ? Theme.of(context).colorScheme.onErrorContainer
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isError
                  ? Theme.of(context).colorScheme.onErrorContainer
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  int _calcularEdad(String? fechaNacimiento) {
    if (fechaNacimiento == null || fechaNacimiento.isEmpty) return 0;

    try {
      final fecha = DateTime.parse(fechaNacimiento);
      final hoy = DateTime.now();
      int edad = hoy.year - fecha.year;
      final mes = hoy.month - fecha.month;

      if (mes < 0 || (mes == 0 && hoy.day < fecha.day)) {
        edad--;
      }

      return edad;
    } catch (e) {
      debugPrint('Error al calcular la edad: $e');
      return 0;
    }
  }

  void _mostrarOpcionesJugador(Plantilla jugador) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (jugador.tieneSancion)
                ListTile(
                  leading: const Icon(Icons.gavel),
                  title: const Text('Ver sanciones'),
                  onTap: () {
                    Navigator.pop(context);
                    _mostrarSanciones(jugador);
                  },
                ),
              if (!jugador.tieneSancion) const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  void _mostrarSanciones(Plantilla jugador) {
    if (jugador.sanciones.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El jugador no tiene sanciones registradas'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sanciones de ${jugador.jugadorNombreCompleto}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: jugador.sanciones
                .map(
                  (sancion) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sancion.tipoSancion,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('Motivo: ${sancion.motivo}'),
                          if (sancion.detalleSancion.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text('Detalle: ${sancion.detalleSancion}'),
                          ],
                          const SizedBox(height: 4),
                          Text(
                            'Fecha: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(sancion.fechaRegistro))}',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
