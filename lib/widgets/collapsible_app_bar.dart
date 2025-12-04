import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class CollapsibleAppBar extends StatefulWidget {
  final String title;
  final String subtitle;
  final String greeting;
  final double expandedHeight;
  final Widget? bottom;
  final List<Widget>? actions;

  const CollapsibleAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.greeting,
    this.expandedHeight = 200,
    this.bottom,
    this.actions,
  });

  @override
  State<CollapsibleAppBar> createState() => _CollapsibleAppBarState();
}

class _CollapsibleAppBarState extends State<CollapsibleAppBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _appBarController;
  late final ScrollController _scrollController;
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _appBarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.userScrollDirection ==
            ScrollDirection.reverse &&
        !_showAppBarTitle) {
      setState(() => _showAppBarTitle = true);
      _appBarController.forward();
    } else if (_scrollController.hasClients &&
        _scrollController.position.userScrollDirection ==
            ScrollDirection.forward &&
        _showAppBarTitle) {
      setState(() => _showAppBarTitle = false);
      _appBarController.reverse();
    }
  }

  @override
  void dispose() {
    _appBarController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final primaryColor = theme.colorScheme.primary;
    final primaryLight = theme.colorScheme.primary.withAlpha(200);

    return SliverAppBar.large(
      expandedHeight: size.height * 0.20,
      floating: false,
      pinned: true,
      backgroundColor: primaryColor,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      title: Text(
        'PAWKAR APP',
        style: theme.textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      centerTitle: true,
      actions: widget.actions,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          // expandedHeight/visibleMainHeight calculation removed
          // (previously used to compute scrolledPercentage) — not needed.

          return FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 4.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeTransition(
                        opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                          CurvedAnimation(
                            parent: _appBarController,
                            curve: const Interval(
                              0.0,
                              0.5,
                              curve: Curves.easeInOut,
                            ),
                          ),
                        ),
                        child: Text(
                          'Bienvenido a',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white.withAlpha(230),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      FadeTransition(
                        opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                          CurvedAnimation(
                            parent: _appBarController,
                            curve: const Interval(
                              0.0,
                              0.5,
                              curve: Curves.easeInOut,
                            ),
                          ),
                        ),
                        child: Text(
                          'PAWKAR 2025',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 0),
                      FadeTransition(
                        opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                          CurvedAnimation(
                            parent: _appBarController,
                            curve: const Interval(
                              0.0,
                              0.5,
                              curve: Curves.easeInOut,
                            ),
                          ),
                        ),
                        child: Text(
                          'Festival Cultural y Deportivo',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white.withAlpha(230),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 0),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
