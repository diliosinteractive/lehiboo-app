import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';

class CategoryFilterChips extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryFilterChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'id': 'all', 'label': context.l10n.homeCategoryAll, 'icon': Icons.apps},
      {
        'id': 'show',
        'label': context.l10n.homeCategoryShows,
        'icon': Icons.theater_comedy,
      },
      {
        'id': 'workshop',
        'label': context.l10n.homeCategoryWorkshops,
        'icon': Icons.palette,
      },
      {
        'id': 'sport',
        'label': context.l10n.homeCategorySport,
        'icon': Icons.sports_basketball,
      },
      {
        'id': 'culture',
        'label': context.l10n.homeCategoryCulture,
        'icon': Icons.museum,
      },
      {
        'id': 'market',
        'label': context.l10n.homeCategoryMarkets,
        'icon': Icons.storefront,
      },
      {
        'id': 'leisure',
        'label': context.l10n.homeCategoryLeisure,
        'icon': Icons.celebration,
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category['id'];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              onSelected: (selected) {
                onCategorySelected(category['id'] as String);
              },
              avatar: Icon(
                category['icon'] as IconData,
                size: 18,
                color: isSelected ? Colors.white : const Color(0xFFFF601F),
              ),
              label: Text(
                category['label'] as String,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF2D3748),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFFFF601F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFFFF601F)
                      : Colors.grey.withOpacity(0.3),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        },
      ),
    );
  }
}
