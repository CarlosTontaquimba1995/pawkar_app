import 'package:flutter/material.dart';
import 'package:pawkar_app/models/encuentro_model.dart';
import 'package:pawkar_app/services/encuentro_service.dart';
import 'package:pawkar_app/widgets/loading_widget.dart';
import 'package:pawkar_app/widgets/error_widget.dart' as custom;

class FeaturedEventsSection extends StatefulWidget {
  final ValueChanged<Encuentro>? onEventTap;
  final VoidCallback? onViewAll;

  const FeaturedEventsSection({
    super.key,
    this.onEventTap,
    this.onViewAll,
  });

  @override
  State<FeaturedEventsSection> createState() => _FeaturedEventsSectionState();
}

class _FeaturedEventsSectionState extends State<FeaturedEventsSection> {
  final EncuentroService _encuentroService = EncuentroService();
  bool _isLoading = true;
  String? _error;
  List<Encuentro> _featuredEvents = [];

  @override
  void initState() {
    super.initState();
    _loadFeaturedEvents();
  }

  Future<void> _loadFeaturedEvents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final params = EncuentroSearchParams(
        page: 0, 
        size: 5, // Limit to 5 events
      );

      final result = await _encuentroService.searchEncuentrosByQuery(params);

      setState(() {
        _featuredEvents = result.content;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading featured events: $e');
      setState(() {
        _error = 'Error al cargar los eventos destacados';
        _isLoading = false;
      });
    }
  }

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
                'Eventos Destacados',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.onViewAll != null)
                TextButton(
                  onPressed: widget.onViewAll,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Ver todos',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Center(child: LoadingWidget()),
          )
        else if (_error != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Center(
              child: custom.ErrorWidget(
                message: _error!,
                onRetry: _loadFeaturedEvents,
              ),
            ),
          )
        else if (_featuredEvents.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: Text('No hay eventos destacados disponibles')),
          )
        else
          SizedBox(
            height: 180,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              scrollDirection: Axis.horizontal,
              itemCount: _featuredEvents.length,
              itemBuilder: (context, index) {
                final event = _featuredEvents[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: _buildEventCard(event, theme),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildEventCard(Encuentro event, ThemeData theme) {
    return GestureDetector(
      onTap: () => widget.onEventTap?.call(event),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event image placeholder with team logos
            Container(
              height: 100,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Local team
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.sports_soccer, size: 30),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 80,
                        child: Text(
                          event.equipoLocalNombre,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  // VS text
                  Text(
                    'VS',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  // Visitor team
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.sports_soccer, size: 30),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 80,
                        child: Text(
                          event.equipoVisitanteNombre,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Event details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.titulo,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Date and time
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _formatDate(event.fechaHora),
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.estadioNombre,
                          style: theme.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${_getWeekday(date.weekday)} ${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString; // Return original string if parsing fails
    }
  }

  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return 'Lun';
      case 2:
        return 'Mar';
      case 3:
        return 'Mié';
      case 4:
        return 'Jue';
      case 5:
        return 'Vie';
      case 6:
        return 'Sáb';
      case 7:
        return 'Dom';
      default:
        return '';
    }
  }
}
