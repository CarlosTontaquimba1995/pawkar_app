import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawkar_app/models/encuentro_model.dart';
import 'package:pawkar_app/services/encuentro_service.dart';
import 'package:pawkar_app/features/home/widgets/match_card.dart';
import 'package:pawkar_app/widgets/loading_widget.dart';

class MatchesScreen extends StatefulWidget {
  final List<Encuentro> initialMatches;
  final EncuentroService? encuentroService;

  const MatchesScreen({
    super.key,
    required this.initialMatches,
    this.encuentroService,
  });

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  late EncuentroService _encuentroService;

  // State variables
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  List<Encuentro> _matches = [];
  int _currentPage = 0;
  final int _pageSize = 10;
  bool _hasMore = true;

  // Filter variables
  String _searchQuery = '';
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  String? _selectedStadiumId;
  String? _selectedTeamId;
  String? _selectedCategoryId;
  String? _selectedSerieId;

  @override
  void initState() {
    super.initState();
    _encuentroService = widget.encuentroService ?? EncuentroService();
    _scrollController.addListener(_onScroll);
    _loadEncuentros(initialLoad: true);
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

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
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
        titulo: _searchQuery.isNotEmpty ? _searchQuery : null,
        equipoId: _selectedTeamId != null
            ? int.tryParse(_selectedTeamId!)
            : null,
        estadioLugar: _selectedStadiumId,
        fechaInicio: _selectedStartDate != null
            ? DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(_selectedStartDate!)
            : null,
        fechaFin: _selectedEndDate != null
            ? DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(_selectedEndDate!)
            : null,
        subcategoriaId: _selectedCategoryId != null
            ? int.tryParse(_selectedCategoryId!)
            : null,
      );

      final result = await _encuentroService.searchEncuentrosByQuery(
        params,
        page: _currentPage,
        size: _pageSize,
      );

      setState(() {
        _matches.addAll(result.content);
        _hasMore = !result.last && result.content.length == _pageSize;
        if (result.content.isNotEmpty) {
          _currentPage++;
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar los encuentros: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  void _applyFilters() {
    // Reset pagination and reload data with new filters
    setState(() {
      _currentPage = 0;
      _matches.clear();
      _hasMore = true;
    });
    _loadEncuentros(initialLoad: true);
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight:
                    MediaQuery.of(context).size.height *
                    0.85, // Reducida la altura máxima
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                  // Title
                  const Text(
                    'Filtrar partidos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Search field
                          TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              labelText: 'Buscar',
                              hintText: 'Buscar por equipo, categoría...',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              _searchQuery = value;
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // Date range picker
                          ListTile(
                            title: Text(
                              _selectedStartDate == null
                                  ? 'Seleccionar rango de fechas'
                                  : '${DateFormat('dd/MM/yyyy').format(_selectedStartDate!)} - ${_selectedEndDate != null ? DateFormat('dd/MM/yyyy').format(_selectedEndDate!) : ''}',
                            ),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: () async {
                              final DateTimeRange? picked =
                                  await showDateRangePicker(
                                    context: context,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                    initialDateRange:
                                        _selectedStartDate != null &&
                                            _selectedEndDate != null
                                        ? DateTimeRange(
                                            start: _selectedStartDate!,
                                            end: _selectedEndDate!,
                                          )
                                        : null,
                                  );
                              if (picked != null) {
                                setState(() {
                                  _selectedStartDate = picked.start;
                                  _selectedEndDate = picked.end;
                                });
                              }
                            },
                          ),
                          
                          // Team ID filter
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'ID de Equipo',
                              hintText: 'Ej: 1',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _selectedTeamId = value.isNotEmpty ? value : null;
                            },
                            controller: TextEditingController(
                              text: _selectedTeamId ?? '',
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Stadium ID filter
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'ID de Estadio',
                              hintText: 'Ej: 2',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _selectedStadiumId = value.isNotEmpty
                                  ? value
                                  : null;
                            },
                            controller: TextEditingController(
                              text: _selectedStadiumId ?? '',
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Category ID filter
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'ID de Categoría',
                              hintText: 'Ej: 5',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _selectedCategoryId = value.isNotEmpty
                                  ? value
                                  : null;
                            },
                            controller: TextEditingController(
                              text: _selectedCategoryId ?? '',
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Serie ID filter
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'ID de Serie',
                              hintText: 'Ej: 1',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _selectedSerieId = value.isNotEmpty
                                  ? value
                                  : null;
                            },
                            controller: TextEditingController(
                              text: _selectedSerieId ?? '',
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  // Action buttons (fixed at the bottom)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          16.0,
                          16.0,
                          32.0,
                        ), // Aumentado el padding inferior
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _searchQuery = '';
                                    _searchController.clear();
                                    _selectedStartDate = null;
                                    _selectedEndDate = null;
                                    _selectedTeamId = null;
                                    _selectedStadiumId = null;
                                    _selectedCategoryId = null;
                                    _selectedSerieId = null;
                                  });
                                },
                                child: const Text('Limpiar filtros'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  _applyFilters();
                                  Navigator.pop(context);
                                },
                                child: const Text('Aplicar'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildActiveFilters() {
    final theme = Theme.of(context);
    final activeFilters = <Widget>[];

    if (_selectedStartDate != null && _selectedEndDate != null) {
      activeFilters.add(
        Chip(
          label: Text(
            '${_selectedStartDate!.day}/${_selectedStartDate!.month}/${_selectedStartDate!.year} - ${_selectedEndDate!.day}/${_selectedEndDate!.month}/${_selectedEndDate!.year}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          backgroundColor: theme.colorScheme.secondaryContainer,
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () {
            setState(() {
              _selectedStartDate = null;
              _selectedEndDate = null;
              _applyFilters();
            });
          },
        ),
      );
    }

    if (_selectedTeamId != null && _selectedTeamId!.isNotEmpty) {
      activeFilters.add(
        Chip(
          label: Text(
            'Equipo ID: $_selectedTeamId',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          backgroundColor: theme.colorScheme.secondaryContainer,
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () {
            setState(() {
              _selectedTeamId = null;
              _applyFilters();
            });
          },
        ),
      );
    }

    if (_selectedStadiumId != null && _selectedStadiumId!.isNotEmpty) {
      activeFilters.add(
        Chip(
          label: Text(
            'Estadio ID: $_selectedStadiumId',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          backgroundColor: theme.colorScheme.secondaryContainer,
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () {
            setState(() {
              _selectedStadiumId = null;
              _applyFilters();
            });
          },
        ),
      );
    }

    if (_selectedCategoryId != null && _selectedCategoryId!.isNotEmpty) {
      activeFilters.add(
        Chip(
          label: Text(
            'Categoría ID: $_selectedCategoryId',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          backgroundColor: theme.colorScheme.secondaryContainer,
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () {
            setState(() {
              _selectedCategoryId = null;
              _applyFilters();
            });
          },
        ),
      );
    }

    if (_selectedSerieId != null && _selectedSerieId!.isNotEmpty) {
      activeFilters.add(
        Chip(
          label: Text(
            'Serie ID: $_selectedSerieId',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          backgroundColor: theme.colorScheme.secondaryContainer,
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () {
            setState(() {
              _selectedSerieId = null;
              _applyFilters();
            });
          },
        ),
      );
    }

    if (activeFilters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: activeFilters),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _matches.isEmpty) {
      return const Scaffold(body: Center(child: LoadingWidget()));
    }

    if (_errorMessage != null && _matches.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadEncuentros,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Partidos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEncuentros,
          ),
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_matches.isEmpty) {
      return const Center(child: Text('No hay partidos disponibles'));
    }

    return Column(
      children: [
        _buildActiveFilters(),
        Expanded(
          child: _matches.isEmpty
              ? const Center(
                  child: Text(
                    'No se encontraron partidos con los filtros actuales',
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: _matches.length + (_isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= _matches.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final match = _matches[index];
                    return MatchCard(match: match);
                  },
                ),
        ),
      ],
    );
  }
}
