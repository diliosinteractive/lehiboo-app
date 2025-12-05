import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../themes/hb_theme.dart';
import '../cards/hb_card.dart';
import '../feedback/hb_feedback.dart';

class TestimonialCard extends StatelessWidget {
  final String authorName;
  final String role;
  final String text;
  final String? avatarUrl;

  const TestimonialCard({
    super.key,
    required this.authorName,
    required this.role,
    required this.text,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = HbTheme.tokens(context);
    final textTheme = Theme.of(context).textTheme;

    return HbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: tokens.brand.withOpacity(0.1),
                backgroundImage: avatarUrl != null ? CachedNetworkImageProvider(avatarUrl!) : null,
                child: avatarUrl == null
                    ? Text(
                        authorName.isNotEmpty ? authorName[0].toUpperCase() : '?',
                        style: TextStyle(color: tokens.brand),
                      )
                    : null,
              ),
              SizedBox(width: tokens.spacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authorName,
                      style: textTheme.titleMedium,
                    ),
                    Text(
                      role,
                      style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: tokens.spacing.m),
          Text(
            '"$text"',
            style: textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
