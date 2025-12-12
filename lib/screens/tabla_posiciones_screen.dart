import 'package:flutter/material.dart';
import 'package:pawkar_app/models/tabla_posicion_model.dart';
import 'package:pawkar_app/services/tabla_posicion_service.dart';
import 'package:intl/intl.dart';

class TablaPosicionesScreen extends StatefulWidget {
  final int subcategoriaId;

  const TablaPosicionesScreen({Key? key, required this.subcategoriaId})
    : super(key: key);

  @override
  _TablaPosicionesScreenState createState() => _TablaPosicionesScreenState();
}

class _TablaPosicionesScreenState extends State<TablaPosicionesScreen> {
  bool _isLoading = true;
  String _errorMessage = '';
  List<TablaPosicion> _tablaPosiciones = [];

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

  Future<void> _loadTablaPosiciones({bool isSearch = false}) async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // Create search params
      final searchParams = SearchParams(
        subcategoriaId: widget.subcategoriaId,
        equipoId: _selectedEquipoId,
        serieId: _selectedSerieId,
      );

      // Call the search API
      final service = TablaPosicionService();
      _tablaPosiciones = await service.search(searchParams);

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

  // Reset search filters
  void _resetSearch() {
    setState(() {
      _selectedEquipoId = null;
      _selectedSerieId = null;
      _fechaInicio = null;
      _fechaFin = null;
    });
    _loadTablaPosiciones();
  }

  // Build search filters
  Widget _buildSearchFilters() {
    return Card(
      margin: const EdgeInsets.all(8.0),
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
                    child: DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Equipo',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedEquipoId,
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Todos los equipos'),
                        ),
                        // TODO: Replace with actual teams from your data source
                        // for (final equipo in equiposList)
                        //   DropdownMenuItem(
                        //     value: equipo.id,
                        //     child: Text(equipo.nombre),
                        //   ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedEquipoId = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Serie',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedSerieId,
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Todas las series'),
                        ),
                        // TODO: Replace with actual series from your data source
                        // for (final serie in seriesList)
                        //   DropdownMenuItem(
                        //     value: serie.id,
                        //     child: Text(serie.nombre),
                        //   ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedSerieId = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(
                        _fechaInicio == null
                            ? 'Fecha inicio'
                            : DateFormat('dd/MM/yyyy').format(_fechaInicio!),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          setState(() {
                            _fechaInicio = date;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        _fechaFin == null
                            ? 'Fecha fin'
                            : DateFormat('dd/MM/yyyy').format(_fechaFin!),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          setState(() {
                            _fechaFin = date;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _resetSearch,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Limpiar'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _loadTablaPosiciones(isSearch: true);
                        }
                      },
                      icon: const Icon(Icons.search),
                      label: const Text('Buscar'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
            icon: const Icon(Icons.search),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: _buildSearchFilters(),
                  ),
                ),
              );
            },
          ),
        ],
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : SingleChildScrollView(
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
            ),
    );
  }
}
