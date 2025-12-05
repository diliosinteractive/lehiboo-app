import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../themes/hb_theme.dart';
import '../feedback/hb_feedback.dart';

class PartnerLogoStrip extends StatelessWidget {
  final List<String> logoUrls;

  const PartnerLogoStrip({
    super.key,
    required this.logoUrls,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = HbTheme.tokens(context);
    
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: tokens.spacing.l),
        itemCount: logoUrls.length,
        separatorBuilder: (context, index) => SizedBox(width: tokens.spacing.xl),
        itemBuilder: (context, index) {
          return Center(
            child: SizedBox(
              width: 100,
              child: Opacity(
                opacity: 0.7,
                child: CachedNetworkImage(
                  imageUrl: logoUrls[index],
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const HbShimmer(width: 80, height: 40),
                  errorWidget: (context, url, error) => const SizedBox(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
