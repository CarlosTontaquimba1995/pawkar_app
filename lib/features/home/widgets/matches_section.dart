import 'package:flutter/material.dart';
import 'package:pawkar_app/models/encuentro_model.dart';
import 'package:pawkar_app/features/home/widgets/match_card.dart';

class MatchesSection extends StatelessWidget {
  final List<Encuentro> matches;
  final ValueChanged<Encuentro>? onMatchTap;
  final VoidCallback? onViewAll;

  const MatchesSection({
    super.key,
    required this.matches,
    this.onMatchTap,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Próximos Partidos',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (onViewAll != null)
                TextButton(
                  onPressed: onViewAll,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Ver todos',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Lista de partidos
        if (matches.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: Text('No hay partidos programados')),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              return MatchCard(
                match: match,
                onTap: onMatchTap != null ? () => onMatchTap!(match) : null,
              );
            },
          ),
      ],
    );
  }
}
