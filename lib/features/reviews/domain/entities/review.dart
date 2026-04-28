import 'package:equatable/equatable.dart';

import 'review_author.dart';
import 'review_enums.dart';
import 'review_response.dart';

/// Un avis sur un événement (entité domain)
class Review extends Equatable {
  final String uuid;
  final int rating;
  final String title;
  final String comment;
  final ReviewStatus status;
  final int helpfulCount;
  final int notHelpfulCount;
  final double helpfulnessPercentage;
  final bool isVerifiedPurchase;
  final bool isFeatured;
  final ReviewAuthor? author;
  final ReviewResponse? response;
  final bool? userVote;
  final DateTime? createdAt;
  final String createdAtFormatted;

  const Review({
    required this.uuid,
    required this.rating,
    this.title = '',
    required this.comment,
    this.status = ReviewStatus.approved,
    this.helpfulCount = 0,
    this.notHelpfulCount = 0,
    this.helpfulnessPercentage = 0,
    this.isVerifiedPurchase = false,
    this.isFeatured = false,
    this.author,
    this.response,
    this.userVote,
    this.createdAt,
    this.createdAtFormatted = '',
  });

  bool get hasResponse => response != null;

  Review copyWith({
    String? uuid,
    int? rating,
    String? title,
    String? comment,
    ReviewStatus? status,
    int? helpfulCount,
    int? notHelpfulCount,
    double? helpfulnessPercentage,
    bool? isVerifiedPurchase,
    bool? isFeatured,
    ReviewAuthor? author,
    ReviewResponse? response,
    Object? userVote = _sentinel,
    DateTime? createdAt,
    String? createdAtFormatted,
  }) {
    return Review(
      uuid: uuid ?? this.uuid,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      comment: comment ?? this.comment,
      status: status ?? this.status,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      notHelpfulCount: notHelpfulCount ?? this.notHelpfulCount,
      helpfulnessPercentage:
          helpfulnessPercentage ?? this.helpfulnessPercentage,
      isVerifiedPurchase: isVerifiedPurchase ?? this.isVerifiedPurchase,
      isFeatured: isFeatured ?? this.isFeatured,
      author: author ?? this.author,
      response: response ?? this.response,
      userVote:
          identical(userVote, _sentinel) ? this.userVote : userVote as bool?,
      createdAt: createdAt ?? this.createdAt,
      createdAtFormatted: createdAtFormatted ?? this.createdAtFormatted,
    );
  }

  @override
  List<Object?> get props => [
        uuid,
        rating,
        title,
        comment,
        status,
        helpfulCount,
        notHelpfulCount,
        helpfulnessPercentage,
        isVerifiedPurchase,
        isFeatured,
        author,
        response,
        userVote,
        createdAt,
        createdAtFormatted,
      ];
}

const Object _sentinel = Object();
