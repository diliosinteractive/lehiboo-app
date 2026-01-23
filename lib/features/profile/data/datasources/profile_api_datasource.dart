import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
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

    final data = response.data;
    if (data['user'] != null) {
      return _parseUserDto(data['user']);
    }
    throw Exception(data['message'] ?? 'Failed to get profile');
  }

  /// Update user profile
  Future<UserDto> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? jobTitle,
  }) async {
    final response = await _dio.patch(
      '/auth/me',
      data: {
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (phone != null) 'phone': phone,
        if (jobTitle != null) 'job_title': jobTitle,
      },
    );

    final data = response.data;
    if (data['data'] != null) {
      return _parseUserDto(data['data']);
    }
    throw Exception(data['message'] ?? 'Failed to update profile');
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

    final data = response.data;
    if (data['data'] != null) {
      return _parseUserDto(data['data']);
    }
    throw Exception(data['message'] ?? 'Failed to upload avatar');
  }

  /// Get user stats
  Future<UserStatsDto> getStats() async {
    final response = await _dio.get('/auth/me/stats');

    final data = response.data;
    if (data['data'] != null) {
      return UserStatsDto.fromJson(data['data']);
    }
    throw Exception(data['message'] ?? 'Failed to get stats');
  }

  /// Update password
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await _dio.post(
      '/account/password',
      data: {
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': confirmPassword,
      },
    );

    final data = response.data;
    if (data['success'] != true && data['message'] != null) {
      throw Exception(data['message']);
    }
  }

  UserDto _parseUserDto(Map<String, dynamic> userData) {
    return UserDto(
      id: userData['id'] is int ? userData['id'] : int.tryParse(userData['id'].toString()) ?? 0,
      email: userData['email']?.toString() ?? '',
      displayName: userData['name']?.toString() ?? '',
      firstName: userData['first_name']?.toString(),
      lastName: userData['last_name']?.toString(),
      phone: userData['phone']?.toString(),
      avatarUrl: userData['avatar_url']?.toString(),
      role: userData['role']?.toString() ?? 'customer',
      registeredAt: userData['created_at']?.toString(),
      isVerified: userData['is_email_verified'] == true,
    );
  }
}
