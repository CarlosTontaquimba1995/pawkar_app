import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:pawkar_app/models/encuentro_model.dart';
import 'package:pawkar_app/models/equipo_model.dart';
import 'package:pawkar_app/models/estadio_model.dart';
import 'package:pawkar_app/models/subcategoria_model.dart';
import 'package:pawkar_app/services/encuentro_service.dart';
import 'package:pawkar_app/services/equipo_service.dart';
import 'package:pawkar_app/services/estadio_service.dart';
import 'package:pawkar_app/services/serie_service.dart';
import 'package:pawkar_app/services/subcategoria_service.dart';
import 'package:pawkar_app/models/serie_model.dart';
import 'package:pawkar_app/features/home/widgets/match_card.dart';
import 'package:pawkar_app/widgets/loading_widget.dart';
import 'package:pawkar_app/widgets/empty_state_widget.dart';

class MatchesScreen extends StatefulWidget {
  final List<Encuentro> initialMatches;
  final EncuentroService? encuentroService;

  const MatchesScreen({
    super.key,
    this.initialMatches = const [],
    this.encuentroService,
  });

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  // Controllers
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  // Services
  late final EncuentroService _encuentroService;
  final EquipoService _equipoService = EquipoService();
  final EstadioService _estadioService = EstadioService();
  final SubcategoriaService _subcategoriaService = SubcategoriaService();

  // State variables
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _errorMessage;
  int _currentPage = 0;
  final int _pageSize = 10;
  
  // Series state
  final SerieService _serieService = SerieService();
  List<Serie> _series = [];
  bool _isLoadingSeries = false;
  int? _selectedSerieId;
  
  // Filter state
  DateTime? _startDate;
  DateTime? _endDate;
  int? _selectedTeamId;
  int? _selectedCategoryId;
  int? _selectedStadiumId;
  String? _selectedStatus;
  final List<Encuentro> _matches = [];

  // Data lists
  List<Equipo> _teams = [];
  List<Subcategoria> _categories = [];
  List<Estadio> _stadiums = [];

  // Loading states
  bool _isLoadingTeams = false;
  // ignore: unused_field
  bool _isLoadingCategories = false;
  // ignore: unused_field
  bool _isLoadingStadiums = false;

  // UI state
  bool _showFilters = false;

  // Status options
  final List<Map<String, dynamic>> _statusOptions = [
    {'value': null, 'label': 'Todos'},
    {'value': 'PROGRAMADO', 'label': 'Programado'},
    {'value': 'EN_JUEGO', 'label': 'En juego'},
    {'value': 'FINALIZADO', 'label': 'Finalizado'},
    {'value': 'SUSPENDIDO', 'label': 'Suspendido'},
    {'value': 'CANCELADO', 'label': 'Cancelado'},
  ];

  @override
  void initState() {
    super.initState();
    _encuentroService = widget.encuentroService ?? EncuentroService();
    _scrollController.addListener(_onScroll);
    _loadInitialData();
    _loadEncuentros(initialLoad: true);
    _loadTeams();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !_isLoading &&
        !_isLoadingMore &&
        _hasMore) {
      _loadEncuentros(loadMore: true);
    }
  }

  Future<void> _loadInitialData() async {
    await Future.wait([_loadTeams(), _loadCategories(), _loadStadiums()]);
  }

  Future<void> _loadEncuentros({
    bool initialLoad = false,
    bool loadMore = false,
  }) async {
    if ((_isLoading && !loadMore) || (loadMore && !_hasMore)) return;

    if (!loadMore) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        if (initialLoad) {
          _currentPage = 0;
          _hasMore = true;
          _matches.clear();
        }
      });
    } else {
      setState(() {
        _isLoadingMore = true;
      });
    }

    try {
      final params = EncuentroSearchParams(
        equipoId: _selectedTeamId,
        estadioId: _selectedStadiumId,
        fechaInicio: _startDate != null
            ? DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(_startDate!)
            : null,
        fechaFin: _endDate != null
            ? DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(
                _endDate!.add(
                  const Duration(days: 1) - const Duration(seconds: 1),
                ),
              )
            : null,
        subcategoriaId:
            _selectedCategoryId, 
        serieId: _selectedSerieId,
        estado: _selectedStatus,
      );
      
      final result = await _encuentroService.searchEncuentrosByQuery(
        params,
        page: _currentPage,
        size: _pageSize,
      );

      if (mounted) {
        setState(() {
          _matches.addAll(result.content);
          _hasMore = !result.last && result.content.length == _pageSize;
          if (result.content.isNotEmpty) {
            _currentPage++;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al cargar los encuentros: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _loadTeams() async {
    // Don't reload if we already have teams and no series is selected
    if (_teams.isNotEmpty && _selectedSerieId == null) return;
    
    setState(() => _isLoadingTeams = true);
    try {
      if (_selectedSerieId != null) {
        // Load teams filtered by selected series
        final response = await _equipoService.getEquiposBySerie(
          _selectedSerieId!,
        );
        if (mounted) {
          setState(() {
            _teams = response.data;
          });
        }
      } else {
        // Load all teams if no series is selected
        final response = await _equipoService.getEquipos(size: 100);
        if (mounted) {
          setState(() {
            _teams = response.data.content;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar equipos: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingTeams = false);
      }
    }
  }

  Future<void> _loadCategories() async {
    if (_categories.isNotEmpty) return;
    
    setState(() => _isLoadingCategories = true);
    try {
      final response = await _subcategoriaService.getSubcategorias();
      if (mounted) {
        setState(() {
          // Filtrar solo las subcategorías de la categoría DEPORTES
          _categories = response
              .where(
                (subcat) => subcat.categoriaNombre.toUpperCase() == 'DEPORTES',
              )
              .toList();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar categorías')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingCategories = false);
      }
    }
  }

  Future<void> _loadStadiums() async {
    if (_stadiums.isNotEmpty) return;

    setState(() => _isLoadingStadiums = true);
    try {
      final response = await _estadioService.getAllEstadios();
      if (mounted) {
        setState(() {
          _stadiums = response;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar estadios')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingStadiums = false);
      }
    }
  }

  Future<void> _applyFilters() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _currentPage = 0;
        _matches.clear();
        _hasMore = true;
      });

      await _loadEncuentros(initialLoad: true);
      setState(() => _showFilters = false);
    }
  }

  Future<void> _loadSeriesByCategory(int? subcategoriaId) async {
    if (subcategoriaId == null) {
      setState(() {
        _series = [];
        _selectedSerieId = null;
      });
      return;
    }

    setState(() => _isLoadingSeries = true);
    try {
      final series = await _serieService.getSeriesBySubcategoria(
        subcategoriaId,
      );
      setState(() {
        _series = series;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar las series')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingSeries = false);
      }
    }
  }

  void _resetFilters() {
    _formKey.currentState?.reset();
    setState(() {
      _selectedTeamId = null;
      _selectedCategoryId = null;
      _selectedSerieId = null;
      _series = [];
      _selectedStadiumId = null;
      _selectedStatus = null;
      _startDate = null;
      _endDate = null;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _matches.isEmpty) {
      return const Scaffold(body: Center(child: LoadingWidget()));
    }

    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Encuentros',
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
        shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.3),
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            icon: Icon(
              _showFilters ? Icons.close : Iconsax.filter,
              color: theme.colorScheme.primary,
            ),
            onPressed: () {
              setState(() => _showFilters = !_showFilters);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEncuentros,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showFilters) _buildFilterForm(),
          if (_errorMessage != null && _matches.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(_errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadEncuentros,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          else
            Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildFilterForm() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Fecha inicial'),
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: () => _selectDate(context, true),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            child: Text(
                              _startDate != null
                                  ? DateFormat('dd/MM/yyyy').format(_startDate!)
                                  : 'Seleccionar fecha',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Fecha final'),
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: () => _selectDate(context, false),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            child: Text(
                              _endDate != null
                                  ? DateFormat('dd/MM/yyyy').format(_endDate!)
                                  : 'Seleccionar fecha',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Todas las categorías'),
                  ),
                  ..._categories.map(
                    (category) => DropdownMenuItem(
                      value: category.subcategoriaId,
                      child: Text(category.nombre),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                    _selectedSerieId = null;
                    _loadSeriesByCategory(value);
                  });
                },
              ),
              const SizedBox(height: 16),
              _isLoadingSeries
                  ? const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Serie'),
                        SizedBox(height: 4),
                        SizedBox(
                          height: 60,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    )
                  : DropdownButtonFormField<int>(
                      initialValue: _selectedSerieId,
                      decoration: const InputDecoration(
                        labelText: 'Serie',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Todas las series'),
                        ),
                        ..._series.map(
                          (serie) => DropdownMenuItem(
                            value: serie.serieId,
                            child: Text(serie.nombreSerie),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedSerieId = value;
                        });
                      },
                    ),
              const SizedBox(height: 16),
              _isLoadingTeams
                  ? const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Equipo'),
                        SizedBox(height: 4),
                        SizedBox(
                          height: 60,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    )
                  : DropdownButtonFormField<int>(
                      initialValue: _selectedTeamId,
                      decoration: const InputDecoration(
                        labelText: 'Equipo',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Todos los equipos'),
                        ),
                        ..._teams.map(
                          (team) => DropdownMenuItem(
                            value: team.equipoId,
                            child: Text(team.nombre),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedTeamId = value;
                        });
                      },
                    ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: _selectedStadiumId,
                decoration: const InputDecoration(
                  labelText: 'Estadio',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Todos los estadios'),
                  ),
                  ..._stadiums.map(
                    (stadium) => DropdownMenuItem(
                      value: stadium.id,
                      child: Text(stadium.nombre),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedStadiumId = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                ),
                items: _statusOptions
                    .map<DropdownMenuItem<String>>(
                      (status) => DropdownMenuItem(
                        value: status['value'],
                        child: Text(status['label']),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _applyFilters,
                      icon: const Icon(Icons.search),
                      label: const Text('Aplicar filtros'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: _resetFilters,
                    child: const Text('Limpiar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_matches.isEmpty) {
      return EmptyStateWidget(
        message: 'No se encontraron partidos',
        icon: Icons.sports_soccer,
        actionLabel: 'Recargar',
        onAction: _loadEncuentros,
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: _matches.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _matches.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        final match = _matches[index];
        return MatchCard(match: match);
      },
    );
  }
}
