import 'package:flutter/material.dart';
import 'package:pawkar_app/models/category.dart';

class CategoryCard extends StatefulWidget {
  final Category category;
  final VoidCallback? onTap;
  final int index;

  const CategoryCard({
    super.key,
    required this.category,
    this.onTap,
    this.index = 0,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600 + (widget.index * 50)),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Opacity(
        opacity: _opacityAnimation.value,
        child: Transform.scale(scale: _scaleAnimation.value, child: child),
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: SizedBox(
            width: 110,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: 85,
                  height: 85,
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? colorScheme.primary.withAlpha(77)
                        : colorScheme.primary.withAlpha(26),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: _isHovered
                        ? [
                            BoxShadow(
                              color: colorScheme.primary.withAlpha(51),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ]
                        : [],
                  ),
                  child: AnimatedScale(
                    scale: _isHovered ? 1.1 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: Icon(
                      _getCategoryIcon(widget.category.name),
                      size: 38,
                      color: _isHovered
                          ? colorScheme.onPrimary
                          : colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.category.name,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'música':
        return Icons.music_note;
      case 'deportes':
        return Icons.sports_soccer;
      case 'teatro':
        return Icons.theater_comedy;
      case 'arte':
        return Icons.palette;
      case 'gastronomía':
        return Icons.restaurant;
      default:
        return Icons.event;
    }
  }
}
