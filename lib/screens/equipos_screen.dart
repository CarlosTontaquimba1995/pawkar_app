import 'package:flutter/material.dart';
import 'package:pawkar_app/models/equipo_model.dart';
import 'package:pawkar_app/models/serie_model.dart';
import 'package:pawkar_app/services/equipo_service.dart';
import 'package:pawkar_app/services/serie_service.dart';
import 'package:pawkar_app/widgets/error_widget.dart' as custom;

class EquiposScreen extends StatefulWidget {
  final int subcategoriaId;

  const EquiposScreen({
    super.key,
    required this.subcategoriaId,
  });

  @override
  _EquiposScreenState createState() => _EquiposScreenState();
}

class _EquiposScreenState extends State<EquiposScreen> {
  bool _isLoading = true;
  bool _isLoadingSeries = true;
  String _errorMessage = '';
  List<Equipo> _equipos = [];
  List<Serie> _series = [];
  int? _selectedSerieId;
  final EquipoService _equipoService = EquipoService();
  final SerieService _serieService = SerieService();

  @override
  void initState() {
    super.initState();
    _loadSeries();
  }

  Future<void> _loadSeries() async {
    try {
      final series = await _serieService.getSeriesBySubcategoria(
        widget.subcategoriaId,
      );

      setState(() {
        _series = series;
        _isLoadingSeries = false;
      });

      // Load equipos after series are loaded
      _loadEquipos();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar las series: $e';
        _isLoading = false;
        _isLoadingSeries = false;
      });
    }
  }

  Future<void> _loadEquipos() async {
    if (_isLoadingSeries) return; // Wait for series to load first

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final response = await _equipoService.getEquiposBySubcategoria(
        widget.subcategoriaId,
        serieId: _selectedSerieId,
      );

      setState(() {
        _equipos = response.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar los equipos: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    await _loadEquipos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipos'),
        centerTitle: true,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementar creación de nuevo equipo
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSeriesFilter() {
    if (_isLoadingSeries) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: LinearProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DropdownButtonFormField<int>(
        value: _selectedSerieId,
        decoration: const InputDecoration(
          labelText: 'Filtrar por serie',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        ),
        items: [
          const DropdownMenuItem(value: null, child: Text('Todas las series')),
          ..._series.map((serie) {
            return DropdownMenuItem(
              value: serie.serieId,
              child: Text(serie.nombreSerie),
            );
          }).toList(),
        ],
        onChanged: (value) {
          setState(() {
            _selectedSerieId = value;
          });
          _loadEquipos();
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _equipos.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: custom.ErrorWidget(
          message: _errorMessage,
          onRetry: _handleRefresh,
        ),
      );
    }

    if (_equipos.isEmpty) {
      return Column(
        children: [
          _buildSeriesFilter(),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.group_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    _selectedSerieId == null
                        ? 'No hay equipos disponibles'
                        : 'No hay equipos en esta serie',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _handleRefresh,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: _buildEquiposList(),
    );
  }
  
  Widget _buildEquiposList() {
    return Column(
      children: [
        _buildSeriesFilter(),
        Expanded(
          child: ListView.builder(
            itemCount: _equipos.length,
            itemBuilder: (context, index) {
              final equipo = _equipos[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.sports_soccer)),
                  title: Text(equipo.nombre),
                  onTap: () {
                    // TODO: Navegar al detalle del equipo
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
