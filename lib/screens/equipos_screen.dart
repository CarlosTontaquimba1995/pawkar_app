import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pawkar_app/models/equipo_model.dart';
import 'package:pawkar_app/models/serie_model.dart';
import 'package:pawkar_app/screens/plantillas_screen.dart';
import 'package:pawkar_app/services/equipo_service.dart';
import 'package:pawkar_app/services/serie_service.dart';
import 'package:pawkar_app/widgets/error_widget.dart' as custom;
import 'package:iconsax/iconsax.dart';

class EquiposScreen extends StatefulWidget {
  final int subcategoriaId;

  const EquiposScreen({
    super.key,
    required this.subcategoriaId,
  });

  @override
  _EquiposScreenState createState() => _EquiposScreenState();
}

class _EquiposScreenState extends State<EquiposScreen> {
  bool _isLoading = true;
  bool _isLoadingSeries = true;
  String _errorMessage = '';
  List<Equipo> _equipos = [];
  List<Serie> _series = [];
  int? _selectedSerieId;
  final EquipoService _equipoService = EquipoService();
  final SerieService _serieService = SerieService();

  @override
  void initState() {
    super.initState();
    _loadSeries();
  }

  Future<void> _loadSeries() async {
    try {
      final series = await _serieService.getSeriesBySubcategoria(
        widget.subcategoriaId,
      );

      setState(() {
        _series = series;
        _isLoadingSeries = false;
      });

      // Load equipos after series are loaded
      _loadEquipos();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar las series: $e';
        _isLoading = false;
        _isLoadingSeries = false;
      });
    }
  }

  Future<void> _loadEquipos() async {
    if (_isLoadingSeries) return; // Wait for series to load first

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final response = await _equipoService.getEquiposBySubcategoria(
        widget.subcategoriaId,
        serieId: _selectedSerieId,
      );

      setState(() {
        _equipos = response.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar los equipos: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    await _loadEquipos();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Equipos',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
            letterSpacing: 0.15,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        surfaceTintColor: const Color.fromARGB(0, 214, 5, 5),
        shadowColor: theme.colorScheme.shadow.withOpacity(0.3),
        scrolledUnderElevation: 1,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildSeriesFilter() {
    if (_isLoadingSeries) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Iconsax.filter,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedSerieId,
                isExpanded: true,
                icon: const Icon(Iconsax.arrow_down_1, size: 18),
                hint: Text(
                  'Todas las series',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                items: [
                  ..._series.map((serie) {
                    return DropdownMenuItem(
                      value: serie.serieId,
                      child: Text(
                        serie.nombreSerie,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedSerieId = value;
                  });
                  _loadEquipos();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _equipos.isEmpty) {
      return _buildLoadingState();
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: custom.ErrorWidget(
          message: _errorMessage,
          onRetry: _handleRefresh,
        ),
      );
    }

    if (_equipos.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildSeriesFilter(),
        const SizedBox(height: 8),
        Expanded(
          child: RefreshIndicator.adaptive(
            onRefresh: _handleRefresh,
            color: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: _buildEquiposList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6, // Number of shimmer placeholders
      itemBuilder: (context, index) => _buildShimmerCard(),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 200, height: 20, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(width: 150, height: 16, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Column(
      children: [
        _buildSeriesFilter(),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No hay equipos disponibles',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _handleRefresh,
                    child: Text(
                      'Recargar',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEquiposList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemCount: _equipos.length,
      itemBuilder: (context, index) {
        final equipo = _equipos[index];
        return _buildTeamCard(context, equipo);
      },
    );
  }

  Widget _buildTeamCard(BuildContext context, Equipo equipo) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Navegar al detalle del equipo
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Team header with solid color
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    // Team logo/avatar with animation
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Iconsax.people5,
                        size: 28,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Team name and info
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              equipo.nombre,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Ver Plantilla button
                          Container(
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () =>
                                    _navigateToPlantillas(context, equipo),
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Iconsax.people,
                                        size: 14,
                                        color: colorScheme.onPrimary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Ver Plantilla',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPlantillas(BuildContext context, Equipo equipo) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PlantillasScreen(
              subcategoriaId: widget.subcategoriaId,
              equipoId: equipo.equipoId,
              equipoNombre: equipo.nombre,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutQuart;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }
}
