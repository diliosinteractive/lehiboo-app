import 'package:flutter/material.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/core/themes/hb_theme.dart';

class FilterTab {
  final String id;
  final String label;
  final int? count;

  const FilterTab({
    required this.id,
    required this.label,
    this.count,
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
              onTap: () => onTabSelected(tab.id),
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
    final tokens = HbTheme.tokens(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? HbColors.brandPrimary : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? HbColors.brandPrimary : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tab.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : HbColors.textPrimary,
              ),
            ),
            if (tab.count != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.25)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${tab.count}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : HbColors.textSecondary,
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
