import 'package:equatable/equatable.dart';

import 'review.dart';
import 'user_review.dart';

class PaginationMeta extends Equatable {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const PaginationMeta({
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 10,
    this.total = 0,
  });

  bool get hasMore => currentPage < lastPage;

  @override
  List<Object?> get props => [currentPage, lastPage, perPage, total];
}

class PaginatedReviews extends Equatable {
  final List<Review> items;
  final PaginationMeta meta;

  const PaginatedReviews({
    this.items = const [],
    this.meta = const PaginationMeta(),
  });

  @override
  List<Object?> get props => [items, meta];
}

class PaginatedUserReviews extends Equatable {
  final List<UserReview> items;
  final PaginationMeta meta;

  const PaginatedUserReviews({
    this.items = const [],
    this.meta = const PaginationMeta(),
  });

  @override
  List<Object?> get props => [items, meta];
}

/// Compteurs de votes utiles/pas utiles renvoyés par /reviews/{uuid}/vote
class VoteCounts extends Equatable {
  final int helpfulCount;
  final int notHelpfulCount;

  const VoteCounts({
    this.helpfulCount = 0,
    this.notHelpfulCount = 0,
  });

  @override
  List<Object?> get props => [helpfulCount, notHelpfulCount];
}
