import 'package:flutter/material.dart';
import 'package:pawkar_app/models/tabla_posicion_model.dart';
import 'package:pawkar_app/services/tabla_posicion_service.dart';
import 'package:pawkar_app/services/equipo_service.dart';
import 'package:pawkar_app/models/equipo_model.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';

class TablaPosicionesScreen extends StatefulWidget {
  final int subcategoriaId;

  const TablaPosicionesScreen({super.key, required this.subcategoriaId});

  @override
  _TablaPosicionesScreenState createState() => _TablaPosicionesScreenState();
}

class _TablaPosicionesScreenState extends State<TablaPosicionesScreen> {
  bool _isLoading = true;
  String _errorMessage = '';
  List<TablaPosicion> _tablaPosiciones = [];
  bool _showFilters = false;
  // Store unique series from the API response
  final Map<int, String> _series = {};
  // Store teams by series ID
  final Map<int, List<Equipo>> _equiposBySerie = {};
  // Store loading state for teams
  bool _isLoadingEquipos = false;

  // Search parameters
  final _formKey = GlobalKey<FormState>();
  int? _selectedEquipoId;
  int? _selectedSerieId;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  @override
  void initState() {
    super.initState();
    _loadTablaPosiciones();
  }

  // Load teams for the selected series
  Future<void> _loadEquiposBySerie(int? serieId) async {
    if (serieId == null) {
      setState(() {
        _selectedEquipoId = null;
        _equiposBySerie.clear();
      });
      return;
    }

    // Return if teams for this series are already loaded
    if (_equiposBySerie.containsKey(serieId)) {
      return;
    }

    setState(() {
      _isLoadingEquipos = true;
    });

    try {
      final service = EquipoService();
      final response = await service.getEquiposBySerie(serieId);

      setState(() {
        _equiposBySerie[serieId] = response.data;
        _isLoadingEquipos = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar los equipos: $e';
        _isLoadingEquipos = false;
      });
    }
  }

  Future<void> _loadTablaPosiciones({bool isSearch = false}) async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // Always include subcategoriaId from the widget
      final searchParams = SearchParams(
        subcategoriaId: widget.subcategoriaId,
        equipoId: _selectedEquipoId,
        serieId: _selectedSerieId,
      );

      debugPrint('Searching with params: ${searchParams.toJson()}');
      
      // Call the search API
      final service = TablaPosicionService();
      _tablaPosiciones = await service.search(searchParams);

      // Extract unique series from the response
      _series.clear();
      for (var posicion in _tablaPosiciones) {
        _series[posicion.serieId] = posicion.serieNombre;
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage =
            'Error al cargar la tabla de posiciones: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _resetSearch() {
    setState(() {
      _selectedEquipoId = null;
      _selectedSerieId = null;
      _fechaInicio = null;
      _fechaFin = null;
      _showFilters = false;
    });
    _loadTablaPosiciones();
  }

  Widget _buildSearchFilters() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filtros de Búsqueda',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Fecha inicio'),
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _fechaInicio ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              setState(() {
                                _fechaInicio = date;
                                if (_fechaFin != null &&
                                    _fechaFin!.isBefore(date)) {
                                  _fechaFin = null;
                                }
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            child: Text(
                              _fechaInicio != null
                                  ? DateFormat(
                                      'dd/MM/yyyy',
                                    ).format(_fechaInicio!)
                                  : 'Seleccionar fecha',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Fecha fin'),
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate:
                                  _fechaFin ?? (_fechaInicio ?? DateTime.now()),
                              firstDate: _fechaInicio ?? DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              setState(() {
                                _fechaFin = date;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            child: Text(
                              _fechaFin != null
                                  ? DateFormat('dd/MM/yyyy').format(_fechaFin!)
                                  : 'Seleccionar fecha',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Series dropdown
              DropdownButtonFormField<int>(
                value: _selectedSerieId,
                decoration: const InputDecoration(
                  labelText: 'Serie',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Todas las series'),
                  ),
                  ..._series.entries
                      .map(
                        (entry) => DropdownMenuItem<int>(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      )
                      .toList(),
                  //   ),
                ],
                onChanged: (value) async {
                  setState(() {
                    _selectedSerieId = value;
                    _selectedEquipoId = null;
                  });
                  // Load teams for the selected series
                  await _loadEquiposBySerie(value);
                },
              ),
              const SizedBox(height: 16),
              // Teams dropdown - only enabled when a series is selected
              DropdownButtonFormField<int>(
                value: _selectedEquipoId,
                decoration: InputDecoration(
                  labelText: 'Equipo',
                  border: const OutlineInputBorder(),
                  hintText: _selectedSerieId == null
                      ? 'Seleccione una serie primero'
                      : _isLoadingEquipos
                      ? 'Cargando equipos...'
                      : 'Seleccione un equipo',
                ),
                items: _selectedSerieId == null || _isLoadingEquipos
                    ? null // Don't show teams until a series is selected or while loading
                    : [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Todos los equipos'),
                        ),
                        ...(_equiposBySerie[_selectedSerieId] ?? [])
                            .map(
                              (equipo) => DropdownMenuItem<int>(
                                value: equipo.equipoId,
                                child: Text(equipo.nombre),
                              ),
                            )
                            .toList(),
                      ],
                onChanged: _selectedSerieId == null || _isLoadingEquipos
                    ? null // Disable dropdown if no series is selected or while loading
                    : (value) {
                        setState(() {
                          _selectedEquipoId = value;
                        });
                      },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _loadTablaPosiciones(isSearch: true);
                        setState(() => _showFilters = false);
                      },
                      icon: const Icon(Icons.search),
                      label: const Text('Aplicar filtros'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: _resetSearch,
                    child: const Text('Limpiar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTablaPosiciones() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Pos')),
          DataColumn(label: Text('Equipo')),
          DataColumn(label: Text('PJ'), numeric: true),
          DataColumn(label: Text('PG'), numeric: true),
          DataColumn(label: Text('PE'), numeric: true),
          DataColumn(label: Text('PP'), numeric: true),
          DataColumn(label: Text('GF'), numeric: true),
          DataColumn(label: Text('GC'), numeric: true),
          DataColumn(label: Text('DG'), numeric: true),
          DataColumn(label: Text('PTS'), numeric: true),
        ],
        rows: _tablaPosiciones.map((equipo) {
          return DataRow(
            cells: [
              DataCell(Text('${equipo.posicion}')),
              DataCell(Text(equipo.equipoNombre)),
              DataCell(Text('${equipo.partidosJugados}')),
              DataCell(Text('${equipo.victorias}')),
              DataCell(Text('${equipo.empates}')),
              DataCell(Text('${equipo.derrotas}')),
              DataCell(Text('${equipo.golesAFavor}')),
              DataCell(Text('${equipo.golesEnContra}')),
              DataCell(Text('${equipo.diferenciaGoles}')),
              DataCell(
                Text(
                  '${equipo.puntos}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabla de Posiciones'),
        actions: [
          IconButton(
            icon: Icon(
              _showFilters ? Icons.close : Iconsax.filter,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              setState(() => _showFilters = !_showFilters);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTablaPosiciones,
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (_showFilters) _buildSearchFilters(),
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            )
          else
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildTablaPosiciones(),
            ),
        ],
      ),
    );
  }
}
