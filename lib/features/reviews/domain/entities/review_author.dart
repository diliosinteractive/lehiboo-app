import 'package:equatable/equatable.dart';

/// Auteur d'un avis
class ReviewAuthor extends Equatable {
  final String name;
  final String? firstName;
  final String? lastName;
  final String? avatar;
  final String initials;

  const ReviewAuthor({
    required this.name,
    this.firstName,
    this.lastName,
    this.avatar,
    this.initials = '',
  });

  String get displayInitials {
    if (initials.isNotEmpty) return initials;
    if (firstName != null && firstName!.isNotEmpty) {
      final f = firstName![0].toUpperCase();
      final l = (lastName != null && lastName!.isNotEmpty)
          ? lastName![0].toUpperCase()
          : '';
      return '$f$l';
    }
    if (name.isNotEmpty) {
      final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
      if (parts.length >= 2) {
        return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
      }
      return parts.first[0].toUpperCase();
    }
    return '?';
  }

  @override
  List<Object?> get props => [name, firstName, lastName, avatar, initials];
}
