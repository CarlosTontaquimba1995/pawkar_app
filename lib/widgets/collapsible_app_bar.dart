import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../theme/app_colors.dart';

class CollapsibleAppBar extends StatefulWidget {
  final String title;
  final String subtitle;
  final String greeting;
  final double expandedHeight;
  final Widget? bottom;

  const CollapsibleAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.greeting,
    this.expandedHeight = 200,
    this.bottom,
  });

  @override
  State<CollapsibleAppBar> createState() => _CollapsibleAppBarState();
}

class _CollapsibleAppBarState extends State<CollapsibleAppBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _appBarController;
  late final Animation<double> _appBarAnimation;
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
    _appBarAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _appBarController, curve: Curves.easeInOut),
    );
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.userScrollDirection == AxisDirection.down &&
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

    return SliverAppBar.large(
      expandedHeight: widget.expandedHeight,
      floating: false,
      pinned: true,
      backgroundColor: theme.colorScheme.primary,
      elevation: 0,
      systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
      title: AnimatedOpacity(
        opacity: _showAppBarTitle ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Text(
          widget.title,
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final double expandedHeight = constraints.biggest.height;
          final double visibleMainHeight = widget.expandedHeight;
          final double scrolledPercentage =
              1.0 -
              ((expandedHeight - kToolbarHeight) /
                  (visibleMainHeight - kToolbarHeight));

          return FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
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
                          widget.greeting,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
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
                          widget.title,
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
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
                          widget.subtitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                      if (widget.bottom != null) ...[
                        const SizedBox(height: 16),
                        widget.bottom!,
                      ],
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
