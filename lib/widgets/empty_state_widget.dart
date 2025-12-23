import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? icon;
  final double iconSize;
  final double spacing;
  final EdgeInsetsGeometry? padding;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.info_outline,
    this.iconSize = 48.0,
    this.spacing = 16.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: padding ?? const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: iconSize,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
              SizedBox(height: spacing),
            ],
            Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: theme.colorScheme.primary.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: spacing),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Common empty state factories
  factory EmptyStateWidget.equipos({VoidCallback? onRetry}) {
    return EmptyStateWidget(
      message: 'No hay equipos disponibles',
      actionLabel: onRetry != null ? 'Recargar' : null,
      onAction: onRetry,
      icon: Icons.people_outline,
    );
  }

  factory EmptyStateWidget.jugadores({VoidCallback? onRetry}) {
    return EmptyStateWidget(
      message: 'No hay jugadores disponibles',
      actionLabel: onRetry != null ? 'Recargar' : null,
      onAction: onRetry,
      icon: Icons.person_outline,
    );
  }

  factory EmptyStateWidget.eventos({VoidCallback? onRetry}) {
    return EmptyStateWidget(
      message: 'No hay eventos disponibles',
      actionLabel: onRetry != null ? 'Recargar' : null,
      onAction: onRetry,
      icon: Icons.event_available_outlined,
    );
  }

  factory EmptyStateWidget.partidos({VoidCallback? onRetry}) {
    return EmptyStateWidget(
      message: 'No hay partidos disponibles',
      actionLabel: onRetry != null ? 'Recargar' : null,
      onAction: onRetry,
      icon: Icons.sports_soccer_outlined,
    );
  }

  factory EmptyStateWidget.categorias({VoidCallback? onRetry}) {
    return EmptyStateWidget(
      message: 'No hay categorías disponibles',
      actionLabel: onRetry != null ? 'Recargar' : null,
      onAction: onRetry,
      icon: Icons.category_outlined,
    );
  }
}
