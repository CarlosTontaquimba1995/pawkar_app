import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pawkar_app/extensions/string_extensions.dart';
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
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Plantilla: ${widget.equipoNombre}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
        shadowColor: theme.colorScheme.shadow.withOpacity(0.3),
        scrolledUnderElevation: 1,
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
        onTap: tieneSancion ? () => _mostrarSanciones(jugador) : null,
        onLongPress: !tieneSancion
            ? () => _mostrarOpcionesJugador(jugador)
            : null,
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
                      ],
                    ),
                  ],
                ),
              ),
              // Sanction indicator moved here to the right side
              if (tieneSancion && sancion != null)
                Container(
                  width: 16, // Made narrower
                  height: 24, // Kept the same height
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: sancion.tipoSancion == 'TARJETA_ROJA'
                        ? Colors.red[700]
                        : Colors.amber[600],
                    borderRadius: BorderRadius.circular(
                      2,
                    ), // More subtle border radius
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
            : Theme.of(context).colorScheme.surfaceContainerHighest,
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
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.gavel_rounded,
                      color: colorScheme.onPrimaryContainer,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sanciones del Jugador',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          jugador.jugadorNombreCompleto,
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Sanciones List
              ...jugador.sanciones.map((sancion) {
                final isRedCard = sancion.tipoSancion == 'TARJETA_ROJA';
                final cardColor = isRedCard
                    ? Colors.red.shade50
                    : Colors.amber.shade50;
                final borderColor = isRedCard
                    ? Colors.red.shade200
                    : Colors.amber.shade200;
                final iconColor = isRedCard
                    ? Colors.red.shade700
                    : Colors.amber.shade700;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header con tipo de sanción
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: borderColor.withOpacity(0.3),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(11),
                            topRight: Radius.circular(11),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isRedCard
                                  ? Icons.block
                                  : Icons.warning_amber_rounded,
                              color: iconColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              sancion.tipoSancion
                                  .replaceAll('_', ' ')
                                  .toTitleCase(),
                              style: textTheme.titleMedium?.copyWith(
                                color: iconColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              DateFormat(
                                'dd MMM yyyy',
                              ).format(DateTime.parse(sancion.fechaRegistro)),
                              style: textTheme.bodySmall?.copyWith(
                                color: iconColor.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Detalles de la sanción
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Motivo
                            _buildDetailRow(
                              context,
                              icon: Icons.info_outline_rounded,
                              label: 'Motivo',
                              value: sancion.motivo,
                            ),
                            
                            // Detalle si existe
                            if (sancion.detalleSancion.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              _buildDetailRow(
                                context,
                                icon: Icons.description_rounded,
                                label: 'Detalles',
                                value: sancion.detalleSancion,
                                isMultiline: true,
                              ),
                            ],

                            // Fecha de registro
                            const SizedBox(height: 10),
                            _buildDetailRow(
                              context,
                              icon: Icons.calendar_today_rounded,
                              label: 'Fecha de registro',
                              value:
                                  DateFormat("EEEE, d 'de' MMMM 'de' y", 'es')
                                      .format(
                                        DateTime.parse(sancion.fechaRegistro),
                                      )
                                      .capitalizeFirst(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // Footer
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isMultiline = false,
  }) {
    // Use explicit dark colors that will be visible on light backgrounds
    final textColor = const Color(0xFF212121); // Dark gray
    final labelColor = const Color(
      0xFF424242,
    ); // Slightly lighter gray for labels

    return Row(
      crossAxisAlignment: isMultiline
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 18,
          color: labelColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: isMultiline
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$label:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: labelColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              : RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: '$label: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: labelColor,
                        ),
                      ),
                      TextSpan(text: value),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
