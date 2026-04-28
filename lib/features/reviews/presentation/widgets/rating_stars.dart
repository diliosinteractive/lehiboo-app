import 'package:flutter/material.dart';

/// Affichage non-interactif d'une note (avec support des étoiles partielles).
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final int maxStars;
  final MainAxisAlignment alignment;
  final double spacing;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
    this.maxStars = 5,
    this.alignment = MainAxisAlignment.start,
    this.spacing = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: alignment,
      children: List.generate(maxStars, (index) {
        final fillAmount = (rating - index).clamp(0.0, 1.0);
        return Padding(
          padding: EdgeInsets.only(right: index < maxStars - 1 ? spacing : 0),
          child: _buildStar(fillAmount),
        );
      }),
    );
  }

  Widget _buildStar(double fillAmount) {
    if (fillAmount >= 1) {
      return Icon(Icons.star, size: size, color: activeColor);
    } else if (fillAmount > 0) {
      return Stack(
        children: [
          Icon(Icons.star,
              size: size, color: inactiveColor.withValues(alpha: 0.3)),
          ClipRect(
            clipper: _StarClipper(fillAmount),
            child: Icon(Icons.star, size: size, color: activeColor),
          ),
        ],
      );
    } else {
      return Icon(Icons.star,
          size: size, color: inactiveColor.withValues(alpha: 0.3));
    }
  }
}

class _StarClipper extends CustomClipper<Rect> {
  final double fillAmount;

  _StarClipper(this.fillAmount);

  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0, 0, size.width * fillAmount, size.height);

  @override
  bool shouldReclip(_StarClipper oldClipper) =>
      fillAmount != oldClipper.fillAmount;
}

/// Sélection interactive d'une note (1-5).
class InteractiveRatingStars extends StatefulWidget {
  final double rating;
  final ValueChanged<double> onRatingChanged;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final int maxStars;
  final bool allowHalf;

  const InteractiveRatingStars({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.size = 32,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
    this.maxStars = 5,
    this.allowHalf = false,
  });

  @override
  State<InteractiveRatingStars> createState() => _InteractiveRatingStarsState();
}

class _InteractiveRatingStarsState extends State<InteractiveRatingStars> {
  double _hoverRating = 0;

  @override
  Widget build(BuildContext context) {
    final displayRating = _hoverRating > 0 ? _hoverRating : widget.rating;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.maxStars, (index) {
        final starValue = index + 1;
        final isFilled = displayRating >= starValue;
        final isHalfFilled = widget.allowHalf &&
            displayRating >= starValue - 0.5 &&
            displayRating < starValue;

        return MouseRegion(
          onEnter: (_) => setState(() => _hoverRating = starValue.toDouble()),
          onExit: (_) => setState(() => _hoverRating = 0),
          child: GestureDetector(
            onTap: () => widget.onRatingChanged(starValue.toDouble()),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: AnimatedScale(
                scale: _hoverRating == starValue ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: Icon(
                  isFilled
                      ? Icons.star
                      : (isHalfFilled ? Icons.star_half : Icons.star_border),
                  size: widget.size,
                  color: isFilled || isHalfFilled
                      ? widget.activeColor
                      : widget.inactiveColor.withValues(alpha: 0.4),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Barre de distribution pour une étoile donnée.
class RatingDistributionBar extends StatelessWidget {
  final int starCount;
  final int count;
  final int total;
  final double height;
  final Color barColor;

  const RatingDistributionBar({
    super.key,
    required this.starCount,
    required this.count,
    required this.total,
    this.height = 8,
    this.barColor = Colors.amber,
  });

  double get _percentage => total > 0 ? count / total : 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          child: Text(
            '$starCount',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Icon(Icons.star, size: 12, color: Colors.amber),
        const SizedBox(width: 8),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: height,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
              FractionallySizedBox(
                widthFactor: _percentage,
                child: Container(
                  height: height,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 30,
          child: Text(
            '$count',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
