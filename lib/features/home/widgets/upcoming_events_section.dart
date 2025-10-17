import 'package:flutter/material.dart';
import 'package:pawkar_app/features/home/widgets/event_card.dart';
import 'package:pawkar_app/features/home/widgets/section_header.dart';
import 'package:pawkar_app/models/event.dart';

class UpcomingEventsSection extends StatelessWidget {
  final List<Event> events;
  final ValueChanged<Event>? onEventTap;

  const UpcomingEventsSection({
    super.key,
    required this.events,
    this.onEventTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Próximos Eventos'),
          const SizedBox(height: 12),
          ...events.map(
            (event) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: EventCard(
                event: event,
                onTap: onEventTap != null ? () => onEventTap!(event) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
