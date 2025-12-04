import 'package:flutter/material.dart';

/// Error widget with retry functionality
class ErrorWidget extends StatelessWidget {
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onRetry;
  final IconData icon;

  const ErrorWidget({
    super.key,
    this.title = 'Oops! Algo salió mal',
    this.message =
        'No pudimos cargar los datos. Por favor, intenta nuevamente.',
    this.actionLabel = 'Reintentar',
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: theme.colorScheme.error),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32),

            // Retry Button
            if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(actionLabel ?? 'Reintentar'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Empty state widget
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  const EmptyStateWidget({
    super.key,
    this.title = 'Sin resultados',
    this.message = 'No hay elementos que mostrar en este momento.',
    this.actionLabel,
    this.onAction,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Network error widget with specific error types
class NetworkErrorWidget extends StatelessWidget {
  final String? error;
  final VoidCallback? onRetry;
  final String? message;

  const NetworkErrorWidget({super.key, this.error, this.onRetry, this.message});

  String _getErrorTitle() {
    if (error == null) return 'Error de conexión';

    if (error!.contains('internet')) {
      return 'Sin conexión a internet';
    } else if (error!.contains('timeout')) {
      return 'Conexión tardó demasiado';
    } else if (error!.contains('servidor')) {
      return 'Error del servidor';
    }
    return 'Error de conexión';
  }

  String _getErrorMessage() {
    return message ?? error ?? 'Algo salió mal. Intenta nuevamente más tarde.';
  }

  IconData _getErrorIcon() {
    if (error == null) return Icons.cloud_off_outlined;

    if (error!.contains('internet')) {
      return Icons.wifi_off;
    } else if (error!.contains('timeout')) {
      return Icons.schedule;
    } else if (error!.contains('servidor')) {
      return Icons.dns;
    }
    return Icons.error_outline;
  }

  @override
  Widget build(BuildContext context) {
    return ErrorWidget(
      title: _getErrorTitle(),
      message: _getErrorMessage(),
      icon: _getErrorIcon(),
      onRetry: onRetry,
    );
  }
}
