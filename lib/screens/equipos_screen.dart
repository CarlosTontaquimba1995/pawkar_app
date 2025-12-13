import 'package:flutter/material.dart';
import 'package:pawkar_app/models/equipo_model.dart';
import 'package:pawkar_app/services/equipo_service.dart';
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
  String _errorMessage = '';
  List<Equipo> _equipos = [];
  final EquipoService _equipoService = EquipoService();

  @override
  void initState() {
    super.initState();
    _loadEquipos();
  }

  Future<void> _loadEquipos() async {
    try {
      final response = await _equipoService.getEquiposBySubcategoria(
        widget.subcategoriaId,
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

  Widget _buildBody() {
    if (_isLoading) {
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.group_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No hay equipos disponibles',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _handleRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: _buildEquiposList(),
    );
  }
  
  Widget _buildEquiposList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: _equipos.length,
      itemBuilder: (context, index) {
        final equipo = _equipos[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: const Icon(Icons.people, color: Colors.blueGrey),
            ),
            title: Text(
              equipo.nombre,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              '${equipo.jugadoresCount} ${equipo.jugadoresCount == 1 ? 'jugador' : 'jugadores'}\n${equipo.serieNombre}',
              style: const TextStyle(fontSize: 13),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              // TODO: Navegar al detalle del equipo si es necesario
            },
          ),
        );
      },
    );
  }
}
