import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pawkar_app/features/settings/presentation/providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentIndex = _tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: 'Inicio'),
            Tab(icon: Icon(Icons.event), text: 'Eventos'),
            Tab(icon: Icon(Icons.newspaper), text: 'Noticias'),
            Tab(icon: Icon(Icons.settings), text: 'Ajustes'),
          ],
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _HomeTab(),
          Center(child: Text('Eventos - En desarrollo')),
          Center(child: Text('Noticias - En desarrollo')),
          Center(child: Text('Ajustes - En desarrollo')),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Inicio';
      case 1:
        return 'Eventos';
      case 2:
        return 'Noticias';
      case 3:
        return 'Ajustes';
      default:
        return 'PAWKAR RAYMI';
    }
  }
}


class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(),
          const SizedBox(height: 24),
          _buildSectionTitle('Eventos Destacados'),
          const SizedBox(height: 16),
          _buildFeaturedEvents(),
          const SizedBox(height: 24),
          _buildSectionTitle('Categorías'),
          const SizedBox(height: 16),
          _buildCategories(),
          const SizedBox(height: 24),
          _buildSectionTitle('Últimas Noticias'),
          const SizedBox(height: 16),
          _buildLatestNews(),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '¡Bienvenido a Pawkar!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Descubre los mejores eventos para ti',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildFeaturedEvents() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: Text('Eventos destacados aparecerán aquí')),
    );
  }

  Widget _buildCategories() {
    // Replace with your actual categories widget
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(5, (index) => _buildCategoryItem('Categoría ${index + 1}')),
      ),
    );
  }

  Widget _buildCategoryItem(String title) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(title),
    );
  }

  Widget _buildLatestNews() {
    return Column(
      children: List.generate(
        3,
        (index) => Card(
          child: ListTile(
            title: Text('Noticia ${index + 1}'),
            subtitle: Text('Descripción de la noticia ${index + 1}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ),
      ).toList(),
    );
  }
} 