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
  String? _errorMessage;
  List<Encuentro> _matches = [];
  List<Encuentro> _filteredMatches = [];

  // Filter variables
  String _searchQuery = '';
  DateTime? _selectedDate;
  String? _selectedStadium;
  String? _selectedTeam;
  String? _selectedCategory;
  final List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _encuentroService = widget.encuentroService ?? EncuentroService();
    _matches = widget.initialMatches;
    _filteredMatches = List.from(_matches);
    _loadEncuentros();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadEncuentros() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final encuentros = await _encuentroService.getAllEncuentros();

      // Extract unique categories
      final categories =
          encuentros
              .map((e) => e.subcategoriaNombre)
              .where((name) => name.isNotEmpty)
              .toSet()
              .toList()
            ..sort();

      setState(() {
        _matches = encuentros;
        _filteredMatches = List.from(_matches);
        _categories.clear();
        _categories.addAll(categories);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar los encuentros: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredMatches = _matches.where((encuentro) {
        // Filter by search query
        if (_searchQuery.isNotEmpty) {
          final searchLower = _searchQuery.toLowerCase();
          if (!(encuentro.titulo.toLowerCase().contains(searchLower)) &&
              !(encuentro.subcategoriaNombre.toLowerCase().contains(
                searchLower,
              )) &&
              !(encuentro.equipoLocalNombre.toLowerCase().contains(
                searchLower,
              )) &&
              !(encuentro.equipoVisitanteNombre.toLowerCase().contains(
                searchLower,
              ))) {
            return false;
          }
        }

        // Filter by date
        if (_selectedDate != null) {
          try {
            final encounterDate = DateTime.parse(encuentro.fechaHora);
            if (!DateUtils.isSameDay(_selectedDate, encounterDate)) {
              return false;
            }
          } catch (e) {
            debugPrint('Error parsing date: ${encuentro.fechaHora}');
            return false;
          }
        }

        // Filter by stadium
        if (_selectedStadium != null && _selectedStadium!.isNotEmpty) {
          if (!encuentro.estadioNombre.toLowerCase().contains(
            _selectedStadium!.toLowerCase(),
          )) {
            return false;
          }
        }

        // Filter by team
        if (_selectedTeam != null && _selectedTeam!.isNotEmpty) {
          if ((encuentro.equipoLocalNombre.toLowerCase()).contains(
                _selectedTeam!.toLowerCase(),
              ) ||
              (encuentro.equipoVisitanteNombre.toLowerCase()).contains(
                _selectedTeam!.toLowerCase(),
              )) {
            return true;
          }
          return false;
        }

        // Filter by category
        if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
          if (!encuentro.subcategoriaNombre.toLowerCase().contains(
            _selectedCategory!.toLowerCase(),
          )) {
            return false;
          }
        }

        return true;
      }).toList();
    });
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildFilterDialog(),
    );
  }

  Widget _buildFilterDialog() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Filtrar partidos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

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
                
                // Date picker
                ListTile(
                  title: Text(
                    _selectedDate == null
                        ? 'Seleccionar fecha'
                        : 'Fecha: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365),
                      ),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  },
                ),
                
                // Category filter
                if (_categories.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Categoría:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 8,
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = selected ? category : null;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],

                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _selectedDate = null;
                            _selectedStadium = null;
                            _selectedTeam = null;
                            _selectedCategory = null;
                            _searchController.clear();
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
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActiveFilters() {
    final theme = Theme.of(context);
    final activeFilters = <Widget>[];

    if (_selectedDate != null) {
      activeFilters.add(
        Chip(
          label: Text(
            'Fecha: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          backgroundColor: theme.colorScheme.secondaryContainer,
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () {
            setState(() {
              _selectedDate = null;
              _applyFilters();
            });
          },
        ),
      );
    }

    if (_selectedStadium != null && _selectedStadium!.isNotEmpty) {
      activeFilters.add(
        Chip(
          label: Text(
            'Estadio: $_selectedStadium',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          backgroundColor: theme.colorScheme.secondaryContainer,
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () {
            setState(() {
              _selectedStadium = null;
              _applyFilters();
            });
          },
        ),
      );
    }

    if (_selectedTeam != null && _selectedTeam!.isNotEmpty) {
      activeFilters.add(
        Chip(
          label: Text(
            'Equipo: $_selectedTeam',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          backgroundColor: theme.colorScheme.secondaryContainer,
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () {
            setState(() {
              _selectedTeam = null;
              _applyFilters();
            });
          },
        ),
      );
    }

    if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
      activeFilters.add(
        Chip(
          label: Text(
            'Categoría: $_selectedCategory',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          backgroundColor: theme.colorScheme.secondaryContainer,
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () {
            setState(() {
              _selectedCategory = null;
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
          child: _filteredMatches.isEmpty
              ? const Center(
                  child: Text(
                    'No se encontraron partidos con los filtros actuales',
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: _filteredMatches.length,
                  itemBuilder: (context, index) {
                    final match = _filteredMatches[index];
                    return MatchCard(match: match);
                  },
                ),
        ),
      ],
    );
  }
}
