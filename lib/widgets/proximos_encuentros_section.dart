import 'package:flutter/material.dart';
import 'package:pawkar_app/models/encuentro_model.dart';
import 'package:pawkar_app/services/encuentro_service.dart';
import 'package:pawkar_app/widgets/empty_state_widget.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pawkar_app/widgets/skeleton_loader.dart';

class ProximosEncuentrosSection extends StatefulWidget {
  const ProximosEncuentrosSection({super.key});

  @override
  State<ProximosEncuentrosSection> createState() =>
      _ProximosEncuentrosSectionState();
}

class _ProximosEncuentrosSectionState extends State<ProximosEncuentrosSection> {
  final EncuentroService _encuentroService = EncuentroService();
  bool _isLoading = true;
  List<Encuentro> _encuentros = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Initialize date formatting with Spanish locale
    initializeDateFormatting('es', null).then((_) {
      setState(() {
        // This will trigger a rebuild after date formatting is initialized
      });
    });
    _loadProximosEncuentros();
  }

  Future<void> _loadProximosEncuentros() async {
    try {
      final params = EncuentroSearchParams();
      final result = await _encuentroService.searchEncuentrosByQuery(
        params,
        page: 0,
        size: 5,
      );

      setState(() {
        _encuentros = result.content;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar los próximos encuentros';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContent(theme, colorScheme),
      ],
    );
  }

  Widget _buildContent(ThemeData theme, ColorScheme colorScheme) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage.isNotEmpty) {
      return _buildErrorState(theme, colorScheme);
    }

    if (_encuentros.isEmpty) {
      return _buildEmptyState(theme, colorScheme);
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: _encuentros.length,
      itemBuilder: (context, index) {
        final encuentro = _encuentros[index];
        return _buildEncuentroCard(encuentro, theme, colorScheme);
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: 3,
      itemBuilder: (context, index) => _buildShimmerCard(),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0, left: 8.0, right: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Date and time row
          const SkeletonLoader(width: 200, height: 16, borderRadius: 4),
          const SizedBox(height: 12),

          // Teams row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Home team
              const Column(
                children: [
                  SkeletonLoader(
                    width: 32,
                    height: 32,
                    shape: BoxShape.circle,
                    borderRadius: 0,
                  ),
                  SizedBox(height: 8),
                  SkeletonLoader(width: 80, height: 14, borderRadius: 4),
                ],
              ),

              // VS text
              const Text(
                'VS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),

              // Away team
              const Column(
                children: [
                  SkeletonLoader(
                    width: 32,
                    height: 32,
                    shape: BoxShape.circle,
                    borderRadius: 0,
                  ),
                  SizedBox(height: 8),
                  SkeletonLoader(width: 80, height: 14, borderRadius: 4),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Status bar
          const SkeletonLoader(
            width: double.infinity,
            height: 8,
            borderRadius: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, ColorScheme colorScheme) {
    return EmptyStateWidget(
      message: _errorMessage,
      actionLabel: 'Reintentar',
      onAction: _loadProximosEncuentros,
      icon: Icons.error_outline,
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    return EmptyStateWidget(
      message: 'No hay encuentros próximos',
      icon: Icons.calendar_today_outlined,
      actionLabel: 'Recargar',
      onAction: _loadProximosEncuentros,
    );
  }

  Widget _buildEncuentroCard(
    Encuentro encuentro,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final dateTime =
        DateTime.tryParse(encuentro.fechaHora) ?? DateTime.now();
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('dd MMM yyyy', 'es');

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () {
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with date and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        dateFormat.format(dateTime),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          encuentro.estado,
                          colorScheme,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        encuentro.estado.value.toLowerCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _getStatusColor(encuentro.estado, colorScheme),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12.0),

                // Title and time
                Text(
                  encuentro.titulo,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8.0),

                // Time and location
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16.0,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      timeFormat.format(dateTime),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Icon(
                      Icons.location_on_outlined,
                      size: 16.0,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6.0),
                    Expanded(
                      child: Text(
                        encuentro.estadioNombre,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12.0),

                // Removed participant avatars and 'Ver detalles' button
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Color _getStatusColor(EstadoEncuentro status, ColorScheme colorScheme) {
    switch (status) {
      case EstadoEncuentro.enJuego:
        return Colors.green;
      case EstadoEncuentro.programado:
        return Colors.blue;
      case EstadoEncuentro.finalizado:
        return Colors.grey;
      case EstadoEncuentro.suspendido:
        return Colors.orange;
      case EstadoEncuentro.cancelado:
        return Colors.red;
    }
  }
}
