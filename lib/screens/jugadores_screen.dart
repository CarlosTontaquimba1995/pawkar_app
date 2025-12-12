import 'package:flutter/material.dart';

class JugadoresScreen extends StatefulWidget {
  final int subcategoriaId;
  final bool mostrarSoloSancionados;

  const JugadoresScreen({
    Key? key,
    required this.subcategoriaId,
    this.mostrarSoloSancionados = false,
  }) : super(key: key);

  @override
  _JugadoresScreenState createState() => _JugadoresScreenState();
}

class _JugadoresScreenState extends State<JugadoresScreen> {
  bool _isLoading = true;
  String _errorMessage = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadJugadores();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadJugadores() async {
    // TODO: Implementar carga de jugadores desde el servicio
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mostrarSoloSancionados 
              ? 'Jugadores Sancionados' 
              : 'Jugadores',
        ),
        centerTitle: true,
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
              onChanged: (value) {
                // TODO: Implementar búsqueda
              },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementar adición de nuevo jugador
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _buildJugadoresList() {
    // TODO: Reemplazar con lista real de jugadores
    return Center(
      child: Text(
        widget.mostrarSoloSancionados
            ? 'No hay jugadores sancionados'
            : 'No hay jugadores registrados',
      ),
    );
  }
}
