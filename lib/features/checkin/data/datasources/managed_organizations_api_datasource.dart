import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/dio_client.dart';
import '../models/managed_organization_dto.dart';

final managedOrganizationsApiDataSourceProvider =
    Provider<ManagedOrganizationsApiDataSource>((ref) {
  return ManagedOrganizationsApiDataSource(ref.watch(dioProvider));
});

/// Loads the organizations the current user owns or actively manages.
///
/// Unlike `/me/memberships/all`, `GET /organizations` deliberately excludes
/// customer adherences and exposes the authenticated user's management role.
class ManagedOrganizationsApiDataSource {
  ManagedOrganizationsApiDataSource(this._dio);

  final Dio _dio;

  Future<List<ManagedOrganizationDto>> getManagedOrganizations() async {
    final response = await _dio.get<Map<String, dynamic>>('/organizations');
    final data = response.data?['data'];
    if (data is! List) {
      throw const FormatException(
        'Expected managed organizations data to be a list',
      );
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(ManagedOrganizationDto.tryFromJson)
        .whereType<ManagedOrganizationDto>()
        .toList(growable: false);
  }
}
