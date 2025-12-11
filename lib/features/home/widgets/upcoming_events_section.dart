import 'package:flutter/material.dart';
import 'package:pawkar_app/features/home/widgets/event_card.dart';
import 'package:pawkar_app/features/home/widgets/section_header.dart';
import 'package:pawkar_app/models/subcategoria_model.dart';

class UpcomingEventsSection extends StatelessWidget {
  final List<Subcategoria> events;
  final ValueChanged<Subcategoria>? onEventTap;
  final VoidCallback? onViewAll;

  const UpcomingEventsSection({
    super.key,
    required this.events,
    this.onEventTap,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Próximos Eventos',
            actionText: 'Ver todos',
            onAction: onViewAll,
          ),
          const SizedBox(height: 12),
          ...events.map(
            (event) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: EventCard(
                subcategoria: event,
                onTap: onEventTap != null ? () => onEventTap!(event) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
