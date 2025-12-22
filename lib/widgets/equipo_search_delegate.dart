import 'package:flutter/material.dart';
import 'package:pawkar_app/models/equipo_model.dart';

class EquipoSearchDelegate extends SearchDelegate<Equipo?> {
  final List<Equipo> equipos;

  EquipoSearchDelegate(this.equipos);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final filteredEquipos = query.isEmpty
        ? equipos
        : equipos
            .where((equipo) => equipo.nombre
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: filteredEquipos.length,
      itemBuilder: (context, index) {
        final equipo = filteredEquipos[index];
        return ListTile(
          title: Text(equipo.nombre),
          onTap: () {
            close(context, equipo);
          },
        );
      },
    );
  }
}
