import 'package:flutter/material.dart';

class ScrollItemCard extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? shadow;
  final Widget? image;

  const ScrollItemCard({
    super.key,
    required this.width,
    required this.height,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.borderRadius,
    this.shadow,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          boxShadow:
              shadow ??
              [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image != null)
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: (borderRadius as BorderRadius?)?.topLeft ?? Radius.zero,
                ),
                child: image,
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(
                          0.7,
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
