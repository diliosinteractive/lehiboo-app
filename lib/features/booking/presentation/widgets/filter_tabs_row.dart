import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/core/themes/hb_theme.dart';

class FilterTab {
  final String id;
  final String label;
  final int? count;
  final IconData? icon;
  final Color? color;

  const FilterTab({
    required this.id,
    required this.label,
    this.count,
    this.icon,
    this.color,
  });
}

class FilterTabsRow extends StatelessWidget {
  final List<FilterTab> tabs;
  final String selectedTabId;
  final ValueChanged<String> onTabSelected;
  final EdgeInsets? padding;

  const FilterTabsRow({
    super.key,
    required this.tabs,
    required this.selectedTabId,
    required this.onTabSelected,
  }) : padding = null;

  const FilterTabsRow.withPadding({
    super.key,
    required this.tabs,
    required this.selectedTabId,
    required this.onTabSelected,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = HbTheme.tokens(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding ?? EdgeInsets.symmetric(
        horizontal: tokens.spacing.m,
        vertical: tokens.spacing.s,
      ),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = tab.id == selectedTabId;
          return Padding(
            padding: EdgeInsets.only(right: tokens.spacing.s),
            child: _FilterTabChip(
              tab: tab,
              isSelected: isSelected,
              onTap: () {
                HapticFeedback.selectionClick();
                onTabSelected(tab.id);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FilterTabChip extends StatelessWidget {
  final FilterTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTabChip({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = tab.color ?? HbColors.brandPrimary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : Colors.grey[50],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? chipColor : Colors.grey[200]!,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: chipColor.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Indicateur de couleur (petit cercle) - visible uniquement si non sélectionné
            if (!isSelected)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: chipColor,
                  shape: BoxShape.circle,
                ),
              ),

            // Icône optionnelle
            if (tab.icon != null) ...[
              Icon(
                tab.icon,
                size: 18,
                color: isSelected ? Colors.white : chipColor,
              ),
              const SizedBox(width: 8),
            ],

            // Label
            Text(
              tab.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[800],
              ),
            ),

            // Compteur
            if (tab.count != null && tab.count! > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.25)
                      : chipColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${tab.count}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : chipColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
