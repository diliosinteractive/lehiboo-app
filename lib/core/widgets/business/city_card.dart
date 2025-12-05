import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../themes/hb_theme.dart';
import '../feedback/hb_feedback.dart';

class CityCard extends StatelessWidget {
  final String cityName;
  final String imageUrl;
  final VoidCallback? onTap;

  const CityCard({
    super.key,
    required this.cityName,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = HbTheme.tokens(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140, // Standard width for row lists
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(tokens.radiusXL),
          color: Colors.grey[200],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const HbShimmer(width: double.infinity, height: double.infinity),
              errorWidget: (context, url, error) => const Icon(Icons.location_city),
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
            // Text
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(tokens.spacing.m),
                child: Text(
                  cityName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
