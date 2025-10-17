import 'package:flutter/material.dart';
import 'package:pawkar_app/models/event.dart';
import 'package:pawkar_app/features/home/widgets/match_card.dart';

class MatchesScreen extends StatefulWidget {
  final List<Event> initialMatches;

  const MatchesScreen({super.key, required this.initialMatches});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  // Filtros
  String _searchQuery = '';
  DateTime? _selectedDate;
  String? _selectedStadium;
  String? _selectedTeam;
  String? _selectedCategory;

  // Categorías disponibles
  final List<String> _categories = [
    'Fútbol',
    'Baloncesto',
    'Vóley',
    'Tenis',
    'Béisbol',
    'Otros',
  ];

  // Equipos por categoría
  final Map<String, List<String>> _teamsByCategory = {
    'Fútbol': [
      'Barcelona SC',
      'Emelec',
      'Liga de Quito',
      'Independiente del Valle',
      'Aucas',
      'Delfín',
      'Universidad Católica',
      'Macará',
      'Técnico Universitario',
      'Guayaquil City',
    ],
    'Baloncesto': [
      'Guerreros de Santo Domingo',
      'Piratas de Los Valles',
      'Triple Tentación',
      'Cangrejeros de Machala',
      'Juvenil de la U. Católica',
    ],
    'Vóley': [
      'Emelec',
      'Universidad Católica',
      'Liga de Loja',
      'Portoviejo F.C.',
      'Club 9 de Octubre',
    ],
    'Tenis': [
      'Equipo Nacional de Tenis',
      'Club de Tenis Guayaquil',
      'Quito Tenis y Golf',
      'Club de Tenis Cuenca',
    ],
    'Béisbol': [
      'Gigantes de Yaguachi',
      'Tigres de Santo Domingo',
      'Águilas de Manta',
      'Toros de Quevedo',
    ],
    'Otros': [
      'Selección Nacional',
      'Liga de la Costa',
      'Liga de la Sierra',
      'Liga del Oriente',
    ],
  };

  // Equipos filtrados por categoría seleccionada
  late List<String> _filteredTeams = [];

  // Paginación
  int _currentPage = 0;
  bool _isLoading = false;

  // Datos de ejemplo
  List<Event> _allMatches = [];
  late List<Event> _filteredMatches;

  @override
  void initState() {
    super.initState();

    // Inicializar con los partidos iniciales
    _allMatches = List.from(widget.initialMatches);

    // Agregar más partidos generados
    _allMatches.addAll(_generateMoreMatches());

    // Inicializar la lista filtrada
    _filteredMatches = List.from(_allMatches);

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreMatches();
    }
  }

  void _loadMoreMatches() {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simular carga de más datos
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _allMatches.addAll(_generateMoreMatches());
          _applyFilters();
          _currentPage++;
          _isLoading = false;
        });
      }
    });
  }

  List<Event> _generateMoreMatches() {
    // Generar más partidos de ejemplo
    final now = DateTime.now();
    final List<Event> moreMatches = [];

    final teams = [
      'Barcelona',
      'Emelec',
      'Liga de Quito',
      'Independiente',
      'Aucas',
      'Orense',
      'Delfín',
      'Macará',
      'Técnico Universitario',
      'Guayaquil City',
    ];

    final stadiums = [
      'Estadio Monumental',
      'Estadio Rodrigo Paz',
      'Estadio George Capwell',
      'Estadio Gonzalo Pozo Ripalda',
      'Estadio Jocay',
      'Estadio Bellavista',
    ];

    for (int i = 0; i < 10; i++) {
      final daysToAdd = _currentPage * 10 + i;
      final team1 = teams[i % teams.length];
      final team2 = teams[(i + 1) % teams.length];

      moreMatches.add(
        Event(
          id: 'm${_allMatches.length + i}',
          title: '$team1 vs $team2',
          description:
              'Partido de la Liga Pro - Fecha ${_currentPage * 10 + i + 1}',
          dateTime: now.add(Duration(days: daysToAdd, hours: 18 + (i % 4))),
          location: stadiums[i % stadiums.length],
          category: 'Fútbol',
          isFeatured: i % 3 == 0,
          price: 10.0 + (i * 2.0),
          imageUrl: 'assets/images/futbol.jpg',
        ),
      );
    }

    return moreMatches;
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return _buildFilterSheet(setState, _selectedCategory);
          },
        );
      },
    );
  }

  void _applyFilters() {
    setState(() {
      _filteredMatches = _allMatches.where((match) {
        // Filtrar por búsqueda
        if (_searchQuery.isNotEmpty &&
            !match.title.toLowerCase().contains(_searchQuery.toLowerCase()) &&
            !match.location.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            )) {
          return false;
        }

        // Filtrar por fecha
        if (_selectedDate != null) {
          final matchDate = DateTime(
            match.dateTime.year,
            match.dateTime.month,
            match.dateTime.day,
          );
          final selectedDate = DateTime(
            _selectedDate!.year,
            _selectedDate!.month,
            _selectedDate!.day,
          );

          if (matchDate != selectedDate) {
            return false;
          }
        }

        // Filtrar por estadio
        if (_selectedStadium != null && match.location != _selectedStadium) {
          return false;
        }

        // Filtrar por equipo
        if (_selectedTeam != null && !match.title.contains(_selectedTeam!)) {
          return false;
        }

        // Filtrar por categoría
        if (_selectedCategory != null && match.category != _selectedCategory) {
          return false;
        }

        return true;
      }).toList();
    });
  }

  void _resetFilters() {
    _searchController.clear();
    _selectedDate = null;
    _selectedStadium = null;
    _selectedTeam = null;
    _selectedCategory = null;
    _filteredTeams = [];
    _searchQuery = '';
    _applyFilters();
  }

  // Actualizar la lista de equipos cuando se selecciona una categoría
  void _updateTeamsByCategory(String? category) {
    setState(() {
      _selectedCategory = category;
      _selectedTeam = null; // Reset team when category changes
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Próximos Partidos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar partidos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchQuery = '';
                          _applyFilters();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
              ),
              onChanged: (value) {
                _searchQuery = value;
                _applyFilters();
              },
            ),
          ),

          // Filtros activos
          _buildActiveFilters(),

          // Contador de resultados
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Text(
                  '${_filteredMatches.length} partidos encontrados',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                if (_selectedDate != null ||
                    _selectedStadium != null ||
                    _selectedTeam != null)
                  TextButton(
                    onPressed: _resetFilters,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Limpiar filtros',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Lista de partidos
          Expanded(
            child: _filteredMatches.isEmpty && !_isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sports_soccer_outlined,
                          size: 64,
                          color: theme.colorScheme.onSurfaceVariant.withOpacity(
                            0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No se encontraron partidos',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Intenta con otros filtros de búsqueda',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant
                                .withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      // Simular recarga
                      await Future.delayed(const Duration(seconds: 1));
                      setState(() {
                        _currentPage = 0;
                        _allMatches = _generateMoreMatches();
                        _applyFilters();
                      });
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: _filteredMatches.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= _filteredMatches.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final match = _filteredMatches[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: MatchCard(
                            match: match,
                            onTap: () {
                              // Navegar al detalle del partido
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
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

    if (_selectedStadium != null) {
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

    if (_selectedTeam != null) {
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

    if (_selectedCategory != null) {
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
        child: Row(
          children: activeFilters
              .map(
                (filter) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: filter,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildFilterSheet(StateSetter setState, String? currentCategory) {
    final theme = Theme.of(context);

    // Usar el estado local para manejar la categoría dentro del diálogo
    final selectedCategory = currentCategory ?? _selectedCategory;
    final filteredTeams = selectedCategory != null
        ? _teamsByCategory[selectedCategory] ?? []
        : [];

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Text(
                'Filtrar partidos',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Filtro por fecha
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : '',
                ),
                decoration: InputDecoration(
                  labelText: 'Fecha del partido',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        locale: const Locale('es', 'ES'),
                      );

                      if (date != null) {
                        setState(() {
                          _selectedDate = date;
                        });
                      }
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Filtro por categoría
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                    _selectedTeam = null; // Reset team when category changes
                  });
                },
              ),
              const SizedBox(height: 16),

              // Filtro por equipo (solo se habilita cuando hay una categoría seleccionada)
              DropdownButtonFormField<String>(
                value: _selectedTeam,
                decoration: InputDecoration(
                  labelText: 'Equipo',
                  hintText: selectedCategory == null
                      ? 'Selecciona una categoría primero'
                      : 'Selecciona un equipo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: filteredTeams.map<DropdownMenuItem<String>>((
                  dynamic team,
                ) {
                  return DropdownMenuItem<String>(
                    value: team.toString(),
                    child: Text(team.toString()),
                  );
                }).toList(),
                onChanged: selectedCategory == null
                    ? null
                    : (value) {
                        setState(() {
                          _selectedTeam = value;
                        });
                      },
                isExpanded: true,
                disabledHint: Text(
                  'Selecciona una categoría primero',
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
              ),
              const SizedBox(height: 16),

              // Filtro por estadio
              DropdownButtonFormField<String>(
                value: _selectedStadium,
                decoration: InputDecoration(
                  labelText: 'Estadio',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items:
                    [
                      'Estadio Monumental',
                      'Estadio Rodrigo Paz',
                      'Estadio George Capwell',
                      'Estadio Gonzalo Pozo Ripalda',
                      'Estadio Jocay',
                      'Estadio Bellavista',
                    ].map((stadium) {
                      return DropdownMenuItem(
                        value: stadium,
                        child: Text(stadium),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStadium = value;
                  });
                },
              ),

              const SizedBox(height: 24),

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedDate = null;
                          _selectedStadium = null;
                          _selectedTeam = null;
                          _selectedCategory = null;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Limpiar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _applyFilters();
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Aplicar filtros'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
