import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';

class QuickFilters extends StatelessWidget {
  const QuickFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = [
      {
        'icon': Icons.today,
        'label': context.l10n.homeQuickToday,
        'color': Colors.blue,
      },
      {
        'icon': Icons.weekend,
        'label': context.l10n.homeQuickWeekend,
        'color': Colors.purple,
      },
      {
        'icon': Icons.attach_money,
        'label': context.l10n.commonFree,
        'color': Colors.green,
      },
      {
        'icon': Icons.family_restroom,
        'label': context.l10n.homeQuickFamily,
        'color': Colors.orange,
      },
      {
        'icon': Icons.location_on,
        'label': context.l10n.homeQuickDistanceUnder2km,
        'color': Colors.red,
      },
    ];

    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          return GestureDetector(
            onTap: () {
              // Apply filter
            },
            child: Container(
              width: 75,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: (filter['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      filter['icon'] as IconData,
                      color: filter['color'] as Color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    filter['label'] as String,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2D3748),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
