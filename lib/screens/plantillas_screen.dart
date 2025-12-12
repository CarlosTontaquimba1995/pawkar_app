import 'package:flutter/material.dart';

class PlantillasScreen extends StatefulWidget {
  final int subcategoriaId;

  const PlantillasScreen({Key? key, required this.subcategoriaId})
    : super(key: key);

  @override
  _PlantillasScreenState createState() => _PlantillasScreenState();
}

class _PlantillasScreenState extends State<PlantillasScreen> {
  bool _isLoading = true;
  String _errorMessage = '';
  List<Map<String, dynamic>> _equipos = [];
  final Map<int, bool> _expandedEquipos = {};

  @override
  void initState() {
    super.initState();
    _loadPlantillas();
  }

  Future<void> _loadPlantillas() async {
    try {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // TODO: Implementar carga de plantillas desde el servicio
      // Ejemplo: _equipos = await PlantillaService.getPlantillas(widget.subcategoriaId);

      // Datos de ejemplo (eliminar cuando se implemente el servicio real)
      await Future.delayed(const Duration(seconds: 1));
      
      if (!mounted) return;
      _equipos = []; // Aquí irían los datos reales

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error al cargar las plantillas: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantillas de Equipos'),
        centerTitle: true,
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
          child: Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (_equipos.isEmpty) {
      return const Center(child: Text('No hay plantillas disponibles'));
    }

    return RefreshIndicator(
      onRefresh: _loadPlantillas,
      child: ListView.builder(
        itemCount: _equipos.length,
        itemBuilder: (context, index) {
          final equipo = _equipos[index];
          final isExpanded = _expandedEquipos[equipo['id']] ?? false;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ExpansionTile(
              leading: CircleAvatar(
                // TODO: Mostrar escudo del equipo si está disponible
                // backgroundImage: NetworkImage(equipo['escudoUrl']),
                child: Text(equipo['nombre'][0]),
              ),
              title: Text(
                equipo['nombre'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${equipo['cantidadJugadores']} jugadores'),
              trailing: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              onExpansionChanged: (expanded) {
                setState(() {
                  _expandedEquipos[equipo['id']] = expanded;
                });
              },
              children: [_buildJugadoresList(equipo['jugadores'] ?? [])],
            ),
          );
        },
      ),
    );
  }

  Widget _buildJugadoresList(List<dynamic> jugadores) {
    if (jugadores.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No hay jugadores en esta plantilla'),
      );
    }

    return Column(
      children: jugadores.map<Widget>((jugador) {
        return ListTile(
          leading: const CircleAvatar(
            // TODO: Mostrar foto del jugador si está disponible
            child: Icon(Icons.person),
          ),
          title: Text('${jugador['nombre']} ${jugador['apellido']}'),
          subtitle: Text(
            'Dorsal: ${jugador['dorsal']} • ${jugador['posicion']}',
          ),
          trailing: jugador['capitan'] == true
              ? const Icon(Icons.star, color: Colors.amber)
              : null,
          onTap: () {
            // TODO: Navegar al detalle del jugador
          },
        );
      }).toList(),
    );
  }
}
