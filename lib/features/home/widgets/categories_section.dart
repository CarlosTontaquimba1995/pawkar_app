import 'package:flutter/material.dart';
import 'package:pawkar_app/features/home/widgets/category_card.dart';
import 'package:pawkar_app/features/home/widgets/section_header.dart';
import 'package:pawkar_app/models/category.dart';

class CategoriesSection extends StatelessWidget {
  final List<Category> categories;
  final ValueChanged<Category>? onCategoryTap;
  final VoidCallback? onViewAll;

  const CategoriesSection({
    super.key,
    required this.categories,
    this.onCategoryTap,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Categorías',
          actionText: 'Ver todas',
          onAction: onViewAll,
        ),
        SizedBox(
          height: 140,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) => CategoryCard(
              category: categories[index],
              onTap: onCategoryTap != null
                  ? () => onCategoryTap!(categories[index])
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
