import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _loadEquipos();
  }

  Future<void> _loadEquipos() async {
    // TODO: Implementar carga de equipos desde el servicio
    setState(() {
      _isLoading = false;
    });
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
    // TODO: Reemplazar con lista real de equipos
    return const Center(
      child: Text('No hay equipos registrados'),
    );
  }
}
