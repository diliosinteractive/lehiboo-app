import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/entities/activity.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: activities.length + (onMoreTap != null ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == activities.length) {
                return _buildMoreCard(context);
              }
              return _AiActivityCard(activity: activities[index]);
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
          border: Border.all(color: const Color(0xFFFF6B35).withOpacity(0.3)),
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
                color: const Color(0xFFFF6B35).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search, color: Color(0xFFFF6B35), size: 30),
            ),
            const SizedBox(height: 16),
            const Text(
              "Voir plus de\nrésultats",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6B35),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AiActivityCard extends StatelessWidget {
  final Activity activity;

  const _AiActivityCard({required this.activity});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
         // Assuming generic route, or use ID directly
         // context.push('/event/${activity.id}');
         // For now, logging, assuming user handles navigation logic or GoRouter
         context.push('/event/${activity.id}');
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12, bottom: 8, top: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Area
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      image: DecorationImage(
                        image: NetworkImage(activity.imageUrl ?? 'https://via.placeholder.com/400x300'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Match Score (Mocked visualization because field missing in Activity entity for now, 
                  // but available in API DTO. We assume high match for AI suggestions)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.auto_awesome, size: 12, color: Color(0xFFFF6B35)),
                          SizedBox(width: 4),
                          Text(
                            "Top match",
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFFF6B35)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content Area
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      activity.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF222222),
                        height: 1.2,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          activity.isFree == true ? "Gratuit" : "Payant", // Simplified
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: activity.isFree == true ? Colors.green : Colors.grey[600],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B35).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFFFF6B35)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
