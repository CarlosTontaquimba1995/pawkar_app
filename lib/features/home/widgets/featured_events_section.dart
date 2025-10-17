import 'package:flutter/material.dart';
import 'package:pawkar_app/features/home/widgets/event_card.dart';
import 'package:pawkar_app/features/home/widgets/section_header.dart';
import 'package:pawkar_app/models/event.dart';

class FeaturedEventsSection extends StatelessWidget {
  final List<Event> events;
  final ValueChanged<Event>? onEventTap;
  final VoidCallback? onViewAll;

  const FeaturedEventsSection({
    super.key,
    required this.events,
    this.onEventTap,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Eventos Destacados',
          actionText: 'Ver más',
          onAction: onViewAll,
        ),
        SizedBox(
          height: 240,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
            scrollDirection: Axis.horizontal,
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) => EventCard(
              event: events[index],
              onTap: onEventTap != null
                  ? () => onEventTap!(events[index])
                  : null,
              isFeatured: true,
            ),
          ),
        ),
      ],
    );
  }
}
