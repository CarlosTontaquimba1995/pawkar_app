import 'package:flutter/material.dart';
import 'package:pawkar_app/models/equipo_model.dart';
import 'package:pawkar_app/services/equipo_service.dart';

class EquiposScreen extends StatefulWidget {
  final int subcategoriaId;

  const EquiposScreen({
    Key? key,
    required this.subcategoriaId,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipos'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _buildEquiposList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementar creación de nuevo equipo
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildEquiposList() {
    if (_equipos.isEmpty) {
      return const Center(child: Text('No hay equipos disponibles'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: _equipos.length,
      itemBuilder: (context, index) {
        final equipo = _equipos[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.people, color: Colors.grey),
            ),
            title: Text(equipo.nombre),
            subtitle: Text('${equipo.jugadoresCount} jugadores'),
            onTap: () {
              // TODO: Navegar al detalle del equipo si es necesario
            },
          ),
        );
      },
    );
  }
}
