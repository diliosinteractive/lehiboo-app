import 'package:flutter/material.dart';

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
      {'id': 'all', 'label': 'Tous', 'icon': Icons.apps},
      {'id': 'show', 'label': 'Spectacles', 'icon': Icons.theater_comedy},
      {'id': 'workshop', 'label': 'Ateliers', 'icon': Icons.palette},
      {'id': 'sport', 'label': 'Sport', 'icon': Icons.sports_basketball},
      {'id': 'culture', 'label': 'Culture', 'icon': Icons.museum},
      {'id': 'market', 'label': 'Marchés', 'icon': Icons.storefront},
      {'id': 'leisure', 'label': 'Loisirs', 'icon': Icons.celebration},
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
                color: isSelected ? Colors.white : const Color(0xFFFF6B35),
              ),
              label: Text(
                category['label'] as String,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF2D3748),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFFFF6B35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFFFF6B35)
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