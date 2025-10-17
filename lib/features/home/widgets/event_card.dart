import 'package:flutter/material.dart';
import 'package:pawkar_app/models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;
  final bool isFeatured;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    return isFeatured
        ? _buildFeaturedCard(context)
        : _buildStandardCard(context);
  }

  Widget _buildFeaturedCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(theme),
            _buildEventDetails(theme, isFeatured: true),
          ],
        ),
      ),
    );
  }

  Widget _buildStandardCard(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(theme, size: 80),
              const SizedBox(width: 16),
              Expanded(child: _buildEventDetails(theme)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(ThemeData theme, {double size = 100}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _getCategoryIcon(),
        size: size * 0.4,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildEventDetails(ThemeData theme, {bool isFeatured = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: isFeatured ? null : theme.textTheme.titleSmall?.fontSize,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4),
        _buildInfoRow(
          Icons.location_on_outlined,
          event.location,
          theme,
          isFeatured: isFeatured,
        ),
        SizedBox(height: isFeatured ? 2 : 4),
        _buildInfoRow(
          Icons.calendar_month_outlined,
          event.formattedDate,
          theme,
          isFeatured: isFeatured,
        ),
        if (event.price != null) ...[
          SizedBox(height: isFeatured ? 6 : 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'S/.${event.price?.toStringAsFixed(2)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: isFeatured ? 11 : null,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String text,
    ThemeData theme, {
    bool isFeatured = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: isFeatured ? 12 : 14,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        SizedBox(width: isFeatured ? 2 : 4),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              fontSize: isFeatured ? 11 : null,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon() {
    switch (event.category.toLowerCase()) {
      case 'música':
        return Icons.music_note;
      case 'deportes':
        return Icons.sports_soccer;
      case 'teatro':
        return Icons.theater_comedy;
      case 'arte':
        return Icons.palette;
      case 'gastronomía':
        return Icons.restaurant;
      default:
        return Icons.event;
    }
  }
}
