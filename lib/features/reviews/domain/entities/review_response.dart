import 'package:equatable/equatable.dart';

/// Réponse de l'organisateur à un avis
class ReviewResponse extends Equatable {
  final String uuid;
  final String response;
  final String organizationName;
  final String? organizationLogo;
  final String? authorName;
  final String? authorAvatar;
  final DateTime? createdAt;
  final String createdAtFormatted;

  const ReviewResponse({
    required this.uuid,
    required this.response,
    required this.organizationName,
    this.organizationLogo,
    this.authorName,
    this.authorAvatar,
    this.createdAt,
    this.createdAtFormatted = '',
  });

  @override
  List<Object?> get props => [
        uuid,
        response,
        organizationName,
        organizationLogo,
        authorName,
        authorAvatar,
        createdAt,
        createdAtFormatted,
      ];
}
