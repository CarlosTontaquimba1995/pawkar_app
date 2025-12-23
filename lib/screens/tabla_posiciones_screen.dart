import 'package:flutter/material.dart';
import 'package:pawkar_app/models/tabla_posicion_model.dart';
import 'package:pawkar_app/services/tabla_posicion_service.dart';
import 'package:pawkar_app/services/equipo_service.dart';
import 'package:pawkar_app/services/serie_service.dart';
import 'package:pawkar_app/models/equipo_model.dart';
import 'package:iconsax/iconsax.dart';

class TablaPosicionesScreen extends StatefulWidget {
  final int subcategoriaId;

  const TablaPosicionesScreen({super.key, required this.subcategoriaId});

  @override
  TablaPosicionesScreenState createState() => TablaPosicionesScreenState();
}

class TablaPosicionesScreenState extends State<TablaPosicionesScreen> {
  bool _isLoading = true;
  String _errorMessage = '';
  List<TablaPosicion> _tablaPosiciones = [];
  bool _showFilters = false;
  // Store series from the API
  final Map<int, String> _series = {};
  // Store teams by series ID
  final Map<int, List<Equipo>> _equiposBySerie = {};
  // Store loading state for teams
  bool _isLoadingEquipos = false;

  // Search parameters
  final _formKey = GlobalKey<FormState>();
  int? _selectedEquipoId;
  int? _selectedSerieId;

  @override
  void initState() {
    super.initState();
    _loadSeries();
  }

  // Load series for the current subcategoria
  Future<void> _loadSeries() async {
    try {
      final service = SerieService();
      final series = await service.getSeriesBySubcategoria(
        widget.subcategoriaId,
      );

      setState(() {
        _series.clear();
        for (var serie in series) {
          _series[serie.serieId] = serie.nombreSerie;
        }
      });

      // Load table positions after series are loaded
      await _loadTablaPosiciones();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar las series: $e';
        _isLoading = false;
      });
    }
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

      // Series are now loaded from SerieService
      // Keep the series selection if it exists

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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcular el ancho disponible
        final screenWidth = constraints.maxWidth;
        final isSmallScreen = screenWidth < 400;
        final isMediumScreen = screenWidth >= 400 && screenWidth < 600;

        // Ajustar el tamaño de fuente según el ancho de la pantalla
        final fontSize = isSmallScreen ? 11.0 : (isMediumScreen ? 12.0 : 13.0);
        
        // Ajustar anchos de columna según el tamaño de la pantalla
        final equipoWidth = isSmallScreen
            ? screenWidth * 0.35
            : screenWidth * 0.3;
        final numberColumnWidth = isSmallScreen
            ? screenWidth * 0.09
            : (isMediumScreen ? screenWidth * 0.08 : screenWidth * 0.07);

        // Crear la tabla con desplazamiento horizontal
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            constraints: BoxConstraints(minWidth: screenWidth),
            child: DataTable(
              columnSpacing: isSmallScreen ? 6 : 8,
              horizontalMargin: isSmallScreen ? 8 : 12,
              headingRowHeight: isSmallScreen ? 40 : 44,
              dataRowMinHeight: isSmallScreen ? 36 : 40,
          headingTextStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
          dataTextStyle: TextStyle(fontSize: fontSize),
          columns: [
                // Columna POS
            DataColumn(
              label: SizedBox(
                width: numberColumnWidth,
                child: const Text(
                  'POS',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              numeric: true,
            ),
                // Columna Equipo
            DataColumn(
              label: SizedBox(
                width: equipoWidth,
                child: const Text('Equipo', overflow: TextOverflow.ellipsis),
              ),
            ),
                // Columna PTS
                DataColumn(
                  label: SizedBox(
                    width: numberColumnWidth,
                    child: const Text(
                      'PTS',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  numeric: true,
                ),
                // Columna PJ
            DataColumn(
              label: SizedBox(
                width: numberColumnWidth,
                child: const Tooltip(
                  message: 'Partidos Jugados',
                  child: Text('PJ', textAlign: TextAlign.center),
                ),
              ),
              numeric: true,
            ),
                // Columna PG
            DataColumn(
              label: SizedBox(
                width: numberColumnWidth,
                child: const Tooltip(
                  message: 'Partidos Ganados',
                  child: Text('PG', textAlign: TextAlign.center),
                ),
              ),
              numeric: true,
            ),
                // Columna PE (solo en pantallas grandes)
                if (!isSmallScreen) 
              DataColumn(
                label: SizedBox(
                  width: numberColumnWidth,
                  child: const Tooltip(
                    message: 'Partidos Empatados',
                    child: Text('PE', textAlign: TextAlign.center),
                  ),
                ),
                numeric: true,
              ),
                // Columna PP (solo en pantallas grandes)
                if (!isSmallScreen) 
              DataColumn(
                label: SizedBox(
                  width: numberColumnWidth,
                  child: const Tooltip(
                    message: 'Partidos Perdidos',
                    child: Text('PP', textAlign: TextAlign.center),
                  ),
                ),
                numeric: true,
              ),
                // Columna GC (solo en pantallas medianas/grandes)
            if (screenWidth > 500)
              DataColumn(
                label: SizedBox(
                  width: numberColumnWidth,
                  child: const Tooltip(
                    message: 'Goles en Contra',
                    child: Text('GC', textAlign: TextAlign.center),
                  ),
                ),
                numeric: true,
              ),
                // Columna DG (solo en pantallas grandes)
            if (screenWidth > 600)
              DataColumn(
                label: SizedBox(
                  width: numberColumnWidth,
                  child: const Tooltip(
                    message: 'Diferencia de Goles',
                    child: Text('DG', textAlign: TextAlign.center),
                  ),
                ),
                numeric: true,
              ),
                // Columna GF (al final)
            DataColumn(
              label: SizedBox(
                width: numberColumnWidth,
                    child: const Tooltip(
                      message: 'Goles a Favor',
                      child: Text('GF', textAlign: TextAlign.center),
                    ),
              ),
              numeric: true,
            ),
          ],
          rows: _tablaPosiciones.map((equipo) {
            return DataRow(
              cells: [
                    // Celda POS
                DataCell(
                  Center(
                    child: Text(
                      '${equipo.posicion}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                    // Celda Equipo
                DataCell(
                  Container(
                    width: equipoWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                        alignment: Alignment.centerLeft,
                    child: Text(
                      equipo.equipoNombre,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                          style: const TextStyle(fontWeight: FontWeight.w500,
                      ),
                        ),
                      ),
                    ),
                    // Celda PTS
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${equipo.puntos}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                    // Celda PJ
                    DataCell(Center(child: Text('${equipo.partidosJugados}'))),
                    // Celda PG
                    DataCell(Center(child: Text('${equipo.victorias}'))),
                    // Celda PE (solo en pantallas grandes)
                    if (!isSmallScreen)
                      DataCell(
                        Center(
                          child: Text(
                            '${equipo.empates}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    // Celda PP (solo en pantallas grandes)
                    if (!isSmallScreen)
                      DataCell(
                        Center(
                          child: Text(
                            '${equipo.derrotas}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    // Celda GC (solo en pantallas medianas/grandes)
                    if (screenWidth > 500)
                      DataCell(Center(child: Text('${equipo.golesEnContra}'))),
                    // Celda DG (solo en pantallas grandes)
                    if (screenWidth > 600)
                      DataCell(
                        Center(child: Text('${equipo.diferenciaGoles}')),
                      ),
                    // Celda GF (al final)
                    DataCell(
                      Center(
                        child: Text(
                          '${equipo.golesAFavor}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
              ],
            );
          }).toList(),
            ),
          ),
        );
      },
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
