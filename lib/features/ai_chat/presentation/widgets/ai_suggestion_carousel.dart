import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/entities/activity.dart';
import '../../../home/presentation/widgets/event_card.dart';

class AiSuggestionCarousel extends StatelessWidget {
  final List<Activity> activities;
  final VoidCallback? onMoreTap;

  const AiSuggestionCarousel({
    super.key,
    required this.activities,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    // Limit to max 10 items as requested
    final displayList = activities.take(10).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 360, // Adjusted height for compact card to avoid overflow
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: displayList.length + (onMoreTap != null ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == displayList.length) {
                return _buildMoreCard(context);
              }
              return Container(
                width: 200, // Reduced width for compact look
                margin: const EdgeInsets.only(right: 12, bottom: 8, top: 4),
                child: EventCard(
                  activity: displayList[index], 
                  isCompact: true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMoreCard(BuildContext context) {
    return GestureDetector(
      onTap: onMoreTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12, bottom: 8, top: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFF601F).withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF601F).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search, color: Color(0xFFFF601F), size: 30),
            ),
            const SizedBox(height: 16),
            const Text(
              "Voir plus de\nrésultats",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF601F),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
