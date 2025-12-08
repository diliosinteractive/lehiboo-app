import 'package:flutter/material.dart';
import 'hb_feedback.dart';

class SkeletonEventCard extends StatelessWidget {
  const SkeletonEventCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image skeleton
          const HbShimmer(
            width: double.infinity,
            height: 150, // Approx aspect ratio height
            radius: 12,
          ),
          
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const HbShimmer(width: 140, height: 16, radius: 4),
                const SizedBox(height: 8),
                const HbShimmer(width: 200, height: 16, radius: 4),
                const SizedBox(height: 12),
                
                // Location & Date
                Row(
                  children: [
                    const HbShimmer(width: 80, height: 12, radius: 4),
                    const Spacer(),
                    const HbShimmer(width: 60, height: 12, radius: 4),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Price
                const HbShimmer(width: 50, height: 14, radius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
