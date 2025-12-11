import 'package:flutter/material.dart';
import 'package:pawkar_app/models/encuentro_model.dart';
import 'package:pawkar_app/services/encuentro_service.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shimmer/shimmer.dart';

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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Próximos Encuentros',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: _loadProximosEncuentros,
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Ver más'),
              ),
            ],
          ),
        ),
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
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700]),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              _errorMessage,
              style: TextStyle(color: Colors.red[700]),
            ),
          ),
          TextButton(
            onPressed: _loadProximosEncuentros,
            style: TextButton.styleFrom(
              foregroundColor: Colors.red[700],
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 6.0,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 48.0,
            color: colorScheme.onSurfaceVariant.withOpacity(0.6),
          ),
          const SizedBox(height: 12.0),
          Text(
            'No hay encuentros próximos',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Text(
            'No hay encuentros programados en este momento. Vuelve más tarde para ver las próximas actividades.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          FilledButton.icon(
            onPressed: _loadProximosEncuentros,
            icon: const Icon(Icons.refresh, size: 18.0),
            label: const Text('Actualizar'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ],
      ),
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
            color: Colors.black.withOpacity(0.05),
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
            // Handle tap on encuentro
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
                        ).withOpacity(0.1),
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

                // Participants and action button
                Row(
                  children: [
                    // Participant avatars (example)
                    _buildParticipantAvatars(),

                    const Spacer(),

                    // Action button
                    FilledButton.tonal(
                      onPressed: () {
                        // Handle action
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text('Ver detalles'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildParticipantAvatars() {
    // Example participant avatars
    return Stack(
      children: [
        _buildAvatar('A', 0),
        _buildAvatar('B', 1),
        _buildAvatar('+2', 2),
      ],
    );
  }

  Widget _buildAvatar(String text, int index) {
    return Container(
      margin: EdgeInsets.only(left: index * 16.0),
      width: 32.0,
      height: 32.0,
      decoration: BoxDecoration(
        color: Colors.primaries[index % Colors.primaries.length].withOpacity(
          0.2,
        ),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.0),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
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
