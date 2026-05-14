import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lehiboo/core/themes/colors.dart';

class HomeSectionTitle extends StatelessWidget {
  const HomeSectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.fontSize = 20,
    this.fontWeight = FontWeight.bold,
    this.color = HbColors.textSlate,
    this.iconSize = 20,
    this.maxLines = 2,
  });

  final String title;
  final String? subtitle;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final double iconSize;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: subtitle == null
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: subtitle == null ? 0 : 2),
          child: Icon(
            Icons.auto_awesome_outlined,
            color: HbColors.brandPrimary,
            size: iconSize,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.montserrat(
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  color: color,
                  height: 1.15,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
