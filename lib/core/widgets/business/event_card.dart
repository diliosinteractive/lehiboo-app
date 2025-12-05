import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../themes/hb_theme.dart';
import '../cards/hb_card.dart';
import '../tags/hb_tag.dart';
import '../feedback/hb_feedback.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String date;
  final String location;
  final String price;
  final String? category;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.location,
    required this.price,
    this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = HbTheme.tokens(context);
    final textTheme = Theme.of(context).textTheme;

    return HbCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const HbShimmer(width: double.infinity, height: double.infinity),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
              if (category != null)
                Positioned(
                  top: tokens.spacing.s,
                  left: tokens.spacing.s,
                  child: HbTag(label: category!),
                ),
            ],
          ),
          
          // Content
          Padding(
            padding: EdgeInsets.all(tokens.spacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: tokens.spacing.xs),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: textTheme.bodySmall,
                    ),
                    const Spacer(),
                    Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
                SizedBox(height: tokens.spacing.s),
                Text(
                  price,
                  style: textTheme.labelLarge?.copyWith(
                    color: tokens.brand,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
