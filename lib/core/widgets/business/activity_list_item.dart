import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../themes/hb_theme.dart';
import '../cards/hb_card.dart';
import '../tags/hb_tag.dart';
import '../feedback/hb_feedback.dart';

class ActivityListItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String location;
  final String category;
  final String price;
  final VoidCallback? onTap;

  const ActivityListItem({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.location,
    required this.category,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = HbTheme.tokens(context);
    final textTheme = Theme.of(context).textTheme;

    return HbCard(
      onTap: onTap,
      padding: EdgeInsets.all(tokens.spacing.s),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 100,
              height: 100,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const HbShimmer(width: 100, height: 100),
                errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, size: 30),
                  ),
              ),
            ),
          ),
          SizedBox(width: tokens.spacing.m),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HbTag.outlined(label: category, textColor: Colors.grey[600], color: Colors.grey[400]),
                SizedBox(height: tokens.spacing.xs),
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
                    Expanded(
                      child: Text(
                        location,
                        style: textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: tokens.spacing.xs),
                Text(
                  price,
                  style: textTheme.labelMedium?.copyWith(
                    color: tokens.brand,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Arrow
          Padding(
            padding: EdgeInsets.only(left: tokens.spacing.s),
            child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
