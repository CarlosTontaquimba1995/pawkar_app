import 'package:flutter/material.dart';
import 'package:pawkar_app/models/subcategoria_model.dart';

class EventCard extends StatelessWidget {
  final Subcategoria subcategoria;
  final VoidCallback? onTap;
  final bool isFeatured;

  const EventCard({
    super.key,
    required this.subcategoria,
    this.onTap,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isFeatured ? 200 : double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: isFeatured ? 4 : 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subcategory Image or Icon
            Container(
              height: isFeatured ? 120 : 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Icon(
                _getCategoryIcon(subcategoria.nombre),
                size: 40,
                color: theme.colorScheme.primary,
              ),
            ),
            
            // Subcategory Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subcategory Name
                  Text(
                    subcategoria.nombre,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Category Name
                  Row(
                    children: [
                      Icon(
                        Icons.category,
                        size: 14,
                        color: theme.textTheme.bodySmall?.color?.withOpacity(
                          0.7,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          subcategoria.categoriaNombre,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color
                                ?.withOpacity(0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  // Additional featured content
                  if (isFeatured) ...[
                    const SizedBox(height: 8),
                    // Add any additional featured content here
                    // For example: number of events, etc.
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get an icon based on subcategory name
  IconData _getCategoryIcon(String subcategoryName) {
    final name = subcategoryName.toLowerCase();
    if (name.contains('futbol') || name.contains('fútbol'))
      return Icons.sports_soccer;
    if (name.contains('basquet') || name.contains('básquet'))
      return Icons.sports_basketball;
    if (name.contains('tenis')) return Icons.sports_tennis;
    if (name.contains('voley') || name.contains('vóley'))
      return Icons.sports_volleyball;
    if (name.contains('natación')) return Icons.pool;
    if (name.contains('ciclismo')) return Icons.directions_bike;
    if (name.contains('atletismo')) return Icons.directions_run;
    return Icons.sports;
  }
}
