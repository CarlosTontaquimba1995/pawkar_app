import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/subcategoria_model.dart';
import '../services/subcategoria_service.dart';
import '../widgets/evento_card.dart';
import '../widgets/empty_state_widget.dart';

class EventosScreen extends StatefulWidget {
  const EventosScreen({super.key});

  @override
  State<EventosScreen> createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Subcategoria>> _proximosEventosFuture;
  late Future<List<Subcategoria>> _eventosPasadosFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final subcategoriaService = Provider.of<SubcategoriaService>(
      context,
      listen: false,
    );
    _proximosEventosFuture = subcategoriaService.getProximosEventos();
    _eventosPasadosFuture = subcategoriaService.getEventosPasados();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Próximos Eventos'),
            Tab(text: 'Eventos Pasados'),
          ],
          labelColor: colorScheme.secondary,
          unselectedLabelColor: colorScheme.onSurface.withOpacity(0.7),
          indicatorColor: colorScheme.secondary,
          indicatorWeight: 3.0,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          labelPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEventosList(_proximosEventosFuture, 'No hay eventos próximos'),
          _buildEventosList(_eventosPasadosFuture, 'No hay eventos pasados'),
        ],
      ),
    );
  }

  Widget _buildEventosList(
    Future<List<Subcategoria>> eventosFuture,
    String emptyMessage,
  ) {
    return FutureBuilder<List<Subcategoria>>(
      future: eventosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return EmptyStateWidget.eventos();
        }

        final eventos = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(
            8.0,
            8.0,
            8.0,
            80.0,
          ), // Added bottom padding
          itemCount: eventos.length,
          itemBuilder: (context, index) {
            final evento = eventos[index];
            return EventoCard(subcategoria: evento);
          },
        );
      },
    );
  }
}
