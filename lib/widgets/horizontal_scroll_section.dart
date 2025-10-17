import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HorizontalScrollSection extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final List<Widget> children;
  final double itemHeight;
  final double itemSpacing;
  final EdgeInsetsGeometry? padding;

  const HorizontalScrollSection({
    super.key,
    required this.title,
    this.actionText,
    this.onActionPressed,
    required this.children,
    this.itemHeight = 120,
    this.itemSpacing = 12,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (actionText != null)
                TextButton(
                  onPressed: onActionPressed,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    actionText!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: itemHeight,
          child: ListView.separated(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
            scrollDirection: Axis.horizontal,
            itemCount: children.length,
            separatorBuilder: (context, index) => SizedBox(width: itemSpacing),
            itemBuilder: (context, index) => children[index],
          ),
        ),
      ],
    );
  }
}

class ScrollItemCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? icon;
  final Color? color;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? shadow;
  final BoxBorder? border;

  const ScrollItemCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.color,
    this.onTap,
    this.width,
    this.height,
    this.borderRadius,
    this.shadow,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 140,
        height: height,
        decoration: BoxDecoration(
          color: color ?? theme.colorScheme.surface,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          boxShadow: shadow ?? [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: border,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (icon != null) ...[icon!],
              const Spacer(),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
