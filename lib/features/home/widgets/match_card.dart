import 'package:flutter/material.dart';
import 'package:pawkar_app/models/encuentro_model.dart';

class MatchCard extends StatelessWidget {
  final Encuentro match;
  final VoidCallback? onTap;

  const MatchCard({super.key, required this.match, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final matchDate = DateTime.parse(match.fechaHora);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fecha y hora
              Text(
                '${_formatDate(matchDate)} • ${_formatTime(matchDate)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),

              // Equipos y marcador
              Row(
                children: [
                  // Equipo local
                  Expanded(
                    child: Text(
                      match.equipoLocalNombre,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),

                  // Marcador
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _getScore(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),

                  // Equipo visitante
                  Expanded(
                    child: Text(
                      match.equipoVisitanteNombre,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              // Lugar
              if (match.estadioNombre.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      match.estadioNombre,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getScore() {
    // Por ahora, devolvemos un marcador ficticio
    // En el futuro, podrías añadir un campo de marcador al modelo Encuentro
    return '0 - 0';
  }
}
