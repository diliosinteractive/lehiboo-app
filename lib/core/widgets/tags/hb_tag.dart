import 'package:flutter/material.dart';
import '../../themes/hb_theme.dart';

class HbTag extends StatelessWidget {
  final String label;
  final bool outlined;
  final Color? color;
  final Color? textColor;

  const HbTag({
    super.key,
    required this.label,
    this.outlined = false,
    this.color,
    this.textColor,
  });

  const HbTag.outlined({
    super.key,
    required this.label,
    this.color,
    this.textColor,
  }) : outlined = true;

  @override
  Widget build(BuildContext context) {
    final tokens = HbTheme.tokens(context);
    final theme = Theme.of(context);

    final effectiveColor = color ?? tokens.brand;
    final effectiveTextColor = textColor ?? (outlined ? effectiveColor : Colors.white);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.spacing.s,
        vertical: tokens.spacing.xs,
      ),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : effectiveColor,
        borderRadius: BorderRadius.circular(tokens.spacing.s),
        border: outlined ? Border.all(color: effectiveColor) : null,
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: effectiveTextColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class HbFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;

  const HbFilterChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = HbTheme.tokens(context);
    
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: Colors.grey[100],
      selectedColor: tokens.brand.withOpacity(0.15),
      labelStyle: TextStyle(
        color: selected ? tokens.brand : Colors.black87,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: selected 
          ? BorderSide(color: tokens.brand)
          : BorderSide.none,
      ),
      padding: EdgeInsets.symmetric(horizontal: tokens.spacing.xs),
      visualDensity: VisualDensity.compact,
    );
  }
}
