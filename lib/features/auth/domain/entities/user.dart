import 'package:equatable/equatable.dart';

enum UserRole {
  user,
  partner,
  admin
}

class User extends Equatable {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? displayName;
  final String? phoneNumber;
  final String? avatarUrl;
  final UserRole role;
  final List<String> favoriteEventIds;
  final List<String> bookingIds;
  final Map<String, dynamic>? preferences;
  final String? defaultCity;
  final String? defaultPostalCode;
  final double? defaultLatitude;
  final double? defaultLongitude;
  final int? defaultSearchRadius; // en km
  final List<String>? interests; // Tags d'intérêts
  final List<int>? childrenAges; // Âges des enfants pour filtrage
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool pushNotifications;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLogin;
  final bool isVerified;
  final String? fcmToken;
  final Map<String, dynamic>? metadata;

  const User({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.displayName,
    this.phoneNumber,
    this.avatarUrl,
    required this.role,
    required this.favoriteEventIds,
    required this.bookingIds,
    this.preferences,
    this.defaultCity,
    this.defaultPostalCode,
    this.defaultLatitude,
    this.defaultLongitude,
    this.defaultSearchRadius,
    this.interests,
    this.childrenAges,
    required this.notificationsEnabled,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.createdAt,
    required this.updatedAt,
    this.lastLogin,
    required this.isVerified,
    this.fcmToken,
    this.metadata,
  });

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return displayName ?? email;
  }

  bool get hasLocation {
    return defaultLatitude != null && defaultLongitude != null;
  }

  bool get hasChildren {
    return childrenAges != null && childrenAges!.isNotEmpty;
  }

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? displayName,
    String? phoneNumber,
    String? avatarUrl,
    UserRole? role,
    List<String>? favoriteEventIds,
    List<String>? bookingIds,
    Map<String, dynamic>? preferences,
    String? defaultCity,
    String? defaultPostalCode,
    double? defaultLatitude,
    double? defaultLongitude,
    int? defaultSearchRadius,
    List<String>? interests,
    List<int>? childrenAges,
    bool? notificationsEnabled,
    bool? emailNotifications,
    bool? pushNotifications,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLogin,
    bool? isVerified,
    String? fcmToken,
    Map<String, dynamic>? metadata,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      favoriteEventIds: favoriteEventIds ?? this.favoriteEventIds,
      bookingIds: bookingIds ?? this.bookingIds,
      preferences: preferences ?? this.preferences,
      defaultCity: defaultCity ?? this.defaultCity,
      defaultPostalCode: defaultPostalCode ?? this.defaultPostalCode,
      defaultLatitude: defaultLatitude ?? this.defaultLatitude,
      defaultLongitude: defaultLongitude ?? this.defaultLongitude,
      defaultSearchRadius: defaultSearchRadius ?? this.defaultSearchRadius,
      interests: interests ?? this.interests,
      childrenAges: childrenAges ?? this.childrenAges,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isVerified: isVerified ?? this.isVerified,
      fcmToken: fcmToken ?? this.fcmToken,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        displayName,
        phoneNumber,
        avatarUrl,
        role,
        favoriteEventIds,
        bookingIds,
        preferences,
        defaultCity,
        defaultPostalCode,
        defaultLatitude,
        defaultLongitude,
        defaultSearchRadius,
        interests,
        childrenAges,
        notificationsEnabled,
        emailNotifications,
        pushNotifications,
        createdAt,
        updatedAt,
        lastLogin,
        isVerified,
        fcmToken,
        metadata,
      ];
}