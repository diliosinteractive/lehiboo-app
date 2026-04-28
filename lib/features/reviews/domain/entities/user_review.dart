import 'review.dart';
import 'review_author.dart';
import 'review_enums.dart';
import 'review_response.dart';

/// Avis enrichi avec les infos de l'événement (utilisé sur l'écran "Mes Avis")
class UserReview extends Review {
  final String? eventUuid;
  final String eventTitle;
  final String eventSlug;
  final String? eventCoverImage;
  final String organizationName;

  const UserReview({
    required super.uuid,
    required super.rating,
    super.title,
    required super.comment,
    super.status,
    super.helpfulCount,
    super.notHelpfulCount,
    super.helpfulnessPercentage,
    super.isVerifiedPurchase,
    super.isFeatured,
    super.author,
    super.response,
    super.userVote,
    super.createdAt,
    super.createdAtFormatted,
    this.eventUuid,
    required this.eventTitle,
    required this.eventSlug,
    this.eventCoverImage,
    this.organizationName = '',
  });

  @override
  UserReview copyWith({
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
    String? eventUuid,
    String? eventTitle,
    String? eventSlug,
    String? eventCoverImage,
    String? organizationName,
  }) {
    return UserReview(
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
      eventUuid: eventUuid ?? this.eventUuid,
      eventTitle: eventTitle ?? this.eventTitle,
      eventSlug: eventSlug ?? this.eventSlug,
      eventCoverImage: eventCoverImage ?? this.eventCoverImage,
      organizationName: organizationName ?? this.organizationName,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        eventUuid,
        eventTitle,
        eventSlug,
        eventCoverImage,
        organizationName,
      ];
}

const Object _sentinel = Object();
