import 'package:flutter/material.dart';
import '../../domain/entities/favorite_list.dart';

/// Sélecteur de couleur pour les listes de favoris
class ListColorPicker extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;
  final double itemSize;
  final double spacing;

  const ListColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
    this.itemSize = 40,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: FavoriteListColors.values.entries.map((entry) {
        final isSelected = entry.value.value == selectedColor.value;

        return GestureDetector(
          onTap: () => onColorSelected(entry.value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: itemSize,
            height: itemSize,
            decoration: BoxDecoration(
              color: entry.value,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 3,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: entry.value.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }
}

/// Sélecteur d'icône pour les listes de favoris
class ListIconPicker extends StatelessWidget {
  final IconData selectedIcon;
  final ValueChanged<IconData> onIconSelected;
  final Color accentColor;
  final double itemSize;
  final double spacing;

  const ListIconPicker({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
    this.accentColor = const Color(0xFFFF601F),
    this.itemSize = 44,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: FavoriteListIcons.values.entries.map((entry) {
        final isSelected = entry.value.codePoint == selectedIcon.codePoint;

        return GestureDetector(
          onTap: () => onIconSelected(entry.value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: itemSize,
            height: itemSize,
            decoration: BoxDecoration(
              color: isSelected ? accentColor.withOpacity(0.1) : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? accentColor : Colors.transparent,
                width: 2,
              ),
            ),
            child: Icon(
              entry.value,
              color: isSelected ? accentColor : Colors.grey[600],
              size: 24,
            ),
          ),
        );
      }).toList(),
    );
  }
}
