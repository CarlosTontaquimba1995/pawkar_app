import 'package:flutter/material.dart';
import 'package:pawkar_app/models/subcategoria_model.dart';
import 'package:pawkar_app/screens/matches_screen.dart';
import 'package:pawkar_app/screens/equipos_screen.dart';
import 'package:pawkar_app/screens/jugadores_screen.dart';
import 'package:pawkar_app/screens/plantillas_screen.dart';
import 'package:pawkar_app/screens/tabla_posiciones_screen.dart';

class EventoDetalleScreen extends StatelessWidget {
  final Subcategoria evento;

  const EventoDetalleScreen({super.key, required this.evento});

  bool get isFutbol =>
      evento.nombre.toLowerCase().contains('futbol') ||
      evento.nombre.toLowerCase().contains('fútbol');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(evento.nombre), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Event header with image and description
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12.0),
                    ),
                    child: Image.asset(
                      _getImageForEvent(evento.nombre),
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 180,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      evento.descripcion.isNotEmpty
                          ? evento.descripcion
                          : 'Sin descripción disponible',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Action buttons
            ..._buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActionButtons(BuildContext context) {
    final buttons = <Widget>[];

    // Common actions for all event types
    buttons.addAll([
      _buildActionButton(
        context,
        icon: Icons.sports_soccer,
        label: 'Encuentros',
        onTap: () => _navigateToEncuentros(context),
      ),
      const SizedBox(height: 12),
      _buildActionButton(
        context,
        icon: Icons.people,
        label: 'Equipos',
        onTap: () => _navigateToEquipos(context),
      ),
      const SizedBox(height: 12),
      _buildActionButton(
        context,
        icon: Icons.person,
        label: 'Jugadores',
        onTap: () => _navigateToJugadores(context),
      ),
    ]);

    // Additional actions for Fútbol
    if (isFutbol) {
      buttons.addAll([
        const SizedBox(height: 12),
        _buildActionButton(
          context,
          icon: Icons.format_list_numbered,
          label: 'Tabla de Posiciones',
          onTap: () => _navigateToTablaPosiciones(context),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          context,
          icon: Icons.assignment_ind,
          label: 'Plantillas',
          onTap: () => _navigateToPlantillas(context),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          context,
          icon: Icons.warning_amber_rounded,
          label: 'Jugadores Sancionados',
          onTap: () => _navigateToJugadoresSancionados(context),
        ),
      ]);
    }

    return buttons;
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 24),
      label: Text(label, style: const TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  void _navigateToEncuentros(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MatchesScreen(initialMatches: const []),
      ),
    );
  }

  void _navigateToEquipos(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EquiposScreen(subcategoriaId: evento.subcategoriaId),
      ),
    );
  }

  void _navigateToJugadores(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            JugadoresScreen(subcategoriaId: evento.subcategoriaId),
      ),
    );
  }

  void _navigateToTablaPosiciones(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TablaPosicionesScreen(subcategoriaId: evento.subcategoriaId),
      ),
    );
  }

  void _navigateToPlantillas(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PlantillasScreen(subcategoriaId: evento.subcategoriaId),
      ),
    );
  }

  void _navigateToJugadoresSancionados(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JugadoresScreen(
          subcategoriaId: evento.subcategoriaId,
          mostrarSoloSancionados: true,
        ),
      ),
    );
  }

  // Helper method to get image path based on event name
  String _getImageForEvent(String eventName) {
    final lowerName = eventName.toLowerCase();
    if (lowerName.contains('futbol') || lowerName.contains('fútbol')) {
      return 'assets/images/futbol.jpg';
    } else if (lowerName.contains('basket') ||
        lowerName.contains('básket') ||
        lowerName.contains('baloncesto')) {
      return 'assets/images/basket.jpg';
    } else if (lowerName.contains('voley') || lowerName.contains('voleibol')) {
      return 'assets/images/voley.jpg';
    } else if (lowerName.contains('gastronomía') ||
        lowerName.contains('gastronomia')) {
      return 'assets/images/gastronomia.jpg';
    }
    return 'assets/images/splash_logo.png';
  }
}
