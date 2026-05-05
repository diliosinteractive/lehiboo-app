import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../../auth/data/models/auth_response_dto.dart';

final profileApiDataSourceProvider = Provider<ProfileApiDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return ProfileApiDataSource(dio);
});

/// User stats response DTO
class UserStatsDto {
  final int bookingsCount;
  final int favoritesCount;
  final int reviewsCount;
  final int upcomingEventsCount;

  UserStatsDto({
    required this.bookingsCount,
    required this.favoritesCount,
    required this.reviewsCount,
    required this.upcomingEventsCount,
  });

  factory UserStatsDto.fromJson(Map<String, dynamic> json) {
    return UserStatsDto(
      bookingsCount: json['bookings_count'] ?? json['bookingsCount'] ?? 0,
      favoritesCount: json['favorites_count'] ?? json['favoritesCount'] ?? 0,
      reviewsCount: json['reviews_count'] ?? json['reviewsCount'] ?? 0,
      upcomingEventsCount: json['upcoming_events_count'] ?? json['upcomingEventsCount'] ?? 0,
    );
  }
}

class ProfileApiDataSource {
  final Dio _dio;

  ProfileApiDataSource(this._dio);

  /// Get current user profile
  Future<UserDto> getProfile() async {
    final response = await _dio.get('/auth/me');
    // /auth/me returns { "user": {...} } at root level
    final payload = ApiResponseHandler.extractObject(response.data, unwrapRoot: true);
    final userData = payload['user'] ?? payload;
    return _parseUserDto(userData is Map<String, dynamic> ? userData : payload);
  }

  /// Update user profile
  Future<UserDto> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? jobTitle,
    String? birthDate,
    String? membershipCity,
    bool? newsletter,
    bool? pushNotificationsEnabled,
    bool clearBirthDate = false,
    bool clearMembershipCity = false,
  }) async {
    final response = await _dio.patch(
      '/auth/me',
      data: {
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (phone != null) 'phone': phone,
        if (jobTitle != null) 'job_title': jobTitle,
        if (birthDate != null) 'birth_date': birthDate,
        if (clearBirthDate) 'birth_date': null,
        if (membershipCity != null) 'membership_city': membershipCity,
        if (clearMembershipCity) 'membership_city': null,
        if (newsletter != null) 'newsletter': newsletter,
        if (pushNotificationsEnabled != null)
          'push_notifications_enabled': pushNotificationsEnabled,
      },
    );

    final payload = ApiResponseHandler.extractObject(response.data);
    return _parseUserDto(payload);
  }

  /// Upload avatar
  Future<UserDto> uploadAvatar(File imageFile) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(
        imageFile.path,
        filename: 'avatar.${imageFile.path.split('.').last}',
      ),
    });

    final response = await _dio.post(
      '/auth/me/avatar',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );

    final payload = ApiResponseHandler.extractObject(response.data);
    return _parseUserDto(payload);
  }

  /// Get user stats
  Future<UserStatsDto> getStats() async {
    final response = await _dio.get('/auth/me/stats');
    final payload = ApiResponseHandler.extractObject(response.data);
    return UserStatsDto.fromJson(payload);
  }

  /// Update password
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _dio.post(
      '/account/password',
      data: {
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': confirmPassword,
      },
    );
  }

  UserDto _parseUserDto(Map<String, dynamic> userData) {
    return UserDto(
      id: userData['id'] is int ? userData['id'] : int.tryParse(userData['id'].toString()) ?? 0,
      email: userData['email']?.toString() ?? '',
      displayName: userData['name']?.toString() ?? '',
      firstName: userData['first_name']?.toString(),
      lastName: userData['last_name']?.toString(),
      phone: userData['phone']?.toString(),
      avatarUrl: (userData['avatar'] ?? userData['avatar_url'])?.toString(),
      birthDate: userData['birthDate']?.toString() ?? userData['birth_date']?.toString(),
      membershipCity: userData['membershipCity']?.toString() ?? userData['membership_city']?.toString(),
      role: userData['role']?.toString() ?? 'customer',
      registeredAt: userData['created_at']?.toString(),
      isVerified: userData['is_email_verified'] == true,
      newsletter: userData['newsletter'] == true,
      pushNotificationsEnabled: userData['push_notifications_enabled'] == true,
    );
  }
}
