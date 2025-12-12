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
    // Limit to max 10 items as requested
    final displayList = activities.take(10).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 400, // Increased height for 9:16 images + info
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: displayList.length + (onMoreTap != null ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == displayList.length) {
                return _buildMoreCard(context);
              }
              return _AiActivityCard(activity: displayList[index]);
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

class _AiActivityCard extends StatelessWidget {
  final Activity activity;

  const _AiActivityCard({required this.activity});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
         context.push('/event/${activity.id}');
      },
      child: Container(
        width: 220, // Adjusted width for 9:16 proportion
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
            // Image Area (9:16 Aspect Ratio)
            Expanded(
              flex: 4, // More space for image
              child: Stack(
                children: [
                   ClipRRect(
                     borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                     child: SizedBox(
                       width: double.infinity,
                       height: double.infinity,
                       child: (activity.imageUrl?.isNotEmpty == true)
                           ? Image.network(
                               activity.imageUrl!,
                               fit: BoxFit.cover,
                               errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                             )
                           : _buildPlaceholder(),
                     ),
                   ),

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
                          Icon(Icons.auto_awesome, size: 12, color: Color(0xFFFF601F)),
                          SizedBox(width: 4),
                          Text(
                            "Match",
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFFF601F)),
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
              flex: 1, // Reduced space for text
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
                          activity.isFree == true ? "Gratuit" : "Payant", 
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: activity.isFree == true ? Colors.green : Colors.grey[600],
                          ),
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

  Widget _buildPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF601F), Color(0xFFFF8F66)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Image.asset(
          'assets/images/petit_boo.png',
          width: 50,
          color: Colors.white, // Tinting white to look good on orange gradient
        ),
      ),
    );
  }
}
