import 'package:equatable/equatable.dart';

/// Statistiques agrégées des avis pour un événement
class ReviewStats extends Equatable {
  final int totalReviews;
  final double averageRating;
  final int verifiedCount;

  /// Distribution stars → count (clé int 1-5)
  final Map<int, int> distribution;

  /// Distribution stars → percentage (clé int 1-5)
  final Map<int, int> percentages;

  const ReviewStats({
    this.totalReviews = 0,
    this.averageRating = 0,
    this.verifiedCount = 0,
    this.distribution = const {},
    this.percentages = const {},
  });

  bool get hasReviews => totalReviews > 0;

  int countForStar(int star) => distribution[star] ?? 0;
  int percentageForStar(int star) => percentages[star] ?? 0;

  @override
  List<Object?> get props =>
      [totalReviews, averageRating, verifiedCount, distribution, percentages];
}
