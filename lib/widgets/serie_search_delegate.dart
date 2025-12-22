import 'package:flutter/material.dart';
import 'package:pawkar_app/models/serie_model.dart';

class SerieSearchDelegate extends SearchDelegate<Serie?> {
  final List<Serie> series;

  SerieSearchDelegate(this.series);

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
    final results = query.isEmpty
        ? series
        : series
              .where(
                (serie) => serie.nombreSerie.toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final serie = results[index];
        return ListTile(
          title: Text(serie.nombreSerie),
          onTap: () {
            close(context, serie);
          },
        );
      },
    );
  }
}
